import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        // Primary - Sunset Orange (نفس Customer App)
        primary: {
          DEFAULT: '#FF6B35',
          dark: '#E55A2B',
          light: '#FF8C5A',
          container: '#FFE5DC',
        },
        // Accent - Gold (نفس Customer App)
        accent: {
          DEFAULT: '#FFD700',
          dark: '#FFA500',
          light: '#FFE44D',
          container: '#FFF8DC',
        },
        // Secondary - Deep Charcoal (نفس Customer App)
        secondary: {
          DEFAULT: '#1A1A1A',
          dark: '#000000',
          light: '#2C3E50',
          container: '#F5F5F5',
        },
        // Background
        background: '#FFFFFF',
        surface: '#F8F9FA',
        surfaceElevated: '#FFFFFF',
        // Text
        text: {
          primary: '#1A1A1A',
          secondary: '#6C757D',
          tertiary: '#95A5A6',
          inverse: '#FFFFFF',
        },
        // Semantic Colors
        success: '#27AE60',
        warning: '#F39C12',
        error: '#E74C3C',
        info: '#3498DB',
        // Dashboard Specific
        sidebar: '#1A1A1A',
        sidebarHover: '#2C3E50',
        sidebarActive: '#FF6B35',
        border: '#E0E0E0',
        divider: '#F0F0F0',
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
      },
      borderRadius: {
        sm: '4px',
        md: '8px',
        lg: '12px',
        xl: '16px',
        full: '9999px',
      },
      boxShadow: {
        sm: '0 1px 2px 0 rgba(0, 0, 0, 0.05)',
        md: '0 4px 6px -1px rgba(0, 0, 0, 0.1)',
        lg: '0 10px 15px -3px rgba(0, 0, 0, 0.1)',
      },
    },
  },
  plugins: [],
}

export default config
