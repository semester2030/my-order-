import { PageHeader } from '@/components/ui/PageHeader'
import { Card, CardHeader, CardBody } from '@/components/ui/Card'
import { StatCard } from '@/components/ui/StatCard'
import { Badge } from '@/components/ui/Badge'
import { Activity, Database, Clock, Zap } from 'lucide-react'

export default function MonitoringPage() {
  return (
    <>
      <PageHeader
        title="المراقبة"
        description="صحة الخدمات، الأداء، التنبيهات"
      />
      <div className="mb-6 grid gap-5 sm:grid-cols-2 lg:grid-cols-4">
        <StatCard title="حالة API" value="يعمل" subtitle="Backend" icon={Activity} />
        <StatCard title="قاعدة البيانات" value="يعمل" subtitle="متصل" icon={Database} />
        <StatCard title="وقت الاستجابة" value="٨٥ ms" subtitle="متوسط" icon={Clock} />
        <StatCard title="الطلبات/دقيقة" value="١٢٤" icon={Zap} />
      </div>
      <div className="grid gap-6 lg:grid-cols-2 transition-smooth">
        <Card>
          <CardHeader
            title="حالة الخدمات"
            description="الخدمات الأساسية"
          />
          <CardBody>
            <ul className="space-y-2 text-sm">
              {['API الرئيسي', 'قاعدة البيانات', 'المصادقة', 'الإشعارات'].map((s) => (
                <li
                  key={s}
                  className="flex items-center justify-between rounded-button border border-divider bg-surface px-4 py-3 transition-smooth hover:bg-primary-container/30 hover:border-primary/20"
                >
                  <span className="font-medium text-text-primary">{s}</span>
                  <Badge variant="success">يعمل</Badge>
                </li>
              ))}
            </ul>
          </CardBody>
        </Card>
        <Card>
          <CardHeader
            title="التنبيهات النشطة"
            description="آخر ٢٤ ساعة"
          />
          <CardBody>
            <p className="text-sm text-text-secondary">لا توجد تنبيهات نشطة.</p>
          </CardBody>
        </Card>
      </div>
    </>
  )
}
