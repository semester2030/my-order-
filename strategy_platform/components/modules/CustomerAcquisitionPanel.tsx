'use client'

import { useStrategyStore } from '@/lib/store'
import { analyzeChannels } from '@/lib/engines/acquisition'
import { GlassCard, KpiCard } from '@/components/ui/GlassCard'
import { EditableNumber } from '@/components/ui/EditableField'
import { SectionHeader, Badge } from '@/components/ui/Badge'
import { formatCurrency, formatPercent } from '@/lib/utils'
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  Tooltip,
  ResponsiveContainer,
  CartesianGrid,
  Cell,
} from 'recharts'

export function CustomerAcquisitionPanel() {
  const { customerChannels, updateCustomerChannel } = useStrategyStore()
  const { analyzed, bestChannel, cheapestChannel, highestLtvChannel, totalBudget, totalCustomers, blendedCac } =
    analyzeChannels(customerChannels)

  const chartData = analyzed.map((c) => ({
    name: c.nameAr,
    cac: c.cac,
    customers: c.customersAcquired,
    roi: c.roi,
  }))

  return (
    <div>
      <SectionHeader
        title="Customer Acquisition System"
        titleAr="نظام اكتساب العملاء"
        description="9 قنوات تسويق — قارن CAC و ROI و LTV لكل قناة"
      />

      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
        <KpiCard labelAr="إجمالي الميزانية" value={formatCurrency(totalBudget, true)} accent />
        <KpiCard labelAr="عملاء متوقعين" value={String(totalCustomers)} />
        <KpiCard labelAr="CAC مدمج" value={formatCurrency(blendedCac)} />
        <KpiCard labelAr="أفضل قناة" value={bestChannel?.nameAr || '—'} sub={`ROI ${bestChannel?.roi}x`} />
      </div>

      <div className="grid lg:grid-cols-3 gap-4 mb-6">
        <GlassCard>
          <Badge variant="brand">Best Channel</Badge>
          <p className="text-lg font-semibold mt-2">{bestChannel?.nameAr}</p>
          <p className="text-sm text-ink-muted">Score: {bestChannel?.score.toFixed(2)}</p>
        </GlassCard>
        <GlassCard>
          <Badge variant="low">Cheapest CAC</Badge>
          <p className="text-lg font-semibold mt-2">{cheapestChannel?.nameAr}</p>
          <p className="text-sm text-ink-muted">CAC: {formatCurrency(cheapestChannel?.cac || 0)}</p>
        </GlassCard>
        <GlassCard>
          <Badge variant="medium">Highest LTV</Badge>
          <p className="text-lg font-semibold mt-2">{highestLtvChannel?.nameAr}</p>
          <p className="text-sm text-ink-muted">LTV: {formatCurrency(highestLtvChannel?.effectiveLtv || 0)}</p>
        </GlassCard>
      </div>

      <div className="glass-card p-6 mb-6">
        <ResponsiveContainer width="100%" height={280}>
          <BarChart data={chartData} layout="vertical">
            <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
            <XAxis type="number" />
            <YAxis type="category" dataKey="name" width={100} tick={{ fontSize: 11 }} />
            <Tooltip />
            <Bar dataKey="customers" fill="#FF6A33" name="Customers" radius={[0, 4, 4, 0]} />
          </BarChart>
        </ResponsiveContainer>
      </div>

      <div className="space-y-4">
        {customerChannels.map((ch) => (
          <GlassCard key={ch.id}>
            <h3 className="font-semibold mb-3">{ch.nameAr} <span className="text-ink-muted font-normal text-sm">({ch.name})</span></h3>
            <div className="grid md:grid-cols-3 lg:grid-cols-5 gap-4">
              <EditableNumber labelAr="CAC" label="CAC" value={ch.cac} onChange={(v) => updateCustomerChannel(ch.id, { cac: v })} min={5} max={200} prefix="SAR" />
              <EditableNumber labelAr="ميزانية" label="Budget" value={ch.budget} onChange={(v) => updateCustomerChannel(ch.id, { budget: v })} min={0} max={100000} step={500} />
              <EditableNumber labelAr="تحويل %" label="Conversion" value={ch.conversionRate} onChange={(v) => updateCustomerChannel(ch.id, { conversionRate: v })} min={0} max={30} suffix="%" />
              <EditableNumber labelAr="جودة احتفاظ" label="Retention Q" value={ch.retentionQuality} onChange={(v) => updateCustomerChannel(ch.id, { retentionQuality: v })} min={0} max={100} suffix="%" />
              <EditableNumber labelAr="ROI" label="ROI" value={ch.roi} onChange={(v) => updateCustomerChannel(ch.id, { roi: v })} min={0} max={10} step={0.1} suffix="x" />
            </div>
            <p className="text-xs text-ink-muted mt-2">
              عملاء متوقعين: {Math.floor(ch.budget / (ch.cac || 1))} | LTV: {formatCurrency(350 * (ch.retentionQuality / 100) * (ch.conversionRate / 5))}
            </p>
          </GlassCard>
        ))}
      </div>
    </div>
  )
}
