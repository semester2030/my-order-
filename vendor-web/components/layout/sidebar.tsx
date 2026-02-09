'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import {
  LayoutDashboard,
  ShoppingBag,
  Utensils,
  ClipboardList,
  ListChecks,
  Users,
  BarChart3,
  Settings,
  LogOut,
} from 'lucide-react'
import { cn } from '@/lib/utils/cn'
import { useAuthStore } from '@/lib/store/auth-store'
import { authApi } from '@/lib/api/auth'
import { useLanguage } from '@/lib/contexts/language-context'
import { useVendorProfile } from '@/lib/contexts/vendor-profile-context'

const navAll = [
  { titleKey: 'nav.dashboard', href: '/dashboard', icon: LayoutDashboard },
  { titleKey: 'nav.orders', href: '/orders', icon: ShoppingBag },
  { titleKey: 'nav.menu', href: '/menu', icon: Utensils },
  { titleKey: 'nav.offerableServices', href: '/services', icon: ClipboardList },
  { titleKey: 'nav.staff', href: '/staff', icon: Users },
  { titleKey: 'nav.analytics', href: '/analytics', icon: BarChart3 },
  { titleKey: 'nav.settings', href: '/settings', icon: Settings },
]

const navPopularCooking = [
  { titleKey: 'nav.dashboard', href: '/dashboard', icon: LayoutDashboard },
  { titleKey: 'nav.orders', href: '/orders', icon: ShoppingBag },
  { titleKey: 'nav.menu', href: '/menu', icon: Utensils },
  { titleKey: 'nav.offerableServices', href: '/services', icon: ClipboardList },
  { titleKey: 'nav.sideOrders', href: '/side-orders', icon: ListChecks },
  { titleKey: 'nav.staff', href: '/staff', icon: Users },
  { titleKey: 'nav.analytics', href: '/analytics', icon: BarChart3 },
  { titleKey: 'nav.settings', href: '/settings', icon: Settings },
]

export function Sidebar() {
  const pathname = usePathname()
  const { clearAuth } = useAuthStore()
  const { t } = useLanguage()
  const { profile } = useVendorProfile()
  const isPopularCooking = profile?.providerCategory === 'popular_cooking'
  const menuItems = isPopularCooking ? navPopularCooking : navAll

  const handleLogout = async () => {
    await authApi.logout()
    window.location.href = '/login'
  }

  return (
    <aside className="fixed left-0 rtl:left-auto rtl:right-0 top-0 h-screen w-64 bg-sidebar text-white flex flex-col">
      <div className="p-6 border-b border-sidebarHover">
        <h1 className="text-xl font-bold text-primary">{t('appName')}</h1>
      </div>

      <nav className="flex-1 p-4 space-y-2 overflow-y-auto custom-scrollbar">
        {menuItems.map((item) => {
          const Icon = item.icon
          const isActive = pathname === item.href || (item.href !== '/' && pathname.startsWith(item.href + '/'))
          return (
            <Link
              key={item.href}
              href={item.href}
              className={cn(
                'flex items-center gap-3 px-4 py-3 rounded-lg transition-colors',
                isActive
                  ? 'bg-sidebarActive text-white'
                  : 'text-gray-300 hover:bg-sidebarHover hover:text-white',
              )}
            >
              <Icon className="w-5 h-5" />
              <span className="font-medium">{t(item.titleKey)}</span>
            </Link>
          )
        })}
      </nav>

      <div className="p-4 border-t border-sidebarHover">
        <button
          onClick={handleLogout}
          className="flex items-center gap-3 w-full px-4 py-3 rounded-lg text-gray-300 hover:bg-sidebarHover hover:text-white transition-colors"
        >
          <LogOut className="w-5 h-5" />
          <span className="font-medium">{t('logout')}</span>
        </button>
      </div>
    </aside>
  )
}
