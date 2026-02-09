'use client'

import { useState } from 'react'
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
import { fetchOrders } from '@/lib/api/client'
import { format } from 'date-fns'
import { ar } from 'date-fns/locale'

const statusLabel: Record<string, string> = {
  pending: 'قيد الانتظار',
  confirmed: 'مؤكد',
  preparing: 'قيد التحضير',
  ready: 'جاهز',
  out_for_delivery: 'قيد التوصيل',
  delivered: 'تم التوصيل',
  cancelled: 'ملغي',
}

export default function OrdersPage() {
  const [status, setStatus] = useState<string | undefined>()
  const [page, setPage] = useState(1)
  const { data, error, isLoading } = useSWR(
    ['/admin/orders', status, page],
    () => fetchOrders({ status, page, limit: 20 }),
  )

  if (error) {
    return (
      <>
        <PageHeader title="الطلبات" description="قائمة الطلبات" />
        <div className="rounded-card border border-error/30 bg-error/10 px-4 py-3 text-text-primary">
          فشل تحميل البيانات: {error.message}
        </div>
      </>
    )
  }

  const items = (data?.items ?? []) as Array<{
    id: string
    orderNumber: string
    status: string
    total: number
    vendorId: string
    vendor?: { name: string }
    createdAt: string
  }>
  const total = data?.total ?? 0
  const totalPages = data?.limit ? Math.ceil(total / data.limit) : 1

  return (
    <>
      <PageHeader
        title="الطلبات"
        description="قائمة الطلبات — فلاتر: حالة، تاريخ"
      />
      <Card>
        <CardHeader
          title="الطلبات"
          description={`إجمالي: ${total}`}
          action={
            <>
              <select
                value={status ?? ''}
                onChange={(e) => {
                  setStatus(e.target.value || undefined)
                  setPage(1)
                }}
                className="rounded-button border border-border-default bg-surface-default px-3 py-2 text-sm text-text-primary"
              >
                <option value="">كل الحالات</option>
                {Object.entries(statusLabel).map(([k, v]) => (
                  <option key={k} value={k}>{v}</option>
                ))}
              </select>
              <Link href="/orders/live" className="mr-2">
                <Button variant="primary" size="sm">طلبات حية</Button>
              </Link>
            </>
          }
        />
        <div className="overflow-hidden rounded-b-card">
          {isLoading ? (
            <div className="flex h-48 items-center justify-center text-text-secondary">
              جاري التحميل...
            </div>
          ) : items.length === 0 ? (
            <EmptyState title="لا طلبات" description="لا توجد طلبات تطابق الفلتر" />
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>الطلب</TableHead>
                  <TableHead>المطعم</TableHead>
                  <TableHead>الحالة</TableHead>
                  <TableHead>المبلغ</TableHead>
                  <TableHead>التاريخ</TableHead>
                  <TableHead></TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {items.map((o) => (
                  <TableRow key={o.id}>
                    <TableCell className="font-semibold text-text-primary">{o.orderNumber}</TableCell>
                    <TableCell>{(o.vendor as { name?: string })?.name ?? o.vendorId}</TableCell>
                    <TableCell>
                      <Badge variant="default">{statusLabel[o.status] ?? o.status}</Badge>
                    </TableCell>
                    <TableCell>{o.total ?? 0} ر.س</TableCell>
                    <TableCell className="text-text-secondary">
                      {o.createdAt
                        ? format(new Date(o.createdAt), 'yyyy/MM/dd HH:mm', { locale: ar })
                        : '-'}
                    </TableCell>
                    <TableCell>
                      <Link href={`/orders/${o.id}`}>
                        <Button variant="ghost" size="sm">عرض</Button>
                      </Link>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          )}
        </div>
        {totalPages > 1 && (
          <div className="flex justify-center gap-2 border-t border-divider px-4 py-3">
            <Button variant="outline" size="sm" disabled={page <= 1} onClick={() => setPage((p) => p - 1)}>
              السابق
            </Button>
            <span className="flex items-center text-sm text-text-secondary">{page} / {totalPages}</span>
            <Button variant="outline" size="sm" disabled={page >= totalPages} onClick={() => setPage((p) => p + 1)}>
              التالي
            </Button>
          </div>
        )}
      </Card>
    </>
  )
}
