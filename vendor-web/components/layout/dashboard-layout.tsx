'use client'

import { VendorProfileProvider } from '@/lib/contexts/vendor-profile-context'
import { Sidebar } from './sidebar'
import { Header } from './header'

interface DashboardLayoutProps {
  children: React.ReactNode
}

export function DashboardLayout({ children }: DashboardLayoutProps) {
  return (
    <VendorProfileProvider>
      <div className="min-h-screen bg-surface">
        <Sidebar />
        <div className="ml-64 rtl:ml-0 rtl:mr-64">
          <Header />
          <main className="p-6">{children}</main>
        </div>
      </div>
    </VendorProfileProvider>
  )
}
