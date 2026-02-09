'use client'

import { useState } from 'react'
import { useParams } from 'next/navigation'
import Link from 'next/link'
import useSWR, { mutate } from 'swr'
import { PageHeader } from '@/components/ui/PageHeader'
import { Card, CardHeader, CardBody } from '@/components/ui/Card'
import { Badge } from '@/components/ui/Badge'
import { Button } from '@/components/ui/Button'
import { fetchOrderById, forceOrderStatus } from '@/lib/api/client'
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
const ORDER_STATUSES = [
  'pending',
  'confirmed',
  'preparing',
  'ready',
  'out_for_delivery',
  'delivered',
  'cancelled',
] as const

export default function OrderDetailPage() {
  const params = useParams()
  const id = params?.id as string
  const [actionLoading, setActionLoading] = useState(false)
  const [message, setMessage] = useState<string | null>(null)
  const { data, error, isLoading } = useSWR(
    id ? [`/admin/orders/${id}`, id] : null,
    () => fetchOrderById(id),
  )

  if (error) {
    return (
      <>
        <PageHeader title="تفاصيل الطلب" description="خطأ" />
        <div className="rounded-card border border-error/30 bg-error/10 px-4 py-3 text-text-primary">
          فشل تحميل البيانات: {error.message}
        </div>
      </>
    )
  }

  if (isLoading || !data) {
    return (
      <>
        <PageHeader title="تفاصيل الطلب" description="جاري التحميل..." />
        <div className="h-64 animate-pulse rounded-card bg-surface-variant" />
      </>
    )
  }

  const o = data as Record<string, unknown>
  const vendor = o.vendor as Record<string, unknown> | undefined
  const status = (o.status as string) ?? ''

  return (
    <>
      <PageHeader
        title={`الطلب ${(o.orderNumber as string) ?? id}`}
        description="تفاصيل الطلب"
        children={
          <Link href="/orders">
            <Button variant="outline" size="sm">العودة للقائمة</Button>
          </Link>
        }
      />
      <div className="grid gap-6 lg:grid-cols-2 transition-smooth">
        <Card>
          <CardHeader title="معلومات الطلب" />
          <CardBody>
            <dl className="space-y-3 text-sm">
              <div className="flex justify-between items-center py-1 border-b border-divider">
                <dt className="text-text-secondary font-medium">رقم الطلب</dt>
                <dd className="font-semibold text-text-primary">{String(o.orderNumber ?? id)}</dd>
              </div>
              <div className="flex justify-between items-center py-1 border-b border-divider">
                <dt className="text-text-secondary font-medium">الحالة</dt>
                <dd><Badge variant="default">{statusLabel[status] ?? status}</Badge></dd>
              </div>
              <div className="flex justify-between items-center py-1 border-b border-divider">
                <dt className="text-text-secondary font-medium">المطعم</dt>
                <dd className="text-text-primary">{String(vendor?.name ?? o.vendorId ?? '-')}</dd>
              </div>
              <div className="flex justify-between items-center py-1">
                <dt className="text-text-secondary font-medium">التاريخ</dt>
                <dd className="text-text-primary">
                  {o.createdAt ? format(new Date(o.createdAt as string), 'yyyy/MM/dd HH:mm', { locale: ar }) : '-'}
                </dd>
              </div>
            </dl>
          </CardBody>
        </Card>
        <Card>
          <CardHeader title="المبلغ والدفع" />
          <CardBody>
            <dl className="space-y-3 text-sm">
              <div className="flex justify-between items-center py-1 border-b border-divider">
                <dt className="text-text-secondary font-medium">المجموع</dt>
                <dd className="font-semibold text-text-primary">{Number(o.total ?? 0)} ر.س</dd>
              </div>
              <div className="flex justify-between items-center py-1 border-b border-divider">
                <dt className="text-text-secondary font-medium">المجموع الفرعي</dt>
                <dd className="text-text-primary">{Number(o.subtotal ?? 0)} ر.س</dd>
              </div>
              <div className="flex justify-between items-center py-1 border-b border-divider">
                <dt className="text-text-secondary font-medium">رسوم التوصيل</dt>
                <dd className="text-text-primary">{Number(o.deliveryFee ?? 0)} ر.س</dd>
              </div>
              <div className="flex justify-between items-center py-1 pt-3">
                <dt className="text-text-secondary font-medium">تغيير الحالة (أدمن)</dt>
                <dd className="flex items-center gap-2">
                  <select
                    id="force-status"
                    className="rounded-button border border-border-default bg-surface-default px-2 py-1 text-sm text-text-primary"
                  >
                    {ORDER_STATUSES.map((s) => (
                      <option key={s} value={s}>{statusLabel[s]}</option>
                    ))}
                  </select>
                  <Button
                    variant="outline"
                    size="sm"
                    disabled={actionLoading}
                    onClick={async () => {
                      const sel = document.getElementById('force-status') as HTMLSelectElement
                      const newStatus = sel?.value
                      if (!newStatus) return
                      setActionLoading(true)
                      try {
                        await forceOrderStatus(id, newStatus)
                        mutate(`/admin/orders/${id}`)
                        mutate('/admin/orders')
                        mutate('/admin/dashboard')
                        setMessage('تم تغيير الحالة')
                      } catch (e) {
                        setMessage('فشل: ' + (e instanceof Error ? e.message : ''))
                      } finally {
                        setActionLoading(false)
                      }
                    }}
                  >
                    تطبيق
                  </Button>
                </dd>
              </div>
            </dl>
            {message && <p className="mt-2 text-sm text-text-secondary">{message}</p>}
          </CardBody>
        </Card>
      </div>
    </>
  )
}
