import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as admin from 'firebase-admin';

/**
 * Firebase Cloud Messaging Configuration
 * 
 * Setup:
 * 1. Create Firebase project
 * 2. Download service account key (JSON)
 * 3. Save to backend/firebase-service-account.json
 * 4. Add to .env: FIREBASE_SERVICE_ACCOUNT_PATH=./firebase-service-account.json
 */
@Injectable()
export class FcmConfig {
  private static initialized = false;

  static initialize(configService: ConfigService) {
    if (this.initialized) {
      return;
    }

    const serviceAccountPath = configService.get<string>(
      'FIREBASE_SERVICE_ACCOUNT_PATH',
    );

    if (!serviceAccountPath) {
      // Firebase is optional in development
      // Will be required when actually sending notifications
      console.warn(
        '⚠️  FIREBASE_SERVICE_ACCOUNT_PATH not set. Push notifications will be disabled.',
      );
      return;
    }

    try {
      const serviceAccount = require(serviceAccountPath);

      admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
      });

      this.initialized = true;
      console.log('✅ Firebase Admin initialized successfully');
    } catch (error) {
      console.warn(
        `⚠️  Failed to initialize Firebase Admin: ${error.message}`,
      );
      // Don't throw - allow app to start without Firebase
    }
  }

  static getMessaging() {
    if (!this.initialized) {
      return null; // Return null instead of throwing
    }
    return admin.messaging();
  }
}
