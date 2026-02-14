import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { EventRequest, EventRequestType, EventRequestStatus } from './entities/event-request.entity';
import { CreateEventRequestDto } from './dto/create-event-request.dto';

@Injectable()
export class EventRequestsService {
  constructor(
    @InjectRepository(EventRequest)
    private readonly eventRequestRepository: Repository<EventRequest>,
  ) {}

  async create(userId: string, dto: CreateEventRequestDto): Promise<EventRequest> {
    if (dto.requestType === EventRequestType.POPULAR_COOKING) {
      if (!dto.addressId?.trim()) {
        throw new BadRequestException('عنوان استقبال الذبايح مطلوب للطبخ الشعبي');
      }
    } else {
      if (!dto.dishIds?.length) {
        throw new BadRequestException('اختر طبقاً واحداً على الأقل');
      }
    }

    const entity = this.eventRequestRepository.create({
      userId,
      vendorId: dto.vendorId,
      addressId: dto.requestType === EventRequestType.POPULAR_COOKING ? dto.addressId : null,
      requestType: dto.requestType,
      scheduledDate: dto.scheduledDate,
      scheduledTime: dto.scheduledTime,
      guestsCount: dto.guestsCount ?? 1,
      addOns: dto.addOns?.length ? dto.addOns : null,
      dishIds: dto.dishIds?.length ? dto.dishIds : null,
      delivery: dto.requestType === EventRequestType.HOME_COOKING ? dto.delivery ?? false : null,
      notes: dto.notes?.trim() || null,
      status: EventRequestStatus.PENDING,
    });

    return this.eventRequestRepository.save(entity);
  }

  async findByUser(userId: string): Promise<EventRequest[]> {
    return this.eventRequestRepository.find({
      where: { userId },
      relations: ['vendor', 'address'],
      order: { createdAt: 'DESC' },
    });
  }
}
