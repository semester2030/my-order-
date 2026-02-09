'use client'

import { useState, useEffect } from 'react'
import { DashboardLayout } from '@/components/layout/dashboard-layout'
import { User, Bell, Lock, CreditCard, Save } from 'lucide-react'
import { vendorsApi, VendorProfile, UpdateVendorProfileDto } from '@/lib/api/vendors'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { SecuritySettings } from '@/components/settings/security-settings'

const profileSchema = z.object({
  name: z.string().min(2, 'Name must be at least 2 characters').optional(),
  tradeName: z.string().optional(),
  description: z.string().optional(),
  email: z.union([z.string().email('Invalid email'), z.literal(''), z.undefined()]).optional(),
  phoneNumber: z.string().optional(),
  website: z.union([z.string().url('Invalid URL'), z.literal(''), z.undefined()]).optional(),
  address: z.string().optional(),
  city: z.string().optional(),
  district: z.string().optional(),
  postalCode: z.string().optional(),
  deliveryFee: z.number().min(0).optional(),
  deliveryRadius: z.number().min(0).optional(),
  estimatedDeliveryTime: z.string().optional(),
  workingHours: z.string().optional(),
  isAcceptingOrders: z.boolean().optional(),
  isActive: z.boolean().optional(),
})

type ProfileFormData = z.infer<typeof profileSchema>

export default function SettingsPage() {
  const [activeTab, setActiveTab] = useState<'profile' | 'notifications' | 'security' | 'payment'>('profile')
  const [profile, setProfile] = useState<VendorProfile | null>(null)
  const [isLoading, setIsLoading] = useState(true)
  const [isSaving, setIsSaving] = useState(false)

  const {
    register,
    handleSubmit,
    formState: { errors },
    reset,
    watch,
    setValue,
  } = useForm<ProfileFormData>({
    resolver: zodResolver(profileSchema),
  })

  const isAcceptingOrders = watch('isAcceptingOrders')
  const isActive = watch('isActive')

  useEffect(() => {
    fetchProfile()
  }, [])

  useEffect(() => {
    if (profile) {
      reset({
        name: profile.name,
        tradeName: profile.tradeName,
        description: profile.description,
        email: profile.email,
        phoneNumber: profile.phoneNumber,
        website: profile.website,
        address: profile.address,
        city: profile.city,
        district: profile.district,
        postalCode: profile.postalCode,
        deliveryFee: profile.deliveryFee,
        deliveryRadius: profile.deliveryRadius,
        estimatedDeliveryTime: profile.estimatedDeliveryTime,
        workingHours: profile.workingHours,
        isAcceptingOrders: profile.isAcceptingOrders,
        isActive: profile.isActive,
      })
    }
  }, [profile, reset])

  const fetchProfile = async () => {
    try {
      setIsLoading(true)
      const data = await vendorsApi.getProfile()
      setProfile(data)
    } catch (error) {
      console.error('Failed to fetch profile:', error)
    } finally {
      setIsLoading(false)
    }
  }

  const onSubmit = async (data: ProfileFormData) => {
    console.log('=== FORM SUBMIT STARTED ===')
    console.log('Form data received:', data)
    console.log('Form errors:', errors)
    console.log('Current profile:', profile)
    
    try {
      setIsSaving(true)
      console.log('Setting isSaving to true')
      
      // Build update data - only include fields that have values
      const updateData: UpdateVendorProfileDto = {}
      
      if (data.name && data.name.trim()) updateData.name = data.name.trim()
      if (data.tradeName && data.tradeName.trim()) updateData.tradeName = data.tradeName.trim()
      if (data.description && data.description.trim()) updateData.description = data.description.trim()
      if (data.email && data.email.trim()) updateData.email = data.email.trim()
      if (data.phoneNumber && data.phoneNumber.trim()) updateData.phoneNumber = data.phoneNumber.trim()
      if (data.website && data.website.trim()) updateData.website = data.website.trim()
      if (data.address && data.address.trim()) updateData.address = data.address.trim()
      if (data.city && data.city.trim()) updateData.city = data.city.trim()
      if (data.district && data.district.trim()) updateData.district = data.district.trim()
      if (data.postalCode && data.postalCode.trim()) updateData.postalCode = data.postalCode.trim()
      if (data.deliveryFee !== undefined) updateData.deliveryFee = data.deliveryFee
      if (data.deliveryRadius !== undefined) updateData.deliveryRadius = data.deliveryRadius
      if (data.estimatedDeliveryTime && data.estimatedDeliveryTime.trim()) updateData.estimatedDeliveryTime = data.estimatedDeliveryTime.trim()
      if (data.workingHours && data.workingHours.trim()) updateData.workingHours = data.workingHours.trim()
      
      // Always include boolean values if they are defined
      if (data.isAcceptingOrders !== undefined) updateData.isAcceptingOrders = data.isAcceptingOrders
      if (data.isActive !== undefined) updateData.isActive = data.isActive
      
      console.log('Update data to send:', updateData)
      
      const response = await vendorsApi.updateProfile(updateData)
      console.log('Update response received:', response)
      
      await fetchProfile()
      console.log('Profile refreshed')
      alert('Profile updated successfully!')
    } catch (error: any) {
      console.error('=== ERROR IN FORM SUBMIT ===')
      console.error('Error object:', error)
      console.error('Error message:', error.message)
      console.error('Error response:', error.response)
      console.error('Error response data:', error.response?.data)
      console.error('Error status:', error.response?.status)
      alert(`Failed to update profile: ${error.response?.data?.message || error.message || 'Unknown error'}. Check console for details.`)
    } finally {
      setIsSaving(false)
      console.log('Setting isSaving to false')
    }
  }
  

  return (
    <DashboardLayout>
      <div className="space-y-6">
        <div>
          <h1 className="text-3xl font-bold text-text-primary">Settings</h1>
          <p className="text-text-secondary mt-1">
            Manage your restaurant settings and preferences
          </p>
        </div>

        {/* Tabs */}
        <div className="flex items-center gap-4 border-b border-border">
          <button
            onClick={() => setActiveTab('profile')}
            className={`px-4 py-2 font-medium transition-colors ${
              activeTab === 'profile'
                ? 'text-primary border-b-2 border-primary'
                : 'text-text-secondary hover:text-text-primary'
            }`}
          >
            Profile
          </button>
          <button
            onClick={() => setActiveTab('notifications')}
            className={`px-4 py-2 font-medium transition-colors ${
              activeTab === 'notifications'
                ? 'text-primary border-b-2 border-primary'
                : 'text-text-secondary hover:text-text-primary'
            }`}
          >
            Notifications
          </button>
          <button
            onClick={() => setActiveTab('security')}
            className={`px-4 py-2 font-medium transition-colors ${
              activeTab === 'security'
                ? 'text-primary border-b-2 border-primary'
                : 'text-text-secondary hover:text-text-primary'
            }`}
          >
            Security
          </button>
          <button
            onClick={() => setActiveTab('payment')}
            className={`px-4 py-2 font-medium transition-colors ${
              activeTab === 'payment'
                ? 'text-primary border-b-2 border-primary'
                : 'text-text-secondary hover:text-text-primary'
            }`}
          >
            Payment
          </button>
        </div>

        {/* Profile Tab */}
        {activeTab === 'profile' && (
          <div className="bg-white rounded-lg border border-border p-6">
            {isLoading ? (
              <p className="text-text-secondary">Loading profile...</p>
            ) : (
              <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div>
                    <label className="block text-sm font-medium text-text-primary mb-2">
                      Restaurant Name
                    </label>
                    <input
                      {...register('name')}
                      type="text"
                      className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                    />
                    {errors.name && (
                      <p className="mt-1 text-sm text-error">{errors.name.message}</p>
                    )}
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-text-primary mb-2">
                      Trade Name
                    </label>
                    <input
                      {...register('tradeName')}
                      type="text"
                      className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                    />
                  </div>

                  <div className="md:col-span-2">
                    <label className="block text-sm font-medium text-text-primary mb-2">
                      Description
                    </label>
                    <textarea
                      {...register('description')}
                      rows={3}
                      className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                    />
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-text-primary mb-2">
                      Email
                    </label>
                    <input
                      {...register('email')}
                      type="email"
                      className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                    />
                    {errors.email && (
                      <p className="mt-1 text-sm text-error">{errors.email.message}</p>
                    )}
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-text-primary mb-2">
                      Phone Number
                    </label>
                    <input
                      {...register('phoneNumber')}
                      type="tel"
                      className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                    />
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-text-primary mb-2">
                      Website
                    </label>
                    <input
                      {...register('website')}
                      type="url"
                      className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                    />
                    {errors.website && (
                      <p className="mt-1 text-sm text-error">{errors.website.message}</p>
                    )}
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-text-primary mb-2">
                      Delivery Fee
                    </label>
                    <input
                      {...register('deliveryFee', { valueAsNumber: true })}
                      type="number"
                      step="0.01"
                      min="0"
                      className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                    />
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-text-primary mb-2">
                      Address
                    </label>
                    <input
                      {...register('address')}
                      type="text"
                      className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                    />
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-text-primary mb-2">
                      City
                    </label>
                    <input
                      {...register('city')}
                      type="text"
                      className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                    />
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-text-primary mb-2">
                      District
                    </label>
                    <input
                      {...register('district')}
                      type="text"
                      className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                    />
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-text-primary mb-2">
                      Estimated Delivery Time
                    </label>
                    <input
                      {...register('estimatedDeliveryTime')}
                      type="text"
                      placeholder="e.g., 30-45 minutes"
                      className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                    />
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-text-primary mb-2">
                      Working Hours
                    </label>
                    <input
                      {...register('workingHours')}
                      type="text"
                      placeholder="e.g., 9:00 AM - 11:00 PM"
                      className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                    />
                  </div>

                  <div className="md:col-span-2">
                    <label className="flex items-center gap-3 cursor-pointer">
                      <input
                        type="checkbox"
                        checked={isAcceptingOrders ?? profile?.isAcceptingOrders ?? false}
                        onChange={(e) => setValue('isAcceptingOrders', e.target.checked)}
                        className="w-5 h-5 rounded border-border text-primary focus:ring-primary"
                      />
                      <span className="text-sm font-medium text-text-primary">
                        Accepting Orders
                      </span>
                    </label>
                  </div>

                  <div className="md:col-span-2">
                    <label className="flex items-center gap-3 cursor-pointer">
                      <input
                        type="checkbox"
                        checked={isActive ?? profile?.isActive ?? false}
                        onChange={(e) => setValue('isActive', e.target.checked)}
                        className="w-5 h-5 rounded border-border text-primary focus:ring-primary"
                      />
                      <span className="text-sm font-medium text-text-primary">
                        Active (Show in customer app feed)
                      </span>
                    </label>
                  </div>
                </div>

                <div className="flex items-center justify-end gap-4 pt-4 border-t border-border">
                  <button
                    type="submit"
                    disabled={isSaving}
                    className="flex items-center gap-2 px-6 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    <Save className="w-4 h-4" />
                    {isSaving ? 'Saving...' : 'Save Changes'}
                  </button>
                </div>
              </form>
            )}
          </div>
        )}

        {/* Other Tabs - Placeholder */}
        {activeTab === 'notifications' && (
          <div className="bg-white rounded-lg border border-border p-6">
            <p className="text-text-secondary">Notifications settings coming soon...</p>
          </div>
        )}

        {activeTab === 'security' && (
          <SecuritySettings />
        )}

        {activeTab === 'payment' && (
          <div className="bg-white rounded-lg border border-border p-6">
            <p className="text-text-secondary">Payment settings coming soon...</p>
          </div>
        )}
      </div>
    </DashboardLayout>
  )
}
