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
import { fetchServiceQualityTickets } from '@/lib/api/client'
import { format } from 'date-fns'
import { ar } from 'date-fns/locale'

function pickVendorName(v: unknown): string {
  if (!v || typeof v !== 'object') return '—'
  const o = v as Record<string, unknown>
  const n = o.name ?? o.tradeName ?? o.trade_name
  return typeof n === 'string' && n.length > 0 ? n : '—'
}

function pickCustomerLabel(u: unknown): string {
  if (!u || typeof u !== 'object') return '—'
  const o = u as Record<string, unknown>
  const name = o.name
  const email = o.email
  const phone = o.phone
  const parts: string[] = []
  if (typeof name === 'string' && name) parts.push(name)
  if (typeof email === 'string' && email) parts.push(email)
  if (typeof phone === 'string' && phone) parts.push(phone)
  return parts.length ? parts.join(' · ') : '—'
}

const categoryAr: Record<string, string> = {
  quality: 'جودة الطعام / الخدمة',
  hygiene: 'النظافة',
  delay: 'التأخير',
  billing: 'الدفع / السعر',
  other: 'أخرى',
}

function statusBadgeVariant(
  s: string | undefined,
): 'default' | 'success' | 'warning' | 'danger' | 'info' {
  switch (s) {
    case 'closed':
      return 'success'
    case 'in_progress':
      return 'info'
    case 'open':
    default:
      return 'warning'
  }
}

const statusFilterOptions: { value: string; label: string }[] = [
  { value: '', label: 'الكل' },
  { value: 'open', label: 'مفتوح' },
  { value: 'in_progress', label: 'قيد المعالجة' },
  { value: 'closed', label: 'مغلق' },
]

export default function ServiceQualityTicketsPage() {
  const [page, setPage] = useState(1)
  const [status, setStatus] = useState('')
  const { data, error, isLoading } = useSWR(
    ['/admin/service-quality-tickets', page, status],
    () =>
      fetchServiceQualityTickets({
        page,
        limit: 20,
        ...(status ? { status } : {}),
      }),
  )

  if (error) {
    return (
      <>
        <PageHeader
          title="بلاغات الجودة"
          description="رسائل خاصة من العملاء — غير ظاهرة للجمهور"
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
        title="بلاغات الجودة"
        description="بلاغات خاصة بالإدارة (جودة، نظافة، تأخير، دفع…) مع ربط الطلب والمقدّم والعميل"
      />
      <div className="mb-4 flex flex-wrap gap-2">
        {statusFilterOptions.map((opt) => (
          <Button
            key={opt.value || 'all'}
            variant={status === opt.value ? 'primary' : 'outline'}
            size="sm"
            onClick={() => {
              setStatus(opt.value)
              setPage(1)
            }}
          >
            {opt.label}
          </Button>
        ))}
      </div>
      <Card>
        <CardHeader
          title="القائمة"
          description={`إجمالي: ${total} — الرسائل هنا للإدارة فقط`}
        />
        <div className="overflow-hidden rounded-b-card">
          {isLoading ? (
            <div className="flex h-48 items-center justify-center text-text-secondary">
              جاري التحميل...
            </div>
          ) : items.length === 0 ? (
            <EmptyState
              title="لا بلاغات"
              description="عند إرسال العملاء بلاغات من التطبيق ستظهر هنا."
            />
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>التصنيف</TableHead>
                  <TableHead>الحالة</TableHead>
                  <TableHead>المقدّم</TableHead>
                  <TableHead>العميل</TableHead>
                  <TableHead>الخدمة</TableHead>
                  <TableHead>التاريخ</TableHead>
                  <TableHead></TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {items.map((row) => {
                  const id = String(row.id ?? '')
                  const cat = String(row.category ?? '')
                  const st = String(row.status ?? '')
                  const subType = String(row.subjectType ?? row.subject_type ?? '')
                  const subId = String(row.subjectId ?? row.subject_id ?? '')
                  const created = row.createdAt ?? row.created_at
                  return (
                    <TableRow key={id}>
                      <TableCell className="font-medium text-text-primary">
                        {categoryAr[cat] ?? cat}
                      </TableCell>
                      <TableCell>
                        <Badge variant={statusBadgeVariant(st)}>{st}</Badge>
                      </TableCell>
                      <TableCell className="text-text-secondary">
                        {pickVendorName(row.vendor)}
                      </TableCell>
                      <TableCell className="max-w-[200px] truncate text-text-secondary">
                        {pickCustomerLabel(row.customer)}
                      </TableCell>
                      <TableCell className="text-xs text-text-secondary">
                        {subType}
                        <br />
                        <span className="font-mono text-[10px]">{subId.slice(0, 8)}…</span>
                      </TableCell>
                      <TableCell className="text-text-secondary text-sm">
                        {typeof created === 'string'
                          ? format(new Date(created), 'yyyy/MM/dd HH:mm', { locale: ar })
                          : '—'}
                      </TableCell>
                      <TableCell>
                        <Link href={`/service_quality/${id}`}>
                          <Button variant="ghost" size="sm">
                            عرض
                          </Button>
                        </Link>
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
