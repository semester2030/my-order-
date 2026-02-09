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
import { fetchDrivers } from '@/lib/api/client'
import { format } from 'date-fns'
import { ar } from 'date-fns/locale'

const statusLabel: Record<string, string> = {
  pending: 'بانتظار الموافقة',
  under_review: 'قيد المراجعة',
  documents_requested: 'مستندات مطلوبة',
  approved: 'معتمد',
  rejected: 'مرفوض',
  suspended: 'موقوف',
  inactive: 'غير نشط',
}

export default function DriversPage() {
  const [status, setStatus] = useState<string | undefined>()
  const [page, setPage] = useState(1)
  const { data, error, isLoading } = useSWR(
    ['/admin/drivers', status, page],
    () => fetchDrivers({ status, page, limit: 20 }),
  )

  if (error) {
    return (
      <>
        <PageHeader title="السائقون" description="قائمة السائقين" />
        <div className="rounded-card border border-error/30 bg-error/10 px-4 py-3 text-text-primary">
          فشل تحميل البيانات: {error.message}
        </div>
      </>
    )
  }

  const items = (data?.items ?? []) as Array<{
    id: string
    fullName: string | null
    phoneNumber: string
    email: string | null
    status: string
    nationalId: string
    createdAt: string
    user?: { phone?: string; name?: string } | null
  }>
  const total = data?.total ?? 0
  const totalPages = data?.limit ? Math.ceil(total / data.limit) : 1

  return (
    <>
      <PageHeader
        title="السائقون"
        description="قائمة السائقين — فلاتر حسب الحالة"
      />
      <Card>
        <CardHeader
          title="قائمة السائقين"
          description={`إجمالي: ${total}`}
          action={
            <select
              value={status ?? ''}
              onChange={(e) => {
                setStatus(e.target.value || undefined)
                setPage(1)
              }}
              className="rounded-button border border-border-default bg-surface-default px-3 py-2 text-sm text-text-primary"
            >
              <option value="">كل الحالات</option>
              {Object.entries(statusLabel).map(([k, v]) => (
                <option key={k} value={k}>{v}</option>
              ))}
            </select>
          }
        />
        <div className="overflow-hidden rounded-b-card">
          {isLoading ? (
            <div className="flex h-48 items-center justify-center text-text-secondary">
              جاري التحميل...
            </div>
          ) : items.length === 0 ? (
            <EmptyState title="لا سائقين" description="لا يوجد سائقون يطابقون الفلتر" />
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>الاسم</TableHead>
                  <TableHead>الهاتف</TableHead>
                  <TableHead>الحالة</TableHead>
                  <TableHead>تاريخ التسجيل</TableHead>
                  <TableHead></TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {items.map((d) => (
                  <TableRow key={d.id}>
                    <TableCell className="font-semibold text-text-primary">
                      {d.fullName ?? d.user?.name ?? '-'}
                    </TableCell>
                    <TableCell className="text-text-secondary">{d.phoneNumber}</TableCell>
                    <TableCell>
                      <Badge
                        variant={
                          d.status === 'approved'
                            ? 'success'
                            : d.status === 'rejected' || d.status === 'suspended'
                              ? 'danger'
                              : 'warning'
                        }
                      >
                        {statusLabel[d.status] ?? d.status}
                      </Badge>
                    </TableCell>
                    <TableCell className="text-text-secondary">
                      {d.createdAt
                        ? format(new Date(d.createdAt), 'yyyy/MM/dd', { locale: ar })
                        : '-'}
                    </TableCell>
                    <TableCell>
                      <Link href={`/drivers/${d.id}`}>
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
