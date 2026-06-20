import type { GrowthInputs, ScenarioAssumptions, ScenarioType } from '../types'
import { computeGrowth } from './growth'

export function applyScenario(growth: GrowthInputs, scenario: ScenarioAssumptions) {
  const adjusted: GrowthInputs = {
    ...growth,
    providers: Math.round(growth.providers * scenario.growthMultiplier),
    avgOrderValue: scenario.avgOrderValue,
    commissionPercent: scenario.commissionRate,
    repeatCustomerPercent: growth.repeatCustomerPercent * scenario.retentionMultiplier,
    avgOrdersPerProvider: Math.round(
      growth.avgOrdersPerProvider * (1 + scenario.customerGrowthRate / 100),
    ),
  }
  return computeGrowth(adjusted)
}

export function compareScenarios(
  growth: GrowthInputs,
  scenarios: Record<ScenarioType, ScenarioAssumptions>,
) {
  return (Object.keys(scenarios) as ScenarioType[]).map((key) => {
    const result = applyScenario(growth, scenarios[key])
    return {
      scenario: key,
      label: key.charAt(0).toUpperCase() + key.slice(1),
      annualGmv: result.annualGmv,
      companyRevenue: result.companyRevenue * 12,
      netMargin: result.netMargin,
      providers: Math.round(growth.providers * scenarios[key].growthMultiplier),
    }
  })
}

export function scenarioMonthlyProjection(
  growth: GrowthInputs,
  scenario: ScenarioAssumptions,
  months = 12,
) {
  return Array.from({ length: months }, (_, i) => {
    const factor = 1 + (i * scenario.providerGrowthRate) / 100 / 12
    const adjusted = {
      ...growth,
      providers: Math.round(growth.providers * scenario.growthMultiplier * factor),
      avgOrderValue: scenario.avgOrderValue,
      commissionPercent: scenario.commissionRate,
    }
    const out = computeGrowth(adjusted)
    return {
      month: `M${i + 1}`,
      gmv: Math.round(out.monthlyGmv),
      revenue: Math.round(out.companyRevenue),
    }
  })
}
