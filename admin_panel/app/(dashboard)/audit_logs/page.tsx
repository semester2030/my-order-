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
import { fetchAuditLogs } from '@/lib/api/client'
import { format } from 'date-fns'
import { ar } from 'date-fns/locale'

export default function AuditLogsPage() {
  const [page, setPage] = useState(1)
  const { data, error, isLoading } = useSWR(
    ['/admin/audit-logs', page],
    () => fetchAuditLogs({ page, limit: 20 }),
  )

  if (error) {
    return (
      <>
        <PageHeader title="سجل التدقيق" description="من وافق؟ متى؟ ماذا تغير؟" />
        <div className="rounded-card border border-error/30 bg-error/10 px-4 py-3 text-text-primary">
          فشل تحميل البيانات: {error.message}
        </div>
      </>
    )
  }

  const items = (data?.items ?? []) as Array<{
    id: string
    action: string
    actorType: string
    actorId: string
    entityType: string
    entityId: string
    reason: string | null
    createdAt: string
  }>
  const total = data?.total ?? 0
  const totalPages = data?.limit ? Math.ceil(total / data.limit) : 1

  return (
    <>
      <PageHeader
        title="سجل التدقيق"
        description="من وافق؟ متى؟ ماذا تغير؟ لماذا رُفض؟ — ضروري قانونياً وتشغيلياً."
      />
      <Card>
        <CardHeader
          title="سجلات التدقيق"
          description={`إجمالي: ${total}`}
        />
        <div className="overflow-hidden rounded-b-card">
          {isLoading ? (
            <div className="flex h-48 items-center justify-center text-text-secondary">
              جاري التحميل...
            </div>
          ) : items.length === 0 ? (
            <EmptyState title="لا سجلات" description="لا توجد سجلات تدقيق بعد" />
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>الإجراء</TableHead>
                  <TableHead>نوع الكيان</TableHead>
                  <TableHead>معرف الكيان</TableHead>
                  <TableHead>السبب</TableHead>
                  <TableHead>الوقت</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {items.map((log) => (
                  <TableRow key={log.id}>
                    <TableCell className="font-semibold text-text-primary">{log.action}</TableCell>
                    <TableCell className="text-text-secondary">{log.entityType}</TableCell>
                    <TableCell>{log.entityId}</TableCell>
                    <TableCell className="text-text-secondary max-w-xs truncate">
                      {log.reason ?? '-'}
                    </TableCell>
                    <TableCell className="text-text-secondary">
                      {log.createdAt
                        ? format(new Date(log.createdAt), 'yyyy/MM/dd HH:mm:ss', { locale: ar })
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
