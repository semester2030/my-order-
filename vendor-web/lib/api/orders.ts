import { apiClient } from './client'
import { Endpoints } from './endpoints'

export interface Order {
  id: string
  orderNumber: string
  status: 'pending' | 'confirmed' | 'preparing' | 'ready' | 'out_for_delivery' | 'delivered' | 'cancelled'
  subtotal: number
  deliveryFee: number
  total: number
  estimatedDeliveryTime: string
  createdAt: string
  user: {
    id: string
    name: string
    phone: string
  }
  address: {
    streetAddress: string
    building: string
    city: string
    district: string
  }
  items: Array<{
    id: string
    menuItem: {
      id: string
      name: string
      image?: string
    }
    quantity: number
    price: number
  }>
}

export interface UpdateOrderStatusDto {
  status: Order['status']
  note?: string
}

export interface RejectOrderDto {
  reason: string
}

export const ordersApi = {
  async getOrders(status?: Order['status']): Promise<Order[]> {
    const params = status ? { status } : {}
    const response = await apiClient.get<Order[]>(Endpoints.orders.list, { params })
    return response.data
  },

  async getOrder(id: string): Promise<Order> {
    const response = await apiClient.get<Order>(Endpoints.orders.detail(id))
    return response.data
  },

  async acceptOrder(id: string): Promise<Order> {
    const response = await apiClient.post<Order>(Endpoints.orders.accept(id))
    return response.data
  },

  async rejectOrder(id: string, reason: string): Promise<Order> {
    const response = await apiClient.post<Order>(
      Endpoints.orders.reject(id),
      { reason },
    )
    return response.data
  },

  async updateOrderStatus(id: string, data: UpdateOrderStatusDto): Promise<Order> {
    const response = await apiClient.patch<Order>(
      Endpoints.orders.updateStatus(id),
      data,
    )
    return response.data
  },
}
