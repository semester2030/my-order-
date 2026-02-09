'use client'

import { useState } from 'react'
import { X, Video } from 'lucide-react'
import { videosApi } from '@/lib/api/videos'
import { useLanguage } from '@/lib/contexts/language-context'

interface AddVideoModalProps {
  isOpen: boolean
  menuItemId: string
  menuItemName: string
  onClose: () => void
  onSuccess: () => void
}

/** أيقونة ثانية: إضافة فيديو لوجبة موجودة (بدون صور وبدون فيديو في الإضافة الأولى). */
export function AddVideoModal({
  isOpen,
  menuItemId,
  menuItemName,
  onClose,
  onSuccess,
}: AddVideoModalProps) {
  const { t } = useLanguage()
  const [videoFile, setVideoFile] = useState<File | null>(null)
  const [isUploading, setIsUploading] = useState(false)

  if (!isOpen) return null

  const handleVideoChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0]
    if (file) {
      if (file.size > 500 * 1024 * 1024) {
        alert(t('menuItem.videoMax500mb'))
        return
      }
      if (!file.type.startsWith('video/')) {
        alert(t('menuItem.selectValidVideo'))
        return
      }
      setVideoFile(file)
    }
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!videoFile) {
      alert(t('menuItem.selectVideoFirst'))
      return
    }
    try {
      setIsUploading(true)
      await videosApi.uploadVideo(menuItemId, videoFile)
      setVideoFile(null)
      onSuccess()
      onClose()
    } catch (error: any) {
      console.error('Video upload failed:', error)
      alert(error.response?.data?.message || t('menuItem.videoUploadFailed'))
    } finally {
      setIsUploading(false)
    }
  }

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-lg max-w-md w-full">
        <div className="flex items-center justify-between p-6 border-b border-border">
          <h2 className="text-xl font-bold text-text-primary">
            {t('menuItem.addVideo')}
          </h2>
          <button
            type="button"
            onClick={onClose}
            className="p-2 hover:bg-surface rounded-lg transition-colors"
            disabled={isUploading}
          >
            <X className="w-5 h-5" />
          </button>
        </div>
        <p className="px-6 pt-4 text-sm text-text-secondary">
          {t('menuItem.addVideoFor')}: <strong>{menuItemName}</strong>
        </p>
        <form onSubmit={handleSubmit} className="p-6 space-y-4">
          <div className="border-2 border-dashed border-border rounded-lg p-6 text-center">
            <input
              type="file"
              accept="video/*"
              onChange={handleVideoChange}
              className="hidden"
              id="video-upload-modal"
              disabled={isUploading}
            />
            <label
              htmlFor="video-upload-modal"
              className="cursor-pointer flex flex-col items-center gap-2"
            >
              <Video className="w-10 h-10 text-text-tertiary" />
              <span className="text-sm text-text-secondary">
                {videoFile ? videoFile.name : t('menuItem.clickUploadVideo')}
              </span>
              <span className="text-xs text-text-tertiary">
                {t('menuItem.max500mb')}
              </span>
            </label>
          </div>
          <div className="flex gap-3 pt-2">
            <button
              type="button"
              onClick={onClose}
              className="flex-1 px-4 py-2 border border-border rounded-lg text-text-primary hover:bg-surface transition-colors"
              disabled={isUploading}
            >
              {t('menuItem.cancel')}
            </button>
            <button
              type="submit"
              className="flex-1 px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
              disabled={isUploading || !videoFile}
            >
              {isUploading ? t('menuItem.uploading') : t('menuItem.uploadVideo')}
            </button>
          </div>
        </form>
      </div>
    </div>
  )
}
