'use client'

import { useStrategyStore } from '@/lib/store'
import { computeFinancial, financialProjection } from '@/lib/engines/financial'
import { KpiCard } from '@/components/ui/GlassCard'
import { EditableNumber } from '@/components/ui/EditableField'
import { SectionHeader } from '@/components/ui/Badge'
import { formatCurrency } from '@/lib/utils'
import {
  AreaChart,
  Area,
  XAxis,
  YAxis,
  Tooltip,
  ResponsiveContainer,
  CartesianGrid,
  Line,
  ComposedChart,
} from 'recharts'

export function FinancialModelPanel() {
  const { financial, growth, updateFinancial } = useStrategyStore()
  const fin = computeFinancial(financial, growth)
  const projection = financialProjection(financial, growth, 18)

  return (
    <div>
      <SectionHeader
        title="Financial Model"
        titleAr="النموذج المالي"
        description="Burn rate, runway, break-even — كل التكاليف قابلة للتعديل"
      />

      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
        <KpiCard labelAr="Burn Rate" value={formatCurrency(fin.monthlyBurn, true)} accent />
        <KpiCard labelAr="Net Burn" value={formatCurrency(fin.netBurn, true)} trend={fin.netBurn > 0 ? 'down' : 'up'} />
        <KpiCard labelAr="Runway" value={`${fin.runwayMonths} mo`} />
        <KpiCard labelAr="ربح شهري" value={formatCurrency(fin.monthlyProfit, true)} trend={fin.monthlyProfit >= 0 ? 'up' : 'down'} />
        <KpiCard labelAr="إيرادات شهرية" value={formatCurrency(fin.monthlyRevenue, true)} />
        <KpiCard labelAr="ربح سنوي" value={formatCurrency(fin.annualProfit, true)} />
        <KpiCard labelAr="رسوم بوابة الدفع" value={formatCurrency(fin.gatewayFees, true)} />
        <KpiCard labelAr="احتياطي نقدي" value={formatCurrency(financial.cashReserve, true)} />
      </div>

      <div className="glass-card p-6 mb-6">
        <h3 className="text-sm font-semibold mb-4">توقعات مالية — 18 شهر</h3>
        <ResponsiveContainer width="100%" height={300}>
          <ComposedChart data={projection}>
            <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
            <XAxis dataKey="month" />
            <YAxis tickFormatter={(v) => `${(v / 1000).toFixed(0)}K`} />
            <Tooltip formatter={(v: number) => formatCurrency(v)} />
            <Area type="monotone" dataKey="revenue" fill="#FF6A33" fillOpacity={0.15} stroke="#FF6A33" />
            <Line type="monotone" dataKey="costs" stroke="#E74C3C" strokeWidth={2} dot={false} />
            <Line type="monotone" dataKey="cash" stroke="#1A1A1A" strokeWidth={2} dot={false} />
          </ComposedChart>
        </ResponsiveContainer>
      </div>

      <div className="glass-card p-6">
        <h3 className="text-sm font-semibold mb-4">التكاليف — قابلة للتعديل</h3>
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-4">
          <EditableNumber labelAr="تكاليف بدء" label="Startup" value={financial.startupCosts} onChange={(v) => updateFinancial({ startupCosts: v })} min={0} max={2000000} step={5000} />
          <EditableNumber labelAr="تكاليف ثابتة" label="Fixed" value={financial.monthlyFixedCosts} onChange={(v) => updateFinancial({ monthlyFixedCosts: v })} min={0} max={200000} />
          <EditableNumber labelAr="رسوم بوابة %" label="Gateway" value={financial.paymentGatewayFeePercent} onChange={(v) => updateFinancial({ paymentGatewayFeePercent: v })} min={0} max={5} suffix="%" />
          <EditableNumber labelAr="رواتب دعم" label="Support" value={financial.supportSalaries} onChange={(v) => updateFinancial({ supportSalaries: v })} min={0} max={100000} />
          <EditableNumber labelAr="تسويق" label="Marketing" value={financial.marketingCosts} onChange={(v) => updateFinancial({ marketingCosts: v })} min={0} max={500000} />
          <EditableNumber labelAr="مكتب" label="Office" value={financial.officeCosts} onChange={(v) => updateFinancial({ officeCosts: v })} min={0} max={50000} />
          <EditableNumber labelAr="برمجيات" label="Software" value={financial.softwareCosts} onChange={(v) => updateFinancial({ softwareCosts: v })} min={0} max={30000} />
          <EditableNumber labelAr="سيرفرات" label="Servers" value={financial.serverCosts} onChange={(v) => updateFinancial({ serverCosts: v })} min={0} max={20000} />
          <EditableNumber labelAr="تكاليف نزاعات" label="Disputes" value={financial.disputeCosts} onChange={(v) => updateFinancial({ disputeCosts: v })} min={0} max={50000} />
          <EditableNumber labelAr="احتياطي نقدي" label="Cash Reserve" value={financial.cashReserve} onChange={(v) => updateFinancial({ cashReserve: v })} min={0} max={5000000} step={10000} />
        </div>
      </div>
    </div>
  )
}
