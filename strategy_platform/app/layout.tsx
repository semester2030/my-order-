import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'مطبخ البيت — Strategic Launch OS',
  description: 'Interactive strategic business planning platform for Home Kitchen marketplace',
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="ar" dir="rtl">
      <body>{children}</body>
    </html>
  )
}
