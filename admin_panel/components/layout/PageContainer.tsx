import { cn } from '@/lib/cn'

interface PageContainerProps {
  children: React.ReactNode
  className?: string
}

export function PageContainer({ children, className }: PageContainerProps) {
  return (
    <main
      className={cn(
        'page-container flex-1 p-6 md:p-8 transition-smooth',
        className
      )}
    >
      {children}
    </main>
  )
}
