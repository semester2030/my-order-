'use client'

import { useEffect, useState } from 'react'
import { DashboardLayout } from '@/components/layout/dashboard-layout'
import { apiClient } from '@/lib/api/client'
import { Endpoints } from '@/lib/api/endpoints'
import { useLanguage } from '@/lib/contexts/language-context'
import { 
  ShoppingBag, 
  Utensils, 
  TrendingUp, 
  DollarSign,
  Package,
  Clock,
} from 'lucide-react'

interface DashboardStats {
  totalOrders: number
  totalRevenue: number
  pendingOrders: number
  preparingOrders: number
  readyOrders: number
  averageOrderValue: number
}

export default function DashboardPage() {
  const { t } = useLanguage()
  const [stats, setStats] = useState<DashboardStats | null>(null)
  const [isLoading, setIsLoading] = useState(true)

  useEffect(() => {
    const fetchStats = async () => {
      try {
        const response = await apiClient.get<DashboardStats>(
          Endpoints.analytics.dashboard,
        )
        setStats(response.data)
      } catch (error) {
        console.error('Failed to fetch dashboard stats:', error)
      } finally {
        setIsLoading(false)
      }
    }

    fetchStats()
  }, [])

  const statCards = [
    {
      titleKey: 'dashboard.totalRevenue',
      value: stats?.totalRevenue || 0,
      icon: DollarSign,
      color: 'text-success',
      bgColor: 'bg-success/10',
      format: (val: number) => `$${val.toFixed(2)}`,
    },
    {
      titleKey: 'dashboard.totalOrders',
      value: stats?.totalOrders || 0,
      icon: ShoppingBag,
      color: 'text-primary',
      bgColor: 'bg-primary/10',
      format: (val: number) => val.toString(),
    },
    {
      titleKey: 'dashboard.pendingOrders',
      value: stats?.pendingOrders || 0,
      icon: Clock,
      color: 'text-warning',
      bgColor: 'bg-warning/10',
      format: (val: number) => val.toString(),
    },
    {
      titleKey: 'dashboard.avgOrderValue',
      value: stats?.averageOrderValue || 0,
      icon: TrendingUp,
      color: 'text-info',
      bgColor: 'bg-info/10',
      format: (val: number) => `$${val.toFixed(2)}`,
    },
  ]

  return (
    <DashboardLayout>
      <div className="space-y-6">
        <div>
          <h1 className="text-3xl font-bold text-text-primary">{t('dashboard.title')}</h1>
          <p className="text-text-secondary mt-1">{t('dashboard.subtitle')}</p>
        </div>

        {/* Stats Grid */}
        {isLoading ? (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {[...Array(4)].map((_, i) => (
              <div
                key={i}
                className="p-6 bg-white rounded-lg border border-border animate-pulse"
              >
                <div className="h-4 bg-surface rounded w-1/2 mb-4"></div>
                <div className="h-8 bg-surface rounded w-3/4"></div>
              </div>
            ))}
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {statCards.map((card, index) => {
              const Icon = card.icon
              return (
                <div
                  key={index}
                  className="p-6 bg-white rounded-lg border border-border hover:shadow-md transition-shadow"
                >
                  <div className="flex items-center justify-between mb-4">
                    <div className={`p-3 ${card.bgColor} rounded-lg`}>
                      <Icon className={`w-6 h-6 ${card.color}`} />
                    </div>
                  </div>
                  <h3 className="text-sm font-medium text-text-secondary mb-1">
                    {t(card.titleKey)}
                  </h3>
                  <p className="text-2xl font-bold text-text-primary">
                    {card.format(card.value)}
                  </p>
                </div>
              )
            })}
          </div>
        )}

        {/* Quick Actions */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div className="p-6 bg-white rounded-lg border border-border">
            <div className="flex items-center gap-4">
              <div className="p-3 bg-primary/10 rounded-lg">
                <Package className="w-6 h-6 text-primary" />
              </div>
              <div>
                <h3 className="font-semibold text-text-primary">{t('dashboard.preparing')}</h3>
                <p className="text-2xl font-bold text-text-primary">
                  {stats?.preparingOrders || 0}
                </p>
              </div>
            </div>
          </div>

          <div className="p-6 bg-white rounded-lg border border-border">
            <div className="flex items-center gap-4">
              <div className="p-3 bg-success/10 rounded-lg">
                <Utensils className="w-6 h-6 text-success" />
              </div>
              <div>
                <h3 className="font-semibold text-text-primary">{t('dashboard.ready')}</h3>
                <p className="text-2xl font-bold text-text-primary">
                  {stats?.readyOrders || 0}
                </p>
              </div>
            </div>
          </div>

          <div className="p-6 bg-white rounded-lg border border-border">
            <div className="flex items-center gap-4">
              <div className="p-3 bg-info/10 rounded-lg">
                <TrendingUp className="w-6 h-6 text-info" />
              </div>
              <div>
                <h3 className="font-semibold text-text-primary">{t('dashboard.performance')}</h3>
                <p className="text-sm text-text-secondary">{t('dashboard.viewAnalytics')}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </DashboardLayout>
  )
}
