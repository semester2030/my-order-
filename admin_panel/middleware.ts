import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

const ADMIN_TOKEN_KEY = 'admin_token';
const LOGIN_PATH = '/auth/login';
const DASHBOARD_PREFIX = '/dashboard';

export function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;
  const token = request.cookies.get(ADMIN_TOKEN_KEY)?.value;

  // الصفحة الرئيسية: إن كان مسجّل دخول → الداشبورد، وإلا → تسجيل الدخول
  if (pathname === '/') {
    if (token) {
      return NextResponse.redirect(new URL(DASHBOARD_PREFIX, request.url));
    }
    return NextResponse.redirect(new URL(LOGIN_PATH, request.url));
  }

  const isProtected = pathname === DASHBOARD_PREFIX || pathname.startsWith(DASHBOARD_PREFIX + '/');
  const isLoginPage = pathname === LOGIN_PATH;

  if (isProtected && !token) {
    const loginUrl = new URL(LOGIN_PATH, request.url);
    loginUrl.searchParams.set('from', pathname);
    return NextResponse.redirect(loginUrl);
  }

  if (isLoginPage && token) {
    return NextResponse.redirect(new URL(DASHBOARD_PREFIX, request.url));
  }

  return NextResponse.next();
}

export const config = {
  matcher: ['/', '/dashboard', '/dashboard/:path*', '/auth/login'],
};
