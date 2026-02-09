'use client'

import useSWR from 'swr'
import Link from 'next/link'
import { PageHeader } from '@/components/ui/PageHeader'
import { Card, CardHeader, CardBody } from '@/components/ui/Card'
import { StatCard } from '@/components/ui/StatCard'
import { Badge } from '@/components/ui/Badge'
import {
  Table,
  TableHeader,
  TableBody,
  TableRow,
  TableHead,
  TableCell,
} from '@/components/ui/Table'
import { EmptyState } from '@/components/ui/EmptyState'
import { fetchDashboard } from '@/lib/api/client'
import { ShoppingBag, Store, Users, MessageSquare, AlertCircle } from 'lucide-react'
import { formatDistanceToNow } from 'date-fns'
import { ar } from 'date-fns/locale'

const statusLabel: Record<string, string> = {
  pending: 'قيد الانتظار',
  confirmed: 'مؤكد',
  preparing: 'قيد التحضير',
  ready: 'جاهز',
  out_for_delivery: 'قيد التوصيل',
  delivered: 'تم التوصيل',
  cancelled: 'ملغي',
}

export default function DashboardPage() {
  const { data, error, isLoading } = useSWR('/admin/dashboard', () => fetchDashboard())

  if (error) {
    return (
      <>
        <PageHeader title="لوحة التحكم" description="نظرة عامة" />
        <div className="rounded-card border border-error/30 bg-error/10 px-4 py-3 text-text-primary">
          فشل تحميل البيانات: {error.message}
        </div>
      </>
    )
  }

  if (isLoading || !data) {
    return (
      <>
        <PageHeader title="لوحة التحكم" description="نظرة عامة" />
        <div className="grid gap-5 sm:grid-cols-2 lg:grid-cols-4">
          {[1, 2, 3, 4].map((i) => (
            <div
              key={i}
              className="h-24 animate-pulse rounded-card bg-surface-variant"
            />
          ))}
        </div>
        <div className="mt-8 h-64 animate-pulse rounded-card bg-surface-variant" />
      </>
    )
  }

  return (
    <>
      <PageHeader
        title="لوحة التحكم"
        description="نظرة عامة حسب الدور (Super Admin / Ops / Finance / Support / Quality)"
      />
      <div className="grid gap-5 sm:grid-cols-2 lg:grid-cols-4">
        <StatCard
          title="طلبات اليوم"
          value={String(data.ordersToday)}
          icon={ShoppingBag}
        />
        <StatCard
          title="مطاعم بانتظار الموافقة"
          value={String(data.vendorsPendingCount)}
          icon={Store}
        />
        <StatCard
          title="سائقون بانتظار الموافقة"
          value={String(data.driversPendingCount)}
          icon={Users}
        />
        <StatCard
          title="طلبات حية (قيد التوصيل)"
          value={String(data.ordersLiveCount)}
          icon={ShoppingBag}
        />
        <StatCard
          title="طلبات معلقة"
          value={String(data.ordersPending)}
          icon={ShoppingBag}
        />
        <StatCard
          title="مشاكل مدفوعات (فاشلة)"
          value={String(data.paymentIssuesCount)}
          icon={AlertCircle}
        />
      </div>
      <div className="mt-8 grid gap-6 lg:grid-cols-2">
        <Card>
          <CardHeader title="آخر الطلبات" description="أحدث 10 طلبات" />
          <div className="overflow-hidden">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>الطلب</TableHead>
                  <TableHead>الحالة</TableHead>
                  <TableHead>المبلغ</TableHead>
                  <TableHead>التاريخ</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {data.recentOrders?.length === 0 ? (
                  <TableRow>
                    <TableCell colSpan={4} className="text-center text-text-secondary">
                      لا توجد طلبات
                    </TableCell>
                  </TableRow>
                ) : (
                  data.recentOrders?.map((row: { id: string; orderNumber: string; status: string; total: number; createdAt: string }) => (
                    <TableRow key={row.id}>
                      <TableCell className="font-semibold text-text-primary">
                        <Link href={`/orders/${row.id}`} className="text-primary hover:underline">
                          {row.orderNumber}
                        </Link>
                      </TableCell>
                      <TableCell>
                        <Badge variant="default">{statusLabel[row.status] ?? row.status}</Badge>
                      </TableCell>
                      <TableCell>{row.total ?? 0} ر.س</TableCell>
                      <TableCell className="text-text-secondary">
                        {row.createdAt
                          ? formatDistanceToNow(new Date(row.createdAt), { addSuffix: true, locale: ar })
                          : '-'}
                      </TableCell>
                    </TableRow>
                  ))
                )}
              </TableBody>
            </Table>
          </div>
        </Card>
        <Card>
          <CardHeader
            title="بانتظار الموافقة"
            description="مطاعم وسائقون"
          />
          <CardBody className="space-y-2">
            <Link
              href="/vendors/applications"
              className="flex items-center justify-between rounded-button border border-divider bg-surface px-4 py-3 transition-smooth hover:bg-primary-container/40 hover:border-primary/20"
            >
              <span className="text-sm font-semibold text-text-primary">
                طلبات المطاعم
              </span>
              <Badge variant="primary">{data.vendorsPendingCount ?? 0}</Badge>
            </Link>
            <Link
              href="/drivers/applications"
              className="flex items-center justify-between rounded-button border border-divider bg-surface px-4 py-3 transition-smooth hover:bg-primary-container/40 hover:border-primary/20"
            >
              <span className="text-sm font-semibold text-text-primary">
                طلبات السائقين
              </span>
              <Badge variant="primary">{data.driversPendingCount ?? 0}</Badge>
            </Link>
          </CardBody>
        </Card>
      </div>
    </>
  )
}
