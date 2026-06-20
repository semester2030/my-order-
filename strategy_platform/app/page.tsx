'use client'

import { AppShell } from '@/components/layout/AppShell'
import { useStrategyStore } from '@/lib/store'
import { OverviewPanel } from '@/components/modules/OverviewPanel'
import { LaunchStrategyPanel } from '@/components/modules/LaunchStrategyPanel'
import { GrowthSimulatorPanel } from '@/components/modules/GrowthSimulatorPanel'
import { CustomerAcquisitionPanel } from '@/components/modules/CustomerAcquisitionPanel'
import { ProviderAcquisitionPanel } from '@/components/modules/ProviderAcquisitionPanel'
import { TrustSystemPanel } from '@/components/modules/TrustSystemPanel'
import { OperationalRiskPanel } from '@/components/modules/OperationalRiskPanel'
import { FinancialModelPanel } from '@/components/modules/FinancialModelPanel'
import { ScalingEnginePanel } from '@/components/modules/ScalingEnginePanel'
import { ScenarioEnginePanel } from '@/components/modules/ScenarioEnginePanel'
import { QualityControlPanel } from '@/components/modules/QualityControlPanel'

const PANELS: Record<string, React.ComponentType> = {
  overview: OverviewPanel,
  launch: LaunchStrategyPanel,
  growth: GrowthSimulatorPanel,
  customers: CustomerAcquisitionPanel,
  providers: ProviderAcquisitionPanel,
  trust: TrustSystemPanel,
  risk: OperationalRiskPanel,
  financial: FinancialModelPanel,
  scaling: ScalingEnginePanel,
  scenarios: ScenarioEnginePanel,
  quality: QualityControlPanel,
}

export default function StrategyDashboard() {
  const activeModule = useStrategyStore((s) => s.activeModule)
  const Panel = PANELS[activeModule] || OverviewPanel

  return (
    <AppShell>
      <Panel />
    </AppShell>
  )
}
