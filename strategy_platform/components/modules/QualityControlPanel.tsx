'use client'

import { useStrategyStore } from '@/lib/store'
import { computeQualityScore, qualityAlerts } from '@/lib/engines/quality'
import { GlassCard, KpiCard } from '@/components/ui/GlassCard'
import { EditableNumber } from '@/components/ui/EditableField'
import { SectionHeader, Badge, ScoreRing } from '@/components/ui/Badge'
import { formatPercent } from '@/lib/utils'

export function QualityControlPanel() {
  const { quality, updateQuality } = useStrategyStore()
  const score = computeQualityScore(quality)
  const alerts = qualityAlerts(quality)

  return (
    <div>
      <SectionHeader
        title="Admin Quality Control"
        titleAr="مراقبة الجودة"
        description="تتبع جودة المزودين والشكاوى المخفية ومحفزات الإيقاف"
      />

      <div className="grid lg:grid-cols-3 gap-6 mb-6">
        <GlassCard className="flex flex-col items-center justify-center relative">
          <ScoreRing score={score} label="Quality Score" />
        </GlassCard>
        <div className="lg:col-span-2 space-y-3">
          {alerts.length === 0 ? (
            <GlassCard>
              <p className="text-sm text-emerald-600">✓ لا توجد تنبيهات — الجودة ضمن المستهدف</p>
            </GlassCard>
          ) : (
            alerts.map((a, i) => (
              <GlassCard key={i}>
                <Badge variant={a.level as 'low' | 'medium' | 'high' | 'critical'}>{a.level}</Badge>
                <p className="text-sm mt-2">{a.msg}</p>
              </GlassCard>
            ))
          )}
          <KpiCard
            labelAr="حد الإيقاف"
            value={`${quality.repeatedViolations} / ${quality.suspensionThreshold}`}
            sub="Repeated violations vs threshold"
            trend={quality.repeatedViolations >= quality.suspensionThreshold ? 'down' : 'up'}
          />
        </div>
      </div>

      <div className="glass-card p-6">
        <h3 className="text-sm font-semibold mb-4">مؤشرات الجودة</h3>
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-4">
          <EditableNumber labelAr="درجة جودة المزود" label="Quality Score" value={quality.providerQualityScore} onChange={(v) => updateQuality({ providerQualityScore: v })} min={0} max={100} />
          <EditableNumber labelAr="شكاوى مخفية" label="Hidden" value={quality.hiddenComplaints} onChange={(v) => updateQuality({ hiddenComplaints: v })} min={0} max={20} />
          <EditableNumber labelAr="تقييمات عامة" label="Public Rating" value={quality.publicRatings} onChange={(v) => updateQuality({ publicRatings: v })} min={1} max={5} step={0.1} />
          <EditableNumber labelAr="علامات استرداد" label="Refund Flags" value={quality.refundFlags} onChange={(v) => updateQuality({ refundFlags: v })} min={0} max={20} suffix="%" />
          <EditableNumber labelAr="مخالفات متكررة" label="Violations" value={quality.repeatedViolations} onChange={(v) => updateQuality({ repeatedViolations: v })} min={0} max={10} />
          <EditableNumber labelAr="حد الإيقاف" label="Suspension" value={quality.suspensionThreshold} onChange={(v) => updateQuality({ suspensionThreshold: v })} min={1} max={10} />
        </div>
      </div>
    </div>
  )
}
