'use client'

import { useStrategyStore } from '@/lib/store'
import { compareScenarios, scenarioMonthlyProjection } from '@/lib/engines/scenarios'
import type { ScenarioType } from '@/lib/types'
import { GlassCard, KpiCard } from '@/components/ui/GlassCard'
import { EditableNumber } from '@/components/ui/EditableField'
import { SectionHeader, Badge } from '@/components/ui/Badge'
import { formatCurrency, formatPercent } from '@/lib/utils'
import { cn } from '@/lib/utils'
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  Tooltip,
  ResponsiveContainer,
  CartesianGrid,
  BarChart,
  Bar,
  Legend,
} from 'recharts'

const SCENARIO_LABELS: Record<ScenarioType, { en: string; ar: string }> = {
  conservative: { en: 'Conservative', ar: 'محافظ' },
  realistic: { en: 'Realistic', ar: 'واقعي' },
  aggressive: { en: 'Aggressive', ar: 'عدواني' },
}

export function ScenarioEnginePanel() {
  const { scenarios, growth, activeScenario, setActiveScenario, updateScenario } = useStrategyStore()
  const comparison = compareScenarios(growth, scenarios)

  const projectionData = Array.from({ length: 12 }, (_, i) => {
    const row: Record<string, string | number> = { month: `M${i + 1}` }
    ;(['conservative', 'realistic', 'aggressive'] as ScenarioType[]).forEach((key) => {
      const proj = scenarioMonthlyProjection(growth, scenarios[key], 12)
      row[key] = proj[i].gmv
    })
    return row
  })

  return (
    <div>
      <SectionHeader
        title="Scenario Engine"
        titleAr="محرك السيناريوهات"
        description="3 سيناريوهات كاملة — محافظ، واقعي، عدواني"
      />

      <div className="flex gap-2 mb-6">
        {(['conservative', 'realistic', 'aggressive'] as ScenarioType[]).map((key) => (
          <button
            key={key}
            onClick={() => setActiveScenario(key)}
            className={cn(
              'px-4 py-2 rounded-xl text-sm font-medium transition-all',
              activeScenario === key
                ? 'bg-brand text-white shadow-glow'
                : 'bg-white border border-gray-200 text-ink-muted hover:border-brand/30',
            )}
          >
            {SCENARIO_LABELS[key].ar}
          </button>
        ))}
      </div>

      <div className="grid md:grid-cols-3 gap-4 mb-6">
        {comparison.map((s) => (
          <KpiCard
            key={s.scenario}
            labelAr={SCENARIO_LABELS[s.scenario as ScenarioType].ar}
            value={formatCurrency(s.annualGmv, true)}
            sub={`Revenue: ${formatCurrency(s.companyRevenue, true)} | Margin: ${formatPercent(s.netMargin)}`}
            accent={s.scenario === activeScenario}
          />
        ))}
      </div>

      <div className="glass-card p-6 mb-6">
        <ResponsiveContainer width="100%" height={300}>
          <LineChart data={projectionData}>
            <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
            <XAxis dataKey="month" />
            <YAxis tickFormatter={(v) => `${(v / 1000).toFixed(0)}K`} />
            <Tooltip formatter={(v: number) => formatCurrency(v)} />
            <Legend />
            <Line type="monotone" dataKey="conservative" stroke="#3498DB" strokeWidth={2} dot={false} name="محافظ" />
            <Line type="monotone" dataKey="realistic" stroke="#FF6A33" strokeWidth={2} dot={false} name="واقعي" />
            <Line type="monotone" dataKey="aggressive" stroke="#E74C3C" strokeWidth={2} dot={false} name="عدواني" />
          </LineChart>
        </ResponsiveContainer>
      </div>

      <div className="space-y-6">
        {(['conservative', 'realistic', 'aggressive'] as ScenarioType[]).map((key) => (
          <GlassCard key={key} className={cn(activeScenario !== key && 'opacity-70')}>
            <div className="flex items-center gap-2 mb-4">
              <h3 className="font-semibold">{SCENARIO_LABELS[key].ar}</h3>
              <Badge variant="brand">{SCENARIO_LABELS[key].en}</Badge>
            </div>
            <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-4">
              <EditableNumber labelAr="مضاعف النمو" label="" value={scenarios[key].growthMultiplier} onChange={(v) => updateScenario(key, { growthMultiplier: v })} min={0.3} max={3} step={0.1} suffix="x" />
              <EditableNumber labelAr="مضاعف CAC" label="" value={scenarios[key].cacMultiplier} onChange={(v) => updateScenario(key, { cacMultiplier: v })} min={0.5} max={2} step={0.1} suffix="x" />
              <EditableNumber labelAr="مضاعف احتفاظ" label="" value={scenarios[key].retentionMultiplier} onChange={(v) => updateScenario(key, { retentionMultiplier: v })} min={0.5} max={1.5} step={0.05} suffix="x" />
              <EditableNumber labelAr="عمولة %" label="" value={scenarios[key].commissionRate} onChange={(v) => updateScenario(key, { commissionRate: v })} min={5} max={25} suffix="%" />
              <EditableNumber labelAr="متوسط الطلب" label="" value={scenarios[key].avgOrderValue} onChange={(v) => updateScenario(key, { avgOrderValue: v })} min={100} max={800} />
              <EditableNumber labelAr="نمو مزودين %" label="" value={scenarios[key].providerGrowthRate} onChange={(v) => updateScenario(key, { providerGrowthRate: v })} min={0} max={50} suffix="%" />
              <EditableNumber labelAr="نمو عملاء %" label="" value={scenarios[key].customerGrowthRate} onChange={(v) => updateScenario(key, { customerGrowthRate: v })} min={0} max={60} suffix="%" />
            </div>
          </GlassCard>
        ))}
      </div>
    </div>
  )
}
