'use client'

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
import { fetchPayoutRequests } from '@/lib/api/client'
import { format } from 'date-fns'
import { ar } from 'date-fns/locale'

const payoutStatusLabel: Record<string, string> = {
  pending: 'قيد الانتظار',
  submitted: 'مُرسَل',
  processing: 'قيد المعالجة',
  completed: 'مكتمل',
  failed: 'فاشل',
}

export default function ReconciliationPage() {
  const { data, error, isLoading } = useSWR(
    ['/admin/payout-requests', 1],
    () => fetchPayoutRequests({ page: 1, limit: 50 }),
  )

  if (error) {
    return (
      <>
        <PageHeader
          title="تحويلات المزوّدين"
          description="طلبات صرف مستحقات مقدّمي الخدمة (تجريبي مع mock حتى ربط PSP)"
          children={
            <Link href="/payments">
              <Button variant="outline" size="sm">العودة للمدفوعات</Button>
            </Link>
          }
        />
        <div className="rounded-card border border-error/30 bg-error/10 px-4 py-3 text-text-primary">
          فشل التحميل: {error.message}
        </div>
      </>
    )
  }

  const items = (data?.items ?? []) as Array<{
    id: string
    vendorId: string
    vendorName: string | null
    amount: number
    currency: string
    status: string
    sourceType: string | null
    sourceId: string | null
    idempotencyKey: string
    providerPayoutId: string | null
    failureReason: string | null
    createdAt: string
    completedAt: string | null
  }>
  const total = data?.total ?? 0

  return (
    <>
      <PageHeader
        title="تحويلات المزوّدين"
        description="سجلات payout_requests — مع مزوّد mock يُكمَّل الطلب في قاعدة البيانات فوراً. عند الاشتراك مع شركة دفع: استبدل PaymentGatewayPort و PayoutGatewayPort دون تغيير الجداول."
        children={
          <Link href="/payments">
            <Button variant="outline" size="sm">العودة للمدفوعات</Button>
          </Link>
        }
      />
      <Card className="mb-4">
        <CardHeader
          title="تجربة مسار الدفع"
          description="لإكمال مدفوعات البطاقة المعلّقة في بيئة غير الإنتاج: من صفحة «المدفوعات» استخدم «إكمال تجريبي». في الإنتاج يُستبدل بـ webhook شركة الدفع."
        />
      </Card>
      <Card>
        <CardHeader
          title="طلبات التحويل"
          description={`إجمالي: ${total}`}
        />
        <div className="overflow-hidden rounded-b-card">
          {isLoading ? (
            <div className="flex h-48 items-center justify-center text-text-secondary">
              جاري التحميل...
            </div>
          ) : items.length === 0 ? (
            <EmptyState
              title="لا طلبات تحويل"
              description="بعد إتمام طلب طبخ منزلي من العميل يُنشأ سجل تحويل للمطبخ إن كان المسار مفعّلاً."
            />
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>المطبخ</TableHead>
                  <TableHead>المبلغ</TableHead>
                  <TableHead>المصدر</TableHead>
                  <TableHead>الحالة</TableHead>
                  <TableHead>مفتاح عدم التكرار</TableHead>
                  <TableHead>التاريخ</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {items.map((r) => (
                  <TableRow key={r.id}>
                    <TableCell className="font-semibold text-text-primary">
                      {r.vendorName ?? '—'}
                      <div className="text-xs font-normal text-text-secondary">{r.vendorId}</div>
                    </TableCell>
                    <TableCell>
                      {r.amount ?? 0} {r.currency === 'SAR' ? 'ر.س' : r.currency}
                    </TableCell>
                    <TableCell className="text-text-secondary text-sm">
                      {r.sourceType ?? '—'}
                      {r.sourceId ? (
                        <div className="break-all font-mono text-xs">{r.sourceId}</div>
                      ) : null}
                    </TableCell>
                    <TableCell>
                      <Badge
                        variant={
                          r.status === 'completed'
                            ? 'success'
                            : r.status === 'failed'
                              ? 'danger'
                              : 'default'
                        }
                      >
                        {payoutStatusLabel[r.status] ?? r.status}
                      </Badge>
                      {r.failureReason ? (
                        <div className="mt-1 text-xs text-error">{r.failureReason}</div>
                      ) : null}
                    </TableCell>
                    <TableCell className="max-w-[140px] break-all font-mono text-xs text-text-secondary">
                      {r.idempotencyKey}
                    </TableCell>
                    <TableCell className="text-text-secondary text-sm">
                      {r.createdAt
                        ? format(new Date(r.createdAt), 'yyyy/MM/dd HH:mm', { locale: ar })
                        : '-'}
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          )}
        </div>
      </Card>
    </>
  )
}
