import { redirect } from 'next/navigation'

export default function HomePage() {
  // Redirect to login page instead of dashboard
  // Users should login first
  redirect('/login')
}
