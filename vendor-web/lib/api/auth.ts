import { apiClient } from './client'
import { Endpoints } from './endpoints'
import { useAuthStore } from '@/lib/store/auth-store'

export interface LoginCredentials {
  email: string
  password: string
}

export interface LoginResponse {
  user: {
    id: string
    email: string
    name: string
    phone: string
  }
  accessToken: string
  refreshToken: string
}

export const authApi = {
  async login(credentials: LoginCredentials): Promise<LoginResponse> {
    // Note: Backend uses phone/OTP for customer login
    // For vendors, we'll use email/password
    // If backend doesn't have vendor login yet, we'll need to add it
    const response = await apiClient.post<LoginResponse>(
      Endpoints.auth.login,
      credentials,
    )
    
    // Set auth in store
    const { setAuth } = useAuthStore.getState()
    setAuth(response.data.user, response.data.accessToken)
    
    return response.data
  },
  
  async logout(): Promise<void> {
    try {
      await apiClient.post(Endpoints.auth.logout)
    } finally {
      // Clear auth regardless of API call success
      const { clearAuth } = useAuthStore.getState()
      clearAuth()
    }
  },
  
  async refreshToken(): Promise<string> {
    const response = await apiClient.post<{ accessToken: string }>(
      Endpoints.auth.refresh,
    )
    
    const token = response.data.accessToken
    const { setAuth, user } = useAuthStore.getState()
    if (user) {
      setAuth(user, token)
    }
    
    return token
  },
}
