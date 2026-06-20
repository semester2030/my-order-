import type { TrustMetrics } from '../types'
import { clamp } from '../utils'

export function computeTrustScore(trust: TrustMetrics): number {
  const ratingScore = (trust.providerRating / 5) * 25
  const completionScore = (trust.completionRate / 100) * 25
  const disputePenalty = trust.disputeRate * 3
  const cancelPenalty = trust.cancellationRate * 1.5
  const refundPenalty = trust.refundRate * 2
  const complaintPenalty = trust.customerComplaints * 2
  const adminPenalty = trust.adminIntervention * 1.5

  const raw =
    ratingScore +
    completionScore +
    25 -
    disputePenalty -
    cancelPenalty -
    refundPenalty -
    complaintPenalty -
    adminPenalty

  return clamp(Math.round(raw), 0, 100)
}

export function trustBreakdown(trust: TrustMetrics) {
  return [
    { name: 'Rating', value: (trust.providerRating / 5) * 100 },
    { name: 'Completion', value: trust.completionRate },
    { name: 'Low Disputes', value: Math.max(0, 100 - trust.disputeRate * 10) },
    { name: 'Low Refunds', value: Math.max(0, 100 - trust.refundRate * 10) },
    { name: 'Low Complaints', value: Math.max(0, 100 - trust.customerComplaints * 8) },
  ]
}
