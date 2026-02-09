import { cn } from '@/lib/cn'

type BadgeVariant = 'default' | 'success' | 'warning' | 'danger' | 'info' | 'primary'

interface BadgeProps {
  children: React.ReactNode
  variant?: BadgeVariant
  className?: string
}

const variants: Record<BadgeVariant, string> = {
  default: 'bg-secondary-container text-text-secondary',
  success: 'bg-emerald-50 text-success font-semibold',
  warning: 'bg-amber-50 text-warning font-semibold',
  danger: 'bg-red-50 text-error font-semibold',
  info: 'bg-blue-50 text-info font-semibold',
  primary: 'bg-primary-container text-primary-dark font-semibold',
}

export function Badge({ children, variant = 'default', className }: BadgeProps) {
  return (
    <span
      className={cn(
        'inline-flex items-center rounded-badge px-2.5 py-0.5 text-[11px] font-medium',
        'transition-smooth',
        variants[variant],
        className
      )}
    >
      {children}
    </span>
  )
}
