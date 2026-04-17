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
import {
  fetchHomeCookingPaymentQueue,
  verifyHomeCookingPayment,
} from '@/lib/api/client'
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

export default function HomeCookingPaymentsPage() {
  const [page, setPage] = useState(1)
  const [busyId, setBusyId] = useState<string | null>(null)
  const { data, error, isLoading, mutate } = useSWR(
    ['/admin/home-cooking-payment-queue', page],
    () => fetchHomeCookingPaymentQueue({ page, limit: 20 }),
  )

  const onVerify = async (id: string) => {
    setBusyId(id)
    try {
      await verifyHomeCookingPayment(id)
      await mutate()
    } finally {
      setBusyId(null)
    }
  }

  if (error) {
    return (
      <>
        <PageHeader
          title="تحقق طبخ منزلي"
          description="طلبات بانتظار تأكيد التحويل البنكي"
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
        title="تحقق طبخ منزلي"
        description="بعد التأكيد يُبلّغ المطبخ ببدء التحضير — منفصل عن طلبات الوجبات الجاهزة"
      />
      <Card>
        <CardHeader
          title="قائمة الانتظار"
          description={`إجمالي: ${total}`}
        />
        <div className="overflow-hidden rounded-b-card">
          {isLoading ? (
            <div className="flex h-48 items-center justify-center text-text-secondary">
              جاري التحميل...
            </div>
          ) : items.length === 0 ? (
            <EmptyState
              title="لا طلبات"
              description="لا توجد طلبات طبخ منزلي بانتظار تحقق الدفع"
            />
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>المعرّف</TableHead>
                  <TableHead>المطبخ</TableHead>
                  <TableHead>العميل</TableHead>
                  <TableHead>المبلغ المعروض</TableHead>
                  <TableHead>مرجع التحويل</TableHead>
                  <TableHead>التاريخ</TableHead>
                  <TableHead>إجراء</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {items.map((row) => {
                  const id = String(row.id ?? '')
                  const quoted =
                    row.quotedAmount ?? row.quoted_amount ?? '—'
                  const ref =
                    row.paymentReference ?? row.payment_reference ?? '—'
                  const created =
                    (row.paymentDeclaredAt ??
                      row.payment_declared_at ??
                      row.createdAt ??
                      row.created_at) as string | undefined
                  const createdLabel =
                    created &&
                    format(new Date(created), 'd MMM yyyy HH:mm', {
                      locale: ar,
                    })

                  return (
                    <TableRow key={id}>
                      <TableCell className="max-w-[120px] truncate font-mono text-xs text-text-secondary">
                        {id}
                      </TableCell>
                      <TableCell className="font-medium text-text-primary">
                        {pickVendorName(row.vendor)}
                      </TableCell>
                      <TableCell className="text-text-secondary">
                        {pickUserLabel(row.user)}
                      </TableCell>
                      <TableCell>
                        {String(quoted)} ر.س
                      </TableCell>
                      <TableCell className="max-w-[200px] break-all text-sm">
                        {String(ref)}
                      </TableCell>
                      <TableCell className="text-text-secondary text-sm">
                        {createdLabel ?? '—'}
                      </TableCell>
                      <TableCell>
                        <Button
                          size="sm"
                          disabled={busyId === id}
                          onClick={() => onVerify(id)}
                        >
                          {busyId === id ? 'جاري…' : 'تأكيد الدفع'}
                        </Button>
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
