import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as admin from 'firebase-admin';
import { FcmConfig } from './fcm.config';

export interface NotificationPayload {
  title: string;
  body: string;
  imageUrl?: string;
}

export interface NotificationData {
  [key: string]: string;
}

export interface SendNotificationOptions {
  token: string;
  notification: NotificationPayload;
  data?: NotificationData;
  android?: {
    priority?: 'normal' | 'high';
    ttl?: number; // seconds
  };
  apns?: {
    headers?: {
      'apns-priority'?: string;
      'apns-expiration'?: string;
    };
  };
}

/**
 * Firebase Cloud Messaging Service
 * 
 * Handles sending push notifications to mobile devices
 */
@Injectable()
export class FcmService {
  private readonly logger = new Logger(FcmService.name);
  private messaging: admin.messaging.Messaging | null;

  constructor(private readonly configService: ConfigService) {
    FcmConfig.initialize(configService);
    this.messaging = FcmConfig.getMessaging();
    
    if (!this.messaging) {
      this.logger.warn(
        'Firebase Admin not initialized. Push notifications will be disabled.',
      );
    }
  }

  /**
   * Send notification to single device
   */
  async sendNotification(options: SendNotificationOptions): Promise<boolean> {
    if (!this.messaging) {
      this.logger.warn('Firebase Admin not initialized. Cannot send notification.');
      return false;
    }

    try {
      const message: admin.messaging.Message = {
        token: options.token,
        notification: {
          title: options.notification.title,
          body: options.notification.body,
          imageUrl: options.notification.imageUrl,
        },
        data: this.convertDataToString(options.data || {}),
        android: {
          priority: options.android?.priority || 'high',
          ttl: options.android?.ttl || 600, // 10 minutes default
          notification: {
            sound: 'default',
            channelId: 'job_offers', // Android notification channel
            priority: 'high',
          },
        },
        apns: {
          headers: {
            'apns-priority': options.apns?.headers?.['apns-priority'] || '10',
            'apns-expiration': options.apns?.headers?.['apns-expiration'] || undefined,
          },
          payload: {
            aps: {
              sound: 'default',
              badge: 1,
              alert: {
                title: options.notification.title,
                body: options.notification.body,
              },
            },
          },
        },
      };

      const response = await this.messaging.send(message);
      this.logger.log(`Notification sent successfully: ${response}`);
      return true;
    } catch (error) {
      this.logger.error(`Failed to send notification: ${error.message}`, error.stack);
      
      // Handle invalid token
      if (error.code === 'messaging/invalid-registration-token' || 
          error.code === 'messaging/registration-token-not-registered') {
        this.logger.warn(`Invalid FCM token: ${options.token}`);
        // TODO: Mark token as invalid in database
      }
      
      return false;
    }
  }

  /**
   * Send notification to multiple devices
   */
  async sendMulticast(
    tokens: string[],
    notification: NotificationPayload,
    data?: NotificationData,
  ): Promise<{ successCount: number; failureCount: number; invalidTokens: string[] }> {
    if (!this.messaging) {
      this.logger.warn('Firebase Admin not initialized. Cannot send notification.');
      return { successCount: 0, failureCount: tokens.length, invalidTokens: [] };
    }

    if (tokens.length === 0) {
      return { successCount: 0, failureCount: 0, invalidTokens: [] };
    }

    try {
      const message: admin.messaging.MulticastMessage = {
        tokens,
        notification: {
          title: notification.title,
          body: notification.body,
          imageUrl: notification.imageUrl,
        },
        data: this.convertDataToString(data || {}),
        android: {
          priority: 'high',
          ttl: 600,
          notification: {
            sound: 'default',
            channelId: 'job_offers',
            priority: 'high',
          },
        },
        apns: {
          headers: {
            'apns-priority': '10',
          },
          payload: {
            aps: {
              sound: 'default',
              badge: 1,
            },
          },
        },
      };

      const response = await this.messaging.sendEachForMulticast(message);
      
      const invalidTokens: string[] = [];
      if (response.failureCount > 0) {
        response.responses.forEach((resp, idx) => {
          if (!resp.success) {
            if (resp.error?.code === 'messaging/invalid-registration-token' ||
                resp.error?.code === 'messaging/registration-token-not-registered') {
              invalidTokens.push(tokens[idx]);
            }
          }
        });
      }

      this.logger.log(
        `Multicast notification sent: ${response.successCount} success, ${response.failureCount} failures`,
      );

      return {
        successCount: response.successCount,
        failureCount: response.failureCount,
        invalidTokens,
      };
    } catch (error) {
      this.logger.error(`Failed to send multicast notification: ${error.message}`, error.stack);
      return {
        successCount: 0,
        failureCount: tokens.length,
        invalidTokens: [],
      };
    }
  }

  /**
   * Validate FCM token
   */
  async validateToken(token: string): Promise<boolean> {
    if (!this.messaging) {
      this.logger.warn('Firebase Admin not initialized. Cannot validate token.');
      return false;
    }

    try {
      // Try to send a test message (silent)
      // If token is invalid, it will throw an error
      await this.messaging.send({
        token,
        data: { test: 'true' },
        android: { priority: 'normal' },
        apns: { headers: { 'apns-priority': '5' } },
      }, true); // dry run
      return true;
    } catch (error) {
      if (error.code === 'messaging/invalid-registration-token' ||
          error.code === 'messaging/registration-token-not-registered') {
        return false;
      }
      // Other errors might be temporary, consider token as valid
      return true;
    }
  }

  /**
   * Convert data object to string map (FCM requirement)
   */
  private convertDataToString(data: NotificationData): { [key: string]: string } {
    const result: { [key: string]: string } = {};
    for (const [key, value] of Object.entries(data)) {
      result[key] = String(value);
    }
    return result;
  }
}
