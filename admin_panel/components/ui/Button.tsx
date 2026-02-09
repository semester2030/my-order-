import { cn } from '@/lib/cn'

type ButtonVariant = 'primary' | 'secondary' | 'ghost' | 'outline' | 'danger'

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: ButtonVariant
  size?: 'sm' | 'md' | 'lg'
  children: React.ReactNode
  className?: string
}

const variants: Record<ButtonVariant, string> = {
  primary:
    'bg-primary text-text-inverse hover:bg-primary-dark border-transparent shadow-button-primary active:scale-[0.98]',
  secondary:
    'bg-secondary-container text-text-primary hover:bg-secondary-container/80 border-transparent',
  ghost:
    'bg-transparent text-text-primary hover:bg-secondary-container border-transparent',
  outline:
    'bg-surface-elevated text-text-primary border-border hover:bg-surface hover:border-primary/30',
  danger:
    'bg-error text-text-inverse hover:bg-red-600 border-transparent active:scale-[0.98]',
}

const sizes = {
  sm: 'h-8 px-3 text-xs rounded-button',
  md: 'h-9 px-4 text-sm rounded-button font-semibold',
  lg: 'h-10 px-5 text-sm rounded-button font-semibold',
}

export function Button({
  variant = 'primary',
  size = 'md',
  className,
  children,
  ...props
}: ButtonProps) {
  return (
    <button
      type="button"
      className={cn(
        'inline-flex items-center justify-center font-medium border transition-smooth focus-ring',
        'disabled:opacity-50 disabled:pointer-events-none disabled:scale-100',
        variants[variant],
        sizes[size],
        className
      )}
      {...props}
    >
      {children}
    </button>
  )
}
