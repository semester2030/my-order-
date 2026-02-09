import { cn } from '@/lib/cn'

interface EmptyStateProps {
  title: string
  description?: string
  className?: string
  children?: React.ReactNode
}

export function EmptyState({ title, description, className, children }: EmptyStateProps) {
  return (
    <div
      className={cn(
        'flex flex-col items-center justify-center rounded-card border border-border bg-surface py-12 text-center transition-smooth',
        className
      )}
    >
      <p className="text-sm font-medium text-text-primary">{title}</p>
      {description && <p className="mt-1 text-sm text-text-secondary">{description}</p>}
      {children && <div className="mt-4">{children}</div>}
    </div>
  )
}
