import { Injectable } from '@nestjs/common';

@Injectable()
export class NotificationsService {
  async getNotifications() {
    // TODO: Implement notifications
    return {
      notifications: [],
    };
  }
}
