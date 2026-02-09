import { cn } from '@/lib/cn'

interface CardProps {
  children: React.ReactNode
  className?: string
}

export function Card({ children, className }: CardProps) {
  return (
    <div
      className={cn(
        'rounded-card border border-border bg-surface-elevated p-0 shadow-card',
        'transition-smooth hover:shadow-card-hover hover:border-border/90',
        'active:scale-[0.998]',
        className
      )}
    >
      {children}
    </div>
  )
}

interface CardHeaderProps {
  title: string
  description?: string
  action?: React.ReactNode
  className?: string
}

export function CardHeader({ title, description, action, className }: CardHeaderProps) {
  return (
    <div
      className={cn(
        'flex flex-col gap-1 border-b border-divider bg-surface rounded-t-card px-6 py-4',
        'sm:flex-row sm:items-center sm:justify-between',
        'transition-smooth',
        className
      )}
    >
      <div>
        <h2 className="text-sm font-bold tracking-tight text-text-primary">
          {title}
        </h2>
        {description && (
          <p className="mt-0.5 text-xs text-text-secondary">{description}</p>
        )}
      </div>
      {action && <div className="mt-2 sm:mt-0">{action}</div>}
    </div>
  )
}

interface CardBodyProps {
  children: React.ReactNode
  className?: string
}

export function CardBody({ children, className }: CardBodyProps) {
  return (
    <div className={cn('px-6 py-4 transition-smooth', className)}>
      {children}
    </div>
  )
}
