import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

const ADMIN_TOKEN_KEY = 'admin_token';
const LOGIN_PATH = '/auth/login';

export function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;
  const token = request.cookies.get(ADMIN_TOKEN_KEY)?.value;

  /** طلبات البروكسي إلى Nest — لا نفرض كوكي هنا؛ التحقق بالـ Bearer على السيرفر */
  if (pathname === '/api' || pathname.startsWith('/api/')) {
    return NextResponse.next();
  }

  if (pathname === '/') {
    if (token) {
      return NextResponse.redirect(new URL('/dashboard', request.url));
    }
    return NextResponse.redirect(new URL(LOGIN_PATH, request.url));
  }

  const isLoginPage =
    pathname === LOGIN_PATH || pathname.startsWith(`${LOGIN_PATH}/`);

  if (isLoginPage) {
    if (token) {
      return NextResponse.redirect(new URL('/dashboard', request.url));
    }
    return NextResponse.next();
  }

  if (!token) {
    const loginUrl = new URL(LOGIN_PATH, request.url);
    loginUrl.searchParams.set('from', pathname);
    return NextResponse.redirect(loginUrl);
  }

  return NextResponse.next();
}

/** يطابق كل المسارات ما عدا أصول Next الثابتة — حتى تُحمى /audit_logs و /team وغيرها */
export const config = {
  matcher: ['/((?!_next/static|_next/image|favicon.ico).*)'],
};
