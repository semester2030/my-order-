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

export default function ReconciliationPage() {
  const rows = [
    { id: 1, period: 'يناير ٢٠٢٥', vendor: 'مطعم الشرق', amount: '٤٬٢٠٠ ر.س', status: 'مُصالح' },
    { id: 2, period: 'يناير ٢٠٢٥', vendor: 'بيت البيتزا', amount: '٢٬٨٠٠ ر.س', status: 'معلق' },
  ]

  return (
    <>
      <PageHeader
        title="المصالحة"
        description="مصالحة المدفوعات مع المطاعم والسائقين"
        children={
          <Link href="/payments">
            <Button variant="outline" size="sm">العودة للمدفوعات</Button>
          </Link>
        }
      />
      <Card>
        <CardHeader
          title="سجلات المصالحة"
          description="فترات المصالحة والحالة"
        />
        <div className="overflow-hidden rounded-b-card">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>الفترة</TableHead>
              <TableHead>الطرف</TableHead>
              <TableHead>المبلغ</TableHead>
              <TableHead>الحالة</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {rows.map((r) => (
              <TableRow key={r.id}>
                <TableCell className="font-semibold text-text-primary">{r.period}</TableCell>
                <TableCell>{r.vendor}</TableCell>
                <TableCell>{r.amount}</TableCell>
                <TableCell><Badge variant={r.status === 'مُصالح' ? 'success' : 'warning'}>{r.status}</Badge></TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
        </div>
      </Card>
    </>
  )
}
