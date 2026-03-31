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
  adminMe,
  fetchAdminUsers,
  fetchAdminRoles,
  createAdminUser,
  updateAdminUser,
  resetAdminUserPassword,
  type AdminTeamUser,
} from '@/lib/api/client'
import { format } from 'date-fns'
import { ar } from 'date-fns/locale'

const inputClass =
  'w-full rounded-card border border-border-default bg-surface-default px-3 py-2 text-text-primary placeholder:text-text-muted focus:outline-none focus:ring-2 focus:ring-primary'

export default function TeamPage() {
  const { data: me } = useSWR('admin-me', adminMe)
  const {
    data: usersData,
    error: usersError,
    isLoading: usersLoading,
    mutate: mutateUsers,
  } = useSWR(me?.role === 'super_admin' ? '/admin/users' : null, fetchAdminUsers)
  const { data: rolesData } = useSWR(
    me?.role === 'super_admin' ? '/admin/users/roles' : null,
    fetchAdminRoles,
  )

  const [formEmail, setFormEmail] = useState('')
  const [formName, setFormName] = useState('')
  const [formPassword, setFormPassword] = useState('')
  const [formRoleSlug, setFormRoleSlug] = useState('ops')
  const [createBusy, setCreateBusy] = useState(false)
  const [createErr, setCreateErr] = useState<string | null>(null)

  const [resetUserId, setResetUserId] = useState<string | null>(null)
  const [resetPassword, setResetPassword] = useState('')
  const [resetBusy, setResetBusy] = useState(false)
  const [resetErr, setResetErr] = useState<string | null>(null)

  if (me && me.role !== 'super_admin') {
    return (
      <>
        <PageHeader
          title="فريق الإدارة"
          description="هذه الصفحة متاحة لـ Super Admin فقط."
        />
        <div className="rounded-card border border-divider bg-surface-default px-4 py-3 text-text-secondary">
          ليس لديك صلاحية إدارة حسابات المشرفين. راجع المسؤول الأعلى للنظام.
        </div>
      </>
    )
  }

  const users = (usersData?.items ?? []) as AdminTeamUser[]
  const roles = rolesData?.roles ?? []

  const handleCreate = async (e: React.FormEvent) => {
    e.preventDefault()
    setCreateErr(null)
    setCreateBusy(true)
    try {
      await createAdminUser({
        email: formEmail.trim(),
        name: formName.trim(),
        password: formPassword,
        roleSlug: formRoleSlug,
      })
      setFormEmail('')
      setFormName('')
      setFormPassword('')
      setFormRoleSlug('ops')
      await mutateUsers()
    } catch (err) {
      setCreateErr(err instanceof Error ? err.message : 'فشل الإنشاء')
    } finally {
      setCreateBusy(false)
    }
  }

  const toggleActive = async (u: AdminTeamUser) => {
    try {
      await updateAdminUser(u.id, { isActive: !u.isActive })
      await mutateUsers()
    } catch {
      /* toast optional */
    }
  }

  const changeRole = async (u: AdminTeamUser, roleSlug: string) => {
    try {
      await updateAdminUser(u.id, { roleSlug })
      await mutateUsers()
    } catch {
      /* */
    }
  }

  const submitReset = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!resetUserId) return
    setResetErr(null)
    setResetBusy(true)
    try {
      await resetAdminUserPassword(resetUserId, resetPassword)
      setResetUserId(null)
      setResetPassword('')
      await mutateUsers()
    } catch (err) {
      setResetErr(err instanceof Error ? err.message : 'فشل تغيير كلمة المرور')
    } finally {
      setResetBusy(false)
    }
  }

  if (usersError) {
    return (
      <>
        <PageHeader title="فريق الإدارة" description="إدارة حسابات المشرفين والأدوار" />
        <div className="rounded-card border border-error/30 bg-error/10 px-4 py-3 text-text-primary">
          فشل تحميل البيانات: {usersError.message}
        </div>
      </>
    )
  }

  return (
    <>
      <PageHeader
        title="فريق الإدارة"
        description="إضافة مشرفين، الأدوار، التفعيل/التعطيل، وإعادة تعيين كلمة المرور — يُسجَّل كل ذلك في سجل التدقيق."
      />

      <Card className="mb-6">
        <CardHeader title="مشرف جديد" description="يستلم بريداً وكلمة مرور للدخول إلى لوحة الإدارة" />
        <div className="border-t border-divider px-4 py-4">
          <form onSubmit={handleCreate} className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
            <div className="sm:col-span-2">
              <label className="mb-1 block text-sm font-medium text-text-primary">البريد</label>
              <input
                className={inputClass}
                type="email"
                value={formEmail}
                onChange={(e) => setFormEmail(e.target.value)}
                required
                disabled={createBusy}
              />
            </div>
            <div className="sm:col-span-2">
              <label className="mb-1 block text-sm font-medium text-text-primary">الاسم الظاهر</label>
              <input
                className={inputClass}
                value={formName}
                onChange={(e) => setFormName(e.target.value)}
                required
                minLength={2}
                disabled={createBusy}
              />
            </div>
            <div>
              <label className="mb-1 block text-sm font-medium text-text-primary">كلمة المرور</label>
              <input
                className={inputClass}
                type="password"
                value={formPassword}
                onChange={(e) => setFormPassword(e.target.value)}
                required
                minLength={8}
                disabled={createBusy}
              />
            </div>
            <div>
              <label className="mb-1 block text-sm font-medium text-text-primary">الدور</label>
              <select
                className={inputClass}
                value={formRoleSlug}
                onChange={(e) => setFormRoleSlug(e.target.value)}
                disabled={createBusy}
              >
                {roles.map((r) => (
                  <option key={r.id} value={r.slug}>
                    {r.name} ({r.slug})
                  </option>
                ))}
              </select>
            </div>
            <div className="flex items-end sm:col-span-2 lg:col-span-4">
              <Button type="submit" variant="primary" disabled={createBusy}>
                {createBusy ? 'جاري الإنشاء...' : 'إنشاء الحساب'}
              </Button>
            </div>
          </form>
          {createErr && (
            <p className="mt-3 text-sm text-red-600">{createErr}</p>
          )}
        </div>
      </Card>

      <Card>
        <CardHeader title="المشرفون" description={`العدد: ${users.length}`} />
        <div className="overflow-hidden rounded-b-card">
          {usersLoading ? (
            <div className="flex h-48 items-center justify-center text-text-secondary">جاري التحميل...</div>
          ) : users.length === 0 ? (
            <EmptyState title="لا مستخدمين" description="أنشئ أول مشرف من النموذج أعلاه" />
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>الاسم</TableHead>
                  <TableHead>البريد</TableHead>
                  <TableHead>الدور</TableHead>
                  <TableHead>الحالة</TableHead>
                  <TableHead>أنشئ في</TableHead>
                  <TableHead></TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {users.map((u) => (
                  <TableRow key={u.id}>
                    <TableCell className="font-semibold text-text-primary">{u.name}</TableCell>
                    <TableCell>{u.email}</TableCell>
                    <TableCell>
                      <select
                        className={`${inputClass} max-w-[200px] text-sm py-1.5`}
                        value={u.role.slug}
                        onChange={(e) => changeRole(u, e.target.value)}
                      >
                        {roles.map((r) => (
                          <option key={r.id} value={r.slug}>
                            {r.name}
                          </option>
                        ))}
                      </select>
                    </TableCell>
                    <TableCell>
                      <Badge variant={u.isActive ? 'success' : 'default'}>
                        {u.isActive ? 'نشط' : 'موقوف'}
                      </Badge>
                    </TableCell>
                    <TableCell className="text-text-secondary text-sm">
                      {u.createdAt
                        ? format(new Date(u.createdAt), 'yyyy/MM/dd', { locale: ar })
                        : '-'}
                    </TableCell>
                    <TableCell className="flex flex-wrap gap-2">
                      <Button
                        type="button"
                        variant="outline"
                        size="sm"
                        onClick={() => toggleActive(u)}
                      >
                        {u.isActive ? 'تعطيل' : 'تفعيل'}
                      </Button>
                      <Button
                        type="button"
                        variant="ghost"
                        size="sm"
                        onClick={() => {
                          setResetUserId(u.id)
                          setResetPassword('')
                          setResetErr(null)
                        }}
                      >
                        كلمة مرور
                      </Button>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          )}
        </div>
      </Card>

      {resetUserId && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4"
          role="dialog"
          aria-modal="true"
        >
          <Card className="w-full max-w-md shadow-card-hover">
            <CardHeader title="إعادة تعيين كلمة المرور" description="يُسجَّل الإجراء في سجل التدقيق" />
            <form onSubmit={submitReset} className="space-y-4 border-t border-divider px-4 py-4">
              <div>
                <label className="mb-1 block text-sm font-medium">كلمة المرور الجديدة</label>
                <input
                  className={inputClass}
                  type="password"
                  value={resetPassword}
                  onChange={(e) => setResetPassword(e.target.value)}
                  required
                  minLength={8}
                  disabled={resetBusy}
                />
              </div>
              {resetErr && <p className="text-sm text-red-600">{resetErr}</p>}
              <div className="flex gap-2 justify-end">
                <Button
                  type="button"
                  variant="outline"
                  onClick={() => setResetUserId(null)}
                  disabled={resetBusy}
                >
                  إلغاء
                </Button>
                <Button type="submit" variant="primary" disabled={resetBusy}>
                  {resetBusy ? '...' : 'حفظ'}
                </Button>
              </div>
            </form>
          </Card>
        </div>
      )}
    </>
  )
}
