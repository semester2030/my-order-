'use client'

import { useState } from 'react'
import useSWR from 'swr'
import { PageHeader } from '@/components/ui/PageHeader'
import { Card, CardHeader } from '@/components/ui/Card'
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
  adminMe,
  fetchAuditLogs,
  fetchAdminUsers,
  type AdminTeamUser,
} from '@/lib/api/client'
import { format } from 'date-fns'
import { ar } from 'date-fns/locale'

const inputClass =
  'rounded-card border border-border-default bg-surface-default px-3 py-2 text-sm text-text-primary focus:outline-none focus:ring-2 focus:ring-primary'

function jsonPreview(v: unknown): string {
  if (v == null) return '-'
  try {
    const s = JSON.stringify(v)
    return s.length > 80 ? `${s.slice(0, 80)}…` : s
  } catch {
    return String(v)
  }
}

export default function AuditLogsPage() {
  const { data: me } = useSWR('admin-me', adminMe)
  const { data: teamData } = useSWR(
    me?.role === 'super_admin' ? '/admin/users-for-audit-filter' : null,
    fetchAdminUsers,
  )
  const teamUsers = (teamData?.items ?? []) as AdminTeamUser[]

  const [page, setPage] = useState(1)
  const [actionFilter, setActionFilter] = useState('')
  const [entityTypeFilter, setEntityTypeFilter] = useState('')
  const [actorIdFilter, setActorIdFilter] = useState('')
  const [dateFrom, setDateFrom] = useState('')
  const [dateTo, setDateTo] = useState('')

  const { data, error, isLoading } = useSWR(
    [
      '/admin/audit-logs',
      page,
      actionFilter,
      entityTypeFilter,
      actorIdFilter,
      dateFrom,
      dateTo,
    ],
    () =>
      fetchAuditLogs({
        page,
        limit: 20,
        action: actionFilter.trim() || undefined,
        entityType: entityTypeFilter.trim() || undefined,
        actorId: actorIdFilter.trim() || undefined,
        dateFrom: dateFrom.trim() || undefined,
        dateTo: dateTo.trim() || undefined,
      }),
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
    actorName: string | null
    actorEmail: string | null
    entityType: string
    entityId: string
    reason: string | null
    ip: string | null
    userAgent: string | null
    oldValue: Record<string, unknown> | null
    newValue: Record<string, unknown> | null
    createdAt: string
  }>
  const total = data?.total ?? 0
  const limit = (data?.limit as number) ?? 20
  const totalPages = Math.max(1, Math.ceil(total / limit))

  return (
    <>
      <PageHeader
        title="سجل التدقيق"
        description="من نفّذ؟ متى؟ الإجراء، الكيان، IP — يشمل تسجيل الدخول والخروج وإدارة الفريق."
      />
      <Card className="mb-4">
        <CardHeader title="تصفية" description="فعّل الفلاتر ثم انتقل بين الصفحات" />
        <div className="flex flex-wrap items-end gap-3 border-t border-divider px-4 py-4">
          <div>
            <label className="mb-1 block text-xs text-text-secondary">الإجراء (نص)</label>
            <input
              className={`${inputClass} w-40`}
              value={actionFilter}
              onChange={(e) => {
                setActionFilter(e.target.value)
                setPage(1)
              }}
              placeholder="ADMIN_LOGIN_SUCCESS"
            />
          </div>
          <div>
            <label className="mb-1 block text-xs text-text-secondary">نوع الكيان</label>
            <input
              className={`${inputClass} w-36`}
              value={entityTypeFilter}
              onChange={(e) => {
                setEntityTypeFilter(e.target.value)
                setPage(1)
              }}
              placeholder="vendor"
            />
          </div>
          <div>
            <label className="mb-1 block text-xs text-text-secondary">من نفّذ</label>
            {me?.role === 'super_admin' && teamUsers.length > 0 ? (
              <select
                className={`${inputClass} min-w-[200px]`}
                value={actorIdFilter}
                onChange={(e) => {
                  setActorIdFilter(e.target.value)
                  setPage(1)
                }}
              >
                <option value="">الكل</option>
                {teamUsers.map((u) => (
                  <option key={u.id} value={u.id}>
                    {u.name} — {u.email}
                  </option>
                ))}
              </select>
            ) : (
              <input
                className={`${inputClass} w-52`}
                value={actorIdFilter}
                onChange={(e) => {
                  setActorIdFilter(e.target.value)
                  setPage(1)
                }}
                placeholder="UUID المشرف"
              />
            )}
          </div>
          <div>
            <label className="mb-1 block text-xs text-text-secondary">من تاريخ</label>
            <input
              type="date"
              className={inputClass}
              value={dateFrom}
              onChange={(e) => {
                setDateFrom(e.target.value)
                setPage(1)
              }}
            />
          </div>
          <div>
            <label className="mb-1 block text-xs text-text-secondary">إلى تاريخ</label>
            <input
              type="date"
              className={inputClass}
              value={dateTo}
              onChange={(e) => {
                setDateTo(e.target.value)
                setPage(1)
              }}
            />
          </div>
          <Button
            type="button"
            variant="outline"
            size="sm"
            onClick={() => {
              setActionFilter('')
              setEntityTypeFilter('')
              setActorIdFilter('')
              setDateFrom('')
              setDateTo('')
              setPage(1)
            }}
          >
            مسح
          </Button>
        </div>
      </Card>
      <Card>
        <CardHeader title="سجلات التدقيق" description={`إجمالي: ${total}`} />
        <div className="overflow-x-auto rounded-b-card">
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
                  <TableHead>الوقت</TableHead>
                  <TableHead>من</TableHead>
                  <TableHead>الإجراء</TableHead>
                  <TableHead>الكيان</TableHead>
                  <TableHead>معرف الكيان</TableHead>
                  <TableHead>تفاصيل</TableHead>
                  <TableHead>IP</TableHead>
                  <TableHead>السبب</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {items.map((log) => (
                  <TableRow key={log.id}>
                    <TableCell className="whitespace-nowrap text-text-secondary text-sm">
                      {log.createdAt
                        ? format(new Date(log.createdAt), 'yyyy/MM/dd HH:mm:ss', { locale: ar })
                        : '-'}
                    </TableCell>
                    <TableCell className="max-w-[180px]">
                      <div className="font-medium text-text-primary text-sm">
                        {log.actorName ?? '—'}
                      </div>
                      <div className="truncate text-xs text-text-secondary">{log.actorEmail ?? log.actorId}</div>
                    </TableCell>
                    <TableCell className="font-semibold text-text-primary text-sm">{log.action}</TableCell>
                    <TableCell className="text-text-secondary text-sm">{log.entityType}</TableCell>
                    <TableCell className="max-w-[120px] truncate font-mono text-xs" title={log.entityId}>
                      {log.entityId}
                    </TableCell>
                    <TableCell
                      className="max-w-[200px] font-mono text-xs text-text-secondary"
                      title={JSON.stringify({ old: log.oldValue, new: log.newValue })}
                    >
                      {jsonPreview(log.newValue ?? log.oldValue)}
                    </TableCell>
                    <TableCell className="whitespace-nowrap font-mono text-xs text-text-secondary">
                      {log.ip ?? '-'}
                    </TableCell>
                    <TableCell className="max-w-xs truncate text-sm text-text-secondary">
                      {log.reason ?? '-'}
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
