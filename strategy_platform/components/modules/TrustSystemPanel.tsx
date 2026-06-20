'use client'

import { useStrategyStore } from '@/lib/store'
import { computeTrustScore, trustBreakdown } from '@/lib/engines/trust'
import { GlassCard, KpiCard } from '@/components/ui/GlassCard'
import { EditableNumber } from '@/components/ui/EditableField'
import { SectionHeader, ScoreRing } from '@/components/ui/Badge'
import { formatPercent } from '@/lib/utils'
import {
  RadarChart,
  PolarGrid,
  PolarAngleAxis,
  Radar,
  ResponsiveContainer,
} from 'recharts'

export function TrustSystemPanel() {
  const { trust, updateTrust } = useStrategyStore()
  const score = computeTrustScore(trust)
  const breakdown = trustBreakdown(trust)

  return (
    <div>
      <SectionHeader
        title="Trust System Model"
        titleAr="نظام الثقة"
        description="تتبع التقييمات والنزاعات والإكمال — درجة الثقة تتحدث لحظياً"
      />

      <div className="grid lg:grid-cols-3 gap-6 mb-6">
        <GlassCard className="flex flex-col items-center justify-center relative">
          <ScoreRing score={score} label="Trust Score" />
        </GlassCard>
        <div className="lg:col-span-2 glass-card p-6">
          <ResponsiveContainer width="100%" height={250}>
            <RadarChart data={breakdown}>
              <PolarGrid stroke="#e5e7eb" />
              <PolarAngleAxis dataKey="name" tick={{ fontSize: 11 }} />
              <Radar dataKey="value" stroke="#FF6A33" fill="#FF6A33" fillOpacity={0.25} />
            </RadarChart>
          </ResponsiveContainer>
        </div>
      </div>

      <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-4">
        <EditableNumber labelAr="تقييم المزود" label="Rating" value={trust.providerRating} onChange={(v) => updateTrust({ providerRating: v })} min={1} max={5} step={0.1} />
        <EditableNumber labelAr="نسبة النزاعات" label="Disputes" value={trust.disputeRate} onChange={(v) => updateTrust({ disputeRate: v })} min={0} max={20} suffix="%" />
        <EditableNumber labelAr="نسبة الإكمال" label="Completion" value={trust.completionRate} onChange={(v) => updateTrust({ completionRate: v })} min={0} max={100} suffix="%" />
        <EditableNumber labelAr="نسبة الإلغاء" label="Cancellation" value={trust.cancellationRate} onChange={(v) => updateTrust({ cancellationRate: v })} min={0} max={30} suffix="%" />
        <EditableNumber labelAr="نسبة الاسترداد" label="Refund" value={trust.refundRate} onChange={(v) => updateTrust({ refundRate: v })} min={0} max={20} suffix="%" />
        <EditableNumber labelAr="شكاوى العملاء" label="Complaints" value={trust.customerComplaints} onChange={(v) => updateTrust({ customerComplaints: v })} min={0} max={20} suffix="%" />
        <EditableNumber labelAr="تدخل الإدارة" label="Admin" value={trust.adminIntervention} onChange={(v) => updateTrust({ adminIntervention: v })} min={0} max={15} suffix="%" />
      </div>
    </div>
  )
}
