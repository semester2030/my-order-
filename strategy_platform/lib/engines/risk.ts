import type { RiskMetrics } from '../types'
import { clamp } from '../utils'

export type RiskItem = {
  key: keyof RiskMetrics
  label: string
  labelAr: string
  value: number
  severity: 'low' | 'medium' | 'high' | 'critical'
  score: number
}

const THRESHOLDS: Record<keyof RiskMetrics, [number, number, number]> = {
  failedOrders: [1, 2, 4],
  providerNoShow: [0.5, 1.5, 3],
  lowQuality: [2, 4, 7],
  disputes: [1.5, 3, 5],
  delayedArrivals: [4, 8, 12],
  refunds: [2, 4, 6],
  fraudAttempts: [0.2, 0.5, 1],
}

const LABELS: Record<keyof RiskMetrics, { en: string; ar: string }> = {
  failedOrders: { en: 'Failed Orders', ar: 'طلبات فاشلة' },
  providerNoShow: { en: 'Provider No-Show', ar: 'عدم حضور المزود' },
  lowQuality: { en: 'Low Quality', ar: 'جودة منخفضة' },
  disputes: { en: 'Disputes', ar: 'نزاعات' },
  delayedArrivals: { en: 'Delayed Arrivals', ar: 'تأخير الوصول' },
  refunds: { en: 'Refunds', ar: 'استردادات' },
  fraudAttempts: { en: 'Fraud Attempts', ar: 'محاولات احتيال' },
}

function severity(value: number, thresholds: [number, number, number]): RiskItem['severity'] {
  if (value >= thresholds[2]) return 'critical'
  if (value >= thresholds[1]) return 'high'
  if (value >= thresholds[0]) return 'medium'
  return 'low'
}

export function analyzeRisk(risk: RiskMetrics): { items: RiskItem[]; overallScore: number } {
  const items = (Object.keys(risk) as (keyof RiskMetrics)[]).map((key) => {
    const value = risk[key]
    const thresholds = THRESHOLDS[key]
    const sev = severity(value, thresholds)
    const scoreMap = { low: 10, medium: 25, high: 50, critical: 80 }
    return {
      key,
      label: LABELS[key].en,
      labelAr: LABELS[key].ar,
      value,
      severity: sev,
      score: scoreMap[sev] * (value / (thresholds[2] || 1)),
    }
  })
  const overallScore = clamp(
    Math.round(items.reduce((s, i) => s + i.score, 0) / items.length),
    0,
    100,
  )
  return { items, overallScore }
}
