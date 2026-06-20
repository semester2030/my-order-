import type { CityExpansion } from '../types'

export type CityMetrics = CityExpansion & {
  monthlyGmv: number
  monthlyRevenue: number
  breakEvenMonths: number
  marketPenetration: number
}

const COMMISSION = 0.15

export function analyzeCities(cities: CityExpansion[]): CityMetrics[] {
  return cities.map((city) => {
    const monthlyOrders = city.active
      ? city.demandForecast
      : city.demandForecast * (city.providerDensity > 0 ? 0.3 : 0.05)
    const monthlyGmv = monthlyOrders * city.avgOrderValue
    const monthlyRevenue = monthlyGmv * COMMISSION
    const breakEvenMonths =
      city.expansionCost > 0 && monthlyRevenue > 0
        ? Math.ceil(city.expansionCost / monthlyRevenue)
        : 0
    const marketPenetration = Math.min(
      100,
      (city.customerDensity / Math.max(city.demandForecast * 10, 1)) * 100,
    )
    return { ...city, monthlyGmv, monthlyRevenue, breakEvenMonths, marketPenetration }
  })
}

export function scalingTimeline(cities: CityExpansion[]) {
  return [...cities]
    .sort((a, b) => a.launchMonth - b.launchMonth)
    .map((c) => ({
      city: c.nameAr,
      month: c.launchMonth,
      cost: c.expansionCost,
      demand: c.demandForecast,
    }))
}
