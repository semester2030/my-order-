'use client'

import { useState, useEffect, useMemo } from 'react'
import { useRouter, useSearchParams } from 'next/navigation'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { CheckCircle } from 'lucide-react'
import { authApi } from '@/lib/api/auth'
import { useLanguage } from '@/lib/contexts/language-context'

type LoginFormData = {
  email: string
  password: string
}

export default function LoginPage() {
  const router = useRouter()
  const searchParams = useSearchParams()
  const { t, lang, setLang } = useLanguage()
  const [error, setError] = useState<string | null>(null)
  const [isLoading, setIsLoading] = useState(false)
  const [showSuccess, setShowSuccess] = useState(false)

  const loginSchema = useMemo(
    () =>
      z.object({
        email: z.string().email(t('login.invalidEmail')),
        password: z.string().min(6, t('login.passwordMin')),
      }),
    [t]
  )

  useEffect(() => {
    if (searchParams.get('registered') === 'true') {
      setShowSuccess(true)
      router.replace('/login', { scroll: false })
    }
  }, [searchParams, router])

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<LoginFormData>({
    resolver: zodResolver(loginSchema),
  })

  const onSubmit = async (data: LoginFormData) => {
    try {
      setIsLoading(true)
      setError(null)
      await authApi.login(data)
      router.push('/dashboard')
    } catch (err: any) {
      setError(err.response?.data?.message || t('login.loginFailed'))
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-primary-container to-accent-container">
      <div className="w-full max-w-md p-8 bg-white rounded-xl shadow-lg">
        {/* Language selector */}
        <div className="flex justify-end mb-6">
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
        </div>

        <div className="text-center mb-8">
          <h1 className="text-3xl font-bold text-text-primary mb-2">
            {t('login.title')}
          </h1>
          <p className="text-text-secondary">
            {t('login.subtitle')}
          </p>
        </div>

        <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
          {showSuccess && (
            <div className="p-4 bg-success/10 border border-success/20 rounded-lg text-success text-sm flex items-center gap-2">
              <CheckCircle className="w-5 h-5" />
              <div>
                <p className="font-semibold">{t('login.registering')}</p>
                <p className="text-xs mt-1">
                  {t('login.pendingApproval')}
                </p>
              </div>
            </div>
          )}

          {error && (
            <div className="p-4 bg-error/10 border border-error/20 rounded-lg text-error text-sm">
              {error}
            </div>
          )}

          <div>
            <label htmlFor="email" className="block text-sm font-medium text-text-primary mb-2">
              {t('login.email')}
            </label>
            <input
              id="email"
              type="email"
              {...register('email')}
              className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"
              placeholder="vendor@restaurant.com"
            />
            {errors.email && (
              <p className="mt-1 text-sm text-error">{errors.email.message}</p>
            )}
          </div>

          <div>
            <label htmlFor="password" className="block text-sm font-medium text-text-primary mb-2">
              {t('login.password')}
            </label>
            <input
              id="password"
              type="password"
              {...register('password')}
              className="w-full px-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"
              placeholder="••••••••"
            />
            {errors.password && (
              <p className="mt-1 text-sm text-error">{errors.password.message}</p>
            )}
          </div>

          <button
            type="submit"
            disabled={isLoading}
            className="w-full py-3 bg-primary text-white rounded-lg font-medium hover:bg-primary-dark transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {isLoading ? t('login.signingIn') : t('login.submit')}
          </button>

          <div className="text-center pt-4 border-t border-border">
            <p className="text-sm text-text-secondary">
              {t('login.noAccount')}{' '}
              <a
                href="/register"
                className="text-primary hover:text-primary-dark font-medium"
              >
                {t('login.register')}
              </a>
            </p>
          </div>
        </form>
      </div>
    </div>
  )
}
