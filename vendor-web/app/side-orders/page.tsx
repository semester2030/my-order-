'use client'

import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import { DashboardLayout } from '@/components/layout/dashboard-layout'
import { useVendorProfile } from '@/lib/contexts/vendor-profile-context'
import { vendorsApi, PopularCookingAddOnItem } from '@/lib/api/vendors'
import { Plus, Trash2 } from 'lucide-react'
import { useLanguage } from '@/lib/contexts/language-context'

export default function SideOrdersPage() {
  const { t } = useLanguage()
  const router = useRouter()
  const { profile, loading: profileLoading, refetch } = useVendorProfile()
  const [addOns, setAddOns] = useState<PopularCookingAddOnItem[]>([])
  const [saving, setSaving] = useState(false)
  const [saved, setSaved] = useState(false)

  useEffect(() => {
    if (profile?.providerCategory !== 'popular_cooking') {
      if (!profileLoading && profile) router.replace('/dashboard')
      return
    }
    setAddOns(profile?.popularCookingAddOns ?? [])
  }, [profile, profileLoading, router])

  const updateItem = (index: number, field: 'name' | 'price', value: string | number) => {
    setAddOns((prev) =>
      prev.map((item, i) => (i === index ? { ...item, [field]: value } : item)),
    )
  }

  const addItem = () => {
    setAddOns((prev) => [...prev, { name: '', price: 0 }])
  }

  const removeItem = (index: number) => {
    setAddOns((prev) => prev.filter((_, i) => i !== index))
  }

  const handleSave = async () => {
    const valid = addOns.filter((a) => (a.name || '').trim()).map((a) => ({ name: a.name.trim(), price: Number(a.price) || 0 }))
    setSaving(true)
    setSaved(false)
    try {
      await vendorsApi.updateProfile({ popularCookingAddOns: valid })
      setAddOns(valid)
      setSaved(true)
      refetch()
      setTimeout(() => setSaved(false), 2000)
    } catch {
      alert(t('sideOrdersPage.failedSave'))
    } finally {
      setSaving(false)
    }
  }

  if (profileLoading || !profile) {
    return (
      <DashboardLayout>
        <div className="p-6">
          <p className="text-text-secondary">{t('sideOrdersPage.noItemsYet')}</p>
        </div>
      </DashboardLayout>
    )
  }

  if (profile.providerCategory !== 'popular_cooking') {
    return null
  }

  return (
    <DashboardLayout>
      <div className="space-y-6">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold text-text-primary">
              {t('sideOrdersPage.title')}
            </h1>
            <p className="text-text-secondary mt-1">{t('sideOrdersPage.subtitle')}</p>
          </div>
          <div className="flex items-center gap-2">
            <button
              type="button"
              onClick={addItem}
              className="flex items-center gap-2 px-4 py-2 border border-primary text-primary rounded-lg hover:bg-primary/10 transition-colors"
            >
              <Plus className="w-5 h-5" />
              {t('sideOrdersPage.addItem')}
            </button>
            <button
              type="button"
              onClick={handleSave}
              disabled={saving}
              className="flex items-center gap-2 px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors disabled:opacity-50"
            >
              {saving ? '...' : saved ? t('sideOrdersPage.saved') : t('sideOrdersPage.save')}
            </button>
          </div>
        </div>

        {addOns.length === 0 ? (
          <div className="p-12 text-center bg-white rounded-xl border-2 border-dashed border-primary/30">
            <p className="text-text-primary font-medium mb-2">{t('sideOrdersPage.noItemsYet')}</p>
            <p className="text-sm text-text-secondary mb-6 max-w-md mx-auto">
              {t('sideOrdersPage.howToAdd')}
            </p>
            <button
              onClick={addItem}
              className="inline-flex items-center gap-2 px-6 py-3 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors text-lg font-medium shadow-md"
            >
              <Plus className="w-5 h-5" />
              {t('sideOrdersPage.addFirstItem')}
            </button>
          </div>
        ) : (
          <div className="space-y-3">
            {addOns.map((item, index) => (
              <div
                key={index}
                className="flex gap-2 items-center p-4 bg-white rounded-lg border border-border"
              >
                <input
                  type="text"
                  placeholder={t('sideOrdersPage.namePlaceholder')}
                  value={item.name}
                  onChange={(e) => updateItem(index, 'name', e.target.value)}
                  className="flex-1 px-4 py-2 border border-border rounded-lg text-sm"
                />
                <input
                  type="number"
                  min={0}
                  step={0.01}
                  value={item.price || ''}
                  onChange={(e) => updateItem(index, 'price', parseFloat(e.target.value) || 0)}
                  className="w-28 px-4 py-2 border border-border rounded-lg text-sm"
                />
                <button
                  type="button"
                  onClick={() => removeItem(index)}
                  className="p-2 text-error hover:bg-error/10 rounded-lg"
                  title={t('sideOrdersPage.remove')}
                >
                  <Trash2 className="w-4 h-4" />
                </button>
              </div>
            ))}
          </div>
        )}
      </div>
    </DashboardLayout>
  )
}
