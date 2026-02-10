'use client'

import { useState } from 'react'
import { useParams } from 'next/navigation'
import Link from 'next/link'
import useSWR, { mutate } from 'swr'
import { PageHeader } from '@/components/ui/PageHeader'
import { Card, CardHeader, CardBody } from '@/components/ui/Card'
import { Badge } from '@/components/ui/Badge'
import { Button } from '@/components/ui/Button'
import { fetchVendorById, approveVendor, rejectVendor, suspendVendor } from '@/lib/api/client'
import { format } from 'date-fns'
import { ar } from 'date-fns/locale'

const statusLabel: Record<string, string> = {
  pending_approval: 'بانتظار الموافقة',
  under_review: 'قيد المراجعة',
  approved: 'معتمد',
  rejected: 'مرفوض',
  suspended: 'موقوف',
}

export default function VendorDetailPage() {
  const params = useParams()
  const id = params?.id as string
  const [actionLoading, setActionLoading] = useState(false)
  const [message, setMessage] = useState<string | null>(null)
  const { data, error, isLoading, mutate: revalidate } = useSWR(
    id ? [`/admin/vendors/${id}`, id] : null,
    () => fetchVendorById(id),
    { revalidateOnFocus: true },
  )

  if (error) {
    return (
      <>
        <PageHeader title="تفاصيل المطعم" description="خطأ" />
        <div className="rounded-card border border-error/30 bg-error/10 px-4 py-3 text-text-primary">
          فشل تحميل البيانات: {error.message}
        </div>
      </>
    )
  }

  if (isLoading || !data) {
    return (
      <>
        <PageHeader title="تفاصيل المطعم" description="جاري التحميل..." />
        <div className="h-64 animate-pulse rounded-card bg-surface-variant" />
      </>
    )
  }

  const v = data as Record<string, unknown>
  const registrationStatus = (v.registrationStatus as string) ?? ''

  return (
    <>
      <PageHeader
        title="تفاصيل المطعم"
        description={(v.name as string) ?? `#${id}`}
        children={
          <Link href="/vendors">
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
                <dd className="font-semibold text-text-primary">{String(v.name ?? '-')}</dd>
              </div>
              <div className="flex justify-between items-center py-1 border-b border-divider">
                <dt className="text-text-secondary font-medium">البريد</dt>
                <dd className="text-text-primary">{String(v.email ?? '-')}</dd>
              </div>
              <div className="flex justify-between items-center py-1 border-b border-divider">
                <dt className="text-text-secondary font-medium">الهاتف</dt>
                <dd className="text-text-primary">{String(v.phoneNumber ?? '-')}</dd>
              </div>
              <div className="flex justify-between items-center py-1 border-b border-divider">
                <dt className="text-text-secondary font-medium">المدينة</dt>
                <dd className="text-text-primary">{String(v.city ?? '-')}</dd>
              </div>
              <div className="flex justify-between items-center py-1 border-b border-divider">
                <dt className="text-text-secondary font-medium">الحالة</dt>
                <dd>
                  <Badge variant={registrationStatus === 'approved' ? 'success' : registrationStatus === 'rejected' || registrationStatus === 'suspended' ? 'danger' : 'warning'}>
                    {statusLabel[registrationStatus] ?? registrationStatus}
                  </Badge>
                </dd>
              </div>
              <div className="flex justify-between items-center py-1">
                <dt className="text-text-secondary font-medium">تاريخ الانضمام</dt>
                <dd className="text-text-primary">
                  {v.createdAt ? format(new Date(v.createdAt as string), 'yyyy/MM/dd', { locale: ar }) : '-'}
                </dd>
              </div>
            </dl>
          </CardBody>
        </Card>
        <Card>
          <CardHeader title="إجراءات" />
          <CardBody>
            <div className="flex flex-wrap gap-2">
              {(registrationStatus === 'pending_approval' || registrationStatus === 'under_review') && (
                <>
                  <Button
                    variant="primary"
                    size="sm"
                    disabled={actionLoading}
                    onClick={async () => {
                      setMessage(null)
                      setActionLoading(true)
                      try {
                        await approveVendor(id)
                        await Promise.all([
                          revalidate(),
                          mutate('/admin/vendors'),
                          mutate('/admin/dashboard'),
                        ])
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
                      rejectVendor(id, r ?? '')
                        .then(async () => {
                          await Promise.all([
                            revalidate(),
                            mutate('/admin/vendors'),
                            mutate('/admin/dashboard'),
                          ])
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
              {registrationStatus === 'approved' && (
                <Button
                  variant="danger"
                  size="sm"
                  disabled={actionLoading}
                    onClick={async () => {
                      setMessage(null)
                      setActionLoading(true)
                      try {
                        await suspendVendor(id)
                        await Promise.all([revalidate(), mutate('/admin/vendors')])
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
