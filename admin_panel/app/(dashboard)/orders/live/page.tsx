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
import { fetchOrders, fetchHomeCookingLive } from '@/lib/api/client'
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

const hcStatusLabel: Record<string, string> = {
  accepted: 'مقبول',
  ready: 'جاهز',
  handed_over: 'مُسلَّم',
}

export default function OrdersLivePage() {
  const {
    data: ordersData,
    error: ordersError,
    isLoading: ordersLoading,
    mutate: mutateOrders,
  } = useSWR('/admin/orders?status=out_for_delivery', () =>
    fetchOrders({ status: 'out_for_delivery', limit: 50 }),
  )

  const {
    data: hcData,
    error: hcError,
    isLoading: hcLoading,
    mutate: mutateHc,
  } = useSWR('/admin/home-cooking-live', () => fetchHomeCookingLive({ limit: 50 }))

  const ordersItems = (ordersData?.items ?? []) as Array<{
    id: string
    orderNumber: string
    status: string
    total: number
    vendorId: string
    vendor?: { name: string }
    createdAt: string
  }>

  const hcItems = (hcData?.items ?? []) as Array<{
    id: string
    status: string
    vendorName: string | null
    quotedAmount: number | null
    scheduledDate: string
    scheduledTime: string
    createdAt: string
  }>

  if (ordersError && hcError) {
    return (
      <>
        <PageHeader title="طلبات حية" description="الطلبات قيد التوصيل" />
        <div className="rounded-card border border-error/30 bg-error/10 px-4 py-3 text-text-primary">
          فشل تحميل البيانات: {ordersError.message}
        </div>
      </>
    )
  }

  return (
    <>
      <PageHeader
        title="طلبات حية"
        description="مساران منفصلان: توصيل الوجبات (جدول orders) والطبخ المنزلي (جدول event_requests)"
      />

      <Card className="mb-4">
        <CardHeader
          title="الطبخ المنزلي — قيد التنفيذ"
          description={`عدد: ${hcItems.length} (مقبول / جاهز / مُسلَّم بانتظار تأكيد العميل)`}
          action={
            <div className="flex gap-2">
              <Link href="/home_cooking_payments">
                <Button variant="outline" size="sm">تحقق الدفع</Button>
              </Link>
              <Button variant="outline" size="sm" onClick={() => void mutateHc()}>
                تحديث
              </Button>
            </div>
          }
        />
        <div className="overflow-hidden rounded-b-card">
          {hcLoading ? (
            <div className="flex h-32 items-center justify-center text-text-secondary">
              جاري التحميل...
            </div>
          ) : hcError ? (
            <div className="px-4 py-3 text-sm text-error">فشل تحميل الطبخ المنزلي: {hcError.message}</div>
          ) : hcItems.length === 0 ? (
            <EmptyState
              title="لا طلبات طبخ منزلي نشطة"
              description="عندما يقبل المطبخ السعر ويُكمَّل الدفع تظهر هنا حتى إتمام الطلب."
            />
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>المعرف</TableHead>
                  <TableHead>المطبخ</TableHead>
                  <TableHead>الحالة</TableHead>
                  <TableHead>المبلغ</TableHead>
                  <TableHead>الموعد</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {hcItems.map((r) => (
                  <TableRow key={r.id}>
                    <TableCell className="max-w-[120px] break-all font-mono text-xs">
                      {r.id}
                    </TableCell>
                    <TableCell>{r.vendorName ?? '—'}</TableCell>
                    <TableCell>
                      <Badge variant="info">{hcStatusLabel[r.status] ?? r.status}</Badge>
                    </TableCell>
                    <TableCell>
                      {r.quotedAmount != null ? `${r.quotedAmount} ر.س` : '—'}
                    </TableCell>
                    <TableCell className="text-text-secondary text-sm">
                      {r.scheduledDate} {r.scheduledTime}
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          )}
        </div>
      </Card>

      <Card>
        <CardHeader
          title="توصيل الوجبات — قيد التوصيل (orders)"
          description={`عدد: ${ordersItems.length} — حالة out_for_delivery فقط`}
          action={
            <Button variant="outline" size="sm" onClick={() => void mutateOrders()}>
              تحديث
            </Button>
          }
        />
        <div className="overflow-hidden rounded-b-card">
          {ordersLoading ? (
            <div className="flex h-48 items-center justify-center text-text-secondary">
              جاري التحميل...
            </div>
          ) : ordersError ? (
            <div className="px-4 py-3 text-sm text-error">فشل تحميل الطلبات: {ordersError.message}</div>
          ) : ordersItems.length === 0 ? (
            <EmptyState
              title="لا طلبات توصيل حية"
              description="هذا الجدول يعرض طلبات السلة/التوصيل في حالة «قيد التوصيل» فقط. طلبات الطبخ المنزلي لا تستخدم هذه الحالة."
            />
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>الطلب</TableHead>
                  <TableHead>مقدّم الخدمة</TableHead>
                  <TableHead>الحالة</TableHead>
                  <TableHead>المبلغ</TableHead>
                  <TableHead>التاريخ</TableHead>
                  <TableHead></TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {ordersItems.map((o) => (
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
