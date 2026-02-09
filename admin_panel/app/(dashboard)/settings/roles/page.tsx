import Link from 'next/link'
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

export default function RolesPage() {
  const roles = [
    { id: 'r1', name: 'Super Admin', description: 'صلاحيات كاملة', users: 1 },
    { id: 'r2', name: 'Ops', description: 'الموافقات والمراقبة', users: 3 },
    { id: 'r3', name: 'Finance', description: 'المدفوعات والمصالحة', users: 2 },
    { id: 'r4', name: 'Support', description: 'الشكاوى والدعم', users: 4 },
  ]

  return (
    <>
      <PageHeader
        title="الأدوار والصلاحيات"
        description="إدارة أدوار الأدمن (Super Admin / Ops / Finance / Support / Quality)"
        children={
          <Link href="/settings">
            <Button variant="outline" size="sm">العودة للإعدادات</Button>
          </Link>
        }
      />
      <Card>
        <CardHeader
          title="قائمة الأدوار"
          description="الأدوار المعرّفة في النظام"
        />
        <div className="overflow-hidden rounded-b-card">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>الدور</TableHead>
              <TableHead>الوصف</TableHead>
              <TableHead>عدد المستخدمين</TableHead>
              <TableHead></TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {roles.map((r) => (
              <TableRow key={r.id}>
                <TableCell className="font-semibold text-text-primary">{r.name}</TableCell>
                <TableCell className="text-text-secondary">{r.description}</TableCell>
                <TableCell>{r.users}</TableCell>
                <TableCell><Button variant="ghost" size="sm">تعديل الصلاحيات</Button></TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
        </div>
      </Card>
    </>
  )
}
