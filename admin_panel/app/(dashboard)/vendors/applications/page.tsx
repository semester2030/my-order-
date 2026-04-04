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
import { fetchVendors } from '@/lib/api/client'
import { format } from 'date-fns'
import { ar } from 'date-fns/locale'

const queueStatusLabel: Record<string, string> = {
  pending_approval: 'بانتظار الموافقة',
  under_review: 'قيد المراجعة',
}

export default function VendorApplicationsPage() {
  const { data, error, isLoading } = useSWR(
    '/admin/vendors?registrationQueue=1',
    () => fetchVendors({ registrationQueue: true, limit: 50 }),
  )

  if (error) {
    return (
      <>
        <PageHeader title="طلبات تسجيل مقدّمي الخدمة" description="مراجعة والموافقة أو الرفض" />
        <div className="rounded-card border border-error/30 bg-error/10 px-4 py-3 text-text-primary">
          فشل تحميل البيانات: {error.message}
        </div>
      </>
    )
  }

  const items = (data?.items ?? []) as Array<{
    id: string
    name: string
    email: string
    city?: string
    registrationStatus: string
    createdAt: string
  }>

  return (
    <>
      <PageHeader
        title="طلبات تسجيل مقدّمي الخدمة"
        description="كل طلبات ما قبل الاعتماد: بانتظار الموافقة وقيد المراجعة — راجع ثم وافق أو ارفض من التفاصيل"
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
            <EmptyState title="لا طلبات معلقة" description="لا توجد طلبات تسجيل لمقدّمي خدمة بانتظار الموافقة" />
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>مقدّم الخدمة</TableHead>
                  <TableHead>البريد</TableHead>
                  <TableHead>تاريخ التقديم</TableHead>
                  <TableHead>الحالة</TableHead>
                  <TableHead>إجراءات</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {items.map((app) => (
                  <TableRow key={app.id}>
                    <TableCell className="font-semibold text-text-primary">
                      <Link href={`/vendors/${app.id}`} className="text-primary hover:underline">
                        {app.name}
                      </Link>
                    </TableCell>
                    <TableCell className="text-text-secondary">{app.email}</TableCell>
                    <TableCell className="text-text-secondary">
                      {app.createdAt
                        ? format(new Date(app.createdAt), 'yyyy/MM/dd HH:mm', { locale: ar })
                        : '-'}
                    </TableCell>
                    <TableCell>
                      <Badge variant="warning">
                        {queueStatusLabel[app.registrationStatus] ?? app.registrationStatus}
                      </Badge>
                    </TableCell>
                    <TableCell>
                      <Link href={`/vendors/${app.id}`}>
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
