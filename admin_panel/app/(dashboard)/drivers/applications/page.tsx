'use client'

import Link from 'next/link'
import useSWR from 'swr'
import { PageHeader } from '@/components/ui/PageHeader'
import { Card, CardHeader } from '@/components/ui/Card'
import { Badge } from '@/components/ui/Badge'
import { Button } from '@/components/ui/Button'
import {
  Table,
  TableHeader,
  TableBody,
  TableRow,
  TableHead,
  TableCell,
} from '@/components/ui/Table'
import { EmptyState } from '@/components/ui/EmptyState'
import { fetchDrivers } from '@/lib/api/client'
import { format } from 'date-fns'
import { ar } from 'date-fns/locale'

export default function DriverApplicationsPage() {
  const { data, error, isLoading } = useSWR(
    '/admin/drivers?status=pending',
    () => fetchDrivers({ status: 'pending', limit: 50 }),
  )

  if (error) {
    return (
      <>
        <PageHeader title="طلبات تسجيل السائقين" description="مراجعة والموافقة أو الرفض" />
        <div className="rounded-card border border-error/30 bg-error/10 px-4 py-3 text-text-primary">
          فشل تحميل البيانات: {error.message}
        </div>
      </>
    )
  }

  const items = (data?.items ?? []) as Array<{
    id: string
    fullName: string | null
    phoneNumber: string
    email: string | null
    status: string
    createdAt: string
  }>

  return (
    <>
      <PageHeader
        title="طلبات تسجيل السائقين"
        description="أزرار الموافقة/الرفض ستُفعّل في المرحلة 4"
      />
      <Card>
        <CardHeader
          title="الطلبات المعلقة (بانتظار الموافقة)"
          description="مراجعة والموافقة أو الرفض"
        />
        <div className="overflow-hidden rounded-b-card">
          {isLoading ? (
            <div className="flex h-48 items-center justify-center text-text-secondary">
              جاري التحميل...
            </div>
          ) : items.length === 0 ? (
            <EmptyState title="لا طلبات معلقة" description="لا توجد طلبات سائقين بانتظار الموافقة" />
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>السائق</TableHead>
                  <TableHead>الهاتف</TableHead>
                  <TableHead>تاريخ التقديم</TableHead>
                  <TableHead>الحالة</TableHead>
                  <TableHead>إجراءات</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {items.map((app) => (
                  <TableRow key={app.id}>
                    <TableCell className="font-semibold text-text-primary">
                      <Link href={`/drivers/${app.id}`} className="text-primary hover:underline">
                        {app.fullName ?? '-'}
                      </Link>
                    </TableCell>
                    <TableCell className="text-text-secondary">{app.phoneNumber}</TableCell>
                    <TableCell className="text-text-secondary">
                      {app.createdAt
                        ? format(new Date(app.createdAt), 'yyyy/MM/dd HH:mm', { locale: ar })
                        : '-'}
                    </TableCell>
                    <TableCell><Badge variant="warning">قيد المراجعة</Badge></TableCell>
                    <TableCell>
                      <Link href={`/drivers/${app.id}`}>
                        <Button variant="ghost" size="sm">تفاصيل</Button>
                      </Link>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          )}
        </div>
      </Card>
    </>
  )
}
