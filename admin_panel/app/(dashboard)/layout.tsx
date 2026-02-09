import { Sidebar } from '@/components/layout/Sidebar'
import { TopBar } from '@/components/layout/TopBar'
import { PageContainer } from '@/components/layout/PageContainer'

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <div className="flex min-h-screen bg-surface-warmBg">
      <Sidebar />
      <div className="flex flex-1 flex-col min-w-0">
        <TopBar />
        <PageContainer>{children}</PageContainer>
      </div>
    </div>
  )
}
