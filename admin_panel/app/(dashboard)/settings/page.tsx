import Link from 'next/link'
import { PageHeader } from '@/components/ui/PageHeader'
import { Card, CardHeader, CardBody } from '@/components/ui/Card'
import { Button } from '@/components/ui/Button'

export default function SettingsPage() {
  return (
    <>
      <PageHeader
        title="الإعدادات"
        description="إعدادات عامة المنصة — ساعات، مناطق، رسوم"
      />
      <div className="space-y-6 transition-smooth">
        <Card>
          <CardHeader
            title="عام"
            description="ساعات العمل، المناطق، العملة"
          />
          <CardBody>
            <p className="text-sm text-text-secondary leading-relaxed mb-4">
              تعديل ساعات العمل والمناطق الجغرافية والعملة من هنا.
            </p>
            <Button variant="outline" size="sm">تعديل</Button>
          </CardBody>
        </Card>
        <Card>
          <CardHeader
            title="الرسوم والعمولات"
            description="نسب العمولة والرسوم"
          />
          <CardBody>
            <p className="text-sm text-text-secondary leading-relaxed mb-4">
              تعيين نسب العمولة للمطاعم والسائقين ورسوم التوصيل.
            </p>
            <Button variant="outline" size="sm">تعديل</Button>
          </CardBody>
        </Card>
        <Card>
          <CardHeader
            title="الأدوار والصلاحيات"
            description="إدارة أدوار الأدمن"
          />
          <CardBody>
            <p className="text-sm text-text-secondary leading-relaxed mb-4">
              Super Admin، Ops، Finance، Support، Quality.
            </p>
            <Link href="/settings/roles">
              <Button variant="outline" size="sm">إدارة الأدوار</Button>
            </Link>
          </CardBody>
        </Card>
      </div>
    </>
  )
}
