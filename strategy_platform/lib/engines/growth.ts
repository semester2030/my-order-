import type { GrowthInputs } from '../types'

export type GrowthOutputs = {
  dailyOrders: number
  dailyGmv: number
  monthlyGmv: number
  annualGmv: number
  companyRevenue: number
  providerPayouts: number
  grossMargin: number
  netMargin: number
  operationalLoad: number
  effectiveOrders: number
  repeatOrders: number
  netRevenueAfterRefunds: number
}

export function computeGrowth(inputs: GrowthInputs): GrowthOutputs {
  const monthlyOrders = inputs.providers * inputs.avgOrdersPerProvider
  const dailyOrders = monthlyOrders / 30
  const grossGmv = monthlyOrders * inputs.avgOrderValue
  const refundImpact = grossGmv * (inputs.refundPercent / 100)
  const effectiveGmv = grossGmv - refundImpact
  const companyRevenue = effectiveGmv * (inputs.commissionPercent / 100)
  const providerPayouts = effectiveGmv - companyRevenue
  const disputeCost = effectiveGmv * (inputs.disputePercent / 100) * 0.15
  const netRevenue = companyRevenue - disputeCost
  const grossMargin = effectiveGmv > 0 ? (companyRevenue / effectiveGmv) * 100 : 0
  const netMargin = effectiveGmv > 0 ? (netRevenue / effectiveGmv) * 100 : 0
  const churnLoad = inputs.providerChurnPercent + inputs.customerChurnPercent
  const operationalLoad = Math.min(100, 40 + churnLoad * 2 + inputs.disputePercent * 5)
  const repeatOrders = monthlyOrders * (inputs.repeatCustomerPercent / 100)

  return {
    dailyOrders,
    dailyGmv: grossGmv / 30,
    monthlyGmv: grossGmv,
    annualGmv: grossGmv * 12,
    companyRevenue,
    providerPayouts,
    grossMargin,
    netMargin,
    operationalLoad,
    effectiveOrders: monthlyOrders * (1 - inputs.refundPercent / 100),
    repeatOrders,
    netRevenueAfterRefunds: netRevenue,
  }
}

export function growthChartData(inputs: GrowthInputs, months = 12) {
  const base = computeGrowth(inputs)
  return Array.from({ length: months }, (_, i) => {
    const growthFactor = 1 + (i * 0.08)
    const churnFactor = 1 - (inputs.providerChurnPercent / 100) * (i / 12)
    return {
      month: `M${i + 1}`,
      gmv: Math.round(base.monthlyGmv * growthFactor * churnFactor),
      revenue: Math.round(base.companyRevenue * growthFactor * churnFactor),
      orders: Math.round(base.dailyOrders * 30 * growthFactor * churnFactor),
    }
  })
}
