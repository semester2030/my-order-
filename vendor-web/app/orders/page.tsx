'use client'

import { useEffect, useState } from 'react'
import { DashboardLayout } from '@/components/layout/dashboard-layout'
import { ordersApi, Order } from '@/lib/api/orders'
import { format } from 'date-fns'
import { 
  CheckCircle2, 
  XCircle, 
  Clock, 
  Package,
  Search,
  Filter,
} from 'lucide-react'
import { cn } from '@/lib/utils/cn'
import { OrderDetailsModal } from '@/components/orders/order-details-modal'

const statusColors = {
  pending: 'bg-warning/10 text-warning border-warning/20',
  confirmed: 'bg-info/10 text-info border-info/20',
  preparing: 'bg-primary/10 text-primary border-primary/20',
  ready: 'bg-success/10 text-success border-success/20',
  out_for_delivery: 'bg-accent/10 text-accent border-accent/20',
  delivered: 'bg-success/10 text-success border-success/20',
  cancelled: 'bg-error/10 text-error border-error/20',
}

const statusLabels = {
  pending: 'Pending',
  confirmed: 'Confirmed',
  preparing: 'Preparing',
  ready: 'Ready',
  out_for_delivery: 'Out for Delivery',
  delivered: 'Delivered',
  cancelled: 'Cancelled',
}

export default function OrdersPage() {
  const [orders, setOrders] = useState<Order[]>([])
  const [filteredOrders, setFilteredOrders] = useState<Order[]>([])
  const [isLoading, setIsLoading] = useState(true)
  const [selectedStatus, setSelectedStatus] = useState<Order['status'] | 'all'>('all')
  const [searchQuery, setSearchQuery] = useState('')
  const [selectedOrderId, setSelectedOrderId] = useState<string | null>(null)

  useEffect(() => {
    fetchOrders()
  }, [])

  useEffect(() => {
    filterOrders()
  }, [orders, selectedStatus, searchQuery])

  const fetchOrders = async () => {
    try {
      setIsLoading(true)
      const data = await ordersApi.getOrders()
      setOrders(data)
    } catch (error) {
      console.error('Failed to fetch orders:', error)
    } finally {
      setIsLoading(false)
    }
  }

  const filterOrders = () => {
    let filtered = orders

    if (selectedStatus !== 'all') {
      filtered = filtered.filter(order => order.status === selectedStatus)
    }

    if (searchQuery) {
      const query = searchQuery.toLowerCase()
      filtered = filtered.filter(
        order =>
          order.orderNumber.toLowerCase().includes(query) ||
          order.user.name.toLowerCase().includes(query) ||
          order.user.phone.includes(query),
      )
    }

    setFilteredOrders(filtered)
  }

  const handleAccept = async (orderId: string) => {
    try {
      await ordersApi.acceptOrder(orderId)
      fetchOrders()
    } catch (error) {
      console.error('Failed to accept order:', error)
      alert('Failed to accept order')
    }
  }

  const handleReject = async (orderId: string) => {
    const reason = prompt('Please provide a reason for rejection:')
    if (!reason) return

    try {
      await ordersApi.rejectOrder(orderId, reason)
      fetchOrders()
    } catch (error) {
      console.error('Failed to reject order:', error)
      alert('Failed to reject order')
    }
  }

  const handleStatusUpdate = async (orderId: string, status: Order['status']) => {
    try {
      await ordersApi.updateOrderStatus(orderId, { status })
      fetchOrders()
    } catch (error) {
      console.error('Failed to update order status:', error)
      alert('Failed to update order status')
    }
  }

  return (
    <DashboardLayout>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold text-text-primary">Orders</h1>
            <p className="text-text-secondary mt-1">
              Manage and track all your orders
            </p>
          </div>
        </div>

        {/* Filters */}
        <div className="flex flex-col sm:flex-row gap-4">
          <div className="flex-1 relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-text-tertiary" />
            <input
              type="text"
              placeholder="Search by order number, customer name..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full pl-10 pr-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"
            />
          </div>
          <div className="flex items-center gap-2">
            <Filter className="w-5 h-5 text-text-tertiary" />
            <select
              value={selectedStatus}
              onChange={(e) => setSelectedStatus(e.target.value as any)}
              className="px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"
            >
              <option value="all">All Status</option>
              {Object.entries(statusLabels).map(([value, label]) => (
                <option key={value} value={value}>
                  {label}
                </option>
              ))}
            </select>
          </div>
        </div>

        {/* Orders List */}
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
        ) : filteredOrders.length === 0 ? (
          <div className="p-12 text-center bg-white rounded-lg border border-border">
            <Package className="w-12 h-12 text-text-tertiary mx-auto mb-4" />
            <p className="text-text-secondary">No orders found</p>
          </div>
        ) : (
          <div className="space-y-4">
            {filteredOrders.map((order) => (
              <div
                key={order.id}
                className="p-6 bg-white rounded-lg border border-border hover:shadow-md transition-shadow"
              >
                <div className="flex items-start justify-between mb-4">
                  <div>
                    <div className="flex items-center gap-3 mb-2">
                      <h3 className="text-lg font-semibold text-text-primary">
                        {order.orderNumber}
                      </h3>
                      <span
                        className={cn(
                          'px-3 py-1 rounded-full text-xs font-medium border',
                          statusColors[order.status],
                        )}
                      >
                        {statusLabels[order.status]}
                      </span>
                    </div>
                    <p className="text-sm text-text-secondary">
                      {order.user.name} • {order.user.phone}
                    </p>
                    <p className="text-sm text-text-secondary">
                      {order.address.streetAddress}, {order.address.building}
                    </p>
                    <p className="text-sm text-text-secondary">
                      {order.address.district}, {order.address.city}
                    </p>
                  </div>
                  <div className="text-right">
                    <p className="text-lg font-bold text-text-primary">
                      ${typeof order.total === 'number' ? order.total.toFixed(2) : parseFloat(String(order.total || 0)).toFixed(2)}
                    </p>
                    <p className="text-xs text-text-tertiary">
                      {format(new Date(order.createdAt), 'MMM dd, yyyy HH:mm')}
                    </p>
                  </div>
                </div>

                {/* Order Items */}
                <div className="mb-4 pb-4 border-b border-divider">
                  <p className="text-sm font-medium text-text-secondary mb-2">
                    Items ({order.items.length}):
                  </p>
                  <div className="space-y-2">
                    {order.items.map((item) => (
                      <div
                        key={item.id}
                        className="flex items-center justify-between text-sm"
                      >
                        <span className="text-text-primary">
                          {item.menuItem.name} × {item.quantity}
                        </span>
                        <span className="text-text-secondary">
                          ${(item.price * item.quantity).toFixed(2)}
                        </span>
                      </div>
                    ))}
                  </div>
                </div>

                {/* Actions */}
                <div className="flex items-center gap-3">
                  <button
                    onClick={() => setSelectedOrderId(order.id)}
                    className="px-4 py-2 border border-border rounded-lg text-text-primary hover:bg-surface transition-colors"
                  >
                    View Details
                  </button>
                  {order.status === 'pending' && (
                    <>
                      <button
                        onClick={() => handleAccept(order.id)}
                        className="flex items-center gap-2 px-4 py-2 bg-success text-white rounded-lg hover:bg-success/90 transition-colors"
                      >
                        <CheckCircle2 className="w-4 h-4" />
                        Accept
                      </button>
                      <button
                        onClick={() => handleReject(order.id)}
                        className="flex items-center gap-2 px-4 py-2 bg-error text-white rounded-lg hover:bg-error/90 transition-colors"
                      >
                        <XCircle className="w-4 h-4" />
                        Reject
                      </button>
                    </>
                  )}

                  {order.status === 'confirmed' && (
                    <button
                      onClick={() => handleStatusUpdate(order.id, 'preparing')}
                      className="px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors"
                    >
                      Start Preparing
                    </button>
                  )}

                  {order.status === 'preparing' && (
                    <button
                      onClick={() => handleStatusUpdate(order.id, 'ready')}
                      className="px-4 py-2 bg-success text-white rounded-lg hover:bg-success/90 transition-colors"
                    >
                      Mark as Ready
                    </button>
                  )}
                </div>
              </div>
            ))}
          </div>
        )}

        {/* Order Details Modal */}
        <OrderDetailsModal
          isOpen={!!selectedOrderId}
          orderId={selectedOrderId}
          onClose={() => setSelectedOrderId(null)}
          onStatusUpdate={() => {
            fetchOrders()
            setSelectedOrderId(null)
          }}
        />
      </div>
    </DashboardLayout>
  )
}
