'use client'

import { useStrategyStore } from '@/lib/store'
import { launchChartData } from '@/lib/engines/launch'
import { GlassCard } from '@/components/ui/GlassCard'
import { EditableNumber, EditableText } from '@/components/ui/EditableField'
import { SectionHeader, Badge } from '@/components/ui/Badge'
import { formatCurrency, formatPercent } from '@/lib/utils'
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  Tooltip,
  ResponsiveContainer,
  Legend,
  CartesianGrid,
} from 'recharts'

export function LaunchStrategyPanel() {
  const { launchPhases, updateLaunchPhase } = useStrategyStore()
  const chartData = launchChartData(launchPhases)

  return (
    <div>
      <SectionHeader
        title="Launch Strategy Engine"
        titleAr="محرك استراتيجية الإطلاق"
        description="4 مراحل إطلاق — عدّل الأهداف وشاهد التأثير على GMV والعمولة والميزانية"
      />

      <div className="glass-card p-6 mb-6">
        <ResponsiveContainer width="100%" height={300}>
          <BarChart data={chartData}>
            <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
            <XAxis dataKey="phase" />
            <YAxis tickFormatter={(v) => `${(v / 1000).toFixed(0)}K`} />
            <Tooltip formatter={(v: number) => formatCurrency(v)} />
            <Legend />
            <Bar dataKey="gmv" fill="#FF6A33" name="GMV" radius={[4, 4, 0, 0]} />
            <Bar dataKey="commission" fill="#1A1A1A" name="Commission" radius={[4, 4, 0, 0]} />
          </BarChart>
        </ResponsiveContainer>
      </div>

      <div className="space-y-6">
        {launchPhases.map((phase) => (
          <GlassCard key={phase.id}>
            <div className="flex items-start justify-between mb-4">
              <div>
                <h3 className="font-semibold text-ink">{phase.nameAr}</h3>
                <p className="text-sm text-ink-muted">{phase.name} — {phase.daysRange} days</p>
              </div>
              <Badge variant="brand">{phase.daysRange}</Badge>
            </div>
            <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-4">
              <EditableNumber labelAr="مزودين" label="Providers" value={phase.targetProviders} onChange={(v) => updateLaunchPhase(phase.id, { targetProviders: v })} min={0} max={2000} />
              <EditableNumber labelAr="عملاء" label="Customers" value={phase.targetCustomers} onChange={(v) => updateLaunchPhase(phase.id, { targetCustomers: v })} min={0} max={50000} />
              <EditableNumber labelAr="طلبات" label="Orders" value={phase.targetOrders} onChange={(v) => updateLaunchPhase(phase.id, { targetOrders: v })} min={0} max={20000} />
              <EditableNumber labelAr="GMV متوقع" label="GMV" value={phase.expectedGmv} onChange={(v) => updateLaunchPhase(phase.id, { expectedGmv: v })} min={0} max={5000000} step={1000} prefix="SAR" />
              <EditableNumber labelAr="إيراد عمولة" label="Commission" value={phase.expectedCommissionRevenue} onChange={(v) => updateLaunchPhase(phase.id, { expectedCommissionRevenue: v })} min={0} max={1000000} step={500} />
              <EditableNumber labelAr="ميزانية تسويق" label="Marketing" value={phase.requiredMarketingBudget} onChange={(v) => updateLaunchPhase(phase.id, { requiredMarketingBudget: v })} min={0} max={500000} step={1000} />
              <EditableNumber labelAr="CAC متوقع" label="CAC" value={phase.expectedCac} onChange={(v) => updateLaunchPhase(phase.id, { expectedCac: v })} min={0} max={500} />
              <EditableNumber labelAr="احتفاظ %" label="Retention" value={phase.retentionTarget} onChange={(v) => updateLaunchPhase(phase.id, { retentionTarget: v })} min={0} max={100} suffix="%" />
            </div>
            <div className="grid md:grid-cols-2 gap-4 mt-4">
              <EditableText label="Operational Goals" value={phase.operationalGoals} onChange={(v) => updateLaunchPhase(phase.id, { operationalGoals: v })} multiline />
              <EditableText label="Trust Building Goals" value={phase.trustBuildingGoals} onChange={(v) => updateLaunchPhase(phase.id, { trustBuildingGoals: v })} multiline />
            </div>
          </GlassCard>
        ))}
      </div>
    </div>
  )
}
