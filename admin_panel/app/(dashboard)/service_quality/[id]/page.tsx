'use client'

import { useState, useEffect } from 'react'
import Link from 'next/link'
import { useParams } from 'next/navigation'
import useSWR from 'swr'
import { PageHeader } from '@/components/ui/PageHeader'
import { Card, CardHeader, CardBody } from '@/components/ui/Card'
import { Badge } from '@/components/ui/Badge'
import { Button } from '@/components/ui/Button'
import {
  fetchServiceQualityTicketById,
  updateServiceQualityTicket,
} from '@/lib/api/client'
import { format } from 'date-fns'
import { ar } from 'date-fns/locale'

const categoryAr: Record<string, string> = {
  quality: 'جودة الطعام / الخدمة',
  hygiene: 'النظافة',
  delay: 'التأخير',
  billing: 'الدفع / السعر',
  other: 'أخرى',
}

const STATUSES = ['open', 'in_progress', 'closed'] as const

export default function ServiceQualityTicketDetailPage() {
  const params = useParams()
  const id = params?.id as string
  const [adminNotes, setAdminNotes] = useState('')
  const [status, setStatus] = useState<string>('')
  const [saving, setSaving] = useState(false)
  const [saveMsg, setSaveMsg] = useState<string | null>(null)

  const { data, error, isLoading, mutate } = useSWR(
    id ? ['/admin/service-quality-tickets', id] : null,
    () => fetchServiceQualityTicketById(id),
  )

  useEffect(() => {
    if (!data || typeof data !== 'object') return
    const row = data as Record<string, unknown>
    if (typeof row.status === 'string') setStatus(row.status)
    const notes = row.adminNotes ?? row.admin_notes
    if (typeof notes === 'string') setAdminNotes(notes)
    else if (notes === null) setAdminNotes('')
  }, [data])

  const onSave = async () => {
    if (!id) return
    setSaving(true)
    setSaveMsg(null)
    try {
      await updateServiceQualityTicket(id, {
        status: status || undefined,
        adminNotes: adminNotes.trim() || undefined,
      })
      setSaveMsg('تم الحفظ')
      await mutate()
    } catch (e) {
      setSaveMsg(e instanceof Error ? e.message : 'فشل الحفظ')
    } finally {
      setSaving(false)
    }
  }

  if (error) {
    return (
      <>
        <PageHeader title="بلاغ جودة" description="" />
        <div className="rounded-card border border-error/30 bg-error/10 px-4 py-3">
          {error.message}
        </div>
      </>
    )
  }

  if (isLoading || !data) {
    return (
      <div className="flex h-48 items-center justify-center text-text-secondary">
        جاري التحميل...
      </div>
    )
  }

  const row = data as Record<string, unknown>
  const vendor = row.vendor as Record<string, unknown> | undefined
  const customer = row.customer as Record<string, unknown> | undefined
  const cat = String(row.category ?? '')
  const privateMessage = String(row.privateMessage ?? row.private_message ?? '')
  const detailScores = row.detailScores ?? row.detail_scores
  const subType = String(row.subjectType ?? row.subject_type ?? '')
  const subId = String(row.subjectId ?? row.subject_id ?? '')
  const created = row.createdAt ?? row.created_at

  return (
    <>
      <PageHeader
        title="بلاغ جودة"
        description={`معرّف: ${id}`}
        children={
          <Link href="/service_quality">
            <Button variant="outline" size="sm">
              العودة للقائمة
            </Button>
          </Link>
        }
      />
      <div className="grid gap-6 lg:grid-cols-2">
        <Card>
          <CardHeader title="محتوى البلاغ" />
          <CardBody className="space-y-4 text-sm">
            <div>
              <span className="text-text-secondary">التصنيف: </span>
              <span className="font-semibold">{categoryAr[cat] ?? cat}</span>
            </div>
            <div>
              <span className="text-text-secondary">الحالة (الحالية): </span>
              <Badge variant="warning">{status || String(row.status ?? '')}</Badge>
            </div>
            <div>
              <span className="text-text-secondary">نوع الخدمة: </span>
              <span className="font-mono">{subType}</span>
            </div>
            <div>
              <span className="text-text-secondary">معرّف الخدمة: </span>
              <span className="font-mono text-xs break-all">{subId}</span>
            </div>
            <div>
              <span className="text-text-secondary">التاريخ: </span>
              {typeof created === 'string'
                ? format(new Date(created), 'yyyy/MM/dd HH:mm', { locale: ar })
                : '—'}
            </div>
            <div className="border-t border-divider pt-3">
              <p className="mb-1 text-text-secondary">رسالة العميل (خاصة)</p>
              <p className="whitespace-pre-wrap rounded-md bg-surface-warmBg p-3 text-text-primary">
                {privateMessage || '—'}
              </p>
            </div>
            {detailScores != null && (
              <div>
                <p className="mb-1 text-text-secondary">درجات فرعية (JSON)</p>
                <pre className="max-h-40 overflow-auto rounded-md bg-surface-warmBg p-3 text-xs">
                  {JSON.stringify(detailScores, null, 2)}
                </pre>
              </div>
            )}
          </CardBody>
        </Card>

        <Card>
          <CardHeader title="الجهات والمتابعة" />
          <CardBody className="space-y-4 text-sm">
            <div>
              <p className="text-text-secondary">المقدّم</p>
              <p className="font-semibold">
                {vendor && typeof vendor.name === 'string' ? vendor.name : '—'}
              </p>
              {vendor && typeof vendor.id === 'string' && (
                <Link
                  href={`/vendors/${vendor.id}`}
                  className="text-primary text-xs hover:underline"
                >
                  فتح بطاقة المقدّم
                </Link>
              )}
            </div>
            <div>
              <p className="text-text-secondary">العميل</p>
              <p className="font-semibold">
                {customer && typeof customer.name === 'string'
                  ? customer.name
                  : '—'}
              </p>
              <p className="text-text-secondary text-xs">
                {customer && typeof customer.email === 'string'
                  ? customer.email
                  : ''}{' '}
                {customer && typeof customer.phone === 'string'
                  ? customer.phone
                  : ''}
              </p>
            </div>

            <div className="border-t border-divider pt-4 space-y-3">
              <label className="block text-text-secondary text-xs">تحديث الحالة</label>
              <select
                className="w-full rounded-md border border-divider bg-white px-3 py-2 text-sm"
                value={status}
                onChange={(e) => setStatus(e.target.value)}
              >
                {STATUSES.map((s) => (
                  <option key={s} value={s}>
                    {s}
                  </option>
                ))}
              </select>
              <label className="block text-text-secondary text-xs">ملاحظات الإدارة</label>
              <textarea
                className="w-full min-h-[120px] rounded-md border border-divider bg-white px-3 py-2 text-sm"
                value={adminNotes}
                onChange={(e) => setAdminNotes(e.target.value)}
                placeholder="سجل المتابعة الداخلية…"
              />
              <Button variant="primary" onClick={onSave} disabled={saving}>
                {saving ? 'جاري الحفظ…' : 'حفظ'}
              </Button>
              {saveMsg && (
                <p className="text-sm text-text-secondary">{saveMsg}</p>
              )}
            </div>
          </CardBody>
        </Card>
      </div>
    </>
  )
}
