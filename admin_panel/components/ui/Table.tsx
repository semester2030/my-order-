import { cn } from '@/lib/cn'

export function Table({ className, ...props }: React.ComponentProps<'table'>) {
  return (
    <div className="overflow-x-auto rounded-b-card">
      <table
        className={cn('w-full min-w-[600px] text-sm text-right', className)}
        {...props}
      />
    </div>
  )
}

export function TableHeader({ className, ...props }: React.ComponentProps<'thead'>) {
  return (
    <thead
      className={cn(
        'border-b border-divider bg-surface text-xs font-bold uppercase tracking-wider text-text-secondary',
        'transition-smooth',
        className
      )}
      {...props}
    />
  )
}

export function TableBody(props: React.ComponentProps<'tbody'>) {
  return <tbody {...props} />
}

export function TableRow({ className, ...props }: React.ComponentProps<'tr'>) {
  return (
    <tr
      className={cn(
        'border-b border-divider transition-smooth last:border-0 hover:bg-primary-container/30',
        'focus-within:bg-primary-container/20',
        className
      )}
      {...props}
    />
  )
}

export function TableHead({ className, ...props }: React.ComponentProps<'th'>) {
  return (
    <th
      className={cn(
        'px-5 py-3.5 text-right font-bold text-text-secondary',
        className
      )}
      {...props}
    />
  )
}

export function TableCell({ className, ...props }: React.ComponentProps<'td'>) {
  return (
    <td
      className={cn(
        'px-5 py-3.5 text-text-primary transition-smooth',
        className
      )}
      {...props}
    />
  )
}
