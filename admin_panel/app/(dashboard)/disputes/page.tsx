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
import { fetchDisputes } from '@/lib/api/client'
import { format } from 'date-fns'
import { ar } from 'date-fns/locale'

export default function DisputesPage() {
  const [page, setPage] = useState(1)
  const { data, error, isLoading } = useSWR(
    ['/admin/disputes', page],
    () => fetchDisputes({ page, limit: 20 }),
  )

  if (error) {
    return (
      <>
        <PageHeader title="الشكاوى" description="شكاوى العملاء والمنازعات" />
        <div className="rounded-card border border-error/30 bg-error/10 px-4 py-3 text-text-primary">
          فشل تحميل البيانات: {error.message}
        </div>
      </>
    )
  }

  const items = (data?.items ?? []) as Array<{
    id: string
    orderId?: string
    type?: string
    status?: string
    createdAt?: string
  }>
  const total = data?.total ?? 0
  const totalPages = data?.limit ? Math.ceil(total / data.limit) : 1

  return (
    <>
      <PageHeader
        title="الشكاوى"
        description="شكاوى العملاء والمنازعات — تعيين واتخاذ قرار"
      />
      <Card>
        <CardHeader
          title="الشكاوى المفتوحة"
          description={`قائمة الشكاوى والمنازعات — إجمالي: ${total}`}
        />
        <div className="overflow-hidden rounded-b-card">
          {isLoading ? (
            <div className="flex h-48 items-center justify-center text-text-secondary">
              جاري التحميل...
            </div>
          ) : items.length === 0 ? (
            <EmptyState
              title="لا شكاوى حالياً"
              description="لا توجد شكاوى أو منازعات. عند إضافة جدول الشكاوى في الباك إند ستظهر هنا."
            />
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>الطلب</TableHead>
                  <TableHead>نوع الشكوى</TableHead>
                  <TableHead>الحالة</TableHead>
                  <TableHead>التاريخ</TableHead>
                  <TableHead></TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {items.map((d) => (
                  <TableRow key={d.id}>
                    <TableCell className="font-semibold text-text-primary">
                      {d.orderId ? (
                        <Link href={`/orders/${d.orderId}`} className="text-primary hover:underline">
                          {d.orderId}
                        </Link>
                      ) : (
                        d.id
                      )}
                    </TableCell>
                    <TableCell>{d.type ?? '—'}</TableCell>
                    <TableCell>
                      <Badge variant="default">{d.status ?? '—'}</Badge>
                    </TableCell>
                    <TableCell className="text-text-secondary">
                      {d.createdAt
                        ? format(new Date(d.createdAt), 'yyyy/MM/dd HH:mm', { locale: ar })
                        : '—'}
                    </TableCell>
                    <TableCell>
                      <Link href={`/disputes/${d.id}`}>
                        <Button variant="ghost" size="sm">عرض</Button>
                      </Link>
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
