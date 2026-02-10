'use client'

import Link from 'next/link'
import { usePathname, useRouter } from 'next/navigation'
import { cn } from '@/lib/cn'
import { clearAdminToken } from '@/lib/api/client'
import {
  LayoutDashboard,
  Store,
  FileCheck,
  Users,
  UserCheck,
  ShoppingBag,
  Radio,
  CreditCard,
  MessageSquare,
  Activity,
  ShieldAlert,
  Settings,
  FileText,
  LogOut,
} from 'lucide-react'

const navItems: { href: string; label: string; icon: React.ComponentType<{ className?: string }> }[] = [
  { href: '/dashboard', label: 'لوحة التحكم', icon: LayoutDashboard },
  { href: '/vendors', label: 'المطاعم', icon: Store },
  { href: '/vendors/applications', label: 'طلبات المطاعم', icon: FileCheck },
  { href: '/drivers', label: 'السائقون', icon: Users },
  { href: '/drivers/applications', label: 'طلبات السائقين', icon: UserCheck },
  { href: '/orders', label: 'الطلبات', icon: ShoppingBag },
  { href: '/orders/live', label: 'طلبات حية', icon: Radio },
  { href: '/payments', label: 'المدفوعات', icon: CreditCard },
  { href: '/disputes', label: 'الشكاوى', icon: MessageSquare },
  { href: '/monitoring', label: 'المراقبة', icon: Activity },
  { href: '/risk_engine', label: 'منع التلاعب', icon: ShieldAlert },
  { href: '/settings', label: 'الإعدادات', icon: Settings },
  { href: '/audit_logs', label: 'سجل التدقيق', icon: FileText },
]

export function Sidebar() {
  const pathname = usePathname()
  const router = useRouter()

  const handleLogout = () => {
    clearAdminToken()
    router.push('/auth/login')
    router.refresh()
  }

  return (
    <aside
      className={cn(
        'flex w-[268px] flex-shrink-0 flex-col bg-secondary text-text-inverse',
        'border-l border-white/10 shadow-sidebar',
        'transition-smooth'
      )}
    >
      <div className="flex h-16 items-center gap-3 border-b border-white/10 px-5">
        <div
          className={cn(
            'flex h-10 w-10 flex-shrink-0 items-center justify-center rounded-xl',
            'bg-primary text-white shadow-md',
            'transition-smooth hover:bg-primary-dark'
          )}
        >
          <LayoutDashboard className="h-5 w-5" />
        </div>
        <span className="text-base font-bold tracking-tight text-white">
          لوحة الإدارة
        </span>
      </div>
      <nav className="flex-1 space-y-0.5 overflow-y-auto px-3 py-4">
        {navItems.map((item) => {
          const isActive =
            pathname === item.href ||
            (item.href !== '/dashboard' && pathname.startsWith(item.href))
          const Icon = item.icon
          return (
            <Link
              key={item.href}
              href={item.href}
              className={cn(
                'flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium',
                'transition-smooth focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 focus:ring-offset-secondary',
                isActive
                  ? 'bg-primary text-white shadow-md'
                  : 'text-white/75 hover:bg-white/10 hover:text-white'
              )}
            >
              <Icon className="h-[18px] w-[18px] flex-shrink-0 opacity-95" />
              <span>{item.label}</span>
            </Link>
          )
        })}
      </nav>
      <div className="border-t border-white/10 p-3">
        <button
          type="button"
          onClick={handleLogout}
          className={cn(
            'flex w-full items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium',
            'text-white/75 hover:bg-white/10 hover:text-white',
            'transition-smooth focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 focus:ring-offset-secondary'
          )}
        >
          <LogOut className="h-[18px] w-[18px] flex-shrink-0 opacity-95" />
          <span>تسجيل الخروج</span>
        </button>
      </div>
    </aside>
  )
}
