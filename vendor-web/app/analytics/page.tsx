'use client'

import { useEffect, useState } from 'react'
import { DashboardLayout } from '@/components/layout/dashboard-layout'
import { apiClient } from '@/lib/api/client'
import { Endpoints } from '@/lib/api/endpoints'
import { useLanguage } from '@/lib/contexts/language-context'
import { BarChart3, TrendingUp, DollarSign, ShoppingBag } from 'lucide-react'

interface AnalyticsData {
  totalOrders: number
  totalRevenue: number
  pendingOrders: number
  preparingOrders: number
  readyOrders: number
  averageOrderValue: number
  topItems: Array<{
    name: string
    count: number
    revenue: number
  }>
}

export default function AnalyticsPage() {
  const { t } = useLanguage()
  const [analytics, setAnalytics] = useState<AnalyticsData | null>(null)
  const [isLoading, setIsLoading] = useState(true)

  useEffect(() => {
    const fetchAnalytics = async () => {
      try {
        const response = await apiClient.get<AnalyticsData>(
          Endpoints.analytics.dashboard,
        )
        setAnalytics(response.data)
      } catch (error) {
        console.error('Failed to fetch analytics:', error)
      } finally {
        setIsLoading(false)
      }
    }

    fetchAnalytics()
  }, [])

  return (
    <DashboardLayout>
      <div className="space-y-6">
        {/* Header */}
        <div>
          <h1 className="text-3xl font-bold text-text-primary">{t('analyticsPage.title')}</h1>
          <p className="text-text-secondary mt-1">
            {t('analyticsPage.subtitle')}
          </p>
        </div>

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
        ) : analytics ? (
          <>
            {/* Summary Cards */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
              <div className="p-6 bg-white rounded-lg border border-border">
                <div className="flex items-center justify-between mb-4">
                  <div className="p-3 bg-primary/10 rounded-lg">
                    <DollarSign className="w-6 h-6 text-primary" />
                  </div>
                </div>
                <h3 className="text-sm font-medium text-text-secondary mb-1">
                  {t('analyticsPage.totalRevenue')}
                </h3>
                <p className="text-2xl font-bold text-text-primary">
                  ${analytics.totalRevenue.toFixed(2)}
                </p>
              </div>

              <div className="p-6 bg-white rounded-lg border border-border">
                <div className="flex items-center justify-between mb-4">
                  <div className="p-3 bg-info/10 rounded-lg">
                    <ShoppingBag className="w-6 h-6 text-info" />
                  </div>
                </div>
                <h3 className="text-sm font-medium text-text-secondary mb-1">
                  {t('analyticsPage.totalOrders')}
                </h3>
                <p className="text-2xl font-bold text-text-primary">
                  {analytics.totalOrders}
                </p>
              </div>

              <div className="p-6 bg-white rounded-lg border border-border">
                <div className="flex items-center justify-between mb-4">
                  <div className="p-3 bg-warning/10 rounded-lg">
                    <TrendingUp className="w-6 h-6 text-warning" />
                  </div>
                </div>
                <h3 className="text-sm font-medium text-text-secondary mb-1">
                  {t('analyticsPage.avgOrderValue')}
                </h3>
                <p className="text-2xl font-bold text-text-primary">
                  ${analytics.averageOrderValue.toFixed(2)}
                </p>
              </div>

              <div className="p-6 bg-white rounded-lg border border-border">
                <div className="flex items-center justify-between mb-4">
                  <div className="p-3 bg-success/10 rounded-lg">
                    <BarChart3 className="w-6 h-6 text-success" />
                  </div>
                </div>
                <h3 className="text-sm font-medium text-text-secondary mb-1">
                  {t('analyticsPage.activeOrders')}
                </h3>
                <p className="text-2xl font-bold text-text-primary">
                  {analytics.pendingOrders + analytics.preparingOrders + analytics.readyOrders}
                </p>
              </div>
            </div>

            {/* Top Items */}
            {analytics.topItems && analytics.topItems.length > 0 && (
              <div className="p-6 bg-white rounded-lg border border-border">
                <h2 className="text-xl font-bold text-text-primary mb-4">
                  {t('analyticsPage.topItems')}
                </h2>
                <div className="space-y-3">
                  {analytics.topItems.map((item, index) => (
                    <div
                      key={index}
                      className="flex items-center justify-between p-4 bg-surface rounded-lg"
                    >
                      <div className="flex items-center gap-3">
                        <div className="w-8 h-8 bg-primary/10 rounded-full flex items-center justify-center">
                          <span className="text-primary font-bold">
                            {index + 1}
                          </span>
                        </div>
                        <div>
                          <p className="font-semibold text-text-primary">
                            {item.name}
                          </p>
                          <p className="text-sm text-text-secondary">
                            {item.count} {t('analyticsPage.ordersCount')}
                          </p>
                        </div>
                      </div>
                      <div className="text-right">
                        <p className="font-bold text-text-primary">
                          ${item.revenue.toFixed(2)}
                        </p>
                        <p className="text-sm text-text-secondary">{t('analyticsPage.revenue')}</p>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </>
        ) : (
          <div className="p-12 text-center bg-white rounded-lg border border-border">
            <BarChart3 className="w-12 h-12 text-text-tertiary mx-auto mb-4" />
            <p className="text-text-secondary">{t('analyticsPage.noData')}</p>
          </div>
        )}
      </div>
    </DashboardLayout>
  )
}
