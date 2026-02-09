'use client'

import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { Lock, Save } from 'lucide-react'
import { vendorsApi } from '@/lib/api/vendors'

const changePasswordSchema = z.object({
  currentPassword: z.string().min(1, 'Current password is required'),
  newPassword: z.string().min(6, 'Password must be at least 6 characters'),
  confirmPassword: z.string().min(6, 'Please confirm your password'),
}).refine((data) => data.newPassword === data.confirmPassword, {
  message: "Passwords don't match",
  path: ['confirmPassword'],
})

type ChangePasswordFormData = z.infer<typeof changePasswordSchema>

export function SecuritySettings() {
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [successMessage, setSuccessMessage] = useState<string | null>(null)

  const {
    register,
    handleSubmit,
    formState: { errors },
    reset,
  } = useForm<ChangePasswordFormData>({
    resolver: zodResolver(changePasswordSchema),
  })

  const onSubmit = async (data: ChangePasswordFormData) => {
    try {
      setIsSubmitting(true)
      setSuccessMessage(null)
      await vendorsApi.changePassword(data.currentPassword, data.newPassword)
      setSuccessMessage('Password changed successfully!')
      reset()
    } catch (error: any) {
      console.error('Failed to change password:', error)
      alert(error.response?.data?.message || 'Failed to change password')
    } finally {
      setIsSubmitting(false)
    }
  }

  return (
    <div className="bg-white rounded-lg border border-border p-6">
      <div className="flex items-center gap-3 mb-6">
        <div className="p-3 bg-warning/10 rounded-lg">
          <Lock className="w-6 h-6 text-warning" />
        </div>
        <div>
          <h3 className="text-lg font-semibold text-text-primary">Change Password</h3>
          <p className="text-sm text-text-secondary">
            Update your password to keep your account secure
          </p>
        </div>
      </div>

      {successMessage && (
        <div className="mb-6 p-4 bg-success/10 border border-success/20 rounded-lg text-success text-sm">
          {successMessage}
        </div>
      )}

      <form onSubmit={handleSubmit(onSubmit)} className="space-y-6 max-w-md">
        <div>
          <label className="block text-sm font-medium text-text-primary mb-2">
            Current Password
          </label>
          <input
            {...register('currentPassword')}
            type="password"
            className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
            disabled={isSubmitting}
          />
          {errors.currentPassword && (
            <p className="mt-1 text-sm text-error">{errors.currentPassword.message}</p>
          )}
        </div>

        <div>
          <label className="block text-sm font-medium text-text-primary mb-2">
            New Password
          </label>
          <input
            {...register('newPassword')}
            type="password"
            className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
            disabled={isSubmitting}
          />
          {errors.newPassword && (
            <p className="mt-1 text-sm text-error">{errors.newPassword.message}</p>
          )}
          <p className="mt-1 text-xs text-text-secondary">
            Password must be at least 6 characters
          </p>
        </div>

        <div>
          <label className="block text-sm font-medium text-text-primary mb-2">
            Confirm New Password
          </label>
          <input
            {...register('confirmPassword')}
            type="password"
            className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
            disabled={isSubmitting}
          />
          {errors.confirmPassword && (
            <p className="mt-1 text-sm text-error">{errors.confirmPassword.message}</p>
          )}
        </div>

        <button
          type="submit"
          disabled={isSubmitting}
          className="flex items-center gap-2 px-6 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
        >
          <Save className="w-4 h-4" />
          {isSubmitting ? 'Changing Password...' : 'Change Password'}
        </button>
      </form>
    </div>
  )
}
