# Vendor Web App

Premium Food Delivery - Vendor Dashboard

## 🚀 Getting Started

### Prerequisites
- Node.js 18+ 
- npm or yarn

### Installation

```bash
npm install
```

### Development

```bash
npm run dev
```

Open [http://localhost:3001](http://localhost:3001) in your browser.

### Build

```bash
npm run build
npm start
```

## 📁 Project Structure

```
vendor-web/
├── app/                    # Next.js App Router pages
│   ├── dashboard/         # Dashboard page
│   ├── orders/            # Orders management
│   ├── menu/              # Menu management
│   ├── staff/             # Staff management
│   ├── settings/          # Settings page
│   └── login/             # Login page
├── components/            # React components
│   └── layout/           # Layout components (Sidebar, Header)
├── lib/                   # Utilities and API
│   ├── api/              # API client and endpoints
│   ├── store/            # Zustand stores
│   └── utils/            # Utility functions
└── public/               # Static assets
```

## 🎨 Theme

Uses the same color scheme as Customer App:
- **Primary:** Sunset Orange (#FF6B35)
- **Accent:** Gold (#FFD700)
- **Secondary:** Deep Charcoal (#1A1A1A)

## 🔗 API Integration

The app connects to the NestJS backend at:
- Default: `http://localhost:3000/api`
- Configure via `NEXT_PUBLIC_API_URL` environment variable

## 📝 Features

- ✅ Authentication (JWT)
- ✅ Dashboard with Analytics
- ✅ Orders Management
- ✅ Menu Management
- ✅ Staff Management
- ✅ Settings

## 🔒 Security

- JWT tokens stored in localStorage
- API client automatically adds Authorization header
- Protected routes with middleware
