import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './app/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        brand: {
          DEFAULT: '#FF6A33',
          dark: '#E55A28',
          light: '#FF8A5C',
          muted: '#FFF0EA',
        },
        ink: {
          DEFAULT: '#1A1A1A',
          soft: '#2D2D2D',
          muted: '#6B7280',
        },
        glass: {
          DEFAULT: 'rgba(255,255,255,0.72)',
          border: 'rgba(255,255,255,0.45)',
        },
      },
      fontFamily: {
        sans: ['system-ui', 'Tajawal', 'Inter', 'sans-serif'],
      },
      boxShadow: {
        glass: '0 8px 32px rgba(0,0,0,0.06)',
        card: '0 1px 3px rgba(0,0,0,0.04), 0 8px 24px rgba(0,0,0,0.04)',
        glow: '0 0 40px rgba(255,106,51,0.15)',
      },
      borderRadius: {
        xl: '16px',
        '2xl': '20px',
      },
      backdropBlur: {
        glass: '20px',
      },
    },
  },
  plugins: [],
}

export default config
