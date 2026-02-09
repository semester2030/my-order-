import Link from 'next/link'
import { PageHeader } from '@/components/ui/PageHeader'
import { Card, CardHeader, CardBody } from '@/components/ui/Card'
import { Badge } from '@/components/ui/Badge'
import { Button } from '@/components/ui/Button'

export default function DisputeDetailPage({ params }: { params: { id: string } }) {
  return (
    <>
      <PageHeader
        title={`الشكوى #${params.id}`}
        description="تفاصيل الشكوى واتخاذ القرار"
        children={
          <Link href="/disputes">
            <Button variant="outline" size="sm">العودة للقائمة</Button>
          </Link>
        }
      />
      <div className="grid gap-6 lg:grid-cols-2 transition-smooth">
        <Card>
          <CardHeader title="تفاصيل الشكوى" />
          <CardBody>
            <dl className="space-y-3 text-sm">
              <div className="flex justify-between items-center py-1 border-b border-divider">
                <dt className="text-text-secondary font-medium">الطلب</dt>
                <dd className="font-semibold text-text-primary">#1020</dd>
              </div>
              <div className="flex justify-between items-center py-1 border-b border-divider">
                <dt className="text-text-secondary font-medium">النوع</dt>
                <dd className="text-text-primary">تأخير</dd>
              </div>
              <div className="flex justify-between items-center py-1 border-b border-divider">
                <dt className="text-text-secondary font-medium">الحالة</dt>
                <dd><Badge variant="danger">مفتوح</Badge></dd>
              </div>
              <div className="flex justify-between items-center py-1">
                <dt className="text-text-secondary font-medium">التاريخ</dt>
                <dd className="text-text-primary">٢٧ يناير ٢٠٢٥</dd>
              </div>
            </dl>
          </CardBody>
        </Card>
        <Card>
          <CardHeader title="إجراءات" />
          <CardBody>
            <div className="flex flex-wrap gap-2">
              <Button variant="primary" size="sm">قبول الشكوى</Button>
              <Button variant="outline" size="sm">رفض</Button>
              <Button variant="secondary" size="sm">طلب معلومات إضافية</Button>
            </div>
          </CardBody>
        </Card>
      </div>
    </>
  )
}
