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
import { fetchVendors } from '@/lib/api/client'
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

export default function VendorsPage() {
  const [status, setStatus] = useState<string | undefined>()
  const [category, setCategory] = useState<string | undefined>()
  const [page, setPage] = useState(1)
  const { data, error, isLoading } = useSWR(
    ['/admin/vendors', status, category, page],
    () => fetchVendors({ status, category, page, limit: 20 }),
  )

  if (error) {
    return (
      <>
        <PageHeader title="المطاعم" description="قائمة المطاعم" />
        <div className="rounded-card border border-error/30 bg-error/10 px-4 py-3 text-text-primary">
          فشل تحميل البيانات: {error.message}
        </div>
      </>
    )
  }

  const items = (data?.items ?? []) as Array<{
    id: string
    name: string
    email: string
    city?: string
    registrationStatus: string
    isActive: boolean
    providerCategory?: string | null
    createdAt: string
  }>
  const total = data?.total ?? 0
  const totalPages = data?.limit ? Math.ceil(total / data.limit) : 1

  return (
    <>
      <PageHeader
        title="المطاعم / مقدمي الخدمة"
        description="قائمة المطاعم — فلاتر حسب الحالة والفئة"
      />
      <Card>
        <CardHeader
          title="قائمة المطاعم"
          description={`إجمالي: ${total}`}
          action={
            <div className="flex flex-wrap items-center gap-2">
              <select
                value={category ?? ''}
                onChange={(e) => {
                  setCategory(e.target.value || undefined)
                  setPage(1)
                }}
                className="rounded-button border border-border-default bg-surface-default px-3 py-2 text-sm text-text-primary"
              >
                <option value="">كل الفئات</option>
                {Object.entries(categoryLabel).map(([k, v]) => (
                  <option key={k} value={k}>{v}</option>
                ))}
              </select>
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
            </div>
          }
        />
        <div className="overflow-hidden rounded-b-card">
          {isLoading ? (
            <div className="flex h-48 items-center justify-center text-text-secondary">
              جاري التحميل...
            </div>
          ) : items.length === 0 ? (
            <EmptyState title="لا مطاعم" description="لا توجد مطاعم تطابق الفلتر" />
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>الاسم</TableHead>
                  <TableHead>الفئة</TableHead>
                  <TableHead>البريد</TableHead>
                  <TableHead>المدينة</TableHead>
                  <TableHead>الحالة</TableHead>
                  <TableHead>تاريخ الانضمام</TableHead>
                  <TableHead></TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {items.map((v) => (
                  <TableRow key={v.id}>
                    <TableCell className="font-semibold text-text-primary">{v.name}</TableCell>
                    <TableCell className="text-text-secondary">
                      {v.providerCategory ? (categoryLabel[v.providerCategory] ?? v.providerCategory) : '-'}
                    </TableCell>
                    <TableCell className="text-text-secondary">{v.email}</TableCell>
                    <TableCell>{v.city ?? '-'}</TableCell>
                    <TableCell>
                      <Badge
                        variant={
                          v.registrationStatus === 'approved'
                            ? 'success'
                            : v.registrationStatus === 'rejected' || v.registrationStatus === 'suspended'
                              ? 'danger'
                              : 'warning'
                        }
                      >
                        {statusLabel[v.registrationStatus] ?? v.registrationStatus}
                      </Badge>
                    </TableCell>
                    <TableCell className="text-text-secondary">
                      {v.createdAt
                        ? format(new Date(v.createdAt), 'yyyy/MM/dd', { locale: ar })
                        : '-'}
                    </TableCell>
                    <TableCell>
                      <Link href={`/vendors/${v.id}`}>
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
