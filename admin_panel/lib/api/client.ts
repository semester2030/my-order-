const DEFAULT_API_URL = 'http://localhost:3001';

function isBrowserLocalhost(hostname: string): boolean {
  return (
    hostname === 'localhost' ||
    hostname === '127.0.0.1' ||
    hostname === '::1' ||
    hostname === '[::1]'
  );
}

/** true إذا كان عنوان الـ API يشير لباك اند على نفس الجهاز (CORS عند الجلب المباشر من المتصفح). */
function isLocalBackendBase(baseUrl: string): boolean {
  const t = baseUrl.trim();
  if (!t) return false;
  try {
    const withProto = t.includes('://') ? t : `https://${t}`;
    const u = new URL(withProto);
    const h = u.hostname.toLowerCase();
    return (
      h === 'localhost' ||
      h === '127.0.0.1' ||
      h === '[::1]' ||
      h === '::1'
    );
  } catch {
    return false;
  }
}

/**
 * - على localhost: إن وُجد `NEXT_PUBLIC_API_URL` لخادم **بعيد** (مثل Render) نستخدمه مباشرة —
 *   حتى تطابق قاعدة البيانات تطبيق المزوّد الذي يضرب الإنترنت. بدون ذلك، `/api` يذهب
 *   للبروكسي → غالباً `localhost:3001` وقاعدة محلية **فارغة** من طلبات الإنتاج.
 * - إن كان المتغير لـ localhost:3001 نتجاهله ونستخدم `/api` → rewrites (تفادي CORS).
 * - في الإنتاج (نطاق غير localhost): `NEXT_PUBLIC_API_URL` إن وُجد.
 */
const getBaseUrl = () => {
  const fromEnvRaw = process.env.NEXT_PUBLIC_API_URL?.trim();
  const fromEnv = fromEnvRaw ? fromEnvRaw.replace(/\/$/, '') : '';

  if (typeof window !== 'undefined') {
    const h = window.location.hostname;
    if (isBrowserLocalhost(h)) {
      if (fromEnv && !isLocalBackendBase(fromEnv)) {
        return fromEnv;
      }
      return '';
    }
    if (fromEnv) return fromEnv;
    return '';
  }
  return fromEnv || DEFAULT_API_URL;
};

/** مسار API كاملاً للـ fetch (نسبي `/api/...` مع البروكسي، أو مطلق نحو الباك اند). */
function buildApiUrl(apiPath: string): string {
  const path = apiPath.startsWith('/') ? apiPath : `/${apiPath}`;
  const base = getBaseUrl();
  if (base) return `${base}/api${path}`;
  return `/api${path}`;
}

const ADMIN_TOKEN_KEY = 'admin_token';

const getToken = (): string | null => {
  if (typeof window === 'undefined') return null;
  try {
    return localStorage.getItem(ADMIN_TOKEN_KEY);
  } catch {
    return null;
  }
};

export const getAuthHeaders = (): Record<string, string> => {
  const token = getToken();
  const headers: Record<string, string> = {
    'Content-Type': 'application/json',
  };
  if (token) {
    headers['Authorization'] = `Bearer ${token}`;
  }
  return headers;
};

export interface AdminLoginResponse {
  accessToken: string;
  expiresIn: number;
  admin: { id: string; email: string; name: string; role: string };
}

export async function adminLogin(
  email: string,
  password: string,
): Promise<AdminLoginResponse> {
  const res = await fetch(buildApiUrl('/admin/auth/login'), {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, password }),
  });
  if (!res.ok) {
    const err = await res.json().catch(() => ({}));
    throw new Error(
      (err as { message?: string }).message || res.statusText || 'Login failed',
    );
  }
  return res.json();
}

export async function adminRefresh(): Promise<AdminLoginResponse> {
  const token = getToken();
  if (!token) throw new Error('No token');
  const res = await fetch(buildApiUrl('/admin/auth/refresh'), {
    method: 'POST',
    headers: getAuthHeaders(),
  });
  if (!res.ok) {
    const err = await res.json().catch(() => ({}));
    throw new Error(
      (err as { message?: string }).message || res.statusText || 'Refresh failed',
    );
  }
  return res.json();
}

export async function adminMe(): Promise<{
  id: string;
  email: string;
  name: string;
  role: string;
} | null> {
  const token = getToken();
  if (!token) return null;
  const res = await fetch(buildApiUrl('/admin/auth/me'), {
    headers: getAuthHeaders(),
  });
  if (!res.ok) return null;
  return res.json();
}

const COOKIE_MAX_AGE_DAYS = 7;

export function setAdminToken(token: string): void {
  if (typeof window !== 'undefined') {
    localStorage.setItem(ADMIN_TOKEN_KEY, token);
    document.cookie = `${ADMIN_TOKEN_KEY}=${encodeURIComponent(token)}; path=/; max-age=${COOKIE_MAX_AGE_DAYS * 86400}; SameSite=Lax`;
  }
}

export function clearAdminToken(): void {
  if (typeof window !== 'undefined') {
    localStorage.removeItem(ADMIN_TOKEN_KEY);
    document.cookie = `${ADMIN_TOKEN_KEY}=; path=/; max-age=0`;
  }
}

/**
 * توكن غير مقبول من الباك اند (منتهي، أو صادر من خادم آخر بـ JWT_SECRET مختلف).
 * يمسح الجلسة ويعيد لتسجيل الدخول حتى لا يبقى «Unauthorized» عالقاً.
 */
function handleAdminUnauthorized(): void {
  if (typeof window === 'undefined') return;
  clearAdminToken();
  const path = window.location.pathname;
  if (!path.startsWith('/auth/login')) {
    window.location.assign('/auth/login?session=invalid');
  }
}

export function hasAdminToken(): boolean {
  return !!getToken();
}

/** Authenticated GET for admin API. Use with SWR: useSWR(key, adminFetch). */
export async function adminFetch<T = unknown>(url: string): Promise<T> {
  const fullUrl = url.startsWith('http') ? url : buildApiUrl(url);
  const res = await fetch(fullUrl, { headers: getAuthHeaders() });
  if (res.status === 401) {
    handleAdminUnauthorized();
  }
  if (!res.ok) {
    const err = await res.json().catch(() => ({}));
    throw new Error(
      (err as { message?: string }).message || res.statusText || String(res.status),
    );
  }
  return res.json();
}

export interface DashboardStats {
  ordersToday: number;
  ordersPending: number;
  vendorsPendingCount: number;
  driversPendingCount: number;
  ordersLiveCount: number;
  paymentIssuesCount: number;
  recentOrders: Array<{
    id: string;
    orderNumber: string;
    status: string;
    total: number;
    createdAt: string;
    vendorId: string;
  }>;
}

export interface PaginatedResponse<T> {
  items: T[];
  total: number;
  page: number;
  limit: number;
}

export function fetchDashboard(): Promise<DashboardStats> {
  return adminFetch<DashboardStats>('/admin/dashboard');
}

export function fetchVendors(params?: {
  status?: string;
  /** طابور ما قبل الاعتماد: pending_approval + under_review */
  registrationQueue?: boolean;
  category?: string;
  page?: number;
  limit?: number;
}): Promise<PaginatedResponse<Record<string, unknown>>> {
  const q = new URLSearchParams();
  if (params?.registrationQueue) q.set('registrationQueue', '1');
  if (params?.status) q.set('status', params.status);
  if (params?.category) q.set('category', params.category);
  if (params?.page) q.set('page', String(params.page));
  if (params?.limit) q.set('limit', String(params.limit));
  const query = q.toString();
  return adminFetch<PaginatedResponse<Record<string, unknown>>>(
    `/admin/vendors${query ? `?${query}` : ''}`,
  );
}

export function fetchVendorById(id: string): Promise<Record<string, unknown>> {
  return adminFetch<Record<string, unknown>>(`/admin/vendors/${id}`);
}

export function fetchDrivers(params?: {
  status?: string;
  page?: number;
  limit?: number;
}): Promise<PaginatedResponse<Record<string, unknown>>> {
  const q = new URLSearchParams();
  if (params?.status) q.set('status', params.status);
  if (params?.page) q.set('page', String(params.page));
  if (params?.limit) q.set('limit', String(params.limit));
  const query = q.toString();
  return adminFetch<PaginatedResponse<Record<string, unknown>>>(
    `/admin/drivers${query ? `?${query}` : ''}`,
  );
}

export function fetchDriverById(id: string): Promise<Record<string, unknown>> {
  return adminFetch<Record<string, unknown>>(`/admin/drivers/${id}`);
}

export function fetchOrders(params?: {
  status?: string;
  dateFrom?: string;
  dateTo?: string;
  page?: number;
  limit?: number;
}): Promise<PaginatedResponse<Record<string, unknown>>> {
  const q = new URLSearchParams();
  if (params?.status) q.set('status', params.status);
  if (params?.dateFrom) q.set('dateFrom', params.dateFrom);
  if (params?.dateTo) q.set('dateTo', params.dateTo);
  if (params?.page) q.set('page', String(params.page));
  if (params?.limit) q.set('limit', String(params.limit));
  const query = q.toString();
  return adminFetch<PaginatedResponse<Record<string, unknown>>>(
    `/admin/orders${query ? `?${query}` : ''}`,
  );
}

export function fetchOrderById(id: string): Promise<Record<string, unknown>> {
  return adminFetch<Record<string, unknown>>(`/admin/orders/${id}`);
}

export function fetchPayments(params?: {
  page?: number;
  limit?: number;
}): Promise<PaginatedResponse<Record<string, unknown>>> {
  const q = new URLSearchParams();
  if (params?.page) q.set('page', String(params.page));
  if (params?.limit) q.set('limit', String(params.limit));
  const query = q.toString();
  return adminFetch<PaginatedResponse<Record<string, unknown>>>(
    `/admin/payments${query ? `?${query}` : ''}`,
  );
}

/** إكمال دفع معلّق تجريبياً — الباك اند يرفض في production. */
export function simulatePaymentComplete(
  paymentId: string,
): Promise<Record<string, unknown>> {
  return adminPost(`/admin/payments/${paymentId}/simulate-complete`);
}

export function fetchPayoutRequests(params?: {
  page?: number;
  limit?: number;
}): Promise<PaginatedResponse<Record<string, unknown>>> {
  const q = new URLSearchParams();
  if (params?.page) q.set('page', String(params.page));
  if (params?.limit) q.set('limit', String(params.limit));
  const query = q.toString();
  return adminFetch<PaginatedResponse<Record<string, unknown>>>(
    `/admin/payout-requests${query ? `?${query}` : ''}`,
  );
}

/** طبخ منزلي نشط (مقبول / جاهز / مُسلَّم) — ليس من جدول orders */
export function fetchHomeCookingLive(params?: {
  limit?: number;
}): Promise<{ items: Record<string, unknown>[] }> {
  const q = new URLSearchParams();
  if (params?.limit) q.set('limit', String(params.limit));
  const query = q.toString();
  return adminFetch<{ items: Record<string, unknown>[] }>(
    `/admin/home-cooking-live${query ? `?${query}` : ''}`,
  );
}

export function fetchAuditLogs(params?: {
  page?: number;
  limit?: number;
  action?: string;
  entityType?: string;
  actorId?: string;
  dateFrom?: string;
  dateTo?: string;
}): Promise<PaginatedResponse<Record<string, unknown>>> {
  const q = new URLSearchParams();
  if (params?.page) q.set('page', String(params.page));
  if (params?.limit) q.set('limit', String(params.limit));
  if (params?.action) q.set('action', params.action);
  if (params?.entityType) q.set('entityType', params.entityType);
  if (params?.actorId) q.set('actorId', params.actorId);
  if (params?.dateFrom) q.set('dateFrom', params.dateFrom);
  if (params?.dateTo) q.set('dateTo', params.dateTo);
  const query = q.toString();
  return adminFetch<PaginatedResponse<Record<string, unknown>>>(
    `/admin/audit-logs${query ? `?${query}` : ''}`,
  );
}

export interface AdminRoleOption {
  id: string;
  name: string;
  slug: string;
}

export interface AdminTeamUser {
  id: string;
  email: string;
  name: string;
  isActive: boolean;
  createdAt: string;
  role: { slug: string; name: string };
}

export function fetchAdminRoles(): Promise<{ roles: AdminRoleOption[] }> {
  return adminFetch<{ roles: AdminRoleOption[] }>('/admin/users/roles');
}

export function fetchAdminUsers(): Promise<{ items: AdminTeamUser[] }> {
  return adminFetch<{ items: AdminTeamUser[] }>('/admin/users');
}

export async function adminPatch(
  path: string,
  body?: Record<string, unknown>,
): Promise<Record<string, unknown>> {
  const fullUrl = path.startsWith('http') ? path : buildApiUrl(path);
  const res = await fetch(fullUrl, {
    method: 'PATCH',
    headers: getAuthHeaders(),
    body: body ? JSON.stringify(body) : undefined,
  });
  if (res.status === 401) {
    handleAdminUnauthorized();
  }
  if (!res.ok) {
    const err = await res.json().catch(() => ({}));
    throw new Error(
      (err as { message?: string }).message || res.statusText || String(res.status),
    );
  }
  return res.json();
}

export function createAdminUser(body: {
  email: string;
  name: string;
  password: string;
  roleSlug: string;
}): Promise<AdminTeamUser> {
  return adminPost('/admin/users', body) as unknown as Promise<AdminTeamUser>;
}

export function updateAdminUser(
  id: string,
  body: { name?: string; roleSlug?: string; isActive?: boolean },
): Promise<AdminTeamUser> {
  return adminPatch(`/admin/users/${id}`, body) as unknown as Promise<AdminTeamUser>;
}

export function resetAdminUserPassword(
  id: string,
  password: string,
): Promise<Record<string, unknown>> {
  return adminPost(`/admin/users/${id}/reset-password`, { password });
}

export async function adminLogout(): Promise<void> {
  const res = await fetch(buildApiUrl('/admin/auth/logout'), {
    method: 'POST',
    headers: getAuthHeaders(),
  });
  if (!res.ok) {
    const err = await res.json().catch(() => ({}));
    throw new Error(
      (err as { message?: string }).message || res.statusText || String(res.status),
    );
  }
}

export async function adminPost(
  path: string,
  body?: Record<string, unknown>,
): Promise<Record<string, unknown>> {
  const fullUrl = path.startsWith('http') ? path : buildApiUrl(path);
  const res = await fetch(fullUrl, {
    method: 'POST',
    headers: getAuthHeaders(),
    body: body ? JSON.stringify(body) : undefined,
  });
  if (res.status === 401) {
    handleAdminUnauthorized();
  }
  if (!res.ok) {
    const err = await res.json().catch(() => ({}));
    throw new Error(
      (err as { message?: string }).message || res.statusText || String(res.status),
    );
  }
  return res.json();
}

export function approveVendor(id: string): Promise<Record<string, unknown>> {
  return adminPost(`/admin/vendors/${id}/approve`);
}

export function resendVendorRegistrationEmail(
  id: string,
): Promise<Record<string, unknown>> {
  return adminPost(`/admin/vendors/${id}/resend-registration-email`);
}
export function rejectVendor(id: string, reason: string): Promise<Record<string, unknown>> {
  return adminPost(`/admin/vendors/${id}/reject`, { reason });
}
export function suspendVendor(id: string): Promise<Record<string, unknown>> {
  return adminPost(`/admin/vendors/${id}/suspend`);
}
export function reactivateVendor(id: string): Promise<Record<string, unknown>> {
  return adminPost(`/admin/vendors/${id}/reactivate`);
}
export function removeVendorForReregistration(
  id: string,
): Promise<Record<string, unknown>> {
  return adminPost(`/admin/vendors/${id}/remove-for-reregistration`);
}
export function approveDriver(id: string): Promise<Record<string, unknown>> {
  return adminPost(`/admin/drivers/${id}/approve`);
}
export function rejectDriver(id: string, reason: string): Promise<Record<string, unknown>> {
  return adminPost(`/admin/drivers/${id}/reject`, { reason });
}
export function suspendDriver(id: string): Promise<Record<string, unknown>> {
  return adminPost(`/admin/drivers/${id}/suspend`);
}
export function forceOrderStatus(id: string, status: string): Promise<Record<string, unknown>> {
  return adminPost(`/admin/orders/${id}/force-status`, { status });
}

export interface RiskFlag {
  id: string;
  type: string;
  title: string;
  description: string;
  severity: string;
  entityType: string;
  entityId: string | null;
}
export function fetchRiskFlags(): Promise<{ flags: RiskFlag[] }> {
  return adminFetch<{ flags: RiskFlag[] }>('/admin/risk-flags');
}

export function fetchDisputes(params?: {
  page?: number;
  limit?: number;
}): Promise<PaginatedResponse<Record<string, unknown>>> {
  const q = new URLSearchParams();
  if (params?.page) q.set('page', String(params.page));
  if (params?.limit) q.set('limit', String(params.limit));
  const query = q.toString();
  return adminFetch<PaginatedResponse<Record<string, unknown>>>(
    `/admin/disputes${query ? `?${query}` : ''}`,
  );
}

/** بلاغات جودة خاصة (رسالة العميل للإدارة) */
export function fetchServiceQualityTickets(params?: {
  status?: string;
  page?: number;
  limit?: number;
}): Promise<PaginatedResponse<Record<string, unknown>>> {
  const q = new URLSearchParams();
  if (params?.status) q.set('status', params.status);
  if (params?.page) q.set('page', String(params.page));
  if (params?.limit) q.set('limit', String(params.limit));
  const query = q.toString();
  return adminFetch<PaginatedResponse<Record<string, unknown>>>(
    `/admin/service-quality-tickets${query ? `?${query}` : ''}`,
  );
}

export function fetchServiceQualityTicketById(
  id: string,
): Promise<Record<string, unknown>> {
  return adminFetch<Record<string, unknown>>(
    `/admin/service-quality-tickets/${id}`,
  );
}

export function updateServiceQualityTicket(
  id: string,
  body: { status?: string; adminNotes?: string },
): Promise<Record<string, unknown>> {
  return adminPatch(`/admin/service-quality-tickets/${id}`, body);
}

/** تقييمات نجمية عامة (مرتبطة بطلب أو حجز) */
export function fetchServiceReviews(params?: {
  vendorId?: string;
  subjectType?: string;
  page?: number;
  limit?: number;
}): Promise<PaginatedResponse<Record<string, unknown>>> {
  const q = new URLSearchParams();
  if (params?.vendorId) q.set('vendorId', params.vendorId);
  if (params?.subjectType) q.set('subjectType', params.subjectType);
  if (params?.page) q.set('page', String(params.page));
  if (params?.limit) q.set('limit', String(params.limit));
  const query = q.toString();
  return adminFetch<PaginatedResponse<Record<string, unknown>>>(
    `/admin/service-reviews${query ? `?${query}` : ''}`,
  );
}

/** طلبات الطبخ المنزلي بانتظار تحقق التحويل البنكي */
export function fetchHomeCookingPaymentQueue(params?: {
  page?: number;
  limit?: number;
}): Promise<{
  items: Record<string, unknown>[];
  total: number;
  page: number;
  limit: number;
}> {
  const q = new URLSearchParams();
  if (params?.page) q.set('page', String(params.page));
  if (params?.limit) q.set('limit', String(params.limit));
  const query = q.toString();
  return adminFetch(
    `/admin/home-cooking-payment-queue${query ? `?${query}` : ''}`,
  );
}

export function verifyHomeCookingPayment(
  requestId: string,
): Promise<Record<string, unknown>> {
  return adminPost(`/admin/home-cooking-requests/${requestId}/verify-payment`);
}

/** أرشيف طلبات الطبخ المنزلي المكتملة (رمز إتمام بعد استلام العميل) */
export function fetchHomeCookingCompleted(params?: {
  page?: number;
  limit?: number;
}): Promise<{
  items: Record<string, unknown>[];
  total: number;
  page: number;
  limit: number;
}> {
  const q = new URLSearchParams();
  if (params?.page) q.set('page', String(params.page));
  if (params?.limit) q.set('limit', String(params.limit));
  const query = q.toString();
  return adminFetch(
    `/admin/home-cooking-completed${query ? `?${query}` : ''}`,
  );
}
