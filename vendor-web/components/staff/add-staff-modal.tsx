'use client'

import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { X } from 'lucide-react'
import { staffApi, CreateStaffDto, StaffRole } from '@/lib/api/staff'

const staffSchema = z.object({
  email: z.string().email('Invalid email address'),
  name: z.string().min(2, 'Name must be at least 2 characters'),
  phone: z.string().min(5, 'Phone must be at least 5 characters'),
  role: z.enum(['owner', 'manager', 'chef', 'waiter', 'cashier', 'viewer']),
})

type StaffFormData = z.infer<typeof staffSchema>

interface AddStaffModalProps {
  isOpen: boolean
  onClose: () => void
  onSuccess: () => void
}

export function AddStaffModal({
  isOpen,
  onClose,
  onSuccess,
}: AddStaffModalProps) {
  const [isSubmitting, setIsSubmitting] = useState(false)

  const {
    register,
    handleSubmit,
    formState: { errors },
    reset,
  } = useForm<StaffFormData>({
    resolver: zodResolver(staffSchema),
    defaultValues: {
      role: 'viewer',
    },
  })

  if (!isOpen) return null

  const onSubmit = async (data: StaffFormData) => {
    try {
      setIsSubmitting(true)
      const createData: CreateStaffDto = {
        email: data.email,
        name: data.name,
        phone: data.phone,
        role: data.role,
      }
      await staffApi.createStaff(createData)
      reset()
      onSuccess()
      onClose()
    } catch (error: any) {
      console.error('Failed to create staff:', error)
      alert(error.response?.data?.message || 'Failed to create staff member')
    } finally {
      setIsSubmitting(false)
    }
  }

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-lg max-w-md w-full">
        <div className="flex items-center justify-between p-6 border-b border-border">
          <h2 className="text-2xl font-bold text-text-primary">Add Staff Member</h2>
          <button
            onClick={onClose}
            className="p-2 hover:bg-surface rounded-lg transition-colors"
            disabled={isSubmitting}
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        <form onSubmit={handleSubmit(onSubmit)} className="p-6 space-y-4">
          <div>
            <label className="block text-sm font-medium text-text-primary mb-2">
              Email <span className="text-error">*</span>
            </label>
            <input
              {...register('email')}
              type="email"
              className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
              placeholder="staff@example.com"
              disabled={isSubmitting}
            />
            {errors.email && (
              <p className="mt-1 text-sm text-error">{errors.email.message}</p>
            )}
          </div>

          <div>
            <label className="block text-sm font-medium text-text-primary mb-2">
              Name <span className="text-error">*</span>
            </label>
            <input
              {...register('name')}
              type="text"
              className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
              placeholder="John Doe"
              disabled={isSubmitting}
            />
            {errors.name && (
              <p className="mt-1 text-sm text-error">{errors.name.message}</p>
            )}
          </div>

          <div>
            <label className="block text-sm font-medium text-text-primary mb-2">
              Phone <span className="text-error">*</span>
            </label>
            <input
              {...register('phone')}
              type="tel"
              className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
              placeholder="+966501234567"
              disabled={isSubmitting}
            />
            {errors.phone && (
              <p className="mt-1 text-sm text-error">{errors.phone.message}</p>
            )}
          </div>

          <div>
            <label className="block text-sm font-medium text-text-primary mb-2">
              Role <span className="text-error">*</span>
            </label>
            <select
              {...register('role')}
              className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
              disabled={isSubmitting}
            >
              <option value="viewer">Viewer</option>
              <option value="cashier">Cashier</option>
              <option value="waiter">Waiter</option>
              <option value="chef">Chef</option>
              <option value="manager">Manager</option>
            </select>
            {errors.role && (
              <p className="mt-1 text-sm text-error">{errors.role.message}</p>
            )}
          </div>

          <div className="flex items-center gap-4 pt-4 border-t border-border">
            <button
              type="button"
              onClick={onClose}
              className="flex-1 px-4 py-2 border border-border rounded-lg text-text-primary hover:bg-surface transition-colors"
              disabled={isSubmitting}
            >
              Cancel
            </button>
            <button
              type="submit"
              className="flex-1 px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
              disabled={isSubmitting}
            >
              {isSubmitting ? 'Adding...' : 'Add Staff'}
            </button>
          </div>
        </form>
      </div>
    </div>
  )
}
