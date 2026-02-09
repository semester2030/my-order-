import { create } from 'zustand'
import { persist, createJSONStorage } from 'zustand/middleware'

interface User {
  id: string
  email: string
  name: string
  phone: string
}

interface AuthState {
  user: User | null
  token: string | null
  isAuthenticated: boolean
  setAuth: (user: User, token: string) => void
  clearAuth: () => void
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      user: null,
      token: null,
      isAuthenticated: false,
      setAuth: (user, token) => {
        set({ user, token, isAuthenticated: true })
        // Also set in API client
        if (typeof window !== 'undefined') {
          const { apiClient } = require('@/lib/api/client')
          apiClient.setToken(token)
          // Also set in cookie for middleware
          document.cookie = `vendor_token=${token}; path=/; max-age=86400`
        }
      },
      clearAuth: () => {
        set({ user: null, token: null, isAuthenticated: false })
        if (typeof window !== 'undefined') {
          localStorage.removeItem('vendor_token')
          document.cookie = 'vendor_token=; path=/; max-age=0'
        }
      },
    }),
    {
      name: 'vendor-auth-storage',
      storage: createJSONStorage(() => localStorage),
    },
  ),
)
