'use client'

import React, { createContext, useContext, useEffect, useState, useCallback } from 'react'
import { vendorsApi, VendorProfile } from '@/lib/api/vendors'

interface VendorProfileContextValue {
  profile: VendorProfile | null
  loading: boolean
  refetch: () => Promise<void>
}

const VendorProfileContext = createContext<VendorProfileContextValue | null>(null)

export function VendorProfileProvider({ children }: { children: React.ReactNode }) {
  const [profile, setProfile] = useState<VendorProfile | null>(null)
  const [loading, setLoading] = useState(true)

  const refetch = useCallback(async () => {
    try {
      setLoading(true)
      const data = await vendorsApi.getProfile()
      setProfile(data)
    } catch {
      setProfile(null)
    } finally {
      setLoading(false)
    }
  }, [])

  useEffect(() => {
    refetch()
  }, [refetch])

  return (
    <VendorProfileContext.Provider value={{ profile, loading, refetch }}>
      {children}
    </VendorProfileContext.Provider>
  )
}

export function useVendorProfile() {
  const ctx = useContext(VendorProfileContext)
  return ctx ?? { profile: null, loading: false, refetch: async () => {} }
}
