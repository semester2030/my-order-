'use client'

import { useState, useEffect } from 'react'
import { X, MapPin, User, Phone, Calendar, DollarSign } from 'lucide-react'
import { ordersApi, Order } from '@/lib/api/orders'
import { format } from 'date-fns'
import { cn } from '@/lib/utils/cn'

interface OrderDetailsModalProps {
  isOpen: boolean
  orderId: string | null
  onClose: () => void
  onStatusUpdate: () => void
}

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

export function OrderDetailsModal({
  isOpen,
  orderId,
  onClose,
  onStatusUpdate,
}: OrderDetailsModalProps) {
  const [order, setOrder] = useState<Order | null>(null)
  const [isLoading, setIsLoading] = useState(false)
  const [newStatus, setNewStatus] = useState<Order['status'] | ''>('')
  const [statusNote, setStatusNote] = useState('')
  const [isUpdating, setIsUpdating] = useState(false)

  useEffect(() => {
    if (isOpen && orderId) {
      fetchOrderDetails()
    } else {
      setOrder(null)
      setNewStatus('')
      setStatusNote('')
    }
  }, [isOpen, orderId])

  const fetchOrderDetails = async () => {
    if (!orderId) return
    try {
      setIsLoading(true)
      const data = await ordersApi.getOrder(orderId)
      setOrder(data)
      setNewStatus(data.status)
    } catch (error) {
      console.error('Failed to fetch order details:', error)
      alert('Failed to load order details')
    } finally {
      setIsLoading(false)
    }
  }

  const handleUpdateStatus = async () => {
    if (!orderId || !newStatus || newStatus === order?.status) return

    try {
      setIsUpdating(true)
      await ordersApi.updateOrderStatus(orderId, {
        status: newStatus as Order['status'],
        note: statusNote || undefined,
      })
      onStatusUpdate()
      onClose()
    } catch (error) {
      console.error('Failed to update order status:', error)
      alert('Failed to update order status')
    } finally {
      setIsUpdating(false)
    }
  }

  if (!isOpen) return null

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-lg max-w-3xl w-full max-h-[90vh] overflow-y-auto">
        {/* Header */}
        <div className="flex items-center justify-between p-6 border-b border-border">
          <h2 className="text-2xl font-bold text-text-primary">Order Details</h2>
          <button
            onClick={onClose}
            className="p-2 hover:bg-surface rounded-lg transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {isLoading ? (
          <div className="p-12 text-center">
            <p className="text-text-secondary">Loading order details...</p>
          </div>
        ) : order ? (
          <div className="p-6 space-y-6">
            {/* Order Info */}
            <div className="grid grid-cols-2 gap-4">
              <div className="p-4 bg-surface rounded-lg">
                <p className="text-sm text-text-secondary mb-1">Order Number</p>
                <p className="font-semibold text-text-primary">{order.orderNumber}</p>
              </div>
              <div className="p-4 bg-surface rounded-lg">
                <p className="text-sm text-text-secondary mb-1">Status</p>
                <span
                  className={cn(
                    'inline-block px-3 py-1 rounded-full text-xs font-medium border',
                    statusColors[order.status],
                  )}
                >
                  {statusLabels[order.status]}
                </span>
              </div>
              <div className="p-4 bg-surface rounded-lg">
                <p className="text-sm text-text-secondary mb-1">Date</p>
                <p className="font-semibold text-text-primary">
                  {format(new Date(order.createdAt), 'MMM dd, yyyy HH:mm')}
                </p>
              </div>
              <div className="p-4 bg-surface rounded-lg">
                <p className="text-sm text-text-secondary mb-1">Estimated Delivery</p>
                <p className="font-semibold text-text-primary">
                  {order.estimatedDeliveryTime}
                </p>
              </div>
            </div>

            {/* Customer Info */}
            <div className="p-4 bg-surface rounded-lg">
              <h3 className="font-semibold text-text-primary mb-4 flex items-center gap-2">
                <User className="w-5 h-5" />
                Customer Information
              </h3>
              <div className="space-y-2">
                <p className="text-sm text-text-primary">
                  <span className="text-text-secondary">Name:</span> {order.user.name}
                </p>
                <p className="text-sm text-text-primary flex items-center gap-2">
                  <Phone className="w-4 h-4" />
                  <span className="text-text-secondary">Phone:</span> {order.user.phone}
                </p>
              </div>
            </div>

            {/* Delivery Address */}
            <div className="p-4 bg-surface rounded-lg">
              <h3 className="font-semibold text-text-primary mb-4 flex items-center gap-2">
                <MapPin className="w-5 h-5" />
                Delivery Address
              </h3>
              <p className="text-sm text-text-primary">
                {order.address.streetAddress}, {order.address.building}
              </p>
              <p className="text-sm text-text-secondary">
                {order.address.district}, {order.address.city}
              </p>
            </div>

            {/* Order Items */}
            <div>
              <h3 className="font-semibold text-text-primary mb-4">Order Items</h3>
              <div className="space-y-3">
                {order.items.map((item) => (
                  <div
                    key={item.id}
                    className="flex items-center gap-4 p-4 bg-surface rounded-lg"
                  >
                    {item.menuItem.image && (
                      <img
                        src={item.menuItem.image}
                        alt={item.menuItem.name}
                        className="w-16 h-16 object-cover rounded-lg"
                      />
                    )}
                    <div className="flex-1">
                      <p className="font-semibold text-text-primary">
                        {item.menuItem.name}
                      </p>
                      <p className="text-sm text-text-secondary">
                        Quantity: {item.quantity}
                      </p>
                    </div>
                    <p className="font-bold text-text-primary">
                      ${typeof item.price === 'number' ? item.price.toFixed(2) : parseFloat(String(item.price || 0)).toFixed(2)}
                    </p>
                  </div>
                ))}
              </div>
            </div>

            {/* Order Summary */}
            <div className="p-4 bg-surface rounded-lg">
              <h3 className="font-semibold text-text-primary mb-4 flex items-center gap-2">
                <DollarSign className="w-5 h-5" />
                Order Summary
              </h3>
              <div className="space-y-2">
                <div className="flex justify-between text-sm">
                  <span className="text-text-secondary">Subtotal</span>
                  <span className="text-text-primary">
                    ${typeof order.subtotal === 'number' ? order.subtotal.toFixed(2) : parseFloat(String(order.subtotal || 0)).toFixed(2)}
                  </span>
                </div>
                <div className="flex justify-between text-sm">
                  <span className="text-text-secondary">Delivery Fee</span>
                  <span className="text-text-primary">
                    ${typeof order.deliveryFee === 'number' ? order.deliveryFee.toFixed(2) : parseFloat(String(order.deliveryFee || 0)).toFixed(2)}
                  </span>
                </div>
                <div className="flex justify-between text-lg font-bold pt-2 border-t border-border">
                  <span className="text-text-primary">Total</span>
                  <span className="text-text-primary">
                    ${typeof order.total === 'number' ? order.total.toFixed(2) : parseFloat(String(order.total || 0)).toFixed(2)}
                  </span>
                </div>
              </div>
            </div>

            {/* Update Status */}
            {order.status !== 'delivered' && order.status !== 'cancelled' && (
              <div className="p-4 border border-border rounded-lg">
                <h3 className="font-semibold text-text-primary mb-4">
                  Update Order Status
                </h3>
                <div className="space-y-4">
                  <div>
                    <label className="block text-sm font-medium text-text-primary mb-2">
                      New Status
                    </label>
                    <select
                      value={newStatus}
                      onChange={(e) =>
                        setNewStatus(e.target.value as Order['status'])
                      }
                      className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                      disabled={isUpdating}
                    >
                      <option value="pending">Pending</option>
                      <option value="confirmed">Confirmed</option>
                      <option value="preparing">Preparing</option>
                      <option value="ready">Ready</option>
                      <option value="out_for_delivery">Out for Delivery</option>
                    </select>
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-text-primary mb-2">
                      Note (Optional)
                    </label>
                    <textarea
                      value={statusNote}
                      onChange={(e) => setStatusNote(e.target.value)}
                      rows={2}
                      className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
                      placeholder="Add a note about this status update..."
                      disabled={isUpdating}
                    />
                  </div>
                  <button
                    onClick={handleUpdateStatus}
                    disabled={
                      isUpdating ||
                      !newStatus ||
                      newStatus === order.status
                    }
                    className="w-full px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    {isUpdating ? 'Updating...' : 'Update Status'}
                  </button>
                </div>
              </div>
            )}
          </div>
        ) : (
          <div className="p-12 text-center">
            <p className="text-text-secondary">Order not found</p>
          </div>
        )}
      </div>
    </div>
  )
}
