import { apiClient } from './client'
import { Endpoints } from './endpoints'

export interface PopularCookingAddOnItem {
  name: string
  price: number
}

export interface VendorProfile {
  id: string
  name: string
  tradeName?: string
  type: string
  description?: string
  email?: string
  phoneNumber?: string
  website?: string
  address?: string
  city?: string
  district?: string
  postalCode?: string
  latitude?: number
  longitude?: number
  deliveryFee?: number
  deliveryRadius?: number
  estimatedDeliveryTime?: string
  workingHours?: string
  isAcceptingOrders: boolean
  isActive: boolean
  /** فئة المقدم: home_cooking | popular_cooking | private_events | grilling */
  providerCategory?: string | null
  /** للطبخ الشعبي فقط: الطلبات الجانبية (جريش، قرصان، ادامات…) */
  popularCookingAddOns?: PopularCookingAddOnItem[] | null
}

export interface UpdateVendorProfileDto {
  name?: string
  tradeName?: string
  type?: string
  description?: string
  email?: string
  phoneNumber?: string
  website?: string
  address?: string
  city?: string
  district?: string
  postalCode?: string
  latitude?: number
  longitude?: number
  deliveryFee?: number
  deliveryRadius?: number
  estimatedDeliveryTime?: string
  workingHours?: string
  isAcceptingOrders?: boolean
  isActive?: boolean
  popularCookingAddOns?: PopularCookingAddOnItem[]
}

export const vendorsApi = {
  async getProfile(): Promise<VendorProfile> {
    const response = await apiClient.get<VendorProfile>(Endpoints.vendors.profile)
    return response.data
  },

  async updateProfile(data: UpdateVendorProfileDto): Promise<VendorProfile> {
    const response = await apiClient.put<VendorProfile>(
      Endpoints.vendors.updateProfile,
      data,
    )
    return response.data
  },

  async changePassword(currentPassword: string, newPassword: string): Promise<{ message: string }> {
    const response = await apiClient.patch<{ message: string }>(
      Endpoints.vendors.changePassword,
      { currentPassword, newPassword },
    )
    return response.data
  },
}
