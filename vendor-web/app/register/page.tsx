'use client'

import { useState, useMemo } from 'react'
import { useRouter } from 'next/navigation'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { vendorsRegisterApi, RegisterVendorDto } from '@/lib/api/vendors-register'
import Link from 'next/link'
import { Plus, Trash2 } from 'lucide-react'
import { useLanguage } from '@/lib/contexts/language-context'

export type PopularCookingAddOn = { id: number; name: string; price: number }

const RESTAURANT_TYPE_KEYS = [
  { value: 'premium_casual', labelKey: 'register.typePremiumCasual' as const },
  { value: 'fine_dining', labelKey: 'register.typeFineDining' as const },
  { value: 'fast_food', labelKey: 'register.typeFastFood' as const },
  { value: 'cafe', labelKey: 'register.typeCafe' as const },
  { value: 'bakery', labelKey: 'register.typeBakery' as const },
  { value: 'food_truck', labelKey: 'register.typeFoodTruck' as const },
]

const PROVIDER_CATEGORY_KEYS = [
  { value: '', labelKey: 'register.categoryPlaceholder' as const },
  { value: 'home_cooking', labelKey: 'register.categoryHomeCooking' as const },
  { value: 'popular_cooking', labelKey: 'register.categoryPopularCooking' as const },
  { value: 'private_events', labelKey: 'register.categoryPrivateEvents' as const },
  { value: 'grilling', labelKey: 'register.categoryGrilling' as const },
]

type RegisterFormData = {
  name: string
  email: string
  password: string
  confirmPassword: string
  phoneNumber?: string
  providerCategory?: string
  tradeName?: string
  type?: string
  description?: string
  website?: string
  address?: string
  city?: string
  latitude?: number
  longitude?: number
  deliveryFee?: number
  deliveryRadius?: number
  estimatedDeliveryTime?: number
  ownerName?: string
  ownerPhone?: string
  ownerEmail?: string
  ownerIdNumber?: string
  commercialRegistrationNumber?: string
  commercialRegistrationIssueDate?: string
  commercialRegistrationExpiryDate?: string
  termsAccepted?: boolean
  privacyAccepted?: boolean
}

export default function RegisterPage() {
  const router = useRouter()
  const { t, lang, setLang } = useLanguage()
  const [error, setError] = useState<string | null>(null)
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [showOptional, setShowOptional] = useState(false)

  const [commercialRegistrationFile, setCommercialRegistrationFile] = useState<File | null>(null)
  const [ownerIdFile, setOwnerIdFile] = useState<File | null>(null)
  const [logoFile, setLogoFile] = useState<File | null>(null)
  const [coverFile, setCoverFile] = useState<File | null>(null)
  const [restaurantImages, setRestaurantImages] = useState<File[]>([])
  const [popularCookingAddOns, setPopularCookingAddOns] = useState<PopularCookingAddOn[]>([])
  const [addOnIdCounter, setAddOnIdCounter] = useState(0)

  const registerSchema = useMemo(
    () =>
      z
        .object({
          name: z.string().min(2, t('register.nameMin')),
          email: z.string().email(t('register.invalidEmail')),
          password: z
            .string()
            .min(8, t('register.passwordMin'))
            .regex(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/, t('register.passwordPattern')),
          confirmPassword: z.string(),
          phoneNumber: z.string().optional(),
          providerCategory: z.string().optional(),
          tradeName: z.string().optional(),
          type: z.string().optional(),
          description: z.string().optional(),
          website: z.string().url(t('register.invalidUrl')).optional().or(z.literal('')),
          address: z.string().optional(),
          city: z.string().optional(),
          latitude: z.number().optional(),
          longitude: z.number().optional(),
          deliveryFee: z.number().optional(),
          deliveryRadius: z.number().optional(),
          estimatedDeliveryTime: z.number().optional(),
          ownerName: z.string().optional(),
          ownerPhone: z.string().optional(),
          ownerEmail: z.string().optional(),
          ownerIdNumber: z.string().optional(),
          commercialRegistrationNumber: z.string().optional(),
          commercialRegistrationIssueDate: z.string().optional(),
          commercialRegistrationExpiryDate: z.string().optional(),
          termsAccepted: z.boolean().optional(),
          privacyAccepted: z.boolean().optional(),
        })
        .refine((data) => data.password === data.confirmPassword, {
          message: t('register.passwordMismatch'),
          path: ['confirmPassword'],
        }),
    [t]
  )

  const {
    register,
    handleSubmit,
    formState: { errors },
    watch,
  } = useForm<RegisterFormData>({
    resolver: zodResolver(registerSchema),
    defaultValues: {
      name: '',
      email: '',
      password: '',
      confirmPassword: '',
      phoneNumber: '',
      providerCategory: '',
      type: 'premium_casual',
      tradeName: '',
      description: '',
      website: '',
      address: '',
      city: '',
      deliveryFee: 15,
      deliveryRadius: 10,
      estimatedDeliveryTime: 30,
      termsAccepted: false,
      privacyAccepted: false,
    },
  })

  const providerCategory = watch('providerCategory')

  const addPopularCookingAddOn = () => {
    const nextId = addOnIdCounter + 1
    setAddOnIdCounter(nextId)
    setPopularCookingAddOns((prev) => [...prev, { id: nextId, name: '', price: 0 }])
  }
  const removePopularCookingAddOn = (id: number) => {
    setPopularCookingAddOns((prev) => prev.filter((a) => a.id !== id))
  }
  const updatePopularCookingAddOn = (id: number, field: 'name' | 'price', value: string | number) => {
    setPopularCookingAddOns((prev) =>
      prev.map((a) => (a.id === id ? { ...a, [field]: value } : a)),
    )
  }

  const handleFileChange = (
    e: React.ChangeEvent<HTMLInputElement>,
    setter: (file: File | null) => void,
    maxSizeMB: number = 5,
  ) => {
    const file = e.target.files?.[0]
    if (file) {
      if (file.size > maxSizeMB * 1024 * 1024) {
        alert(`File size must be less than ${maxSizeMB}MB`)
        return
      }
      setter(file)
    }
  }

  const handleRestaurantImagesChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = Array.from(e.target.files || [])
    if (files.length > 10) {
      alert('Maximum 10 images allowed')
      return
    }
    setRestaurantImages(files)
  }

  const onSubmit = async (data: RegisterFormData) => {
    try {
      setIsSubmitting(true)
      setError(null)

      const registerData: RegisterVendorDto = {
        name: data.name.trim(),
        email: data.email.trim(),
        password: data.password,
      }
      if (data.phoneNumber?.trim()) registerData.phoneNumber = data.phoneNumber.trim()
      if (data.providerCategory?.trim()) registerData.providerCategory = data.providerCategory.trim()
      if (data.tradeName?.trim()) registerData.tradeName = data.tradeName.trim()
      if (data.type) registerData.type = data.type
      if (data.description?.trim()) registerData.description = data.description.trim()
      if (data.website?.trim()) registerData.website = data.website.trim()
      if (data.address?.trim()) registerData.address = data.address.trim()
      if (data.city?.trim()) registerData.city = data.city.trim()
      if (data.latitude !== undefined) registerData.latitude = data.latitude
      if (data.longitude !== undefined) registerData.longitude = data.longitude
      if (data.deliveryFee !== undefined) registerData.deliveryFee = data.deliveryFee
      if (data.deliveryRadius !== undefined) registerData.deliveryRadius = data.deliveryRadius
      if (data.estimatedDeliveryTime !== undefined) registerData.estimatedDeliveryTime = data.estimatedDeliveryTime
      if (data.ownerName?.trim()) registerData.ownerName = data.ownerName.trim()
      if (data.ownerPhone?.trim()) registerData.ownerPhone = data.ownerPhone.trim()
      if (data.ownerEmail?.trim()) registerData.ownerEmail = data.ownerEmail.trim()
      if (data.ownerIdNumber?.trim()) registerData.ownerIdNumber = data.ownerIdNumber.trim()
      if (data.commercialRegistrationNumber?.trim()) registerData.commercialRegistrationNumber = data.commercialRegistrationNumber.trim()
      if (data.commercialRegistrationIssueDate?.trim()) registerData.commercialRegistrationIssueDate = data.commercialRegistrationIssueDate.trim()
      if (data.commercialRegistrationExpiryDate?.trim()) registerData.commercialRegistrationExpiryDate = data.commercialRegistrationExpiryDate.trim()
      if (data.termsAccepted !== undefined) registerData.termsAccepted = data.termsAccepted
      if (data.privacyAccepted !== undefined) registerData.privacyAccepted = data.privacyAccepted
      if (data.providerCategory === 'popular_cooking' && popularCookingAddOns.length > 0) {
        const addOnsPayload = popularCookingAddOns
          .filter((a) => (a.name || '').trim())
          .map((a) => ({ name: a.name.trim(), price: Number(a.price) || 0 }))
        if (addOnsPayload.length > 0) {
          registerData.popularCookingAddOns = JSON.stringify(addOnsPayload)
        }
      }
      if (commercialRegistrationFile) registerData.commercialRegistration = commercialRegistrationFile
      if (ownerIdFile) registerData.ownerId = ownerIdFile
      if (logoFile) registerData.logo = logoFile
      if (coverFile) registerData.cover = coverFile
      if (restaurantImages.length > 0) registerData.restaurantImages = restaurantImages

      const response = await vendorsRegisterApi.register(registerData)
      router.push(`/login?registered=true&vendorId=${response.vendorId}`)
    } catch (err: any) {
      console.error('Registration error:', err)
      setError(err.response?.data?.message || t('register.registerFailed'))
    } finally {
      setIsSubmitting(false)
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-primary-container to-accent-container py-12 px-4">
      <div className="max-w-4xl mx-auto">
        <div className="bg-white rounded-xl shadow-lg p-8">
          <div className="flex justify-end mb-6">
            <div className="flex items-center gap-1 border border-border rounded-lg overflow-hidden">
              <button
                type="button"
                onClick={() => setLang('ar')}
                className={`px-3 py-1.5 text-sm font-medium transition-colors ${
                  lang === 'ar' ? 'bg-primary text-white' : 'bg-surface text-text-secondary hover:bg-surface/80'
                }`}
              >
                ع
              </button>
              <button
                type="button"
                onClick={() => setLang('en')}
                className={`px-3 py-1.5 text-sm font-medium transition-colors ${
                  lang === 'en' ? 'bg-primary text-white' : 'bg-surface text-text-secondary hover:bg-surface/80'
                }`}
              >
                EN
              </button>
            </div>
          </div>
          <div className="text-center mb-8">
            <h1 className="text-3xl font-bold text-text-primary mb-2">
              {t('register.title')}
            </h1>
            <p className="text-text-secondary">
              {t('register.subtitle')}
            </p>
          </div>

          {error && (
            <div className="mb-6 p-4 bg-error/10 border border-error/20 rounded-lg text-error text-sm">
              {error}
            </div>
          )}

          <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
            {/* الضروري فقط */}
            <div className="space-y-4">
              <h2 className="text-lg font-semibold text-text-primary">
                {t('register.requiredData')}
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-text-primary mb-2">
                    {t('register.name')} <span className="text-error">*</span>
                  </label>
                  <input
                    {...register('name')}
                    type="text"
                    placeholder="مثال: مطبخ أم محمد"
                    className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  />
                  {errors.name && (
                    <p className="mt-1 text-sm text-error">{errors.name.message}</p>
                  )}
                </div>
                <div>
                  <label className="block text-sm font-medium text-text-primary mb-2">
                    {t('register.email')} <span className="text-error">*</span>
                  </label>
                  <input
                    {...register('email')}
                    type="email"
                    placeholder="example@email.com"
                    className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  />
                  {errors.email && (
                    <p className="mt-1 text-sm text-error">{errors.email.message}</p>
                  )}
                </div>
                <div>
                  <label className="block text-sm font-medium text-text-primary mb-2">
                    {t('register.password')} <span className="text-error">*</span>
                  </label>
                  <input
                    {...register('password')}
                    type="password"
                    placeholder="8+ أحرف، حرف كبير وصغير ورقم"
                    className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  />
                  {errors.password && (
                    <p className="mt-1 text-sm text-error">{errors.password.message}</p>
                  )}
                </div>
                <div>
                  <label className="block text-sm font-medium text-text-primary mb-2">
                    {t('register.confirmPassword')} <span className="text-error">*</span>
                  </label>
                  <input
                    {...register('confirmPassword')}
                    type="password"
                    className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                  />
                  {errors.confirmPassword && (
                    <p className="mt-1 text-sm text-error">{errors.confirmPassword.message}</p>
                  )}
                </div>
              </div>
            </div>

            {/* اختياري: رقم الجوال + فئة الخدمة */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-text-primary mb-2">
                  {t('register.phoneOptional')}
                </label>
                <input
                  {...register('phoneNumber')}
                  type="tel"
                  placeholder="05XXXXXXXX"
                  className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-text-primary mb-2">
                  {t('register.categoryOptional')}
                </label>
                <select
                  {...register('providerCategory')}
                  className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                >
                  {PROVIDER_CATEGORY_KEYS.map((cat) => (
                    <option key={cat.value || 'empty'} value={cat.value}>
                      {t(cat.labelKey)}
                    </option>
                  ))}
                </select>
              </div>
            </div>

            {/* خدمات إضافية للطبخ الشعبي (جريش، قرصان، ادامات…) — تظهر للعميل لطلبها */}
            {providerCategory === 'popular_cooking' && (
              <div className="mt-4 p-4 border border-border rounded-lg bg-surface/50 space-y-3">
                <h3 className="text-sm font-semibold text-text-primary">
                  {t('register.popularCookingAddOnsTitle')}
                </h3>
                <p className="text-xs text-text-secondary">
                  {t('register.popularCookingAddOnsHint')}
                </p>
                {popularCookingAddOns.map((addOn) => (
                  <div key={addOn.id} className="flex gap-2 items-center">
                    <input
                      type="text"
                      placeholder={t('register.addOnName')}
                      value={addOn.name}
                      onChange={(e) => updatePopularCookingAddOn(addOn.id, 'name', e.target.value)}
                      className="flex-1 px-3 py-2 border border-border rounded-lg text-sm"
                    />
                    <input
                      type="number"
                      min={0}
                      step={0.01}
                      placeholder={t('register.addOnPrice')}
                      value={addOn.price || ''}
                      onChange={(e) =>
                        updatePopularCookingAddOn(addOn.id, 'price', parseFloat(e.target.value) || 0)
                      }
                      className="w-24 px-3 py-2 border border-border rounded-lg text-sm"
                    />
                    <button
                      type="button"
                      onClick={() => removePopularCookingAddOn(addOn.id)}
                      className="p-2 text-error hover:bg-error/10 rounded-lg"
                      title={t('register.removeAddOn')}
                    >
                      <Trash2 className="w-4 h-4" />
                    </button>
                  </div>
                ))}
                <button
                  type="button"
                  onClick={addPopularCookingAddOn}
                  className="flex items-center gap-2 text-sm text-primary hover:underline"
                >
                  <Plus className="w-4 h-4" />
                  {t('register.addAddOn')}
                </button>
              </div>
            )}

            {/* بقية البيانات اختياري — قابلة للتوسيع */}
            <div>
              <button
                type="button"
                onClick={() => setShowOptional(!showOptional)}
                className="text-sm text-primary hover:underline"
              >
                {showOptional ? t('register.hideOptional') : t('register.addOptional')}
              </button>
              {showOptional && (
              <div className="mt-4 p-4 border border-border rounded-lg space-y-4 bg-surface/50">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <label className="block text-sm font-medium text-text-primary mb-2">{t('register.tradeName')}</label>
                    <input {...register('tradeName')} type="text" className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary" />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-text-primary mb-2">{t('register.establishmentType')}</label>
                    <select {...register('type')} className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary">
                      {RESTAURANT_TYPE_KEYS.map((opt) => (
                        <option key={opt.value} value={opt.value}>{t(opt.labelKey)}</option>
                      ))}
                    </select>
                  </div>
                  <div className="md:col-span-2">
                    <label className="block text-sm font-medium text-text-primary mb-2">{t('register.description')}</label>
                    <textarea {...register('description')} rows={2} className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary" />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-text-primary mb-2">{t('register.address')}</label>
                    <input {...register('address')} type="text" className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary" />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-text-primary mb-2">{t('register.city')}</label>
                    <input {...register('city')} type="text" className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary" />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-text-primary mb-2">{t('register.ownerName')}</label>
                    <input {...register('ownerName')} type="text" className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary" />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-text-primary mb-2">{t('register.ownerPhone')}</label>
                    <input {...register('ownerPhone')} type="tel" className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary" />
                  </div>
                </div>
                <p className="text-xs text-text-secondary">
                  {t('register.optionalNote')}
                </p>
              </div>
              )}
            </div>

            {/* زر التسجيل */}
            <div className="flex flex-col sm:flex-row gap-4 justify-between items-center pt-4">
              <button
                type="submit"
                disabled={isSubmitting}
                className="w-full sm:w-auto px-6 py-3 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors disabled:opacity-50 disabled:cursor-not-allowed font-medium"
              >
                {isSubmitting ? t('register.submitting') : t('register.submit')}
              </button>
            </div>
          </form>

          <div className="text-center pt-6 border-t border-border mt-6">
            <p className="text-sm text-text-secondary">
              {t('register.haveAccount')}{' '}
              <Link href="/login" className="text-primary hover:text-primary-dark font-medium">
                {t('register.signIn')}
              </Link>
            </p>
          </div>
        </div>
      </div>
    </div>
  )
}

