'use client'

import { useState } from 'react'
import { useParams } from 'next/navigation'
import Link from 'next/link'
import useSWR, { mutate } from 'swr'
import { PageHeader } from '@/components/ui/PageHeader'
import { Card, CardHeader, CardBody } from '@/components/ui/Card'
import { Badge } from '@/components/ui/Badge'
import { Button } from '@/components/ui/Button'
import { fetchDriverById, approveDriver, rejectDriver, suspendDriver } from '@/lib/api/client'
import { format } from 'date-fns'
import { ar } from 'date-fns/locale'

const statusLabel: Record<string, string> = {
  pending: 'بانتظار الموافقة',
  under_review: 'قيد المراجعة',
  approved: 'معتمد',
  rejected: 'مرفوض',
  suspended: 'موقوف',
  inactive: 'غير نشط',
}

export default function DriverDetailPage() {
  const params = useParams()
  const id = params?.id as string
  const [actionLoading, setActionLoading] = useState(false)
  const [message, setMessage] = useState<string | null>(null)
  const { data, error, isLoading } = useSWR(
    id ? [`/admin/drivers/${id}`, id] : null,
    () => fetchDriverById(id),
  )

  if (error) {
    return (
      <>
        <PageHeader title="تفاصيل السائق" description="خطأ" />
        <div className="rounded-card border border-error/30 bg-error/10 px-4 py-3 text-text-primary">
          فشل تحميل البيانات: {error.message}
        </div>
      </>
    )
  }

  if (isLoading || !data) {
    return (
      <>
        <PageHeader title="تفاصيل السائق" description="جاري التحميل..." />
        <div className="h-64 animate-pulse rounded-card bg-surface-variant" />
      </>
    )
  }

  const d = data as Record<string, unknown>
  const user = d.user as Record<string, unknown> | undefined
  const status = (d.status as string) ?? ''

  return (
    <>
      <PageHeader
        title="تفاصيل السائق"
        description={(d.fullName as string) ?? (user?.name as string) ?? `#${id}`}
        children={
          <Link href="/drivers">
            <Button variant="outline" size="sm">العودة للقائمة</Button>
          </Link>
        }
      />
      <div className="grid gap-6 lg:grid-cols-2 transition-smooth">
        <Card>
          <CardHeader title="البيانات الأساسية" />
          <CardBody>
            <dl className="space-y-3 text-sm">
              <div className="flex justify-between items-center py-1 border-b border-divider">
                <dt className="text-text-secondary font-medium">الاسم</dt>
                <dd className="font-semibold text-text-primary">{String(d.fullName ?? user?.name ?? '-')}</dd>
              </div>
              <div className="flex justify-between items-center py-1 border-b border-divider">
                <dt className="text-text-secondary font-medium">الهاتف</dt>
                <dd className="text-text-primary">{String(d.phoneNumber ?? user?.phone ?? '-')}</dd>
              </div>
              <div className="flex justify-between items-center py-1 border-b border-divider">
                <dt className="text-text-secondary font-medium">البريد</dt>
                <dd className="text-text-primary">{String(d.email ?? '-')}</dd>
              </div>
              <div className="flex justify-between items-center py-1 border-b border-divider">
                <dt className="text-text-secondary font-medium">الحالة</dt>
                <dd>
                  <Badge variant={status === 'approved' ? 'success' : status === 'rejected' || status === 'suspended' ? 'danger' : 'warning'}>
                    {statusLabel[status] ?? status}
                  </Badge>
                </dd>
              </div>
              <div className="flex justify-between items-center py-1">
                <dt className="text-text-secondary font-medium">تاريخ التسجيل</dt>
                <dd className="text-text-primary">
                  {d.createdAt ? format(new Date(d.createdAt as string), 'yyyy/MM/dd', { locale: ar }) : '-'}
                </dd>
              </div>
            </dl>
          </CardBody>
        </Card>
        <Card>
          <CardHeader title="إجراءات" />
          <CardBody>
            <div className="flex flex-wrap gap-2">
              {(status === 'pending' || status === 'under_review') && (
                <>
                  <Button
                    variant="primary"
                    size="sm"
                    disabled={actionLoading}
                    onClick={async () => {
                      setActionLoading(true)
                      try {
                        await approveDriver(id)
                        mutate(`/admin/drivers/${id}`)
                        mutate('/admin/drivers')
                        mutate('/admin/dashboard')
                        setMessage('تمت الموافقة')
                      } catch (e) {
                        setMessage('فشل: ' + (e instanceof Error ? e.message : ''))
                      } finally {
                        setActionLoading(false)
                      }
                    }}
                  >
                    موافقة
                  </Button>
                  <Button
                    variant="outline"
                    size="sm"
                    disabled={actionLoading}
                    onClick={() => {
                      const r = window.prompt('سبب الرفض (اختياري):')
                      if (r === null) return
                      setActionLoading(true)
                      rejectDriver(id, r ?? '')
                        .then(() => {
                          mutate(`/admin/drivers/${id}`)
                          mutate('/admin/drivers')
                          mutate('/admin/dashboard')
                          setMessage('تم الرفض')
                        })
                        .catch((e) => setMessage('فشل: ' + (e instanceof Error ? e.message : '')))
                        .finally(() => setActionLoading(false))
                    }}
                  >
                    رفض
                  </Button>
                </>
              )}
              {status === 'approved' && (
                <Button
                  variant="danger"
                  size="sm"
                  disabled={actionLoading}
                  onClick={async () => {
                    setActionLoading(true)
                    try {
                      await suspendDriver(id)
                      mutate(`/admin/drivers/${id}`)
                      mutate('/admin/drivers')
                      setMessage('تم الإيقاف')
                    } catch (e) {
                      setMessage('فشل: ' + (e instanceof Error ? e.message : ''))
                    } finally {
                      setActionLoading(false)
                    }
                  }}
                >
                  إيقاف
                </Button>
              )}
            </div>
            {message && <p className="mt-2 text-sm text-text-secondary">{message}</p>}
          </CardBody>
        </Card>
      </div>
    </>
  )
}
