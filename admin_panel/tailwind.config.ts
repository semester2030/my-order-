import type { Config } from 'tailwindcss'

/** ألوان الثيم الموحد مع تطبيقات العميل والسائق وويب المطاعم (Sunset Orange + Gold + Deep Charcoal) */
const config: Config = {
  content: [
    './app/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        // Primary - Sunset Orange (موحد مع customer_app & vendor-web)
        primary: {
          DEFAULT: '#FF6B35',
          dark: '#E55A2B',
          light: '#FF8C5A',
          container: '#FFE5DC',
        },
        // Accent - Gold (موحد)
        accent: {
          DEFAULT: '#FFD700',
          dark: '#FFA500',
          light: '#FFE44D',
          container: '#FFF8DC',
        },
        // Secondary - Deep Charcoal (موحد)
        secondary: {
          DEFAULT: '#1A1A1A',
          dark: '#000000',
          light: '#2C3E50',
          container: '#F5F5F5',
        },
        // Background & Surface (موحد)
        surface: {
          DEFAULT: '#F8F9FA',
          elevated: '#FFFFFF',
          warm: '#FAF7F2',
          warmBg: '#FFFBF5',
        },
        // Text (موحد)
        text: {
          primary: '#1A1A1A',
          secondary: '#6C757D',
          tertiary: '#95A5A6',
          inverse: '#FFFFFF',
        },
        // Semantic (موحد مع vendor-web)
        success: '#27AE60',
        warning: '#F39C12',
        error: '#E74C3C',
        info: '#3498DB',
        // Admin layout
        border: '#E0E0E0',
        divider: '#F0F0F0',
      },
      fontFamily: {
        sans: ['system-ui', 'Tajawal', 'Inter', 'sans-serif'],
      },
      boxShadow: {
        card: '0 1px 3px 0 rgb(0 0 0 / 0.04), 0 1px 2px -1px rgb(0 0 0 / 0.03)',
        'card-hover':
          '0 12px 24px -8px rgb(0 0 0 / 0.08), 0 4px 8px -4px rgb(0 0 0 / 0.04)',
        elevated:
          '0 20px 25px -5px rgb(0 0 0 / 0.06), 0 8px 10px -6px rgb(0 0 0 / 0.04)',
        sidebar: '4px 0 24px -4px rgb(0 0 0 / 0.12)',
        'button-primary': '0 2px 8px -2px rgba(255, 107, 53, 0.35)',
      },
      borderRadius: {
        card: '14px',
        button: '10px',
        badge: '8px',
      },
      transitionDuration: {
        200: '200ms',
        250: '250ms',
        300: '300ms',
      },
    },
  },
  plugins: [],
}

export default config
