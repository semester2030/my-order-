'use client'

import { useStrategyStore } from '@/lib/store'
import { computeGrowth, growthChartData } from '@/lib/engines/growth'
import { KpiCard } from '@/components/ui/GlassCard'
import { EditableNumber } from '@/components/ui/EditableField'
import { SectionHeader } from '@/components/ui/Badge'
import { formatCurrency, formatPercent } from '@/lib/utils'
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  Tooltip,
  ResponsiveContainer,
  CartesianGrid,
  PieChart,
  Pie,
  Cell,
} from 'recharts'

const PIE_COLORS = ['#FF6A33', '#1A1A1A', '#FFD700', '#3498DB']

export function GrowthSimulatorPanel() {
  const { growth, updateGrowth } = useStrategyStore()
  const out = computeGrowth(growth)
  const chartData = growthChartData(growth, 12)

  const pieData = [
    { name: 'Company Revenue', value: out.companyRevenue },
    { name: 'Provider Payouts', value: out.providerPayouts },
    { name: 'Refunds', value: out.monthlyGmv * (growth.refundPercent / 100) },
  ]

  return (
    <div>
      <SectionHeader
        title="Marketplace Growth Simulator"
        titleAr="محاكي نمو السوق"
        description="عدّل افتراضات السوق وشاهد GMV والهوامش والحمل التشغيلي"
      />

      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
        <KpiCard labelAr="GMV يومي" value={formatCurrency(out.dailyGmv, true)} accent />
        <KpiCard labelAr="GMV شهري" value={formatCurrency(out.monthlyGmv, true)} />
        <KpiCard labelAr="GMV سنوي" value={formatCurrency(out.annualGmv, true)} />
        <KpiCard labelAr="إيرادات الشركة" value={formatCurrency(out.companyRevenue, true)} />
        <KpiCard labelAr="هامش إجمالي" value={formatPercent(out.grossMargin)} />
        <KpiCard labelAr="هامش صافي" value={formatPercent(out.netMargin)} />
        <KpiCard labelAr="حمل تشغيلي" value={formatPercent(out.operationalLoad)} trend={out.operationalLoad > 70 ? 'down' : 'up'} />
        <KpiCard labelAr="طلبات متكررة" value={String(Math.round(out.repeatOrders))} />
      </div>

      <div className="grid lg:grid-cols-3 gap-6 mb-6">
        <div className="lg:col-span-2 glass-card p-6">
          <h3 className="text-sm font-semibold mb-4">توقعات GMV & Revenue</h3>
          <ResponsiveContainer width="100%" height={280}>
            <LineChart data={chartData}>
              <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
              <XAxis dataKey="month" />
              <YAxis tickFormatter={(v) => `${(v / 1000).toFixed(0)}K`} />
              <Tooltip formatter={(v: number) => formatCurrency(v)} />
              <Line type="monotone" dataKey="gmv" stroke="#FF6A33" strokeWidth={2} dot={false} />
              <Line type="monotone" dataKey="revenue" stroke="#1A1A1A" strokeWidth={2} dot={false} />
            </LineChart>
          </ResponsiveContainer>
        </div>
        <div className="glass-card p-6">
          <h3 className="text-sm font-semibold mb-4">توزيع الإيرادات</h3>
          <ResponsiveContainer width="100%" height={280}>
            <PieChart>
              <Pie data={pieData} dataKey="value" nameKey="name" cx="50%" cy="50%" innerRadius={60} outerRadius={90}>
                {pieData.map((_, i) => (
                  <Cell key={i} fill={PIE_COLORS[i % PIE_COLORS.length]} />
                ))}
              </Pie>
              <Tooltip formatter={(v: number) => formatCurrency(v)} />
            </PieChart>
          </ResponsiveContainer>
        </div>
      </div>

      <div className="glass-card p-6">
        <h3 className="text-sm font-semibold mb-4">الافتراضات — قابلة للتعديل</h3>
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-4">
          <EditableNumber labelAr="عدد المزودين" label="Providers" value={growth.providers} onChange={(v) => updateGrowth({ providers: v })} min={1} max={2000} />
          <EditableNumber labelAr="طلبات/مزود" label="Orders/Provider" value={growth.avgOrdersPerProvider} onChange={(v) => updateGrowth({ avgOrdersPerProvider: v })} min={1} max={100} />
          <EditableNumber labelAr="متوسط الطلب" label="AOV" value={growth.avgOrderValue} onChange={(v) => updateGrowth({ avgOrderValue: v })} min={50} max={5000} prefix="SAR" />
          <EditableNumber labelAr="عمولة %" label="Commission" value={growth.commissionPercent} onChange={(v) => updateGrowth({ commissionPercent: v })} min={5} max={30} suffix="%" />
          <EditableNumber labelAr="عملاء متكررين %" label="Repeat" value={growth.repeatCustomerPercent} onChange={(v) => updateGrowth({ repeatCustomerPercent: v })} min={0} max={100} suffix="%" />
          <EditableNumber labelAr="استرداد %" label="Refund" value={growth.refundPercent} onChange={(v) => updateGrowth({ refundPercent: v })} min={0} max={20} suffix="%" />
          <EditableNumber labelAr="تسرب مزودين %" label="Provider Churn" value={growth.providerChurnPercent} onChange={(v) => updateGrowth({ providerChurnPercent: v })} min={0} max={50} suffix="%" />
          <EditableNumber labelAr="تسرب عملاء %" label="Customer Churn" value={growth.customerChurnPercent} onChange={(v) => updateGrowth({ customerChurnPercent: v })} min={0} max={50} suffix="%" />
          <EditableNumber labelAr="نزاعات %" label="Disputes" value={growth.disputePercent} onChange={(v) => updateGrowth({ disputePercent: v })} min={0} max={20} suffix="%" />
        </div>
      </div>
    </div>
  )
}
