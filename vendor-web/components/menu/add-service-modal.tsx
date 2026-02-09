'use client'

import { useMemo, useState } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { X } from 'lucide-react'
import { menuApi } from '@/lib/api/menu'
import { useLanguage } from '@/lib/contexts/language-context'

type ServiceFormData = {
  name: string
  description?: string
  price: number
  isAvailable: boolean
}

interface AddServiceModalProps {
  isOpen: boolean
  onClose: () => void
  onSuccess: () => void
}

/** إضافة خدمة أو وجبة للطلب عند الطلب — اسم، وصف، سعر فقط. بدون فيديو ولا صورة. تظهر في "طلب طباخة". */
export function AddServiceModal({
  isOpen,
  onClose,
  onSuccess,
}: AddServiceModalProps) {
  const { t } = useLanguage()
  const [isSubmitting, setIsSubmitting] = useState(false)

  const schema = useMemo(
    () =>
      z.object({
        name: z.string().min(2, t('menuItem.nameMin')),
        description: z.string().optional(),
        price: z.number().min(0, t('servicesPage.priceMinZero')),
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
  } = useForm<ServiceFormData>({
    resolver: zodResolver(schema),
    defaultValues: {
      isAvailable: true,
    },
  })

  const isAvailable = watch('isAvailable')

  if (!isOpen) return null

  const onSubmit = async (data: ServiceFormData) => {
    try {
      setIsSubmitting(true)
      await menuApi.createMenuItem({
        name: data.name,
        description: data.description,
        price: data.price,
        isAvailable: data.isAvailable,
      })
      reset()
      onSuccess()
      onClose()
    } catch (error: any) {
      console.error('Failed to add service:', error)
      alert(error.response?.data?.message || t('servicesPage.failedAdd'))
    } finally {
      setIsSubmitting(false)
    }
  }

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-lg max-w-2xl w-full max-h-[90vh] overflow-y-auto">
        <div className="flex items-center justify-between p-6 border-b border-border">
          <h2 className="text-xl font-semibold text-text-primary">
            {t('servicesPage.addItem')}
          </h2>
          <button
            type="button"
            onClick={onClose}
            className="p-2 text-text-secondary hover:text-text-primary hover:bg-surface rounded-lg transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        <form onSubmit={handleSubmit(onSubmit)} className="p-6 space-y-4">
          <div>
            <label className="block text-sm font-medium text-text-primary mb-1">
              {t('menuItem.name')}
            </label>
            <input
              {...register('name')}
              type="text"
              className="w-full px-4 py-2 border border-border rounded-lg focus:ring-2 focus:ring-primary focus:border-primary"
              placeholder={t('menuItem.placeholderName')}
            />
            {errors.name && (
              <p className="mt-1 text-sm text-error">{errors.name.message}</p>
            )}
          </div>

          <div>
            <label className="block text-sm font-medium text-text-primary mb-1">
              {t('menuItem.description')}
            </label>
            <textarea
              {...register('description')}
              rows={3}
              className="w-full px-4 py-2 border border-border rounded-lg focus:ring-2 focus:ring-primary focus:border-primary"
              placeholder={t('menuItem.placeholderDesc')}
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-text-primary mb-1">
              {t('menuItem.price')} ({t('servicesPage.priceOptional')})
            </label>
            <input
              {...register('price', { valueAsNumber: true })}
              type="number"
              step="0.01"
              min={0}
              className="w-full px-4 py-2 border border-border rounded-lg focus:ring-2 focus:ring-primary focus:border-primary"
              placeholder={t('menuItem.placeholderPrice')}
            />
            {errors.price && (
              <p className="mt-1 text-sm text-error">{errors.price.message}</p>
            )}
          </div>

          <div className="flex items-center gap-2">
            <button
              type="button"
              onClick={() => setValue('isAvailable', !isAvailable)}
              className={isAvailable ? 'text-success' : 'text-error'}
            >
              {isAvailable ? t('servicesPage.available') : t('servicesPage.unavailable')}
            </button>
            <input
              type="checkbox"
              {...register('isAvailable')}
              className="rounded border-border"
            />
          </div>

          <div className="flex justify-end gap-2 pt-4">
            <button
              type="button"
              onClick={onClose}
              className="px-4 py-2 text-text-secondary hover:bg-surface rounded-lg transition-colors"
            >
              {t('menuItem.cancel')}
            </button>
            <button
              type="submit"
              disabled={isSubmitting}
              className="px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors disabled:opacity-50"
            >
              {isSubmitting ? t('menuItem.creating') : t('menuItem.createItem')}
            </button>
          </div>
        </form>
      </div>
    </div>
  )
}
