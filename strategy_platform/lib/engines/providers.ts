import type { ProviderSegment } from '../types'

export type ProviderFunnelResult = ProviderSegment & {
  endToEndConversion: number
  activeProviders: number
  monthlyChurnCount: number
  retentionRate: number
}

export function analyzeProviderFunnel(segments: ProviderSegment[], monthlyLeads = 500) {
  return segments.map((seg) => {
    const endToEnd =
      (seg.leadToSignup / 100) *
      (seg.signupToApplication / 100) *
      (seg.applicationToApproval / 100) *
      (seg.approvalToActive / 100) *
      100
    const activeProviders = Math.floor(monthlyLeads * (endToEnd / 100))
    const monthlyChurnCount = Math.floor(activeProviders * (seg.monthlyChurn / 100))
    const retentionRate = 100 - seg.monthlyChurn
    return { ...seg, endToEndConversion: endToEnd, activeProviders, monthlyChurnCount, retentionRate }
  })
}

export function providerFunnelSteps(seg: ProviderSegment) {
  const leads = 1000
  const signups = leads * (seg.leadToSignup / 100)
  const applications = signups * (seg.signupToApplication / 100)
  const approved = applications * (seg.applicationToApproval / 100)
  const active = approved * (seg.approvalToActive / 100)
  return [
    { stage: 'Leads', stageAr: 'عملاء محتملين', count: leads },
    { stage: 'Signups', stageAr: 'تسجيل', count: signups },
    { stage: 'Applications', stageAr: 'طلبات', count: applications },
    { stage: 'Approved', stageAr: 'موافق عليه', count: approved },
    { stage: 'Active', stageAr: 'نشط', count: active },
  ]
}
