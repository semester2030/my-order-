'use client'

import { useState } from 'react'
import { useParams } from 'next/navigation'
import Link from 'next/link'
import useSWR, { mutate } from 'swr'
import { PageHeader } from '@/components/ui/PageHeader'
import { Card, CardHeader, CardBody } from '@/components/ui/Card'
import { Badge } from '@/components/ui/Badge'
import { Button } from '@/components/ui/Button'
import {
  fetchVendorById,
  approveVendor,
  rejectVendor,
  suspendVendor,
  reactivateVendor,
  removeVendorForReregistration,
  resendVendorRegistrationEmail,
} from '@/lib/api/client'
import { format } from 'date-fns'
import { ar } from 'date-fns/locale'

const statusLabel: Record<string, string> = {
  pending_approval: 'بانتظار الموافقة',
  under_review: 'قيد المراجعة',
  approved: 'معتمد',
  rejected: 'مرفوض',
  suspended: 'موقوف',
}

const categoryLabel: Record<string, string> = {
  home_cooking: 'الطبخ المنزلي',
  popular_cooking: 'الطبخ الشعبي',
  private_events: 'المناسبات الخاصة',
  grilling: 'الشوي',
}

function boolBadge(active: boolean) {
  return active ? (
    <Badge variant="success">نعم</Badge>
  ) : (
    <Badge variant="danger">لا</Badge>
  )
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
        <PageHeader title="تفاصيل مقدّم الخدمة" description="خطأ" />
        <div className="rounded-card border border-error/30 bg-error/10 px-4 py-3 text-text-primary">
          فشل تحميل البيانات: {error.message}
        </div>
      </>
    )
  }

  if (isLoading || !data) {
    return (
      <>
        <PageHeader title="تفاصيل مقدّم الخدمة" description="جاري التحميل..." />
        <div className="h-64 animate-pulse rounded-card bg-surface-variant" />
      </>
    )
  }

  const v = data as Record<string, unknown>
  const registrationStatus = (v.registrationStatus as string) ?? ''

  return (
    <>
      <PageHeader
        title="تفاصيل مقدّم الخدمة"
        description={(v.name as string) ?? `#${id}`}
        children={
          <Link href="/vendors">
            <Button variant="outline" size="sm">العودة للقائمة</Button>
          </Link>
        }
      />
      <div className="grid gap-6 lg:grid-cols-2 transition-smooth">
        {(() => {
          const oc = v.onboardingCompliance as
            | {
                ownerEmailVerified?: boolean
                ownerEmailVerifiedAt?: string | null
                legalAccepted?: boolean
                legalAcceptedAt?: string | null
                legalDocumentVersion?: string | null
                requiredLegalDocumentVersion?: string
              }
            | undefined
          if (!oc) return null
          const canApprove =
            registrationStatus === 'pending_approval' ||
            registrationStatus === 'under_review'
          const ready =
            Boolean(oc.ownerEmailVerified) && Boolean(oc.legalAccepted)
          return (
            <Card className="lg:col-span-2">
              <CardHeader title="التحقق قبل الموافقة (لوائح / بريد المالك)" />
              <CardBody>
                <dl className="grid gap-3 text-sm sm:grid-cols-2">
                  <div className="flex justify-between items-center py-1 border-b border-divider">
                    <dt className="text-text-secondary font-medium">
                      بريد المالك مُحقق
                    </dt>
                    <dd>{boolBadge(Boolean(oc.ownerEmailVerified))}</dd>
                  </div>
                  <div className="flex justify-between items-center py-1 border-b border-divider">
                    <dt className="text-text-secondary font-medium">
                      قبول اللوائح مسجّل
                    </dt>
                    <dd>{boolBadge(Boolean(oc.legalAccepted))}</dd>
                  </div>
                  <div className="flex justify-between items-center py-1 border-b border-divider sm:col-span-2">
                    <dt className="text-text-secondary font-medium">
                      إصدار اللوائح المطلوب حالياً
                    </dt>
                    <dd className="font-mono text-text-primary">
                      {String(oc.requiredLegalDocumentVersion ?? '-')}
                    </dd>
                  </div>
                  <div className="flex justify-between items-center py-1 border-b border-divider sm:col-span-2">
                    <dt className="text-text-secondary font-medium">
                      إصدار اللوائح الموقّع
                    </dt>
                    <dd className="font-mono text-text-primary">
                      {oc.legalDocumentVersion
                        ? String(oc.legalDocumentVersion)
                        : '—'}
                    </dd>
                  </div>
                  <div className="flex justify-between items-center py-1 sm:col-span-2">
                    <dt className="text-text-secondary font-medium">
                      تواريخ (إن وُجدت)
                    </dt>
                    <dd className="text-xs text-text-secondary text-end">
                      تحقق البريد:{' '}
                      {oc.ownerEmailVerifiedAt
                        ? format(
                            new Date(oc.ownerEmailVerifiedAt),
                            'yyyy/MM/dd HH:mm',
                            { locale: ar },
                          )
                        : '—'}
                      <br />
                      قبول اللوائح:{' '}
                      {oc.legalAcceptedAt
                        ? format(
                            new Date(oc.legalAcceptedAt),
                            'yyyy/MM/dd HH:mm',
                            { locale: ar },
                          )
                        : '—'}
                    </dd>
                  </div>
                </dl>
                {canApprove && !ready && (
                  <p className="mt-3 rounded-md border border-warning/40 bg-warning/10 px-3 py-2 text-xs text-text-primary">
                    لا يمكن اعتماد هذا الطلب من الخادم حتى يُكمل مقدّم الخدمة
                    التحقق من البريد وقبول اللوائح في التطبيق. زر «موافقة» سيرجع
                    خطأ إن لم يكتمل ذلك.
                  </p>
                )}
              </CardBody>
            </Card>
          )
        })()}
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
                <dd className="text-text-primary">
                  {(() => {
                    const c = (v.city as string | undefined)?.trim()
                    return c ? c : 'غير محدد'
                  })()}
                </dd>
              </div>
              <div className="flex justify-between items-center py-1 border-b border-divider">
                <dt className="text-text-secondary font-medium">فئة الخدمة</dt>
                <dd className="text-text-primary">
                  {(() => {
                    const cat = v.providerCategory as string | undefined
                    return cat ? (categoryLabel[cat] ?? cat) : 'غير محدد'
                  })()}
                </dd>
              </div>
              <div className="flex justify-between items-center py-1 border-b border-divider">
                <dt className="text-text-secondary font-medium">الحالة</dt>
                <dd>
                  <Badge variant={registrationStatus === 'approved' ? 'success' : registrationStatus === 'rejected' || registrationStatus === 'suspended' ? 'danger' : 'warning'}>
                    {statusLabel[registrationStatus] ?? registrationStatus}
                  </Badge>
                </dd>
              </div>
              <div className="flex justify-between items-center py-1 border-b border-divider">
                <dt className="text-text-secondary font-medium">نشط في النظام</dt>
                <dd title="يُستخدم في فلتر تطبيق العميل — إن كان «لا» لن يظهر مقدّم الخدمة في الفيد">
                  {boolBadge(Boolean(v.isActive))}
                </dd>
              </div>
              <div className="flex justify-between items-center py-1 border-b border-divider">
                <dt className="text-text-secondary font-medium">يقبل الطلبات</dt>
                <dd title="إعداد تشغيلي؛ لا يمنع ظهور الفيد في فيد العميل بعد التعديل الأخير للخادم">
                  {boolBadge(Boolean(v.isAcceptingOrders))}
                </dd>
              </div>
              <div className="flex justify-between items-center py-1">
                <dt className="text-text-secondary font-medium">تاريخ الانضمام</dt>
                <dd className="text-text-primary">
                  {v.createdAt ? format(new Date(v.createdAt as string), 'yyyy/MM/dd', { locale: ar }) : '-'}
                </dd>
              </div>
            </dl>
            <p className="mt-4 rounded-md border border-border-default bg-surface-variant/80 px-3 py-2 text-xs text-text-secondary leading-relaxed">
              فيد العميل يعرض مقدّمي خدمة معتمدين و«نشطين في النظام» فقط. حقل «يقبل الطلبات» إعداد تشغيلي ولا يمنع ظهور الفيد في الفيد.
              إن كان «نشط» معطّلاً فلن يظهر المحتوى للعملاء رغم الاعتماد.
            </p>
          </CardBody>
        </Card>
        <Card>
          <CardHeader title="إجراءات" />
          <CardBody>
            <div className="flex flex-wrap gap-2">
              {(registrationStatus === 'pending_approval' || registrationStatus === 'under_review') && (
                <>
                  <Button
                    variant="outline"
                    size="sm"
                    disabled={actionLoading}
                    onClick={async () => {
                      setMessage(null)
                      setActionLoading(true)
                      try {
                        const r = await resendVendorRegistrationEmail(id)
                        setMessage(
                          typeof r.message === 'string'
                            ? r.message
                            : r.emailSent
                              ? 'تم إرسال البريد'
                              : 'لم يُرسل البريد — تحقق من إعدادات الخادم',
                        )
                      } catch (e) {
                        setMessage('فشل: ' + (e instanceof Error ? e.message : ''))
                      } finally {
                        setActionLoading(false)
                      }
                    }}
                  >
                    إعادة إرسال بريد التسجيل
                  </Button>
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
              {registrationStatus === 'suspended' && (
                <>
                  <Button
                    variant="primary"
                    size="sm"
                    disabled={actionLoading}
                    onClick={async () => {
                      setMessage(null)
                      setActionLoading(true)
                      try {
                        await reactivateVendor(id)
                        await Promise.all([
                          revalidate(),
                          mutate('/admin/vendors'),
                          mutate('/admin/dashboard'),
                        ])
                        setMessage('تم فك الإيقاف وإعادة التفعيل')
                      } catch (e) {
                        setMessage('فشل: ' + (e instanceof Error ? e.message : ''))
                      } finally {
                        setActionLoading(false)
                      }
                    }}
                  >
                    فك الإيقاف
                  </Button>
                  <Button
                    variant="outline"
                    size="sm"
                    disabled={actionLoading}
                    onClick={async () => {
                      const ok = window.confirm(
                        'سيتم حذف مقدّم الخدمة وحسابات فريقه نهائياً وتحرير البريد لإعادة التسجيل. لا يُسمح إن وُجدت طلبات أو ارتباطات. هل أنت متأكد؟',
                      )
                      if (!ok) return
                      setMessage(null)
                      setActionLoading(true)
                      try {
                        await removeVendorForReregistration(id)
                        await Promise.all([
                          mutate('/admin/vendors'),
                          mutate('/admin/dashboard'),
                        ])
                        window.location.href = '/vendors'
                      } catch (e) {
                        setMessage('فشل: ' + (e instanceof Error ? e.message : ''))
                      } finally {
                        setActionLoading(false)
                      }
                    }}
                  >
                    حذف وتحرير البريد
                  </Button>
                </>
              )}
              {(registrationStatus === 'rejected' ||
                registrationStatus === 'pending_approval' ||
                registrationStatus === 'under_review') && (
                <Button
                  variant="outline"
                  size="sm"
                  disabled={actionLoading}
                  onClick={async () => {
                    const ok = window.confirm(
                      'سيتم حذف هذا الطلب نهائياً وتحرير البريد لإعادة التسجيل (إن وُجدت شروط الحذف في النظام). متابعة؟',
                    )
                    if (!ok) return
                    setMessage(null)
                    setActionLoading(true)
                    try {
                      await removeVendorForReregistration(id)
                      await Promise.all([
                        mutate('/admin/vendors'),
                        mutate('/admin/dashboard'),
                      ])
                      window.location.href = '/vendors'
                    } catch (e) {
                      setMessage('فشل: ' + (e instanceof Error ? e.message : ''))
                    } finally {
                      setActionLoading(false)
                    }
                  }}
                >
                  حذف الطلب وتحرير البريد
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
