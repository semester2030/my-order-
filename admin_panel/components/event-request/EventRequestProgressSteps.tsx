'use client'

import { format } from 'date-fns'
import { ar } from 'date-fns/locale'

export type EventRequestProgressStep = {
  id: string
  icon: string
  done: boolean
  current: boolean
  at: string | null
}

const stepLabels: Record<string, string> = {
  created: 'إنشاء الطلب',
  quoted: 'عرض السعر',
  payment_declared: 'إعلان الدفع',
  payment_received: 'تأكيد استلام الدفع',
  preparing: 'قيد التنفيذ',
  ready: 'جاهز',
  handed_over: 'تم التسليم',
  completed: 'مكتمل',
}

export function parseProgressSteps(raw: unknown): EventRequestProgressStep[] {
  if (!Array.isArray(raw)) return []
  return raw
    .filter((s): s is Record<string, unknown> => s != null && typeof s === 'object')
    .map((s) => ({
      id: String(s.id ?? ''),
      icon: String(s.icon ?? ''),
      done: s.done === true,
      current: s.current === true,
      at: s.at != null ? String(s.at) : null,
    }))
}

export function EventRequestProgressSteps({
  steps,
  compact = false,
}: {
  steps: EventRequestProgressStep[]
  compact?: boolean
}) {
  if (steps.length === 0) return null

  return (
    <ol className={compact ? 'space-y-1 text-xs' : 'space-y-2 text-sm'}>
      {steps.map((step) => {
        const label = stepLabels[step.id] ?? step.id
        const atLabel =
          step.at &&
          format(new Date(step.at), compact ? 'd/M HH:mm' : 'd MMM yyyy HH:mm', {
            locale: ar,
          })

        return (
          <li
            key={step.id}
            className={`flex items-start gap-2 ${
              step.done
                ? 'text-text-primary'
                : step.current
                  ? 'font-semibold text-primary'
                  : 'text-text-secondary/60'
            }`}
          >
            <span aria-hidden className="mt-0.5 shrink-0">
              {step.done ? '✓' : step.current ? '●' : '○'}
            </span>
            <span className="min-w-0 flex-1">
              {label}
              {atLabel ? (
                <span className="block text-text-secondary font-normal">{atLabel}</span>
              ) : null}
            </span>
          </li>
        )
      })}
    </ol>
  )
}

export function paymentMethodLabel(method: unknown): string {
  const m = String(method ?? '').toLowerCase()
  if (m === 'stc_bank') return 'STC Bank'
  if (m === 'cash') return 'كاش'
  return m || '—'
}
