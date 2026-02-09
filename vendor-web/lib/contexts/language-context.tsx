'use client'

import React, { createContext, useContext, useEffect, useState } from 'react'
import { Lang, translations, t as tFn } from '@/lib/i18n/translations'

const STORAGE_KEY = 'vendor-web-lang'

function getStoredLang(): Lang {
  if (typeof window === 'undefined') return 'ar'
  const stored = localStorage.getItem(STORAGE_KEY) as Lang | null
  return stored === 'ar' || stored === 'en' ? stored : 'ar'
}

type LanguageContextType = {
  lang: Lang
  setLang: (lang: Lang) => void
  t: (key: string) => string
  dir: 'rtl' | 'ltr'
}

const LanguageContext = createContext<LanguageContextType | null>(null)

export function LanguageProvider({ children }: { children: React.ReactNode }) {
  const [lang, setLangState] = useState<Lang>('ar')
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setLangState(getStoredLang())
    setMounted(true)
  }, [])

  const setLang = (newLang: Lang) => {
    setLangState(newLang)
    if (typeof window !== 'undefined') {
      localStorage.setItem(STORAGE_KEY, newLang)
      document.documentElement.lang = newLang
      document.documentElement.dir = newLang === 'ar' ? 'rtl' : 'ltr'
    }
  }

  useEffect(() => {
    if (!mounted) return
    document.documentElement.lang = lang
    document.documentElement.dir = lang === 'ar' ? 'rtl' : 'ltr'
  }, [lang, mounted])

  const t = (key: string) => tFn(lang, key)

  const value: LanguageContextType = {
    lang,
    setLang,
    t,
    dir: lang === 'ar' ? 'rtl' : 'ltr',
  }

  return (
    <LanguageContext.Provider value={value}>
      {children}
    </LanguageContext.Provider>
  )
}

export function useLanguage() {
  const ctx = useContext(LanguageContext)
  if (!ctx) throw new Error('useLanguage must be used within LanguageProvider')
  return ctx
}
