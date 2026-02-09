'use client'

import { useEffect, useState } from 'react'
import { DashboardLayout } from '@/components/layout/dashboard-layout'
import { staffApi, StaffMember, StaffRole } from '@/lib/api/staff'
import { Plus, Edit, Trash2, UserCheck, UserX } from 'lucide-react'
import { cn } from '@/lib/utils/cn'
import { AddStaffModal } from '@/components/staff/add-staff-modal'
import { EditStaffModal } from '@/components/staff/edit-staff-modal'

const roleLabels: Record<StaffRole, string> = {
  owner: 'Owner',
  manager: 'Manager',
  chef: 'Chef',
  waiter: 'Waiter',
  cashier: 'Cashier',
  viewer: 'Viewer',
}

export default function StaffPage() {
  const [staff, setStaff] = useState<StaffMember[]>([])
  const [isLoading, setIsLoading] = useState(true)
  const [showAddModal, setShowAddModal] = useState(false)
  const [editingMember, setEditingMember] = useState<StaffMember | null>(null)

  useEffect(() => {
    fetchStaff()
  }, [])

  const fetchStaff = async () => {
    try {
      setIsLoading(true)
      const data = await staffApi.getStaff()
      setStaff(data)
    } catch (error) {
      console.error('Failed to fetch staff:', error)
    } finally {
      setIsLoading(false)
    }
  }

  const handleToggleActive = async (id: string, currentStatus: boolean) => {
    try {
      await staffApi.updateStaff(id, { isActive: !currentStatus })
      fetchStaff()
    } catch (error) {
      console.error('Failed to update staff:', error)
      alert('Failed to update staff status')
    }
  }

  const handleDelete = async (id: string, role: StaffRole) => {
    if (role === 'owner') {
      alert('Cannot delete owner')
      return
    }

    if (!confirm('Are you sure you want to remove this staff member?')) return

    try {
      await staffApi.deleteStaff(id)
      fetchStaff()
    } catch (error) {
      console.error('Failed to delete staff:', error)
      alert('Failed to delete staff member')
    }
  }

  return (
    <DashboardLayout>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold text-text-primary">Staff</h1>
            <p className="text-text-secondary mt-1">
              Manage your restaurant staff members
            </p>
          </div>
          <button
            onClick={() => setShowAddModal(true)}
            className="flex items-center gap-2 px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors"
          >
            <Plus className="w-5 h-5" />
            Add Staff
          </button>
        </div>

        {/* Staff List */}
        {isLoading ? (
          <div className="space-y-4">
            {[...Array(5)].map((_, i) => (
              <div
                key={i}
                className="p-6 bg-white rounded-lg border border-border animate-pulse"
              >
                <div className="h-4 bg-surface rounded w-1/4 mb-4"></div>
                <div className="h-6 bg-surface rounded w-1/2"></div>
              </div>
            ))}
          </div>
        ) : staff.length === 0 ? (
          <div className="p-12 text-center bg-white rounded-lg border border-border">
            <p className="text-text-secondary mb-4">No staff members yet</p>
            <button
              onClick={() => setShowAddModal(true)}
              className="px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors"
            >
              Add Your First Staff Member
            </button>
          </div>
        ) : (
          <div className="space-y-4">
            {staff.map((member) => (
              <div
                key={member.id}
                className="p-6 bg-white rounded-lg border border-border hover:shadow-md transition-shadow"
              >
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-4">
                    <div className="w-12 h-12 bg-primary rounded-full flex items-center justify-center text-white font-semibold">
                      {member.user.name.charAt(0).toUpperCase()}
                    </div>
                    <div>
                      <h3 className="text-lg font-semibold text-text-primary">
                        {member.user.name}
                      </h3>
                      <p className="text-sm text-text-secondary">
                        {member.user.email}
                      </p>
                      <p className="text-sm text-text-secondary">
                        {member.user.phone}
                      </p>
                    </div>
                  </div>

                  <div className="flex items-center gap-4">
                    <div className="text-right">
                      <span
                        className={cn(
                          'px-3 py-1 rounded-full text-xs font-medium',
                          member.isActive
                            ? 'bg-success/10 text-success'
                            : 'bg-error/10 text-error',
                        )}
                      >
                        {member.isActive ? 'Active' : 'Inactive'}
                      </span>
                      <p className="text-sm text-text-secondary mt-1">
                        {roleLabels[member.role]}
                      </p>
                    </div>

                    <div className="flex items-center gap-2">
                      <button
                        onClick={() => handleToggleActive(member.id, member.isActive)}
                        className={cn(
                          'p-2 rounded-lg transition-colors',
                          member.isActive
                            ? 'text-error hover:bg-error/10'
                            : 'text-success hover:bg-success/10',
                        )}
                        title={member.isActive ? 'Deactivate' : 'Activate'}
                      >
                        {member.isActive ? (
                          <UserX className="w-5 h-5" />
                        ) : (
                          <UserCheck className="w-5 h-5" />
                        )}
                      </button>
                      <button
                        onClick={() => setEditingMember(member)}
                        className="p-2 text-text-secondary hover:text-text-primary hover:bg-surface rounded-lg transition-colors"
                        title="Edit"
                      >
                        <Edit className="w-5 h-5" />
                      </button>
                      {member.role !== 'owner' && (
                        <button
                          onClick={() => handleDelete(member.id, member.role)}
                          className="p-2 text-error hover:bg-error/10 rounded-lg transition-colors"
                          title="Delete"
                        >
                          <Trash2 className="w-5 h-5" />
                        </button>
                      )}
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}

        {/* Add Modal */}
        <AddStaffModal
          isOpen={showAddModal}
          onClose={() => setShowAddModal(false)}
          onSuccess={() => {
            fetchStaff()
            setShowAddModal(false)
          }}
        />

        {/* Edit Modal */}
        <EditStaffModal
          isOpen={!!editingMember}
          member={editingMember}
          onClose={() => setEditingMember(null)}
          onSuccess={() => {
            fetchStaff()
            setEditingMember(null)
          }}
        />
      </div>
    </DashboardLayout>
  )
}
