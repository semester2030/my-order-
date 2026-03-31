/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  /**
   * يوجّه طلبات /api/* من لوحة الإدارة (مثلاً :3002) إلى Nest (افتراضي :3001).
   * يمنع خطأ "Cannot GET /api/..." عندما يكون NEXT_PUBLIC_API_URL يشير بالخطأ لنفس منفذ Next.
   */
  async rewrites() {
    const target =
      process.env.API_PROXY_TARGET || 'http://localhost:3001';
    return [
      {
        source: '/api/:path*',
        destination: `${target.replace(/\/$/, '')}/api/:path*`,
      },
    ];
  },
};

module.exports = nextConfig;
