import { apiClient } from './client'
import { Endpoints } from './endpoints'

export type StaffRole = 'owner' | 'manager' | 'chef' | 'waiter' | 'cashier' | 'viewer'

export interface StaffMember {
  id: string
  userId: string
  role: StaffRole
  permissions: string[]
  isActive: boolean
  user: {
    id: string
    name: string
    email: string
    phone: string
  }
  createdAt: string
}

export interface CreateStaffDto {
  email: string
  name: string
  phone: string
  role: StaffRole
  permissions?: string[]
}

export interface UpdateStaffDto {
  role?: StaffRole
  permissions?: string[]
  isActive?: boolean
}

export const staffApi = {
  async getStaff(): Promise<StaffMember[]> {
    const response = await apiClient.get<StaffMember[]>(Endpoints.staff.list)
    return response.data
  },

  async createStaff(data: CreateStaffDto): Promise<StaffMember> {
    const response = await apiClient.post<StaffMember>(
      Endpoints.staff.create,
      data,
    )
    return response.data
  },

  async updateStaff(id: string, data: UpdateStaffDto): Promise<StaffMember> {
    const response = await apiClient.put<StaffMember>(
      Endpoints.staff.update(id),
      data,
    )
    return response.data
  },

  async deleteStaff(id: string): Promise<void> {
    await apiClient.delete(Endpoints.staff.delete(id))
  },
}
