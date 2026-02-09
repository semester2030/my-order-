import { cn } from '@/lib/cn'
import type { LucideIcon } from 'lucide-react'

interface StatCardProps {
  title: string
  value: string | number
  subtitle?: string
  trend?: { value: string; positive: boolean }
  icon?: LucideIcon
  className?: string
}

export function StatCard({ title, value, subtitle, trend, icon: Icon, className }: StatCardProps) {
  return (
    <div
      className={cn(
        'rounded-card border border-border bg-surface-elevated p-5 shadow-card',
        'transition-smooth hover:shadow-card-hover hover:border-primary/20 hover:-translate-y-0.5',
        'focus-within:ring-2 focus-within:ring-primary/20 focus-within:ring-offset-2',
        'cursor-default',
        className
      )}
    >
      <div className="flex items-start justify-between gap-3">
        <div className="min-w-0 flex-1">
          <p className="text-xs font-semibold uppercase tracking-wider text-text-secondary">
            {title}
          </p>
          <p className="mt-2 text-2xl font-bold tracking-tight text-text-primary tabular-nums">
            {value}
          </p>
          {subtitle && (
            <p className="mt-0.5 text-xs text-text-tertiary">{subtitle}</p>
          )}
          {trend && (
            <p
              className={cn(
                'mt-1.5 text-xs font-semibold',
                trend.positive ? 'text-success' : 'text-error'
              )}
            >
              {trend.value}
            </p>
          )}
        </div>
        {Icon && (
          <div
            className={cn(
              'flex h-11 w-11 flex-shrink-0 items-center justify-center rounded-xl',
              'bg-primary-container text-primary',
              'transition-smooth hover:bg-primary/10'
            )}
          >
            <Icon className="h-5 w-5" />
          </div>
        )}
      </div>
    </div>
  )
}
