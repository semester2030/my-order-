import { redirect } from 'next/navigation'

export default function Home() {
  // TODO: check auth; if not logged in → /auth/login, else → /dashboard
  redirect('/dashboard')
}
