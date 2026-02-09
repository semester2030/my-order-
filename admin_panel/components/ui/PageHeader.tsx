import { cn } from '@/lib/cn'

interface PageHeaderProps {
  title: string
  description?: string
  subtitle?: string
  className?: string
  children?: React.ReactNode
}

export function PageHeader({
  title,
  description,
  subtitle,
  className,
  children,
}: PageHeaderProps) {
  return (
    <div
      className={cn(
        'mb-8 flex flex-col gap-2 sm:flex-row sm:items-end sm:justify-between transition-smooth',
        className
      )}
    >
      <div>
        <h1 className="text-2xl font-bold tracking-tight text-text-primary md:text-3xl">
          {title}
        </h1>
        {(description || subtitle) && (
          <p className="mt-1.5 text-sm text-text-secondary max-w-2xl leading-relaxed">
            {description ?? subtitle}
          </p>
        )}
      </div>
      {children && <div className="mt-2 sm:mt-0 flex-shrink-0">{children}</div>}
    </div>
  )
}
