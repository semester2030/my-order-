'use client'

import { useStrategyStore } from '@/lib/store'
import { analyzeCities, scalingTimeline } from '@/lib/engines/scaling'
import { GlassCard, KpiCard } from '@/components/ui/GlassCard'
import { EditableNumber } from '@/components/ui/EditableField'
import { SectionHeader, Badge } from '@/components/ui/Badge'
import { formatCurrency } from '@/lib/utils'
import { cn } from '@/lib/utils'
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  Tooltip,
  ResponsiveContainer,
  CartesianGrid,
  ScatterChart,
  Scatter,
  ZAxis,
} from 'recharts'

export function ScalingEnginePanel() {
  const { cities, updateCity } = useStrategyStore()
  const cityMetrics = analyzeCities(cities)
  const timeline = scalingTimeline(cities)
  const totalGmv = cityMetrics.reduce((s, c) => s + c.monthlyGmv, 0)
  const activeCities = cities.filter((c) => c.active).length

  const scatterData = cityMetrics.map((c) => ({
    name: c.nameAr,
    x: c.providerDensity,
    y: c.customerDensity,
    z: c.demandForecast,
  }))

  return (
    <div>
      <SectionHeader
        title="Scaling Engine"
        titleAr="محرك التوسع"
        description="توسع مدينة بمدينة — الرياض أولاً ثم جدة والدمام والخبر ومكة والمدينة"
      />

      <div className="grid grid-cols-2 lg:grid-cols-3 gap-4 mb-6">
        <KpiCard labelAr="GMV شهري (كل المدن)" value={formatCurrency(totalGmv, true)} accent />
        <KpiCard labelAr="مدن نشطة" value={String(activeCities)} />
        <KpiCard labelAr="مدن مخططة" value={String(cities.length)} />
      </div>

      <div className="glass-card p-6 mb-6">
        <h3 className="text-sm font-semibold mb-4">كثافة السوق</h3>
        <ResponsiveContainer width="100%" height={280}>
          <ScatterChart>
            <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
            <XAxis type="number" dataKey="x" name="Providers" />
            <YAxis type="number" dataKey="y" name="Customers" />
            <ZAxis type="number" dataKey="z" range={[100, 600]} />
            <Tooltip cursor={{ strokeDasharray: '3 3' }} />
            <Scatter data={scatterData} fill="#FF6A33" />
          </ScatterChart>
        </ResponsiveContainer>
      </div>

      <div className="glass-card p-6 mb-6">
        <h3 className="text-sm font-semibold mb-4">جدول التوسع</h3>
        <ResponsiveContainer width="100%" height={220}>
          <BarChart data={timeline}>
            <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
            <XAxis dataKey="city" />
            <YAxis yAxisId="left" tickFormatter={(v) => `${(v / 1000).toFixed(0)}K`} />
            <YAxis yAxisId="right" orientation="left" hide />
            <Tooltip formatter={(v: number, name: string) => (name === 'cost' ? formatCurrency(v) : v)} />
            <Bar yAxisId="left" dataKey="cost" fill="#1A1A1A" name="Cost" radius={[4, 4, 0, 0]} />
            <Bar yAxisId="left" dataKey="demand" fill="#FF6A33" name="Demand" radius={[4, 4, 0, 0]} />
          </BarChart>
        </ResponsiveContainer>
      </div>

      <div className="space-y-4">
        {cities.map((city) => {
          const m = cityMetrics.find((c) => c.id === city.id)!
          return (
            <GlassCard key={city.id} className={cn(!city.active && 'opacity-80')}>
              <div className="flex justify-between items-start mb-4">
                <div>
                  <h3 className="font-semibold">{city.nameAr}</h3>
                  <p className="text-sm text-ink-muted">{city.name} — Month {city.launchMonth}</p>
                </div>
                <div className="flex gap-2">
                  <Badge variant={city.active ? 'brand' : 'default'}>{city.active ? 'نشط' : 'مخطط'}</Badge>
                  {m.breakEvenMonths > 0 && <Badge variant="medium">BE: {m.breakEvenMonths}mo</Badge>}
                </div>
              </div>
              <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-4 mb-3">
                <EditableNumber labelAr="كثافة مزودين" label="" value={city.providerDensity} onChange={(v) => updateCity(city.id, { providerDensity: v })} min={0} max={1000} />
                <EditableNumber labelAr="كثافة عملاء" label="" value={city.customerDensity} onChange={(v) => updateCity(city.id, { customerDensity: v })} min={0} max={50000} />
                <EditableNumber labelAr="توقع طلب" label="" value={city.demandForecast} onChange={(v) => updateCity(city.id, { demandForecast: v })} min={0} max={10000} />
                <EditableNumber labelAr="تكلفة توسع" label="" value={city.expansionCost} onChange={(v) => updateCity(city.id, { expansionCost: v })} min={0} max={500000} step={5000} />
                <EditableNumber labelAr="متوسط الطلب" label="" value={city.avgOrderValue} onChange={(v) => updateCity(city.id, { avgOrderValue: v })} min={100} max={2000} />
                <EditableNumber labelAr="شهر الإطلاق" label="" value={city.launchMonth} onChange={(v) => updateCity(city.id, { launchMonth: v })} min={1} max={24} />
              </div>
              <div className="flex gap-4 text-sm text-ink-muted">
                <span>GMV: {formatCurrency(m.monthlyGmv, true)}/mo</span>
                <span>Revenue: {formatCurrency(m.monthlyRevenue, true)}/mo</span>
                <span>Penetration: {m.marketPenetration.toFixed(1)}%</span>
              </div>
              <button
                onClick={() => updateCity(city.id, { active: !city.active })}
                className="mt-3 text-xs px-3 py-1.5 rounded-lg border border-brand/30 text-brand hover:bg-brand-muted transition-colors"
              >
                {city.active ? 'تعطيل' : 'تفعيل'} المدينة
              </button>
            </GlassCard>
          )
        })}
      </div>
    </div>
  )
}
