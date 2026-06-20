'use client'

import { useStrategyStore } from '@/lib/store'
import { analyzeProviderFunnel, providerFunnelSteps } from '@/lib/engines/providers'
import { GlassCard, KpiCard } from '@/components/ui/GlassCard'
import { EditableNumber } from '@/components/ui/EditableField'
import { SectionHeader } from '@/components/ui/Badge'
import { formatCurrency, formatPercent } from '@/lib/utils'
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from 'recharts'

export function ProviderAcquisitionPanel() {
  const { providerSegments, updateProviderSegment } = useStrategyStore()
  const funnelResults = analyzeProviderFunnel(providerSegments)
  const totalActive = funnelResults.reduce((s, r) => s + r.activeProviders, 0)
  const avgChurn = funnelResults.reduce((s, r) => s + r.monthlyChurn, 0) / funnelResults.length

  const churnData = funnelResults.map((r) => ({
    name: r.nameAr,
    churn: r.monthlyChurn,
    retention: r.retentionRate,
  }))

  return (
    <div>
      <SectionHeader
        title="Provider Acquisition System"
        titleAr="نظام اكتساب المزودين"
        description="5 شرائح مزودين — مسار onboarding و approval و quality control"
      />

      <div className="grid grid-cols-2 lg:grid-cols-3 gap-4 mb-6">
        <KpiCard labelAr="مزودين نشطين/شهر" value={String(totalActive)} accent />
        <KpiCard labelAr="متوسط تسرب" value={formatPercent(avgChurn)} />
        <KpiCard labelAr="شرائح" value={String(providerSegments.length)} />
      </div>

      <div className="glass-card p-6 mb-6">
        <h3 className="text-sm font-semibold mb-4">تحليل التسرب vs الاحتفاظ</h3>
        <ResponsiveContainer width="100%" height={250}>
          <BarChart data={churnData}>
            <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
            <XAxis dataKey="name" tick={{ fontSize: 11 }} />
            <YAxis />
            <Tooltip formatter={(v: number) => `${v.toFixed(1)}%`} />
            <Bar dataKey="retention" fill="#27AE60" name="Retention %" radius={[4, 4, 0, 0]} />
            <Bar dataKey="churn" fill="#E74C3C" name="Churn %" radius={[4, 4, 0, 0]} />
          </BarChart>
        </ResponsiveContainer>
      </div>

      <div className="space-y-6">
        {providerSegments.map((seg) => {
          const result = funnelResults.find((r) => r.id === seg.id)!
          const steps = providerFunnelSteps(seg)
          return (
            <GlassCard key={seg.id}>
              <div className="flex justify-between items-start mb-4">
                <div>
                  <h3 className="font-semibold">{seg.nameAr}</h3>
                  <p className="text-sm text-ink-muted">{seg.name}</p>
                </div>
                <div className="text-left">
                  <p className="text-xs text-ink-muted">End-to-end</p>
                  <p className="text-lg font-bold text-brand">{formatPercent(result.endToEndConversion)}</p>
                </div>
              </div>

              <div className="flex gap-2 mb-4 overflow-x-auto pb-2">
                {steps.map((step, i) => (
                  <div key={step.stage} className="flex-1 min-w-[80px] text-center">
                    <div
                      className="h-2 rounded-full mb-1"
                      style={{
                        background: `linear-gradient(90deg, #FF6A33 ${100 - i * 18}%, #FFE5DC)`,
                      }}
                    />
                    <p className="text-xs text-ink-muted">{step.stageAr}</p>
                    <p className="text-sm font-semibold">{Math.round(step.count)}</p>
                  </div>
                ))}
              </div>

              <div className="grid md:grid-cols-3 lg:grid-cols-6 gap-3">
                <EditableNumber labelAr="Lead→Signup" label="" value={seg.leadToSignup} onChange={(v) => updateProviderSegment(seg.id, { leadToSignup: v })} min={0} max={100} suffix="%" />
                <EditableNumber labelAr="Signup→App" label="" value={seg.signupToApplication} onChange={(v) => updateProviderSegment(seg.id, { signupToApplication: v })} min={0} max={100} suffix="%" />
                <EditableNumber labelAr="App→Approve" label="" value={seg.applicationToApproval} onChange={(v) => updateProviderSegment(seg.id, { applicationToApproval: v })} min={0} max={100} suffix="%" />
                <EditableNumber labelAr="Approve→Active" label="" value={seg.approvalToActive} onChange={(v) => updateProviderSegment(seg.id, { approvalToActive: v })} min={0} max={100} suffix="%" />
                <EditableNumber labelAr="تسرب شهري" label="" value={seg.monthlyChurn} onChange={(v) => updateProviderSegment(seg.id, { monthlyChurn: v })} min={0} max={30} suffix="%" />
                <EditableNumber labelAr="تكلفة اكتساب" label="" value={seg.acquisitionCost} onChange={(v) => updateProviderSegment(seg.id, { acquisitionCost: v })} min={0} max={1000} prefix="SAR" />
              </div>
              <p className="text-xs text-ink-muted mt-2">
                نشطين: {result.activeProviders} | تسرب: {result.monthlyChurnCount}/mo | CAC: {formatCurrency(seg.acquisitionCost)}
              </p>
            </GlassCard>
          )
        })}
      </div>
    </div>
  )
}
