'use client'

import { cn } from '@/lib/utils'

export function EditableNumber({
  label,
  labelAr,
  value,
  onChange,
  min,
  max,
  step = 1,
  suffix,
  prefix,
  className,
}: {
  label: string
  labelAr?: string
  value: number
  onChange: (v: number) => void
  min?: number
  max?: number
  step?: number
  suffix?: string
  prefix?: string
  className?: string
}) {
  return (
    <div className={cn('space-y-2', className)}>
      <div className="flex justify-between items-center gap-2">
        <label className="text-sm text-ink-soft font-medium">{labelAr || label}</label>
        <span className="text-xs text-ink-muted">{label !== (labelAr || '') ? label : ''}</span>
      </div>
      <div className="flex items-center gap-2">
        {prefix && <span className="text-sm text-ink-muted">{prefix}</span>}
        <input
          type="number"
          value={value}
          min={min}
          max={max}
          step={step}
          onChange={(e) => onChange(parseFloat(e.target.value) || 0)}
          className="w-full px-3 py-2 rounded-lg border border-gray-200 bg-white/90 text-sm focus:outline-none focus:ring-2 focus:ring-brand/30 focus:border-brand transition-all"
        />
        {suffix && <span className="text-sm text-ink-muted shrink-0">{suffix}</span>}
      </div>
      {min !== undefined && max !== undefined && (
        <input
          type="range"
          min={min}
          max={max}
          step={step}
          value={value}
          onChange={(e) => onChange(parseFloat(e.target.value))}
          className="w-full h-1.5 rounded-full appearance-none bg-gray-200 accent-brand cursor-pointer"
        />
      )}
    </div>
  )
}

export function EditableText({
  label,
  value,
  onChange,
  multiline = false,
}: {
  label: string
  value: string
  onChange: (v: string) => void
  multiline?: boolean
}) {
  const cls =
    'w-full px-3 py-2 rounded-lg border border-gray-200 bg-white/90 text-sm focus:outline-none focus:ring-2 focus:ring-brand/30 focus:border-brand'
  return (
    <div className="space-y-2">
      <label className="text-sm text-ink-soft font-medium">{label}</label>
      {multiline ? (
        <textarea rows={2} value={value} onChange={(e) => onChange(e.target.value)} className={cls} />
      ) : (
        <input type="text" value={value} onChange={(e) => onChange(e.target.value)} className={cls} />
      )}
    </div>
  )
}
