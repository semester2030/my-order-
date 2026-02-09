const DEFAULT_API_URL = 'http://localhost:3001';

const getBaseUrl = () => {
  return process.env.NEXT_PUBLIC_API_URL || DEFAULT_API_URL;
};

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
  const base = getBaseUrl();
  const res = await fetch(`${base}/api/admin/auth/login`, {
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
  const base = getBaseUrl();
  const token = getToken();
  if (!token) throw new Error('No token');
  const res = await fetch(`${base}/api/admin/auth/refresh`, {
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
  const base = getBaseUrl();
  const token = getToken();
  if (!token) return null;
  const res = await fetch(`${base}/api/admin/auth/me`, {
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

export function hasAdminToken(): boolean {
  return !!getToken();
}

/** Authenticated GET for admin API. Use with SWR: useSWR(key, adminFetch). */
export async function adminFetch<T = unknown>(url: string): Promise<T> {
  const base = getBaseUrl();
  const fullUrl = url.startsWith('http') ? url : `${base}/api${url}`;
  const res = await fetch(fullUrl, { headers: getAuthHeaders() });
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
  category?: string;
  page?: number;
  limit?: number;
}): Promise<PaginatedResponse<Record<string, unknown>>> {
  const q = new URLSearchParams();
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

export function fetchAuditLogs(params?: {
  page?: number;
  limit?: number;
  action?: string;
  entityType?: string;
}): Promise<PaginatedResponse<Record<string, unknown>>> {
  const q = new URLSearchParams();
  if (params?.page) q.set('page', String(params.page));
  if (params?.limit) q.set('limit', String(params.limit));
  if (params?.action) q.set('action', params.action);
  if (params?.entityType) q.set('entityType', params.entityType);
  const query = q.toString();
  return adminFetch<PaginatedResponse<Record<string, unknown>>>(
    `/admin/audit-logs${query ? `?${query}` : ''}`,
  );
}

export async function adminPost(
  path: string,
  body?: Record<string, unknown>,
): Promise<Record<string, unknown>> {
  const base = getBaseUrl();
  const fullUrl = path.startsWith('http') ? path : `${base}/api${path}`;
  const res = await fetch(fullUrl, {
    method: 'POST',
    headers: getAuthHeaders(),
    body: body ? JSON.stringify(body) : undefined,
  });
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
export function rejectVendor(id: string, reason: string): Promise<Record<string, unknown>> {
  return adminPost(`/admin/vendors/${id}/reject`, { reason });
}
export function suspendVendor(id: string): Promise<Record<string, unknown>> {
  return adminPost(`/admin/vendors/${id}/suspend`);
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
