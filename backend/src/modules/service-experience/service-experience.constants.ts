/** نوع الكيان المُقيَّم — مصدر واحد للأهلية والتخزين */
export enum ServiceReviewSubjectType {
  EVENT_REQUEST = 'event_request',
  ORDER = 'order',
}

export const SERVICE_EXPERIENCE_REVIEW_WINDOW_DAYS = 14;

export const QUALITY_TICKET_CATEGORIES = [
  'quality',
  'hygiene',
  'delay',
  'billing',
  'other',
] as const;

export type QualityTicketCategory = (typeof QUALITY_TICKET_CATEGORIES)[number];

export enum QualityTicketStatus {
  OPEN = 'open',
  IN_PROGRESS = 'in_progress',
  CLOSED = 'closed',
}
