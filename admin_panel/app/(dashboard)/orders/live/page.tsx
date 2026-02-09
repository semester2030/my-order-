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

export default function OrdersLivePage() {
  const { data, error, isLoading, mutate } = useSWR(
    '/admin/orders?status=out_for_delivery',
    () => fetchOrders({ status: 'out_for_delivery', limit: 50 }),
  )

  if (error) {
    return (
      <>
        <PageHeader title="طلبات حية" description="الطلبات قيد التوصيل" />
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

  return (
    <>
      <PageHeader
        title="طلبات حية"
        description="الطلبات الحية — قيد التوصيل ومتابعة التأخير"
      />
      <Card>
        <CardHeader
          title="الطلبات النشطة الآن (قيد التوصيل)"
          description={`عدد: ${items.length}`}
          action={
            <Button variant="outline" size="sm" onClick={() => mutate()}>
              تحديث
            </Button>
          }
        />
        <div className="overflow-hidden rounded-b-card">
          {isLoading ? (
            <div className="flex h-48 items-center justify-center text-text-secondary">
              جاري التحميل...
            </div>
          ) : items.length === 0 ? (
            <EmptyState
              title="لا طلبات حية"
              description="لا توجد طلبات قيد التوصيل حالياً"
            />
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
                    <TableCell className="font-semibold text-text-primary">
                      <Link href={`/orders/${o.id}`} className="text-primary hover:underline">
                        {o.orderNumber}
                      </Link>
                    </TableCell>
                    <TableCell>{(o.vendor as { name?: string })?.name ?? o.vendorId}</TableCell>
                    <TableCell>
                      <Badge variant="info">{statusLabel[o.status] ?? o.status}</Badge>
                    </TableCell>
                    <TableCell>{o.total ?? 0} ر.س</TableCell>
                    <TableCell className="text-text-secondary">
                      {o.createdAt
                        ? format(new Date(o.createdAt), 'yyyy/MM/dd HH:mm', { locale: ar })
                        : '—'}
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
      </Card>
    </>
  )
}
