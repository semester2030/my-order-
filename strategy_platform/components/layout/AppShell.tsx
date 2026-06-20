'use client'

import { motion, AnimatePresence } from 'framer-motion'
import {
  LayoutDashboard,
  Rocket,
  TrendingUp,
  Users,
  ChefHat,
  Shield,
  AlertTriangle,
  Wallet,
  MapPin,
  GitBranch,
  BadgeCheck,
  RotateCcw,
} from 'lucide-react'
import { MODULES, BRAND } from '@/lib/defaults'
import { useStrategyStore } from '@/lib/store'
import { cn } from '@/lib/utils'

const ICONS: Record<string, React.ComponentType<{ className?: string }>> = {
  LayoutDashboard,
  Rocket,
  TrendingUp,
  Users,
  ChefHat,
  Shield,
  AlertTriangle,
  Wallet,
  MapPin,
  GitBranch,
  BadgeCheck,
}

export function AppShell({ children }: { children: React.ReactNode }) {
  const { activeModule, setActiveModule, resetAll } = useStrategyStore()

  return (
    <div className="min-h-screen flex">
      <aside className="fixed inset-y-0 right-0 w-64 glass-panel m-3 mr-0 rounded-r-none z-50 hidden lg:flex flex-col">
        <div className="p-5 border-b border-gray-100">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl brand-gradient flex items-center justify-center text-white font-bold text-lg">
              م
            </div>
            <div>
              <h1 className="font-bold text-ink">{BRAND.name}</h1>
              <p className="text-xs text-ink-muted">Launch OS</p>
            </div>
          </div>
        </div>
        <nav className="flex-1 overflow-y-auto p-3 space-y-1">
          {MODULES.map((m) => {
            const Icon = ICONS[m.icon] || LayoutDashboard
            const active = activeModule === m.id
            return (
              <button
                key={m.id}
                onClick={() => setActiveModule(m.id)}
                className={cn(
                  'w-full flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm transition-all duration-200',
                  active
                    ? 'bg-brand text-white shadow-glow'
                    : 'text-ink-muted hover:bg-gray-50 hover:text-ink',
                )}
              >
                <Icon className="w-4 h-4 shrink-0" />
                <span className="truncate">{m.labelAr}</span>
              </button>
            )
          })}
        </nav>
        <div className="p-3 border-t border-gray-100">
          <button
            onClick={() => {
              if (confirm('إعادة تعيين جميع البيانات؟')) resetAll()
            }}
            className="w-full flex items-center justify-center gap-2 px-3 py-2 rounded-xl text-sm text-ink-muted hover:bg-red-50 hover:text-red-600 transition-colors"
          >
            <RotateCcw className="w-4 h-4" />
            إعادة تعيين
          </button>
        </div>
      </aside>

      {/* Mobile nav */}
      <div className="lg:hidden fixed bottom-0 inset-x-0 z-50 glass-panel m-2 rounded-2xl p-2 overflow-x-auto">
        <div className="flex gap-1 min-w-max">
          {MODULES.slice(0, 6).map((m) => {
            const Icon = ICONS[m.icon] || LayoutDashboard
            return (
              <button
                key={m.id}
                onClick={() => setActiveModule(m.id)}
                className={cn(
                  'flex flex-col items-center gap-1 px-3 py-2 rounded-xl text-xs',
                  activeModule === m.id ? 'bg-brand text-white' : 'text-ink-muted',
                )}
              >
                <Icon className="w-4 h-4" />
                {m.labelAr.split(' ')[0]}
              </button>
            )
          })}
        </div>
      </div>

      <main className="flex-1 lg:mr-[268px] p-4 lg:p-8 pb-24 lg:pb-8">
        <AnimatePresence mode="wait">
          <motion.div
            key={activeModule}
            initial={{ opacity: 0, y: 12 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -8 }}
            transition={{ duration: 0.25 }}
          >
            {children}
          </motion.div>
        </AnimatePresence>
      </main>
    </div>
  )
}
