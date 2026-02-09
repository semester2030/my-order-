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
import { fetchPayments } from '@/lib/api/client'
import { format } from 'date-fns'
import { ar } from 'date-fns/locale'
const methodLabel: Record<string, string> = {
  apple_pay: 'Apple Pay',
  mada: 'مدى',
  stc_pay: 'STC Pay',
}
const statusLabel: Record<string, string> = {
  pending: 'قيد الانتظار',
  processing: 'قيد المعالجة',
  completed: 'مكتمل',
  failed: 'فاشل',
  refunded: 'مسترد',
}

export default function PaymentsPage() {
  const [page, setPage] = useState(1)
  const { data, error, isLoading } = useSWR(
    ['/admin/payments', page],
    () => fetchPayments({ page, limit: 20 }),
  )

  if (error) {
    return (
      <>
        <PageHeader title="المدفوعات" description="المعاملات والمصالحة" />
        <div className="rounded-card border border-error/30 bg-error/10 px-4 py-3 text-text-primary">
          فشل تحميل البيانات: {error.message}
        </div>
      </>
    )
  }

  const items = (data?.items ?? []) as Array<{
    id: string
    orderId: string
    method: string
    status: string
    amount: number
    transactionId: string | null
    failureReason: string | null
    createdAt: string
  }>
  const total = data?.total ?? 0
  const totalPages = data?.limit ? Math.ceil(total / data.limit) : 1

  return (
    <>
      <PageHeader
        title="المدفوعات"
        description="المعاملات والمصالحة والعمولات"
      />
      <Card>
        <CardHeader
          title="آخر المعاملات"
          description={`إجمالي: ${total}`}
          action={
            <Link href="/payments/reconciliation">
              <Button variant="outline" size="sm">المصالحة</Button>
            </Link>
          }
        />
        <div className="overflow-hidden rounded-b-card">
          {isLoading ? (
            <div className="flex h-48 items-center justify-center text-text-secondary">
              جاري التحميل...
            </div>
          ) : items.length === 0 ? (
            <EmptyState title="لا معاملات" description="لا توجد مدفوعات" />
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>الطلب</TableHead>
                  <TableHead>المبلغ</TableHead>
                  <TableHead>طريقة الدفع</TableHead>
                  <TableHead>الحالة</TableHead>
                  <TableHead>التاريخ</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {items.map((p) => (
                  <TableRow key={p.id}>
                    <TableCell className="font-semibold text-text-primary">
                      <Link href={`/orders/${p.orderId}`} className="text-primary hover:underline">
                        {p.orderId}
                      </Link>
                    </TableCell>
                    <TableCell>{p.amount ?? 0} ر.س</TableCell>
                    <TableCell className="text-text-secondary">
                      {methodLabel[p.method] ?? p.method}
                    </TableCell>
                    <TableCell>
                      <Badge
                        variant={
                          p.status === 'completed'
                            ? 'success'
                            : p.status === 'failed'
                              ? 'danger'
                              : 'default'
                        }
                      >
                        {statusLabel[p.status] ?? p.status}
                      </Badge>
                    </TableCell>
                    <TableCell className="text-text-secondary">
                      {p.createdAt
                        ? format(new Date(p.createdAt), 'yyyy/MM/dd HH:mm', { locale: ar })
                        : '-'}
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          )}
        </div>
        {totalPages > 1 && (
          <div className="flex justify-center gap-2 border-t border-divider px-4 py-3">
            <Button variant="outline" size="sm" disabled={page <= 1} onClick={() => setPage((p) => p - 1)}>
              السابق
            </Button>
            <span className="flex items-center text-sm text-text-secondary">{page} / {totalPages}</span>
            <Button variant="outline" size="sm" disabled={page >= totalPages} onClick={() => setPage((p) => p + 1)}>
              التالي
            </Button>
          </div>
        )}
      </Card>
    </>
  )
}
