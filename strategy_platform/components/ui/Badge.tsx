'use client'

import { cn } from '@/lib/utils'

const SEVERITY_STYLES = {
  low: 'bg-emerald-50 text-emerald-700 border-emerald-200',
  medium: 'bg-amber-50 text-amber-700 border-amber-200',
  high: 'bg-orange-50 text-orange-700 border-orange-200',
  critical: 'bg-red-50 text-red-700 border-red-200',
}

export function Badge({
  children,
  variant = 'default',
}: {
  children: React.ReactNode
  variant?: 'default' | 'brand' | keyof typeof SEVERITY_STYLES
}) {
  return (
    <span
      className={cn(
        'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium border',
        variant === 'default' && 'bg-gray-100 text-gray-700 border-gray-200',
        variant === 'brand' && 'bg-brand-muted text-brand border-brand/20',
        variant in SEVERITY_STYLES && SEVERITY_STYLES[variant as keyof typeof SEVERITY_STYLES],
      )}
    >
      {children}
    </span>
  )
}

export function SectionHeader({
  title,
  titleAr,
  description,
}: {
  title: string
  titleAr: string
  description?: string
}) {
  return (
    <div className="mb-6">
      <h2 className="text-xl font-semibold text-ink">{titleAr}</h2>
      <p className="text-sm text-ink-muted mt-0.5">{title}</p>
      {description && <p className="text-sm text-ink-muted mt-2 max-w-2xl">{description}</p>}
    </div>
  )
}

export function ScoreRing({ score, label, size = 120 }: { score: number; label: string; size?: number }) {
  const radius = (size - 12) / 2
  const circumference = 2 * Math.PI * radius
  const offset = circumference - (score / 100) * circumference
  const color = score >= 80 ? '#27AE60' : score >= 60 ? '#FF6A33' : score >= 40 ? '#F39C12' : '#E74C3C'

  return (
    <div className="relative flex flex-col items-center">
      <svg width={size} height={size} className="-rotate-90">
        <circle cx={size / 2} cy={size / 2} r={radius} fill="none" stroke="#E5E7EB" strokeWidth={8} />
        <circle
          cx={size / 2}
          cy={size / 2}
          r={radius}
          fill="none"
          stroke={color}
          strokeWidth={8}
          strokeLinecap="round"
          strokeDasharray={circumference}
          strokeDashoffset={offset}
          className="transition-all duration-700"
        />
      </svg>
      <div className="absolute flex flex-col items-center justify-center" style={{ width: size, height: size }}>
        <span className="text-2xl font-bold text-ink">{score}</span>
      </div>
      <p className="text-sm text-ink-muted mt-2">{label}</p>
    </div>
  )
}
