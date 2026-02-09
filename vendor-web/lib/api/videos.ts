import { apiClient } from './client'
import { Endpoints } from './endpoints'

export interface VideoUploadInit {
  uploadId: string
  uploadUrl: string
  cloudflareAssetId: string // Asset ID from Cloudflare
  expiresAt: string
}

export interface VideoAsset {
  id: string
  menuItemId: string
  cloudflareAssetId: string
  playbackUrl: string
  thumbnailUrl: string | null
  duration: number
  status: 'processing' | 'ready' | 'failed'
  isPrimary: boolean
  createdAt: string
}

export interface InitUploadDto {
  menuItemId: string
  fileName: string
  fileSize: number
}

export interface CompleteUploadDto {
  uploadId: string
  menuItemId: string
  cloudflareAssetId: string
}

export const videosApi = {
  async initUpload(data: InitUploadDto): Promise<VideoUploadInit> {
    const response = await apiClient.post<VideoUploadInit>(
      Endpoints.videos.init,
      data,
    )
    return response.data
  },

  async completeUpload(data: CompleteUploadDto): Promise<VideoAsset> {
    const response = await apiClient.post<VideoAsset>(
      Endpoints.videos.complete,
      data,
    )
    return response.data
  },

  async uploadVideo(menuItemId: string, videoFile: File): Promise<VideoAsset> {
    // Upload video through server (avoids CORS issues)
    const formData = new FormData()
    formData.append('video', videoFile)
    
    const response = await apiClient.postFormData<VideoAsset>(
      Endpoints.videos.upload(menuItemId),
      formData,
    )
    return response.data
  },
}
