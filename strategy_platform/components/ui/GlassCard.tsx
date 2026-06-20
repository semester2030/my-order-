'use client'

import { cn } from '@/lib/utils'

export function GlassCard({
  className,
  children,
  hover = false,
}: {
  className?: string
  children: React.ReactNode
  hover?: boolean
}) {
  return (
    <div
      className={cn(
        'glass-card p-5 transition-all duration-300',
        hover && 'hover:shadow-glow hover:-translate-y-0.5',
        className,
      )}
    >
      {children}
    </div>
  )
}

export function KpiCard({
  label = '',
  labelAr,
  value,
  sub,
  trend,
  accent = false,
}: {
  label?: string
  labelAr?: string
  value: string
  sub?: string
  trend?: 'up' | 'down' | 'neutral'
  accent?: boolean
}) {
  return (
    <GlassCard hover className={cn(accent && 'ring-1 ring-brand/20')}>
      <p className="text-xs text-ink-muted uppercase tracking-wider">{labelAr || label}</p>
      <p className={cn('text-2xl font-semibold mt-1', accent ? 'text-brand' : 'text-ink')}>
        {value}
      </p>
      {sub && <p className="text-xs text-ink-muted mt-1">{sub}</p>}
      {trend && (
        <span
          className={cn(
            'inline-block mt-2 text-xs px-2 py-0.5 rounded-full',
            trend === 'up' && 'bg-emerald-50 text-emerald-600',
            trend === 'down' && 'bg-red-50 text-red-600',
            trend === 'neutral' && 'bg-gray-100 text-gray-600',
          )}
        >
          {trend === 'up' ? '↑' : trend === 'down' ? '↓' : '→'}
        </span>
      )}
    </GlassCard>
  )
}
