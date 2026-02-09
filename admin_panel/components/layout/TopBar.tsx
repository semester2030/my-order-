'use client'

import { cn } from '@/lib/cn'

interface TopBarProps {
  children?: React.ReactNode
  className?: string
}

export function TopBar({ children, className }: TopBarProps) {
  return (
    <header
      className={cn(
        'flex h-14 flex-shrink-0 items-center justify-between',
        'border-b border-border bg-surface-elevated px-6',
        'transition-smooth',
        className
      )}
    >
      {children ?? <div className="h-4 w-4" />}
    </header>
  )
}
