import type {
  CityExpansion,
  CustomerChannel,
  FinancialInputs,
  GrowthInputs,
  LaunchPhase,
  ProviderSegment,
  QualityControlMetrics,
  RiskMetrics,
  ScenarioAssumptions,
  TrustMetrics,
} from './types'

export const BRAND = {
  name: 'مطبخ البيت',
  nameEn: 'Home Kitchen',
  color: '#FF6A33',
}

export const DEFAULT_LAUNCH_PHASES: LaunchPhase[] = [
  {
    id: 'phase-1',
    name: 'Phase 1 — Soft Launch',
    nameAr: 'المرحلة 1 — الإطلاق الناعم',
    daysRange: '0–30',
    targetProviders: 25,
    targetCustomers: 150,
    targetOrders: 80,
    expectedGmv: 28000,
    expectedCommissionRevenue: 4200,
    requiredMarketingBudget: 12000,
    expectedCac: 80,
    retentionTarget: 35,
    operationalGoals: 'Onboard 25 verified home chefs in Riyadh north districts',
    trustBuildingGoals: '100% profile verification, first 50 orders with manual QC',
  },
  {
    id: 'phase-2',
    name: 'Phase 2 — Market Fit',
    nameAr: 'المرحلة 2 — ملاءمة السوق',
    daysRange: '30–90',
    targetProviders: 80,
    targetCustomers: 600,
    targetOrders: 450,
    expectedGmv: 157500,
    expectedCommissionRevenue: 23625,
    requiredMarketingBudget: 35000,
    expectedCac: 58,
    retentionTarget: 42,
    operationalGoals: 'Launch lamb cooking & BBQ categories, reduce avg response time to 15min',
    trustBuildingGoals: 'Dispute rate below 3%, NPS survey after every order',
  },
  {
    id: 'phase-3',
    name: 'Phase 3 — Scale Riyadh',
    nameAr: 'المرحلة 3 — توسيع الرياض',
    daysRange: '90–180',
    targetProviders: 200,
    targetCustomers: 2500,
    targetOrders: 1800,
    expectedGmv: 630000,
    expectedCommissionRevenue: 94500,
    requiredMarketingBudget: 85000,
    expectedCac: 45,
    retentionTarget: 48,
    operationalGoals: 'Events & catering live, automated dispatch, 24/7 support',
    trustBuildingGoals: 'Trust score above 85, public ratings on all providers',
  },
  {
    id: 'phase-4',
    name: 'Phase 4 — Multi-City',
    nameAr: 'المرحلة 4 — تعدد المدن',
    daysRange: '6–12 months',
    targetProviders: 600,
    targetCustomers: 12000,
    targetOrders: 9000,
    expectedGmv: 3150000,
    expectedCommissionRevenue: 472500,
    requiredMarketingBudget: 280000,
    expectedCac: 38,
    retentionTarget: 52,
    operationalGoals: 'Expand to Jeddah & Dammam, city-level ops managers',
    trustBuildingGoals: 'Brand recognition in 3 cities, influencer trust campaigns',
  },
]

export const DEFAULT_GROWTH: GrowthInputs = {
  providers: 80,
  avgOrdersPerProvider: 12,
  avgOrderValue: 350,
  commissionPercent: 15,
  repeatCustomerPercent: 38,
  refundPercent: 2.5,
  providerChurnPercent: 8,
  customerChurnPercent: 12,
  disputePercent: 2,
}

export const DEFAULT_CUSTOMER_CHANNELS: CustomerChannel[] = [
  { id: 'tiktok', name: 'TikTok', nameAr: 'تيك توك', cac: 42, budget: 15000, conversionRate: 3.2, retentionQuality: 72, roi: 2.4 },
  { id: 'snapchat', name: 'Snapchat', nameAr: 'سناب شات', cac: 38, budget: 12000, conversionRate: 2.8, retentionQuality: 68, roi: 2.1 },
  { id: 'instagram', name: 'Instagram', nameAr: 'انستقرام', cac: 55, budget: 18000, conversionRate: 2.5, retentionQuality: 75, roi: 1.9 },
  { id: 'whatsapp', name: 'WhatsApp Groups', nameAr: 'مجموعات واتساب', cac: 18, budget: 5000, conversionRate: 8.5, retentionQuality: 82, roi: 4.2 },
  { id: 'influencer', name: 'Influencer Marketing', nameAr: 'المؤثرين', cac: 65, budget: 25000, conversionRate: 4.1, retentionQuality: 70, roi: 1.8 },
  { id: 'referral', name: 'Referral System', nameAr: 'الإحالة', cac: 22, budget: 8000, conversionRate: 12, retentionQuality: 88, roi: 5.1 },
  { id: 'field', name: 'Field Marketing', nameAr: 'التسويق الميداني', cac: 35, budget: 10000, conversionRate: 6.2, retentionQuality: 78, roi: 3.0 },
  { id: 'micro', name: 'Micro Communities', nameAr: 'المجتمعات الصغيرة', cac: 28, budget: 6000, conversionRate: 7.5, retentionQuality: 85, roi: 3.8 },
  { id: 'neighborhood', name: 'Neighborhood Launches', nameAr: 'إطلاقات الأحياء', cac: 25, budget: 7000, conversionRate: 9.0, retentionQuality: 90, roi: 4.5 },
]

export const DEFAULT_PROVIDER_SEGMENTS: ProviderSegment[] = [
  { id: 'housewives', name: 'Housewives', nameAr: 'ربات البيوت', leadToSignup: 45, signupToApplication: 72, applicationToApproval: 68, approvalToActive: 85, monthlyChurn: 6, acquisitionCost: 120 },
  { id: 'freelance', name: 'Freelance Chefs', nameAr: 'الطهاة المستقلين', leadToSignup: 38, signupToApplication: 65, applicationToApproval: 75, approvalToActive: 90, monthlyChurn: 5, acquisitionCost: 180 },
  { id: 'lamb', name: 'Lamb Specialists', nameAr: 'متخصصي الذبائح', leadToSignup: 30, signupToApplication: 55, applicationToApproval: 80, approvalToActive: 92, monthlyChurn: 4, acquisitionCost: 250 },
  { id: 'bbq', name: 'BBQ Specialists', nameAr: 'متخصصي الشواء', leadToSignup: 35, signupToApplication: 60, applicationToApproval: 70, approvalToActive: 88, monthlyChurn: 7, acquisitionCost: 200 },
  { id: 'events', name: 'Event Providers', nameAr: 'مزودي المناسبات', leadToSignup: 25, signupToApplication: 50, applicationToApproval: 85, approvalToActive: 95, monthlyChurn: 3, acquisitionCost: 350 },
]

export const DEFAULT_TRUST: TrustMetrics = {
  providerRating: 4.6,
  disputeRate: 2.1,
  completionRate: 94,
  cancellationRate: 4.5,
  refundRate: 2.5,
  customerComplaints: 3.2,
  adminIntervention: 1.8,
}

export const DEFAULT_RISK: RiskMetrics = {
  failedOrders: 1.2,
  providerNoShow: 0.8,
  lowQuality: 2.5,
  disputes: 2.1,
  delayedArrivals: 5.5,
  refunds: 2.5,
  fraudAttempts: 0.3,
}

export const DEFAULT_FINANCIAL: FinancialInputs = {
  startupCosts: 180000,
  monthlyFixedCosts: 45000,
  paymentGatewayFeePercent: 2.5,
  supportSalaries: 18000,
  marketingCosts: 35000,
  officeCosts: 8000,
  softwareCosts: 4500,
  serverCosts: 2500,
  disputeCosts: 3000,
  cashReserve: 250000,
}

export const DEFAULT_CITIES: CityExpansion[] = [
  { id: 'riyadh', name: 'Riyadh', nameAr: 'الرياض', active: true, launchMonth: 1, providerDensity: 80, customerDensity: 2500, demandForecast: 1800, expansionCost: 0, avgOrderValue: 350 },
  { id: 'jeddah', name: 'Jeddah', nameAr: 'جدة', active: false, launchMonth: 7, providerDensity: 0, customerDensity: 0, demandForecast: 1200, expansionCost: 120000, avgOrderValue: 380 },
  { id: 'dammam', name: 'Dammam', nameAr: 'الدمام', active: false, launchMonth: 9, providerDensity: 0, customerDensity: 0, demandForecast: 800, expansionCost: 85000, avgOrderValue: 340 },
  { id: 'khobar', name: 'Khobar', nameAr: 'الخبر', active: false, launchMonth: 10, providerDensity: 0, customerDensity: 0, demandForecast: 500, expansionCost: 45000, avgOrderValue: 360 },
  { id: 'makkah', name: 'Makkah', nameAr: 'مكة', active: false, launchMonth: 12, providerDensity: 0, customerDensity: 0, demandForecast: 900, expansionCost: 95000, avgOrderValue: 320 },
  { id: 'madinah', name: 'Madinah', nameAr: 'المدينة', active: false, launchMonth: 14, providerDensity: 0, customerDensity: 0, demandForecast: 600, expansionCost: 70000, avgOrderValue: 310 },
]

export const DEFAULT_SCENARIOS: Record<'conservative' | 'realistic' | 'aggressive', ScenarioAssumptions> = {
  conservative: {
    growthMultiplier: 0.7,
    cacMultiplier: 1.3,
    retentionMultiplier: 0.85,
    commissionRate: 14,
    avgOrderValue: 300,
    providerGrowthRate: 8,
    customerGrowthRate: 12,
  },
  realistic: {
    growthMultiplier: 1,
    cacMultiplier: 1,
    retentionMultiplier: 1,
    commissionRate: 15,
    avgOrderValue: 350,
    providerGrowthRate: 15,
    customerGrowthRate: 22,
  },
  aggressive: {
    growthMultiplier: 1.5,
    cacMultiplier: 0.75,
    retentionMultiplier: 1.1,
    commissionRate: 16,
    avgOrderValue: 400,
    providerGrowthRate: 28,
    customerGrowthRate: 40,
  },
}

export const DEFAULT_QUALITY: QualityControlMetrics = {
  providerQualityScore: 82,
  hiddenComplaints: 4,
  publicRatings: 4.5,
  refundFlags: 2.8,
  repeatedViolations: 1.5,
  suspensionThreshold: 3,
}

export const MODULES = [
  { id: 'overview', label: 'Overview', labelAr: 'نظرة عامة', icon: 'LayoutDashboard' },
  { id: 'launch', label: 'Launch Strategy', labelAr: 'استراتيجية الإطلاق', icon: 'Rocket' },
  { id: 'growth', label: 'Growth Simulator', labelAr: 'محاكي النمو', icon: 'TrendingUp' },
  { id: 'customers', label: 'Customer Acquisition', labelAr: 'اكتساب العملاء', icon: 'Users' },
  { id: 'providers', label: 'Provider Acquisition', labelAr: 'اكتساب المزودين', icon: 'ChefHat' },
  { id: 'trust', label: 'Trust System', labelAr: 'نظام الثقة', icon: 'Shield' },
  { id: 'risk', label: 'Operational Risk', labelAr: 'المخاطر التشغيلية', icon: 'AlertTriangle' },
  { id: 'financial', label: 'Financial Model', labelAr: 'النموذج المالي', icon: 'Wallet' },
  { id: 'scaling', label: 'Scaling Engine', labelAr: 'محرك التوسع', icon: 'MapPin' },
  { id: 'scenarios', label: 'Scenario Engine', labelAr: 'محرك السيناريوهات', icon: 'GitBranch' },
  { id: 'quality', label: 'Quality Control', labelAr: 'مراقبة الجودة', icon: 'BadgeCheck' },
] as const
