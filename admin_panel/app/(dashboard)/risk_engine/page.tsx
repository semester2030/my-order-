'use client'

import useSWR from 'swr'
import { PageHeader } from '@/components/ui/PageHeader'
import { Card, CardHeader } from '@/components/ui/Card'
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
import { fetchRiskFlags } from '@/lib/api/client'

export default function RiskEnginePage() {
  const { data, error, isLoading } = useSWR('/admin/risk-flags', () => fetchRiskFlags())

  if (error) {
    return (
      <>
        <PageHeader title="منع التلاعب" description="كشف الاحتيال والسلوك المشبوه" />
        <div className="rounded-card border border-error/30 bg-error/10 px-4 py-3 text-text-primary">
          فشل تحميل البيانات: {error.message}
        </div>
      </>
    )
  }

  const flags = data?.flags ?? []

  return (
    <>
      <PageHeader
        title="منع التلاعب"
        description="كشف الاحتيال والسلوك المشبوه — قواعد ومخاطر"
      />
      <Card>
        <CardHeader
          title="تنبيهات المخاطر"
          description="الحسابات أو الطلبات ذات المخاطر (من الباك إند)"
        />
        <div className="overflow-hidden rounded-b-card">
          {isLoading ? (
            <div className="flex h-48 items-center justify-center text-text-secondary">
              جاري التحميل...
            </div>
          ) : flags.length === 0 ? (
            <EmptyState title="لا تنبيهات" description="لا توجد تنبيهات مخاطر حالياً" />
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>العنوان</TableHead>
                  <TableHead>الوصف</TableHead>
                  <TableHead>مستوى الخطورة</TableHead>
                  <TableHead>نوع الكيان</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {flags.map((f) => (
                  <TableRow key={f.id}>
                    <TableCell className="font-semibold text-text-primary">{f.title}</TableCell>
                    <TableCell className="text-text-secondary">{f.description}</TableCell>
                    <TableCell>
                      <Badge variant={f.severity === 'high' ? 'danger' : 'warning'}>
                        {f.severity === 'high' ? 'عالي' : 'متوسط'}
                      </Badge>
                    </TableCell>
                    <TableCell className="text-text-secondary">{f.entityType}</TableCell>
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
