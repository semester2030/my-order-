export const Endpoints = {
  // Auth
  auth: {
    login: '/auth/vendor/login', // Vendor login endpoint
    logout: '/auth/logout',
    refresh: '/auth/refresh',
  },
  
  // Vendors
  vendors: {
    register: '/vendors/register',
    profile: '/vendors/profile',
    updateProfile: '/vendors/profile',
    changePassword: '/vendors/change-password',
    registrationStatus: (id: string) => `/vendors/registration-status/${id}`,
    certificates: '/vendors/certificates',
    addCertificate: '/vendors/certificates',
  },
  
  // Orders
  orders: {
    list: '/vendors/orders',
    detail: (id: string) => `/vendors/orders/${id}`,
    accept: (id: string) => `/vendors/orders/${id}/accept`,
    reject: (id: string) => `/vendors/orders/${id}/reject`,
    updateStatus: (id: string) => `/vendors/orders/${id}/status`,
  },
  
  // Menu
  menu: {
    list: '/vendors/menu',
    create: '/vendors/menu',
    update: (id: string) => `/vendors/menu/${id}`,
    delete: (id: string) => `/vendors/menu/${id}`,
    toggleAvailability: (id: string) => `/vendors/menu/${id}/availability`,
  },
  
  // Analytics
  analytics: {
    dashboard: '/vendors/analytics',
  },
  
  // Staff
  staff: {
    list: '/vendors/staff',
    create: '/vendors/staff',
    update: (id: string) => `/vendors/staff/${id}`,
    delete: (id: string) => `/vendors/staff/${id}`,
  },
  
  // Videos
  videos: {
    init: '/videos/upload/init',
    complete: '/videos/upload/complete',
    upload: (menuItemId: string) => `/videos/upload/${menuItemId}`, // Server-side upload
  },
} as const
