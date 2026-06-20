import type { FinancialInputs, GrowthInputs } from '../types'
import { computeGrowth } from './growth'

export type FinancialOutputs = {
  monthlyRevenue: number
  monthlyBurn: number
  netBurn: number
  runwayMonths: number
  breakEvenMonth: number | null
  monthlyProfit: number
  annualProfit: number
  totalMonthlyCosts: number
  gatewayFees: number
}

export function computeFinancial(financial: FinancialInputs, growth: GrowthInputs): FinancialOutputs {
  const growthOut = computeGrowth(growth)
  const monthlyRevenue = growthOut.netRevenueAfterRefunds
  const gatewayFees = growthOut.monthlyGmv * (financial.paymentGatewayFeePercent / 100)
  const totalMonthlyCosts =
    financial.monthlyFixedCosts +
    financial.supportSalaries +
    financial.marketingCosts +
    financial.officeCosts +
    financial.softwareCosts +
    financial.serverCosts +
    financial.disputeCosts +
    gatewayFees
  const monthlyBurn = totalMonthlyCosts
  const netBurn = monthlyBurn - monthlyRevenue
  const totalCash = financial.cashReserve
  const runwayMonths = netBurn > 0 ? Math.floor(totalCash / netBurn) : 999
  const monthlyProfit = monthlyRevenue - monthlyBurn
  const breakEvenMonth = monthlyProfit >= 0 ? 1 : netBurn > 0 ? Math.ceil(totalCash / (monthlyRevenue || 1)) : null

  return {
    monthlyRevenue,
    monthlyBurn,
    netBurn,
    runwayMonths: Math.min(runwayMonths, 999),
    breakEvenMonth: monthlyProfit >= 0 ? 1 : breakEvenMonth,
    monthlyProfit,
    annualProfit: monthlyProfit * 12,
    totalMonthlyCosts,
    gatewayFees,
  }
}

export function financialProjection(financial: FinancialInputs, growth: GrowthInputs, months = 18) {
  const base = computeFinancial(financial, growth)
  let cash = financial.cashReserve - financial.startupCosts
  let rev = base.monthlyRevenue

  return Array.from({ length: months }, (_, i) => {
    rev *= 1 + i * 0.04
    const costs = base.totalMonthlyCosts * (1 + i * 0.02)
    const profit = rev - costs
    cash += profit
    return {
      month: `M${i + 1}`,
      revenue: Math.round(rev),
      costs: Math.round(costs),
      profit: Math.round(profit),
      cash: Math.round(cash),
    }
  })
}
