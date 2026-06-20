'use client'

import { useStrategyStore } from '@/lib/store'
import { analyzeRisk } from '@/lib/engines/risk'
import { GlassCard, KpiCard } from '@/components/ui/GlassCard'
import { EditableNumber } from '@/components/ui/EditableField'
import { SectionHeader, Badge } from '@/components/ui/Badge'
import { formatPercent } from '@/lib/utils'
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

const SEV_COLORS = { low: '#27AE60', medium: '#F39C12', high: '#FF6A33', critical: '#E74C3C' }

export function OperationalRiskPanel() {
  const { risk, updateRisk } = useStrategyStore()
  const { items, overallScore } = analyzeRisk(risk)

  const chartData = items.map((i) => ({
    name: i.labelAr,
    value: i.value,
    severity: i.severity,
  }))

  return (
    <div>
      <SectionHeader
        title="Operational Risk Engine"
        titleAr="محرك المخاطر التشغيلية"
        description="تتبع 7 أنواع مخاطر مع تصنيف شدة — كلما انخفضت الدرجة كان أفضل"
      />

      <div className="mb-6 max-w-xs">
        <KpiCard labelAr="درجة المخاطر الإجمالية" value={`${overallScore}/100`} accent />
      </div>

      <div className="glass-card p-6 mb-6">
        <ResponsiveContainer width="100%" height={280}>
          <BarChart data={chartData}>
            <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
            <XAxis dataKey="name" tick={{ fontSize: 10 }} />
            <YAxis tickFormatter={(v) => `${v}%`} />
            <Tooltip formatter={(v: number) => `${v}%`} />
            <Bar dataKey="value" radius={[4, 4, 0, 0]}>
              {chartData.map((entry, i) => (
                <Cell key={i} fill={SEV_COLORS[entry.severity as keyof typeof SEV_COLORS]} />
              ))}
            </Bar>
          </BarChart>
        </ResponsiveContainer>
      </div>

      <div className="grid md:grid-cols-2 gap-4">
        {items.map((item) => (
          <GlassCard key={item.key}>
            <div className="flex justify-between items-center mb-3">
              <h3 className="font-medium">{item.labelAr}</h3>
              <Badge variant={item.severity}>{item.severity}</Badge>
            </div>
            <EditableNumber
              labelAr={item.labelAr}
              label={item.label}
              value={risk[item.key]}
              onChange={(v) => updateRisk({ [item.key]: v })}
              min={0}
              max={20}
              step={0.1}
              suffix="%"
            />
          </GlassCard>
        ))}
      </div>
    </div>
  )
}
