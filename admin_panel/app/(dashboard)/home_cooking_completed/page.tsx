'use client'

import { useState } from 'react'
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
import { fetchHomeCookingCompleted } from '@/lib/api/client'
import { format } from 'date-fns'
import { ar } from 'date-fns/locale'

function pickVendorName(v: unknown): string {
  if (!v || typeof v !== 'object') return '—'
  const o = v as Record<string, unknown>
  const n = o.name ?? o.tradeName ?? o.trade_name
  return typeof n === 'string' && n.length > 0 ? n : '—'
}

function pickUserLabel(u: unknown): string {
  if (!u || typeof u !== 'object') return '—'
  const o = u as Record<string, unknown>
  const name = o.name
  const phone = o.phone
  const parts: string[] = []
  if (typeof name === 'string' && name) parts.push(name)
  if (typeof phone === 'string' && phone) parts.push(phone)
  return parts.length ? parts.join(' · ') : '—'
}

export default function HomeCookingCompletedPage() {
  const [page, setPage] = useState(1)
  const { data, error, isLoading } = useSWR(
    ['/admin/home-cooking-completed', page],
    () => fetchHomeCookingCompleted({ page, limit: 20 }),
  )

  if (error) {
    return (
      <>
        <PageHeader
          title="أرشيف الطبخ المنزلي المكتمل"
          description="طلبات أُغلقت بتأكيد استلام العميل ومرفقة برمز إتمام"
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
        title="أرشيف الطبخ المنزلي المكتمل"
        description="يظهر رمز الإتمام الصادر عند ضغط العميل «تم الاستلام» — للرجوع إليه في الشكاوى أو التدقيق"
      />
      <Card>
        <CardHeader title="السجلات" description={`إجمالي: ${total}`} />
        <div className="overflow-hidden rounded-b-card">
          {isLoading ? (
            <div className="flex h-48 items-center justify-center text-text-secondary">
              جاري التحميل...
            </div>
          ) : items.length === 0 ? (
            <EmptyState
              title="لا سجلات"
              description="لا توجد طلبات طبخ منزلي مكتملة بعد"
            />
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>رمز الإتمام</TableHead>
                  <TableHead>المعرّف</TableHead>
                  <TableHead>المطبخ</TableHead>
                  <TableHead>العميل</TableHead>
                  <TableHead>تاريخ الإتمام</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {items.map((row) => {
                  const id = String(row.id ?? '')
                  const code =
                    row.completionCertificateCode ??
                    row.completion_certificate_code ??
                    '—'
                  const completed =
                    (row.completedAt ?? row.completed_at) as string | undefined
                  const completedLabel =
                    completed &&
                    format(new Date(completed), 'd MMM yyyy HH:mm', {
                      locale: ar,
                    })

                  return (
                    <TableRow key={id}>
                      <TableCell>
                        <Badge variant="success" className="font-mono text-xs">
                          {String(code)}
                        </Badge>
                      </TableCell>
                      <TableCell className="max-w-[100px] truncate font-mono text-xs text-text-secondary">
                        {id}
                      </TableCell>
                      <TableCell className="font-medium text-text-primary">
                        {pickVendorName(row.vendor)}
                      </TableCell>
                      <TableCell className="text-text-secondary">
                        {pickUserLabel(row.user)}
                      </TableCell>
                      <TableCell className="text-sm text-text-secondary">
                        {completedLabel ?? '—'}
                      </TableCell>
                    </TableRow>
                  )
                })}
              </TableBody>
            </Table>
          )}
        </div>
        {totalPages > 1 && (
          <div className="flex items-center justify-end gap-2 border-t border-border/60 px-4 py-3">
            <Badge variant="default">
              صفحة {page} / {totalPages}
            </Badge>
            <Button
              variant="outline"
              size="sm"
              disabled={page <= 1}
              onClick={() => setPage((p) => Math.max(1, p - 1))}
            >
              السابق
            </Button>
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
