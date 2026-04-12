import { apiClient } from './client'
import { Endpoints } from './endpoints'

/** التسجيل — مطلوب: الاسم، الإيميل، كلمة المرور، العنوان، المدينة، الإحداثيات. */
export interface RegisterVendorDto {
  name: string
  email: string
  password: string
  address: string
  city: string
  latitude: number
  longitude: number

  tradeName?: string
  type?: string
  description?: string
  providerCategory?: string
  phoneNumber?: string
  website?: string

  commercialRegistrationNumber?: string
  commercialRegistrationIssueDate?: string
  commercialRegistrationExpiryDate?: string

  district?: string
  postalCode?: string

  deliveryFee?: number
  deliveryRadius?: number
  estimatedDeliveryTime?: number

  ownerName?: string
  ownerPhone?: string
  ownerEmail?: string
  ownerIdNumber?: string
  ownerNationality?: string
  ownerAddress?: string

  bankName?: string
  bankAccountNumber?: string
  iban?: string
  accountHolderName?: string
  swiftCode?: string

  termsAccepted?: boolean
  privacyAccepted?: boolean

  /** للطبخ الشعبي: خدمات إضافية (جريش، قرصان، ادامات…) — JSON: [{ name, price }] */
  popularCookingAddOns?: string

  commercialRegistration?: File
  ownerId?: File
  logo?: File
  cover?: File
  restaurantImages?: File[]
}

export interface RegisterVendorResponse {
  vendorId: string
  status: string
  message: string
}

export const vendorsRegisterApi = {
  async register(data: RegisterVendorDto): Promise<RegisterVendorResponse> {
    const formData = new FormData()

    formData.append('name', data.name)
    formData.append('email', data.email)
    formData.append('password', data.password)
    formData.append('address', data.address)
    formData.append('city', data.city)
    formData.append('latitude', data.latitude.toString())
    formData.append('longitude', data.longitude.toString())

    if (data.tradeName) formData.append('tradeName', data.tradeName)
    if (data.type) formData.append('type', data.type)
    if (data.description) formData.append('description', data.description)
    if (data.providerCategory) formData.append('providerCategory', data.providerCategory)
    if (data.phoneNumber) formData.append('phoneNumber', data.phoneNumber)
    if (data.website) formData.append('website', data.website)

    if (data.commercialRegistrationNumber) formData.append('commercialRegistrationNumber', data.commercialRegistrationNumber)
    if (data.commercialRegistrationIssueDate) formData.append('commercialRegistrationIssueDate', data.commercialRegistrationIssueDate)
    if (data.commercialRegistrationExpiryDate) formData.append('commercialRegistrationExpiryDate', data.commercialRegistrationExpiryDate)

    if (data.district) formData.append('district', data.district)
    if (data.postalCode) formData.append('postalCode', data.postalCode)

    if (data.deliveryFee !== undefined) formData.append('deliveryFee', data.deliveryFee.toString())
    if (data.deliveryRadius !== undefined) formData.append('deliveryRadius', data.deliveryRadius.toString())
    if (data.estimatedDeliveryTime !== undefined) formData.append('estimatedDeliveryTime', data.estimatedDeliveryTime.toString())

    if (data.ownerName) formData.append('ownerName', data.ownerName)
    if (data.ownerPhone) formData.append('ownerPhone', data.ownerPhone)
    if (data.ownerEmail) formData.append('ownerEmail', data.ownerEmail)
    if (data.ownerIdNumber) formData.append('ownerIdNumber', data.ownerIdNumber)
    if (data.ownerNationality) formData.append('ownerNationality', data.ownerNationality)
    if (data.ownerAddress) formData.append('ownerAddress', data.ownerAddress)

    if (data.bankName) formData.append('bankName', data.bankName)
    if (data.bankAccountNumber) formData.append('bankAccountNumber', data.bankAccountNumber)
    if (data.iban) formData.append('iban', data.iban)
    if (data.accountHolderName) formData.append('accountHolderName', data.accountHolderName)
    if (data.swiftCode) formData.append('swiftCode', data.swiftCode)

    if (data.termsAccepted !== undefined) formData.append('termsAccepted', String(data.termsAccepted))
    if (data.privacyAccepted !== undefined) formData.append('privacyAccepted', String(data.privacyAccepted))

    if (data.popularCookingAddOns) formData.append('popularCookingAddOns', data.popularCookingAddOns)

    if (data.commercialRegistration) formData.append('commercialRegistration', data.commercialRegistration)
    if (data.ownerId) formData.append('ownerId', data.ownerId)
    if (data.logo) formData.append('logo', data.logo)
    if (data.cover) formData.append('cover', data.cover)
    if (data.restaurantImages?.length) {
      data.restaurantImages.forEach((file) => formData.append('restaurantImages', file))
    }

    const response = await apiClient.postFormData<RegisterVendorResponse>(
      Endpoints.vendors.register,
      formData,
    )
    return response.data
  },
}
