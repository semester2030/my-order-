'use client'

import { useState, useEffect } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { X } from 'lucide-react'
import { staffApi, UpdateStaffDto, StaffMember, StaffRole } from '@/lib/api/staff'

const staffSchema = z.object({
  role: z.enum(['owner', 'manager', 'chef', 'waiter', 'cashier', 'viewer']).optional(),
  isActive: z.boolean().optional(),
})

type StaffFormData = z.infer<typeof staffSchema>

interface EditStaffModalProps {
  isOpen: boolean
  member: StaffMember | null
  onClose: () => void
  onSuccess: () => void
}

export function EditStaffModal({
  isOpen,
  member,
  onClose,
  onSuccess,
}: EditStaffModalProps) {
  const [isSubmitting, setIsSubmitting] = useState(false)

  const {
    register,
    handleSubmit,
    formState: { errors },
    reset,
    watch,
    setValue,
  } = useForm<StaffFormData>({
    resolver: zodResolver(staffSchema),
  })

  const isActive = watch('isActive')
  const role = watch('role')

  useEffect(() => {
    if (member) {
      reset({
        role: member.role,
        isActive: member.isActive,
      })
    }
  }, [member, reset])

  if (!isOpen || !member) return null

  const onSubmit = async (data: StaffFormData) => {
    try {
      setIsSubmitting(true)
      const updateData: UpdateStaffDto = {
        role: data.role,
        isActive: data.isActive,
      }
      await staffApi.updateStaff(member.id, updateData)
      onSuccess()
      onClose()
    } catch (error: any) {
      console.error('Failed to update staff:', error)
      alert(error.response?.data?.message || 'Failed to update staff member')
    } finally {
      setIsSubmitting(false)
    }
  }

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-lg max-w-md w-full">
        <div className="flex items-center justify-between p-6 border-b border-border">
          <h2 className="text-2xl font-bold text-text-primary">Edit Staff Member</h2>
          <button
            onClick={onClose}
            className="p-2 hover:bg-surface rounded-lg transition-colors"
            disabled={isSubmitting}
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        <form onSubmit={handleSubmit(onSubmit)} className="p-6 space-y-4">
          <div className="p-4 bg-surface rounded-lg">
            <p className="text-sm text-text-secondary mb-1">Name</p>
            <p className="font-semibold text-text-primary">{member.user.name}</p>
          </div>

          <div className="p-4 bg-surface rounded-lg">
            <p className="text-sm text-text-secondary mb-1">Email</p>
            <p className="font-semibold text-text-primary">{member.user.email}</p>
          </div>

          <div>
            <label className="block text-sm font-medium text-text-primary mb-2">
              Role
            </label>
            <select
              {...register('role')}
              className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
              disabled={isSubmitting || member.role === 'owner'}
            >
              <option value="viewer">Viewer</option>
              <option value="cashier">Cashier</option>
              <option value="waiter">Waiter</option>
              <option value="chef">Chef</option>
              <option value="manager">Manager</option>
              {member.role === 'owner' && <option value="owner">Owner</option>}
            </select>
            {member.role === 'owner' && (
              <p className="mt-1 text-xs text-text-secondary">
                Owner role cannot be changed
              </p>
            )}
          </div>

          <div>
            <label className="flex items-center gap-3 cursor-pointer">
              <input
                type="checkbox"
                checked={isActive ?? member.isActive}
                onChange={(e) => setValue('isActive', e.target.checked)}
                className="w-5 h-5 rounded border-border text-primary focus:ring-primary"
                disabled={isSubmitting}
              />
              <span className="text-sm font-medium text-text-primary">
                Active
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
              Cancel
            </button>
            <button
              type="submit"
              className="flex-1 px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
              disabled={isSubmitting}
            >
              {isSubmitting ? 'Updating...' : 'Update Staff'}
            </button>
          </div>
        </form>
      </div>
    </div>
  )
}
