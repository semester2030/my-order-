'use client'

import { useState } from 'react'
import Link from 'next/link'
import useSWR from 'swr'
import { PageHeader } from '@/components/ui/PageHeader'
import { Card, CardHeader } from '@/components/ui/Card'
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
import { fetchServiceReviews } from '@/lib/api/client'
import { format } from 'date-fns'
import { ar } from 'date-fns/locale'

function pickVendorName(v: unknown): string {
  if (!v || typeof v !== 'object') return '—'
  const o = v as Record<string, unknown>
  const n = o.name ?? o.tradeName ?? o.trade_name
  return typeof n === 'string' && n.length > 0 ? n : '—'
}

function pickVendorId(v: unknown): string | null {
  if (!v || typeof v !== 'object') return null
  const id = (v as Record<string, unknown>).id
  return typeof id === 'string' ? id : null
}

function pickCustomerLabel(u: unknown): string {
  if (!u || typeof u !== 'object') return '—'
  const o = u as Record<string, unknown>
  const name = o.name
  const email = o.email
  const parts: string[] = []
  if (typeof name === 'string' && name) parts.push(name)
  if (typeof email === 'string' && email) parts.push(email)
  return parts.length ? parts.join(' · ') : '—'
}

function starsRow(n: number): string {
  const s = Math.max(0, Math.min(5, Math.round(n)))
  return `${'★'.repeat(s)}${'☆'.repeat(5 - s)}`
}

const subjectFilter: { value: string; label: string }[] = [
  { value: '', label: 'الكل' },
  { value: 'order', label: 'طلب توصيل' },
  { value: 'event_request', label: 'حجز / طبخ' },
]

export default function ServiceReviewsPage() {
  const [page, setPage] = useState(1)
  const [subjectType, setSubjectType] = useState('')
  const [vendorId, setVendorId] = useState('')
  const { data, error, isLoading } = useSWR(
    ['/admin/service-reviews', page, subjectType, vendorId],
    () =>
      fetchServiceReviews({
        page,
        limit: 20,
        ...(subjectType ? { subjectType } : {}),
        ...(vendorId.trim() ? { vendorId: vendorId.trim() } : {}),
      }),
  )

  if (error) {
    return (
      <>
        <PageHeader
          title="تقييمات الخدمة"
          description="نجوم وتعليق عام من العملاء بعد إتمام الخدمة"
        />
        <div className="rounded-card border border-error/30 bg-error/10 px-4 py-3 text-text-primary">
          فشل تحميل البيانات: {error.message}
        </div>
      </>
    )
  }

  const items = (data?.items ?? []) as Array<Record<string, unknown>>
  const total = data?.total ?? 0
  const limit = data?.limit ?? 20
  const totalPages = Math.max(1, Math.ceil(total / limit))

  return (
    <>
      <PageHeader
        title="تقييمات الخدمة"
        description="تقييمات موحّدة لطلبات التوصيل وحجوزات الطبّاخ / الطبخ المنزلي — التعليقات هنا عامة (ظاهرة للجمهوم في التطبيق)"
      />
      <div className="mb-4 flex flex-col gap-3 sm:flex-row sm:flex-wrap sm:items-end">
        <div className="flex flex-wrap gap-2">
          {subjectFilter.map((opt) => (
            <Button
              key={opt.value || 'all'}
              variant={subjectType === opt.value ? 'primary' : 'outline'}
              size="sm"
              onClick={() => {
                setSubjectType(opt.value)
                setPage(1)
              }}
            >
              {opt.label}
            </Button>
          ))}
        </div>
        <div className="flex max-w-md gap-2">
          <input
            type="text"
            placeholder="تصفية بمعرّف المقدّم (UUID)"
            className="flex-1 rounded-md border border-divider px-3 py-2 text-sm"
            value={vendorId}
            onChange={(e) => setVendorId(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === 'Enter') setPage(1)
            }}
          />
          <Button variant="secondary" size="sm" onClick={() => setPage(1)}>
            تطبيق
          </Button>
        </div>
      </div>
      <Card>
        <CardHeader title="السجل" description={`إجمالي: ${total}`} />
        <div className="overflow-hidden rounded-b-card">
          {isLoading ? (
            <div className="flex h-48 items-center justify-center text-text-secondary">
              جاري التحميل...
            </div>
          ) : items.length === 0 ? (
            <EmptyState
              title="لا تقييمات بعد"
              description="عند تقييم العملاء للخدمات بعد الإتمام ستظهر هنا."
            />
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>النجوم</TableHead>
                  <TableHead>التعليق</TableHead>
                  <TableHead>المقدّم</TableHead>
                  <TableHead>العميل</TableHead>
                  <TableHead>نوع الخدمة</TableHead>
                  <TableHead>التاريخ</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {items.map((row) => {
                  const rid = String(row.id ?? '')
                  const stars = Number(row.stars ?? 0)
                  const comment = String(
                    row.publicComment ?? row.public_comment ?? '',
                  )
                  const subType = String(
                    row.subjectType ?? row.subject_type ?? '',
                  )
                  const subId = String(row.subjectId ?? row.subject_id ?? '')
                  const created = row.createdAt ?? row.created_at
                  const vid = pickVendorId(row.vendor)
                  return (
                    <TableRow key={rid}>
                      <TableCell
                        className="whitespace-nowrap text-amber-600"
                        title={String(stars)}
                      >
                        {starsRow(stars)}
                      </TableCell>
                      <TableCell className="max-w-xs truncate text-sm text-text-secondary">
                        {comment || '—'}
                      </TableCell>
                      <TableCell>
                        <span className="text-sm">{pickVendorName(row.vendor)}</span>
                        {vid && (
                          <>
                            <br />
                            <Link
                              href={`/vendors/${vid}`}
                              className="text-primary text-xs hover:underline"
                            >
                              البطاقة
                            </Link>
                          </>
                        )}
                      </TableCell>
                      <TableCell className="max-w-[180px] truncate text-xs text-text-secondary">
                        {pickCustomerLabel(row.customer)}
                      </TableCell>
                      <TableCell className="text-xs font-mono text-text-secondary">
                        {subType}
                        <br />
                        <span className="text-[10px]">{subId.slice(0, 8)}…</span>
                      </TableCell>
                      <TableCell className="text-text-secondary text-sm">
                        {typeof created === 'string'
                          ? format(new Date(created), 'yyyy/MM/dd HH:mm', {
                              locale: ar,
                            })
                          : '—'}
                      </TableCell>
                    </TableRow>
                  )
                })}
              </TableBody>
            </Table>
          )}
        </div>
        {totalPages > 1 && (
          <div className="flex justify-center gap-2 border-t border-divider px-4 py-3">
            <Button
              variant="outline"
              size="sm"
              disabled={page <= 1}
              onClick={() => setPage((p) => p - 1)}
            >
              السابق
            </Button>
            <span className="flex items-center text-sm text-text-secondary">
              {page} / {totalPages}
            </span>
            <Button
              variant="outline"
              size="sm"
              disabled={page >= totalPages}
              onClick={() => setPage((p) => p + 1)}
            >
              التالي
            </Button>
          </div>
        )}
      </Card>
    </>
  )
}
