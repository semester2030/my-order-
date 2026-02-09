'use client'

import { useEffect, useState } from 'react'
import { DashboardLayout } from '@/components/layout/dashboard-layout'
import { menuApi, MenuItem } from '@/lib/api/menu'
import { Plus, Edit, Trash2, Eye, EyeOff } from 'lucide-react'
import { cn } from '@/lib/utils/cn'
import { AddServiceModal } from '@/components/menu/add-service-modal'
import { EditMenuItemModal } from '@/components/menu/edit-menu-item-modal'
import { useLanguage } from '@/lib/contexts/language-context'

/**
 * صفحة "ما أقدمه للزبائن" — الخدمات أو الوجبات التي يمكن أن تقدمها (بدون فيديو).
 */
export default function ServicesPage() {
  const { t } = useLanguage()
  const [items, setItems] = useState<MenuItem[]>([])
  const [isLoading, setIsLoading] = useState(true)
  const [showAddModal, setShowAddModal] = useState(false)
  const [editingItem, setEditingItem] = useState<MenuItem | null>(null)

  useEffect(() => {
    fetchItems()
  }, [])

  const fetchItems = async () => {
    try {
      setIsLoading(true)
      const data = await menuApi.getMenu()
      setItems(data)
    } catch (error) {
      console.error('Failed to fetch services:', error)
    } finally {
      setIsLoading(false)
    }
  }

  const handleToggleAvailability = async (id: string) => {
    try {
      await menuApi.toggleAvailability(id)
      fetchItems()
    } catch (error) {
      console.error('Failed to toggle availability:', error)
      alert(t('servicesPage.failedUpdate'))
    }
  }

  const handleDelete = async (id: string) => {
    if (!confirm(t('servicesPage.confirmDelete'))) return
    try {
      await menuApi.deleteMenuItem(id)
      fetchItems()
    } catch (error) {
      console.error('Failed to delete:', error)
      alert(t('servicesPage.failedDelete'))
    }
  }

  return (
    <DashboardLayout>
      <div className="space-y-6">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold text-text-primary">
              {t('servicesPage.title')}
            </h1>
            <p className="text-text-secondary mt-1">
              {t('servicesPage.subtitle')}
            </p>
          </div>
          <button
            onClick={() => setShowAddModal(true)}
            className="flex items-center gap-2 px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors"
          >
            <Plus className="w-5 h-5" />
            {t('servicesPage.addItem')}
          </button>
        </div>

        {isLoading ? (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {[...Array(6)].map((_, i) => (
              <div
                key={i}
                className="p-6 bg-white rounded-lg border border-border animate-pulse"
              >
                <div className="h-4 bg-surface rounded w-3/4 mb-2" />
                <div className="h-4 bg-surface rounded w-1/2 mb-4" />
                <div className="h-8 bg-surface rounded w-1/4" />
              </div>
            ))}
          </div>
        ) : items.length === 0 ? (
          <div className="p-12 text-center bg-white rounded-lg border border-border">
            <p className="text-text-secondary mb-4">{t('servicesPage.noItemsYet')}</p>
            <button
              onClick={() => setShowAddModal(true)}
              className="px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors"
            >
              {t('servicesPage.addFirstItem')}
            </button>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {items.map((item) => (
              <div
                key={item.id}
                className="p-6 bg-white rounded-lg border border-border hover:shadow-md transition-shadow"
              >
                <div className="flex items-start justify-between mb-2">
                  <div className="flex-1">
                    <h3 className="text-lg font-semibold text-text-primary">
                      {item.name}
                    </h3>
                    {item.description && (
                      <p className="text-sm text-text-secondary mt-1 line-clamp-2">
                        {item.description}
                      </p>
                    )}
                  </div>
                </div>
                <div className="flex items-center justify-between mb-4">
                  <p className="text-xl font-bold text-text-primary">
                    {typeof item.price === 'number' && item.price > 0
                      ? `$${item.price.toFixed(2)}`
                      : t('servicesPage.priceOnRequest')}
                  </p>
                  <span
                    className={cn(
                      'px-3 py-1 rounded-full text-xs font-medium',
                      item.isAvailable
                        ? 'bg-success/10 text-success'
                        : 'bg-error/10 text-error',
                    )}
                  >
                    {item.isAvailable
                      ? t('servicesPage.available')
                      : t('servicesPage.unavailable')}
                  </span>
                </div>
                <div className="flex items-center gap-2 flex-wrap">
                  <button
                    onClick={() => handleToggleAvailability(item.id)}
                    className={cn(
                      'flex-1 flex items-center justify-center gap-2 px-3 py-2 rounded-lg text-sm font-medium transition-colors',
                      item.isAvailable
                        ? 'bg-error/10 text-error hover:bg-error/20'
                        : 'bg-success/10 text-success hover:bg-success/20',
                    )}
                  >
                    {item.isAvailable ? (
                      <>
                        <EyeOff className="w-4 h-4" />
                        {t('servicesPage.hide')}
                      </>
                    ) : (
                      <>
                        <Eye className="w-4 h-4" />
                        {t('servicesPage.show')}
                      </>
                    )}
                  </button>
                  <button
                    onClick={() => setEditingItem(item)}
                    className="p-2 text-text-secondary hover:text-text-primary hover:bg-surface rounded-lg transition-colors"
                    title={t('servicesPage.edit')}
                  >
                    <Edit className="w-4 h-4" />
                  </button>
                  <button
                    onClick={() => handleDelete(item.id)}
                    className="p-2 text-error hover:bg-error/10 rounded-lg transition-colors"
                    title={t('servicesPage.delete')}
                  >
                    <Trash2 className="w-4 h-4" />
                  </button>
                </div>
              </div>
            ))}
          </div>
        )}

        <AddServiceModal
          isOpen={showAddModal}
          onClose={() => setShowAddModal(false)}
          onSuccess={() => {
            fetchItems()
            setShowAddModal(false)
          }}
        />

        <EditMenuItemModal
          isOpen={!!editingItem}
          item={editingItem}
          onClose={() => setEditingItem(null)}
          onSuccess={() => {
            fetchItems()
            setEditingItem(null)
          }}
        />
      </div>
    </DashboardLayout>
  )
}
