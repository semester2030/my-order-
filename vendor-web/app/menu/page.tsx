'use client'

import { useEffect, useState } from 'react'
import { DashboardLayout } from '@/components/layout/dashboard-layout'
import { menuApi, MenuItem } from '@/lib/api/menu'
import { Plus, Edit, Trash2, Star, Eye, EyeOff, Play, Video } from 'lucide-react'
import { cn } from '@/lib/utils/cn'
import { AddMenuItemModal } from '@/components/menu/add-menu-item-modal'
import { EditMenuItemModal } from '@/components/menu/edit-menu-item-modal'
import { AddVideoModal } from '@/components/menu/add-video-modal'
import { useLanguage } from '@/lib/contexts/language-context'

export default function MenuPage() {
  const { t } = useLanguage()
  const [menuItems, setMenuItems] = useState<MenuItem[]>([])
  const [isLoading, setIsLoading] = useState(true)
  const [showAddModal, setShowAddModal] = useState(false)
  const [editingItem, setEditingItem] = useState<MenuItem | null>(null)
  const [videoForItem, setVideoForItem] = useState<MenuItem | null>(null)

  useEffect(() => {
    fetchMenu()
  }, [])

  const fetchMenu = async () => {
    try {
      setIsLoading(true)
      const data = await menuApi.getMenu()
      setMenuItems(data)
    } catch (error) {
      console.error('Failed to fetch menu:', error)
    } finally {
      setIsLoading(false)
    }
  }

  const handleToggleAvailability = async (id: string) => {
    try {
      await menuApi.toggleAvailability(id)
      fetchMenu()
    } catch (error) {
      console.error('Failed to toggle availability:', error)
      alert(t('menuPage.failedUpdate'))
    }
  }

  const handleDelete = async (id: string) => {
    if (!confirm(t('menuPage.confirmDelete'))) return

    try {
      await menuApi.deleteMenuItem(id)
      fetchMenu()
    } catch (error) {
      console.error('Failed to delete menu item:', error)
      alert(t('menuPage.failedDelete'))
    }
  }

  return (
    <DashboardLayout>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold text-text-primary">{t('menuPage.title')}</h1>
            <p className="text-text-secondary mt-1">
              {t('menuPage.subtitle')}
            </p>
          </div>
          <button
            onClick={() => setShowAddModal(true)}
            className="flex items-center gap-2 px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors"
          >
            <Plus className="w-5 h-5" />
            {t('menuPage.addItem')}
          </button>
        </div>

        {/* Menu Grid */}
        {isLoading ? (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {[...Array(6)].map((_, i) => (
              <div
                key={i}
                className="p-6 bg-white rounded-lg border border-border animate-pulse"
              >
                <div className="h-48 bg-surface rounded-lg mb-4"></div>
                <div className="h-4 bg-surface rounded w-3/4 mb-2"></div>
                <div className="h-4 bg-surface rounded w-1/2"></div>
              </div>
            ))}
          </div>
        ) : menuItems.length === 0 ? (
          <div className="p-12 text-center bg-white rounded-lg border border-border">
            <p className="text-text-secondary mb-4">{t('menuPage.noItemsYet')}</p>
            <button
              onClick={() => setShowAddModal(true)}
              className="px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors"
            >
              {t('menuPage.addFirstItem')}
            </button>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {menuItems.map((item) => (
              <div
                key={item.id}
                className="p-6 bg-white rounded-lg border border-border hover:shadow-md transition-shadow"
              >
                {/* Video or Image */}
                {(() => {
                  const primaryVideo = item.videoAssets?.find(v => v.isPrimary && v.status === 'ready');
                  
                  if (primaryVideo?.playbackUrl) {
                    return (
                      <div className="relative w-full h-48 rounded-lg mb-4 overflow-hidden bg-black">
                        <video
                          src={primaryVideo.playbackUrl}
                          className="w-full h-full object-cover"
                          controls
                          poster={primaryVideo.thumbnailUrl || undefined}
                        />
                        <div className="absolute top-2 right-2 bg-black/50 text-white px-2 py-1 rounded text-xs">
                          <Play className="w-3 h-3 inline mr-1" />
                          {t('menuPage.video')}
                        </div>
                      </div>
                    );
                  } else if (item.image) {
                    return (
                      <img
                        src={item.image}
                        alt={item.name}
                        className="w-full h-48 object-cover rounded-lg mb-4"
                      />
                    );
                  } else {
                    return (
                      <div className="w-full h-48 bg-surface rounded-lg mb-4 flex items-center justify-center">
                        <span className="text-text-tertiary">{t('menuPage.noImage')}</span>
                      </div>
                    );
                  }
                })()}

                <div className="flex items-start justify-between mb-2">
                  <div className="flex-1">
                    <div className="flex items-center gap-2 mb-1">
                      <h3 className="text-lg font-semibold text-text-primary">
                        {item.name}
                      </h3>
                      {item.isSignature && (
                        <Star className="w-4 h-4 text-accent fill-accent" />
                      )}
                    </div>
                    {item.description && (
                      <p className="text-sm text-text-secondary mb-2 line-clamp-2">
                        {item.description}
                      </p>
                    )}
                  </div>
                </div>

                <div className="flex items-center justify-between mb-4">
                  <p className="text-xl font-bold text-text-primary">
                    ${typeof item.price === 'number' ? item.price.toFixed(2) : parseFloat(String(item.price || 0)).toFixed(2)}
                  </p>
                  <span
                    className={cn(
                      'px-3 py-1 rounded-full text-xs font-medium',
                      item.isAvailable
                        ? 'bg-success/10 text-success'
                        : 'bg-error/10 text-error',
                    )}
                  >
                    {item.isAvailable ? t('menuPage.available') : t('menuPage.unavailable')}
                  </span>
                </div>

                <div className="flex items-center gap-2 flex-wrap">
                  <button
                    onClick={() => setVideoForItem(item)}
                    className="p-2 text-primary hover:bg-primary/10 rounded-lg transition-colors"
                    title={t('menuItem.addVideo')}
                  >
                    <Video className="w-5 h-5" />
                  </button>
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
                        {t('menuPage.hide')}
                      </>
                    ) : (
                      <>
                        <Eye className="w-4 h-4" />
                        {t('menuPage.show')}
                      </>
                    )}
                  </button>
                  <button
                    onClick={() => setEditingItem(item)}
                    className="p-2 text-text-secondary hover:text-text-primary hover:bg-surface rounded-lg transition-colors"
                    title={t('menuPage.edit')}
                  >
                    <Edit className="w-4 h-4" />
                  </button>
                  <button
                    onClick={() => handleDelete(item.id)}
                    className="p-2 text-error hover:bg-error/10 rounded-lg transition-colors"
                    title={t('menuPage.delete')}
                  >
                    <Trash2 className="w-4 h-4" />
                  </button>
                </div>
              </div>
            ))}
          </div>
        )}

        {/* Add Modal */}
        <AddMenuItemModal
          isOpen={showAddModal}
          onClose={() => setShowAddModal(false)}
          onSuccess={() => {
            fetchMenu()
            setShowAddModal(false)
          }}
        />

        {/* Edit Modal */}
        <EditMenuItemModal
          isOpen={!!editingItem}
          item={editingItem}
          onClose={() => setEditingItem(null)}
          onSuccess={() => {
            fetchMenu()
            setEditingItem(null)
          }}
        />

        {/* أيقونة ثانية: إضافة فيديو لوجبة موجودة */}
        <AddVideoModal
          isOpen={!!videoForItem}
          menuItemId={videoForItem?.id ?? ''}
          menuItemName={videoForItem?.name ?? ''}
          onClose={() => setVideoForItem(null)}
          onSuccess={() => {
            fetchMenu()
            setVideoForItem(null)
          }}
        />
      </div>
    </DashboardLayout>
  )
}
