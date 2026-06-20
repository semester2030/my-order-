'use client'

import { useStrategyStore } from '@/lib/store'
import { computeGrowth, growthChartData } from '@/lib/engines/growth'
import { computeFinancial } from '@/lib/engines/financial'
import { computeTrustScore } from '@/lib/engines/trust'
import { analyzeRisk } from '@/lib/engines/risk'
import { launchPhaseTotals } from '@/lib/engines/launch'
import { compareScenarios } from '@/lib/engines/scenarios'
import { KpiCard } from '@/components/ui/GlassCard'
import { SectionHeader } from '@/components/ui/Badge'
import { formatCurrency, formatPercent } from '@/lib/utils'
import {
  AreaChart,
  Area,
  XAxis,
  YAxis,
  Tooltip,
  ResponsiveContainer,
  CartesianGrid,
} from 'recharts'

export function OverviewPanel() {
  const { growth, financial, trust, risk, launchPhases, scenarios, activeScenario } =
    useStrategyStore()
  const g = computeGrowth(growth)
  const fin = computeFinancial(financial, growth)
  const trustScore = computeTrustScore(trust)
  const riskAnalysis = analyzeRisk(risk)
  const launchTotals = launchPhaseTotals(launchPhases)
  const scenarioCompare = compareScenarios(growth, scenarios)
  const activeScenarioData = scenarioCompare.find((s) => s.scenario === activeScenario)
  const chartData = growthChartData(growth, 12)

  return (
    <div>
      <SectionHeader
        title="Executive Overview"
        titleAr="نظرة عامة تنفيذية"
        description="مركز القيادة الاستراتيجي — جميع المؤشرات تتحدث فوراً عند تعديل الافتراضات"
      />

      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
        <KpiCard labelAr="GMV سنوي" value={formatCurrency(g.annualGmv, true)} accent />
        <KpiCard labelAr="إيرادات الشركة" value={formatCurrency(g.companyRevenue * 12, true)} />
        <KpiCard labelAr="درجة الثقة" value={`${trustScore}/100`} trend={trustScore >= 80 ? 'up' : 'neutral'} />
        <KpiCard
          labelAr="Runway"
          value={`${fin.runwayMonths} شهر`}
          sub={`Burn: ${formatCurrency(fin.netBurn, true)}/mo`}
          trend={fin.runwayMonths > 12 ? 'up' : 'down'}
        />
      </div>

      <div className="grid lg:grid-cols-3 gap-4 mb-6">
        <KpiCard labelAr="مزودين مستهدفين" value={String(launchTotals.providers)} sub="Year 1 total" />
        <KpiCard labelAr="عملاء مستهدفين" value={String(launchTotals.customers)} />
        <KpiCard labelAr="طلبات مستهدفة" value={String(launchTotals.orders)} />
      </div>

      <div className="glass-card p-6 mb-6">
        <h3 className="text-sm font-semibold text-ink mb-4">توقعات النمو — 12 شهر</h3>
        <ResponsiveContainer width="100%" height={280}>
          <AreaChart data={chartData}>
            <defs>
              <linearGradient id="gmvGrad" x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%" stopColor="#FF6A33" stopOpacity={0.3} />
                <stop offset="100%" stopColor="#FF6A33" stopOpacity={0} />
              </linearGradient>
            </defs>
            <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
            <XAxis dataKey="month" tick={{ fontSize: 12 }} />
            <YAxis tick={{ fontSize: 12 }} tickFormatter={(v) => `${(v / 1000).toFixed(0)}K`} />
            <Tooltip formatter={(v: number) => formatCurrency(v)} />
            <Area type="monotone" dataKey="gmv" stroke="#FF6A33" fill="url(#gmvGrad)" strokeWidth={2} />
            <Area type="monotone" dataKey="revenue" stroke="#1A1A1A" fill="transparent" strokeWidth={1.5} strokeDasharray="4 4" />
          </AreaChart>
        </ResponsiveContainer>
      </div>

      <div className="grid lg:grid-cols-2 gap-4">
        <div className="glass-card p-5">
          <h3 className="text-sm font-semibold mb-3">السيناريو النشط: {activeScenarioData?.label}</h3>
          <div className="space-y-2 text-sm">
            <div className="flex justify-between"><span className="text-ink-muted">GMV سنوي</span><span>{formatCurrency(activeScenarioData?.annualGmv || 0, true)}</span></div>
            <div className="flex justify-between"><span className="text-ink-muted">إيرادات</span><span>{formatCurrency(activeScenarioData?.companyRevenue || 0, true)}</span></div>
            <div className="flex justify-between"><span className="text-ink-muted">هامش صافي</span><span>{formatPercent(activeScenarioData?.netMargin || 0)}</span></div>
          </div>
        </div>
        <div className="glass-card p-5">
          <h3 className="text-sm font-semibold mb-3">المخاطر التشغيلية</h3>
          <div className="flex items-center gap-4">
            <div className="text-3xl font-bold text-brand">{riskAnalysis.overallScore}</div>
            <div className="text-sm text-ink-muted">درجة المخاطر من 100 — كلما انخفضت كان أفضل</div>
          </div>
        </div>
      </div>
    </div>
  )
}
