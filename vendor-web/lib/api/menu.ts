import { apiClient } from './client'
import { Endpoints } from './endpoints'

export interface VideoAsset {
  id: string
  menuItemId: string
  cloudflareAssetId: string
  playbackUrl: string
  thumbnailUrl: string | null
  duration: number
  status: 'processing' | 'ready' | 'failed'
  isPrimary: boolean
  createdAt: string
}

export interface MenuItem {
  id: string
  name: string
  description?: string
  price: number | string // Can be number or string from backend
  image?: string
  isSignature: boolean
  isAvailable: boolean
  createdAt: string
  updatedAt: string
  videoAssets?: VideoAsset[] // Include video assets
}

export interface CreateMenuItemDto {
  name: string
  description?: string
  price: number
  isSignature?: boolean
  isAvailable?: boolean
  image?: File
}

export interface UpdateMenuItemDto {
  name?: string
  description?: string
  price?: number
  isSignature?: boolean
  isAvailable?: boolean
  image?: File
}

export const menuApi = {
  async getMenu(): Promise<MenuItem[]> {
    const response = await apiClient.get<MenuItem[]>(Endpoints.menu.list)
    return response.data
  },

  async createMenuItem(data: CreateMenuItemDto): Promise<MenuItem> {
    const formData = new FormData()
    formData.append('name', data.name)
    formData.append('price', data.price.toString())
    if (data.description) formData.append('description', data.description)
    if (data.isSignature !== undefined) formData.append('isSignature', data.isSignature.toString())
    if (data.isAvailable !== undefined) formData.append('isAvailable', data.isAvailable.toString())
    if (data.image) formData.append('image', data.image)

    const response = await apiClient.postFormData<MenuItem>(
      Endpoints.menu.create,
      formData,
    )
    return response.data
  },

  async updateMenuItem(id: string, data: UpdateMenuItemDto): Promise<MenuItem> {
    const formData = new FormData()
    if (data.name) formData.append('name', data.name)
    if (data.price !== undefined) formData.append('price', data.price.toString())
    if (data.description !== undefined) formData.append('description', data.description || '')
    if (data.isSignature !== undefined) formData.append('isSignature', data.isSignature.toString())
    if (data.isAvailable !== undefined) formData.append('isAvailable', data.isAvailable.toString())
    if (data.image) formData.append('image', data.image)

    const response = await apiClient.put<MenuItem>(
      Endpoints.menu.update(id),
      formData,
      {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      },
    )
    return response.data
  },

  async deleteMenuItem(id: string): Promise<void> {
    await apiClient.delete(Endpoints.menu.delete(id))
  },

  async toggleAvailability(id: string): Promise<MenuItem> {
    const response = await apiClient.patch<MenuItem>(
      Endpoints.menu.toggleAvailability(id),
    )
    return response.data
  },
}
