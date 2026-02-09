import { Module, Global } from '@nestjs/common';
import { FcmService } from './fcm.service';

/**
 * FCM Module - Global module for Firebase Cloud Messaging
 * 
 * Can be imported by any module that needs to send notifications
 */
@Global()
@Module({
  providers: [FcmService],
  exports: [FcmService],
})
export class FcmModule {}
