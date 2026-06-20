import { create } from 'zustand'
import { persist } from 'zustand/middleware'
import {
  DEFAULT_CITIES,
  DEFAULT_CUSTOMER_CHANNELS,
  DEFAULT_FINANCIAL,
  DEFAULT_GROWTH,
  DEFAULT_LAUNCH_PHASES,
  DEFAULT_PROVIDER_SEGMENTS,
  DEFAULT_QUALITY,
  DEFAULT_RISK,
  DEFAULT_SCENARIOS,
  DEFAULT_TRUST,
} from './defaults'
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
  ScenarioType,
  TrustMetrics,
} from './types'

type StrategyStore = {
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

  setActiveModule: (id: string) => void
  setActiveScenario: (s: ScenarioType) => void
  updateLaunchPhase: (id: string, patch: Partial<LaunchPhase>) => void
  updateGrowth: (patch: Partial<GrowthInputs>) => void
  updateCustomerChannel: (id: string, patch: Partial<CustomerChannel>) => void
  updateProviderSegment: (id: string, patch: Partial<ProviderSegment>) => void
  updateTrust: (patch: Partial<TrustMetrics>) => void
  updateRisk: (patch: Partial<RiskMetrics>) => void
  updateFinancial: (patch: Partial<FinancialInputs>) => void
  updateCity: (id: string, patch: Partial<CityExpansion>) => void
  updateScenario: (type: ScenarioType, patch: Partial<ScenarioAssumptions>) => void
  updateQuality: (patch: Partial<QualityControlMetrics>) => void
  resetAll: () => void
}

const initialState = {
  activeModule: 'overview',
  activeScenario: 'realistic' as ScenarioType,
  launchPhases: DEFAULT_LAUNCH_PHASES,
  growth: DEFAULT_GROWTH,
  customerChannels: DEFAULT_CUSTOMER_CHANNELS,
  providerSegments: DEFAULT_PROVIDER_SEGMENTS,
  trust: DEFAULT_TRUST,
  risk: DEFAULT_RISK,
  financial: DEFAULT_FINANCIAL,
  cities: DEFAULT_CITIES,
  scenarios: DEFAULT_SCENARIOS,
  quality: DEFAULT_QUALITY,
}

export const useStrategyStore = create<StrategyStore>()(
  persist(
    (set) => ({
      ...initialState,
      setActiveModule: (id) => set({ activeModule: id }),
      setActiveScenario: (s) => set({ activeScenario: s }),
      updateLaunchPhase: (id, patch) =>
        set((s) => ({
          launchPhases: s.launchPhases.map((p) => (p.id === id ? { ...p, ...patch } : p)),
        })),
      updateGrowth: (patch) => set((s) => ({ growth: { ...s.growth, ...patch } })),
      updateCustomerChannel: (id, patch) =>
        set((s) => ({
          customerChannels: s.customerChannels.map((c) => (c.id === id ? { ...c, ...patch } : c)),
        })),
      updateProviderSegment: (id, patch) =>
        set((s) => ({
          providerSegments: s.providerSegments.map((p) => (p.id === id ? { ...p, ...patch } : p)),
        })),
      updateTrust: (patch) => set((s) => ({ trust: { ...s.trust, ...patch } })),
      updateRisk: (patch) => set((s) => ({ risk: { ...s.risk, ...patch } })),
      updateFinancial: (patch) => set((s) => ({ financial: { ...s.financial, ...patch } })),
      updateCity: (id, patch) =>
        set((s) => ({ cities: s.cities.map((c) => (c.id === id ? { ...c, ...patch } : c)) })),
      updateScenario: (type, patch) =>
        set((s) => ({ scenarios: { ...s.scenarios, [type]: { ...s.scenarios[type], ...patch } } })),
      updateQuality: (patch) => set((s) => ({ quality: { ...s.quality, ...patch } })),
      resetAll: () => set(initialState),
    }),
    { name: 'matbakh-strategy-v1' },
  ),
)
