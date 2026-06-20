import type { QualityControlMetrics } from '../types'
import { clamp } from '../utils'

export function computeQualityScore(q: QualityControlMetrics): number {
  const base = q.providerQualityScore
  const complaintPenalty = q.hiddenComplaints * 2
  const refundPenalty = q.refundFlags * 1.5
  const violationPenalty = q.repeatedViolations * 4
  const ratingBonus = (q.publicRatings - 4) * 10
  return clamp(Math.round(base - complaintPenalty - refundPenalty - violationPenalty + ratingBonus), 0, 100)
}

export function qualityAlerts(q: QualityControlMetrics) {
  const alerts = []
  if (q.hiddenComplaints > 5) alerts.push({ level: 'high', msg: 'Hidden complaints above threshold' })
  if (q.refundFlags > 4) alerts.push({ level: 'medium', msg: 'Refund flags increasing' })
  if (q.repeatedViolations >= q.suspensionThreshold)
    alerts.push({ level: 'critical', msg: 'Suspension threshold reached' })
  if (q.publicRatings < 4) alerts.push({ level: 'medium', msg: 'Public ratings below target' })
  return alerts
}
