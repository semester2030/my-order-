export type LaunchPhase = {
  id: string
  name: string
  nameAr: string
  daysRange: string
  targetProviders: number
  targetCustomers: number
  targetOrders: number
  expectedGmv: number
  expectedCommissionRevenue: number
  requiredMarketingBudget: number
  expectedCac: number
  retentionTarget: number
  operationalGoals: string
  trustBuildingGoals: string
}

export type CustomerChannel = {
  id: string
  name: string
  nameAr: string
  cac: number
  budget: number
  conversionRate: number
  retentionQuality: number
  roi: number
}

export type ProviderSegment = {
  id: string
  name: string
  nameAr: string
  leadToSignup: number
  signupToApplication: number
  applicationToApproval: number
  approvalToActive: number
  monthlyChurn: number
  acquisitionCost: number
}

export type CityExpansion = {
  id: string
  name: string
  nameAr: string
  active: boolean
  launchMonth: number
  providerDensity: number
  customerDensity: number
  demandForecast: number
  expansionCost: number
  avgOrderValue: number
}

export type ScenarioType = 'conservative' | 'realistic' | 'aggressive'

export type ScenarioAssumptions = {
  growthMultiplier: number
  cacMultiplier: number
  retentionMultiplier: number
  commissionRate: number
  avgOrderValue: number
  providerGrowthRate: number
  customerGrowthRate: number
}

export type GrowthInputs = {
  providers: number
  avgOrdersPerProvider: number
  avgOrderValue: number
  commissionPercent: number
  repeatCustomerPercent: number
  refundPercent: number
  providerChurnPercent: number
  customerChurnPercent: number
  disputePercent: number
}

export type TrustMetrics = {
  providerRating: number
  disputeRate: number
  completionRate: number
  cancellationRate: number
  refundRate: number
  customerComplaints: number
  adminIntervention: number
}

export type RiskMetrics = {
  failedOrders: number
  providerNoShow: number
  lowQuality: number
  disputes: number
  delayedArrivals: number
  refunds: number
  fraudAttempts: number
}

export type FinancialInputs = {
  startupCosts: number
  monthlyFixedCosts: number
  paymentGatewayFeePercent: number
  supportSalaries: number
  marketingCosts: number
  officeCosts: number
  softwareCosts: number
  serverCosts: number
  disputeCosts: number
  cashReserve: number
}

export type QualityControlMetrics = {
  providerQualityScore: number
  hiddenComplaints: number
  publicRatings: number
  refundFlags: number
  repeatedViolations: number
  suspensionThreshold: number
}

export type StrategyState = {
  activeModule: string
  activeScenario: ScenarioType
  launchPhases: LaunchPhase[]
  growth: GrowthInputs
  customerChannels: CustomerChannel[]
  providerSegments: ProviderSegment[]
  trust: TrustMetrics
  risk: RiskMetrics
  financial: FinancialInputs
  cities: CityExpansion[]
  scenarios: Record<ScenarioType, ScenarioAssumptions>
  quality: QualityControlMetrics
}
