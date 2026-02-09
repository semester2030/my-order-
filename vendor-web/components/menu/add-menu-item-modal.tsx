'use client'

import { useState, useMemo } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { X, Video } from 'lucide-react'
import { menuApi, CreateMenuItemDto } from '@/lib/api/menu'
import { videosApi } from '@/lib/api/videos'
import { useLanguage } from '@/lib/contexts/language-context'
import { useVendorProfile } from '@/lib/contexts/vendor-profile-context'

type MenuItemFormData = {
  name: string
  description?: string
  price: number
  isSignature: boolean
  isAvailable: boolean
}

interface AddMenuItemModalProps {
  isOpen: boolean
  onClose: () => void
  onSuccess: () => void
}

/** إضافة وجبة أو خدمة — مع الفيديو إجباري. العبارات تتغير حسب الفئة (طبخ الولائم للطبخ الشعبي). */
export function AddMenuItemModal({
  isOpen,
  onClose,
  onSuccess,
}: AddMenuItemModalProps) {
  const { t } = useLanguage()
  const { profile } = useVendorProfile()
  const isPopularCooking = profile?.providerCategory === 'popular_cooking'
  const [videoFile, setVideoFile] = useState<File | null>(null)
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [uploadProgress, setUploadProgress] = useState(0)

  const menuItemSchema = useMemo(
    () =>
      z.object({
        name: z.string().min(2, t('menuItem.nameMin')),
        description: z.string().optional(),
        price: z.number().min(0.01, t('menuItem.priceMin')),
        isSignature: z.boolean().default(false),
        isAvailable: z.boolean().default(true),
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
    defaultValues: {
      isSignature: false,
      isAvailable: true,
    },
  })

  const isSignature = watch('isSignature')
  const isAvailable = watch('isAvailable')

  if (!isOpen) return null

  const handleVideoChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0]
    if (file) {
      if (file.size > 500 * 1024 * 1024) {
        alert(t('menuItem.videoMax500mb'))
        return
      }
      if (!file.type.startsWith('video/')) {
        alert(t('menuItem.selectValidVideo'))
        return
      }
      setVideoFile(file)
    }
  }

  const onSubmit = async (data: MenuItemFormData) => {
    if (!videoFile) {
      alert(t('menuItem.videoRequired'))
      return
    }
    try {
      setIsSubmitting(true)
      setUploadProgress(0)

      const createData: CreateMenuItemDto = {
        name: data.name,
        description: data.description,
        price: data.price,
        isSignature: data.isSignature,
        isAvailable: data.isAvailable,
      }
      setUploadProgress(20)
      const menuItem = await menuApi.createMenuItem(createData)
      setUploadProgress(50)

      await videosApi.uploadVideo(menuItem.id, videoFile)
      setUploadProgress(100)

      reset()
      setVideoFile(null)
      onSuccess()
      onClose()
    } catch (error: any) {
      console.error('Failed to create menu item:', error)
      alert(error.response?.data?.message || t('menuItem.createFailed'))
    } finally {
      setIsSubmitting(false)
      setUploadProgress(0)
    }
  }

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-lg max-w-2xl w-full max-h-[90vh] overflow-y-auto">
        <div className="flex items-center justify-between p-6 border-b border-border">
          <h2 className="text-2xl font-bold text-text-primary">
            {isPopularCooking ? t('menuItem.addTitlePopularCooking') : t('menuItem.addTitle')}
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
              {isPopularCooking ? t('menuItem.namePopularCooking') : t('menuItem.name')} <span className="text-error">*</span>
            </label>
            <input
              {...register('name')}
              type="text"
              className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
              placeholder={isPopularCooking ? t('menuItem.placeholderNamePopularCooking') : t('menuItem.placeholderName')}
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
              placeholder={isPopularCooking ? t('menuItem.placeholderDescPopularCooking') : t('menuItem.placeholderDesc')}
              disabled={isSubmitting}
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-text-primary mb-2">
              {isPopularCooking ? t('menuItem.pricePopularCooking') : t('menuItem.price')} <span className="text-error">*</span>
            </label>
            <input
              {...register('price', { valueAsNumber: true })}
              type="number"
              step="0.01"
              min="0"
              className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
              placeholder={t('menuItem.placeholderPrice')}
              disabled={isSubmitting}
            />
            {errors.price && (
              <p className="mt-1 text-sm text-error">{errors.price.message}</p>
            )}
          </div>

          {/* الفيديو إجباري */}
          <div>
            <label className="block text-sm font-medium text-text-primary mb-2">
              {t('menuItem.videoRequiredLabel')} <span className="text-error">*</span>
            </label>
            <div className="border-2 border-dashed border-primary/50 rounded-lg p-6 text-center bg-primary/5">
              <input
                type="file"
                accept="video/*"
                onChange={handleVideoChange}
                className="hidden"
                id="video-upload-add"
                disabled={isSubmitting}
              />
              <label
                htmlFor="video-upload-add"
                className="cursor-pointer flex flex-col items-center gap-2"
              >
                <Video className="w-10 h-10 text-primary" />
                <span className="text-sm text-text-secondary">
                  {videoFile ? videoFile.name : t('menuItem.clickUploadVideo')}
                </span>
                <span className="text-xs text-text-tertiary">
                  {t('menuItem.max500mb')}
                </span>
              </label>
            </div>
            {!videoFile && (
              <p className="mt-1 text-sm text-error">
                {t('menuItem.videoRequired')}
              </p>
            )}
          </div>

          <div className="space-y-4">
            <label className="flex items-center gap-3 cursor-pointer">
              <input
                type="checkbox"
                checked={isSignature}
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
                checked={isAvailable}
                onChange={(e) => setValue('isAvailable', e.target.checked)}
                className="w-5 h-5 rounded border-border text-primary focus:ring-primary"
                disabled={isSubmitting}
              />
              <span className="text-sm font-medium text-text-primary">
                {t('menuItem.availableNow')}
              </span>
            </label>
          </div>

          {isSubmitting && (
            <div className="space-y-2">
              <div className="flex items-center justify-between text-sm">
                <span className="text-text-secondary">{t('menuItem.uploading')}</span>
                <span className="text-text-primary font-medium">{uploadProgress}%</span>
              </div>
              <div className="w-full bg-surface rounded-full h-2">
                <div
                  className="bg-primary h-2 rounded-full transition-all duration-300"
                  style={{ width: `${uploadProgress}%` }}
                />
              </div>
            </div>
          )}

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
              disabled={isSubmitting || !videoFile}
            >
              {isSubmitting ? t('menuItem.creating') : t('menuItem.createItem')}
            </button>
          </div>
        </form>
      </div>
    </div>
  )
}
