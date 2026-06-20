import type { LaunchPhase } from '../types'

export function launchPhaseTotals(phases: LaunchPhase[]) {
  return phases.reduce(
    (acc, p) => ({
      providers: acc.providers + p.targetProviders,
      customers: acc.customers + p.targetCustomers,
      orders: acc.orders + p.targetOrders,
      gmv: acc.gmv + p.expectedGmv,
      commission: acc.commission + p.expectedCommissionRevenue,
      marketing: acc.marketing + p.requiredMarketingBudget,
    }),
    { providers: 0, customers: 0, orders: 0, gmv: 0, commission: 0, marketing: 0 },
  )
}

export function launchChartData(phases: LaunchPhase[]) {
  return phases.map((p) => ({
    phase: p.daysRange,
    gmv: p.expectedGmv,
    commission: p.expectedCommissionRevenue,
    orders: p.targetOrders,
    providers: p.targetProviders,
    customers: p.targetCustomers,
  }))
}
