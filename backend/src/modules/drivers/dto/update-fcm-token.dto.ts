import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsNotEmpty } from 'class-validator';

export class UpdateFcmTokenDto {
  @ApiProperty({
    description: 'FCM token from Firebase Cloud Messaging',
    example: 'fcm-token-string-here',
  })
  @IsString()
  @IsNotEmpty()
  fcmToken: string;
}
