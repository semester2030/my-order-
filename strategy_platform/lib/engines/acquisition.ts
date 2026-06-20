import type { CustomerChannel } from '../types'

export type ChannelAnalysis = CustomerChannel & {
  customersAcquired: number
  effectiveLtv: number
  score: number
}

const BASE_LTV = 350

export function analyzeChannels(channels: CustomerChannel[]) {
  const analyzed: ChannelAnalysis[] = channels.map((ch) => {
    const customersAcquired = ch.cac > 0 ? Math.floor(ch.budget / ch.cac) : 0
    const effectiveLtv = BASE_LTV * (ch.retentionQuality / 100) * (ch.conversionRate / 5)
    const score = ch.roi * (ch.retentionQuality / 100) * (ch.conversionRate / 5)
    return { ...ch, customersAcquired, effectiveLtv, score }
  })

  const bestChannel = [...analyzed].sort((a, b) => b.score - a.score)[0]
  const cheapestChannel = [...analyzed].sort((a, b) => a.cac - b.cac)[0]
  const highestLtvChannel = [...analyzed].sort((a, b) => b.effectiveLtv - a.effectiveLtv)[0]
  const totalBudget = channels.reduce((s, c) => s + c.budget, 0)
  const totalCustomers = analyzed.reduce((s, c) => s + c.customersAcquired, 0)
  const blendedCac = totalCustomers > 0 ? totalBudget / totalCustomers : 0

  return { analyzed, bestChannel, cheapestChannel, highestLtvChannel, totalBudget, totalCustomers, blendedCac }
}
