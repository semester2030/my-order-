'use client'

import { useState, useEffect, useMemo } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { X } from 'lucide-react'
import { menuApi, UpdateMenuItemDto, MenuItem } from '@/lib/api/menu'
import { useLanguage } from '@/lib/contexts/language-context'
import { useVendorProfile } from '@/lib/contexts/vendor-profile-context'

type MenuItemFormData = {
  name?: string
  description?: string
  price?: number
  isSignature?: boolean
  isAvailable?: boolean
}

interface EditMenuItemModalProps {
  isOpen: boolean
  item: MenuItem | null
  onClose: () => void
  onSuccess: () => void
}

/** تعديل الوجبة أو الخدمة — العبارات تتغير حسب الفئة (طبخ الولائم للطبخ الشعبي). */
export function EditMenuItemModal({
  isOpen,
  item,
  onClose,
  onSuccess,
}: EditMenuItemModalProps) {
  const { t } = useLanguage()
  const { profile } = useVendorProfile()
  const isPopularCooking = profile?.providerCategory === 'popular_cooking'
  const [isSubmitting, setIsSubmitting] = useState(false)

  const menuItemSchema = useMemo(
    () =>
      z.object({
        name: z.string().min(2, t('menuItem.nameMin')).optional(),
        description: z.string().optional(),
        price: z.number().min(0.01, t('menuItem.priceMin')).optional(),
        isSignature: z.boolean().optional(),
        isAvailable: z.boolean().optional(),
      }),
    [t]
  )

  const {
    register,
    handleSubmit,
    formState: { errors },
    reset,
    watch,
    setValue,
  } = useForm<MenuItemFormData>({
    resolver: zodResolver(menuItemSchema),
  })

  const isSignature = watch('isSignature')
  const isAvailable = watch('isAvailable')

  useEffect(() => {
    if (item) {
      reset({
        name: item.name,
        description: item.description,
        price: typeof item.price === 'string' ? parseFloat(item.price) : item.price,
        isSignature: item.isSignature,
        isAvailable: item.isAvailable,
      })
    }
  }, [item, reset])

  if (!isOpen || !item) return null

  const onSubmit = async (data: MenuItemFormData) => {
    try {
      setIsSubmitting(true)
      const updateData: UpdateMenuItemDto = {
        name: data.name,
        description: data.description,
        price: data.price,
        isSignature: data.isSignature,
        isAvailable: data.isAvailable,
      }
      await menuApi.updateMenuItem(item.id, updateData)
      onSuccess()
      onClose()
    } catch (error: any) {
      console.error('Failed to update menu item:', error)
      alert(error.response?.data?.message || t('menuItem.updateFailed'))
    } finally {
      setIsSubmitting(false)
    }
  }

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-lg max-w-2xl w-full max-h-[90vh] overflow-y-auto">
        <div className="flex items-center justify-between p-6 border-b border-border">
          <h2 className="text-2xl font-bold text-text-primary">
            {isPopularCooking ? t('menuItem.editTitlePopularCooking') : t('menuItem.editTitle')}
          </h2>
          <button
            type="button"
            onClick={onClose}
            className="p-2 hover:bg-surface rounded-lg transition-colors"
            disabled={isSubmitting}
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        <form onSubmit={handleSubmit(onSubmit)} className="p-6 space-y-6">
          <div>
            <label className="block text-sm font-medium text-text-primary mb-2">
              {isPopularCooking ? t('menuItem.namePopularCooking') : t('menuItem.name')}
            </label>
            <input
              {...register('name')}
              type="text"
              className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
              disabled={isSubmitting}
            />
            {errors.name && (
              <p className="mt-1 text-sm text-error">{errors.name.message}</p>
            )}
          </div>

          <div>
            <label className="block text-sm font-medium text-text-primary mb-2">
              {t('menuItem.description')}
            </label>
            <textarea
              {...register('description')}
              rows={3}
              className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
              disabled={isSubmitting}
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-text-primary mb-2">
              {isPopularCooking ? t('menuItem.pricePopularCooking') : t('menuItem.price')}
            </label>
            <input
              {...register('price', { valueAsNumber: true })}
              type="number"
              step="0.01"
              min="0"
              className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
              disabled={isSubmitting}
            />
            {errors.price && (
              <p className="mt-1 text-sm text-error">{errors.price.message}</p>
            )}
          </div>

          <div className="space-y-4">
            <label className="flex items-center gap-3 cursor-pointer">
              <input
                type="checkbox"
                checked={isSignature ?? item.isSignature}
                onChange={(e) => setValue('isSignature', e.target.checked)}
                className="w-5 h-5 rounded border-border text-primary focus:ring-primary"
                disabled={isSubmitting}
              />
              <span className="text-sm font-medium text-text-primary">
                {t('menuItem.signatureDish')}
              </span>
            </label>
            <label className="flex items-center gap-3 cursor-pointer">
              <input
                type="checkbox"
                checked={isAvailable ?? item.isAvailable}
                onChange={(e) => setValue('isAvailable', e.target.checked)}
                className="w-5 h-5 rounded border-border text-primary focus:ring-primary"
                disabled={isSubmitting}
              />
              <span className="text-sm font-medium text-text-primary">
                {t('menuItem.availableNow')}
              </span>
            </label>
          </div>

          <div className="flex items-center gap-4 pt-4 border-t border-border">
            <button
              type="button"
              onClick={onClose}
              className="flex-1 px-4 py-2 border border-border rounded-lg text-text-primary hover:bg-surface transition-colors"
              disabled={isSubmitting}
            >
              {t('menuItem.cancel')}
            </button>
            <button
              type="submit"
              className="flex-1 px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
              disabled={isSubmitting}
            >
              {isSubmitting ? t('menuItem.updating') : t('menuItem.updateItem')}
            </button>
          </div>
        </form>
      </div>
    </div>
  )
}
