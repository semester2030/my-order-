import {
  EventRequest,
  EventRequestStatus,
  isPaidServiceEventRequestType,
} from './entities/event-request.entity';
import { User } from '../users/entities/user.entity';
import { Vendor } from '../vendors/entities/vendor.entity';
import { Address } from '../addresses/entities/address.entity';

export type EventRequestProgressStep = {
  id: string;
  icon: string;
  done: boolean;
  current: boolean;
  at: string | null;
};

export type PresentedEventRequest = Record<string, unknown> & {
  progressSteps: EventRequestProgressStep[];
};

function iso(d: Date | null | undefined): string | null {
  if (!d) return null;
  return d instanceof Date ? d.toISOString() : String(d);
}

function pickVendorPhone(v: Vendor): string | null {
  const candidates = [v.phoneNumber, v.ownerPhone];
  for (const raw of candidates) {
    const s = raw?.trim();
    if (!s || s.includes('@')) continue;
    return s;
  }
  return null;
}

function pickVendor(v: Vendor | null | undefined) {
  if (!v) return null;
  return {
    id: v.id,
    name: v.tradeName?.trim() || v.name?.trim() || null,
    tradeName: v.tradeName ?? null,
    phoneNumber: pickVendorPhone(v),
    email: v.email ?? null,
  };
}

function pickUser(u: User | null | undefined) {
  if (!u) return null;
  return {
    id: u.id,
    name: u.name ?? null,
    phone: u.phone ?? null,
    email: u.email ?? null,
  };
}

function pickAddress(a: Address | null | undefined) {
  if (!a) return null;
  return {
    id: a.id,
    streetAddress: a.streetAddress ?? null,
    city: a.city ?? null,
    latitude: a.latitude ?? null,
    longitude: a.longitude ?? null,
  };
}

function step(
  id: string,
  icon: string,
  done: boolean,
  current: boolean,
  at: Date | null | undefined,
): EventRequestProgressStep {
  return { id, icon, done, current, at: iso(at) };
}

/** خطوات متابعة موحّدة — مصدر واحد للعميل والمزوّd والإدارة */
export function buildEventRequestProgressSteps(
  row: EventRequest,
): EventRequestProgressStep[] {
  if (!isPaidServiceEventRequestType(row.requestType)) {
    return [];
  }

  const s = row.status;
  const after = (statuses: EventRequestStatus[]) => statuses.includes(s);
  const isCancelled =
    s === EventRequestStatus.CANCELLED || s === EventRequestStatus.REJECTED;

  const createdDone = true;
  const quotedDone =
    after([
      EventRequestStatus.QUOTED,
      EventRequestStatus.PAYMENT_PENDING,
      EventRequestStatus.ACCEPTED,
      EventRequestStatus.READY,
      EventRequestStatus.HANDED_OVER,
      EventRequestStatus.COMPLETED,
    ]) || isCancelled;
  const paymentDeclaredDone =
    after([
      EventRequestStatus.PAYMENT_PENDING,
      EventRequestStatus.ACCEPTED,
      EventRequestStatus.READY,
      EventRequestStatus.HANDED_OVER,
      EventRequestStatus.COMPLETED,
    ]) || !!row.paymentDeclaredAt;
  const paymentReceivedDone =
    after([
      EventRequestStatus.ACCEPTED,
      EventRequestStatus.READY,
      EventRequestStatus.HANDED_OVER,
      EventRequestStatus.COMPLETED,
    ]) || !!row.paymentVerifiedAt;
  const preparingDone = after([
    EventRequestStatus.READY,
    EventRequestStatus.HANDED_OVER,
    EventRequestStatus.COMPLETED,
  ]);
  const readyDone =
    after([EventRequestStatus.HANDED_OVER, EventRequestStatus.COMPLETED]) ||
    !!row.readyAt;
  const handedOverDone =
    after([EventRequestStatus.HANDED_OVER, EventRequestStatus.COMPLETED]) ||
    !!row.handedOverAt;
  const completedDone = s === EventRequestStatus.COMPLETED;

  const currentId = (() => {
    if (isCancelled) return null;
    if (s === EventRequestStatus.PENDING) return 'created';
    if (s === EventRequestStatus.QUOTED) return 'quoted';
    if (s === EventRequestStatus.PAYMENT_PENDING) return 'payment_declared';
    if (s === EventRequestStatus.ACCEPTED) return 'preparing';
    if (s === EventRequestStatus.READY) return 'ready';
    if (s === EventRequestStatus.HANDED_OVER) return 'handed_over';
    if (s === EventRequestStatus.COMPLETED) return 'completed';
    return null;
  })();

  const cur = (id: string) => currentId === id;

  return [
    step('created', 'receipt_long', createdDone, cur('created'), row.createdAt),
    step('quoted', 'sell', quotedDone, cur('quoted'), row.quotedAt),
    step(
      'payment_declared',
      'payments',
      paymentDeclaredDone,
      cur('payment_declared'),
      row.paymentDeclaredAt,
    ),
    step(
      'payment_received',
      'account_balance_wallet',
      paymentReceivedDone,
      cur('payment_received'),
      row.paymentVerifiedAt,
    ),
    step(
      'preparing',
      'restaurant',
      preparingDone,
      cur('preparing'),
      row.paymentVerifiedAt,
    ),
    step('ready', 'check_circle', readyDone, cur('ready'), row.readyAt),
    step(
      'handed_over',
      'local_shipping',
      handedOverDone,
      cur('handed_over'),
      row.handedOverAt,
    ),
    step('completed', 'verified', completedDone, cur('completed'), row.completedAt),
  ];
}

/** JSON آمن بدون مراجع دائرية من كيان TypeORM */
export function presentEventRequest(row: EventRequest): PresentedEventRequest {
  return {
    id: row.id,
    userId: row.userId,
    vendorId: row.vendorId,
    addressId: row.addressId,
    requestType: row.requestType,
    scheduledDate: row.scheduledDate,
    scheduledTime: row.scheduledTime,
    mealSlot: row.mealSlot,
    guestsCount: row.guestsCount,
    addOns: row.addOns,
    dishIds: row.dishIds,
    customDishNames: row.customDishNames,
    delivery: row.delivery,
    notes: row.notes,
    status: row.status,
    quotedAmount: row.quotedAmount,
    quoteNotes: row.quoteNotes,
    quotedAt: iso(row.quotedAt),
    paymentMethod: row.paymentMethod ?? null,
    paymentReference: row.paymentReference,
    paymentDeclaredAt: iso(row.paymentDeclaredAt),
    paymentVerifiedAt: iso(row.paymentVerifiedAt),
    paymentVerifiedByAdminId: row.paymentVerifiedByAdminId,
    cashPaidDeclaredAt: iso(row.cashPaidDeclaredAt),
    readyAt: iso(row.readyAt),
    handedOverAt: iso(row.handedOverAt),
    handoverNotes: row.handoverNotes,
    completedAt: iso(row.completedAt),
    completionCertificateCode: row.completionCertificateCode,
    respondBy: iso(row.respondBy),
    createdAt: iso(row.createdAt),
    vendor: pickVendor(row.vendor),
    user: pickUser(row.user),
    address: pickAddress(row.address),
    progressSteps: buildEventRequestProgressSteps(row),
  };
}

export function presentEventRequests(rows: EventRequest[]): PresentedEventRequest[] {
  return rows.map((row) => presentEventRequest(row));
}
