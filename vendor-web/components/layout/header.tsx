'use client'

import { Bell, Search } from 'lucide-react'
import { useAuthStore } from '@/lib/store/auth-store'
import { useLanguage } from '@/lib/contexts/language-context'

export function Header() {
  const { user } = useAuthStore()
  const { t, lang, setLang } = useLanguage()

  return (
    <header className="sticky top-0 z-10 bg-white border-b border-border">
      <div className="flex items-center justify-between px-6 py-4">
        <div className="flex-1 max-w-md">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-text-tertiary" />
            <input
              type="text"
              placeholder={t('search')}
              className="w-full pl-10 pr-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"
            />
          </div>
        </div>

        <div className="flex items-center gap-4">
          {/* Language selector */}
          <div className="flex items-center gap-1 border border-border rounded-lg overflow-hidden">
            <button
              type="button"
              onClick={() => setLang('ar')}
              className={`px-3 py-1.5 text-sm font-medium transition-colors ${
                lang === 'ar' ? 'bg-primary text-white' : 'bg-surface text-text-secondary hover:bg-surface/80'
              }`}
            >
              ع
            </button>
            <button
              type="button"
              onClick={() => setLang('en')}
              className={`px-3 py-1.5 text-sm font-medium transition-colors ${
                lang === 'en' ? 'bg-primary text-white' : 'bg-surface text-text-secondary hover:bg-surface/80'
              }`}
            >
              EN
            </button>
          </div>

          <button className="relative p-2 text-text-secondary hover:text-text-primary transition-colors">
            <Bell className="w-5 h-5" />
            <span className="absolute top-1 right-1 w-2 h-2 bg-error rounded-full" />
          </button>

          <div className="flex items-center gap-3">
            <div className="text-right">
              <p className="text-sm font-medium text-text-primary">{user?.name || t('vendor')}</p>
              <p className="text-xs text-text-tertiary">{user?.email || ''}</p>
            </div>
            <div className="w-10 h-10 bg-primary rounded-full flex items-center justify-center text-white font-semibold">
              {user?.name?.charAt(0).toUpperCase() || 'V'}
            </div>
          </div>
        </div>
      </div>
    </header>
  )
}
