import { Injectable, NotFoundException, BadRequestException, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { EventOffer } from './entities/event-offer.entity';
import { PrivateEventRequest } from './entities/private-event-request.entity';
import { CreatePrivateEventRequestDto } from './dto/create-private-event-request.dto';
import { CreateEventOfferDto } from './dto/create-event-offer.dto';
import { Vendor } from '../vendors/entities/vendor.entity';

@Injectable()
export class PrivateEventsService {
  constructor(
    @InjectRepository(EventOffer)
    private readonly eventOfferRepository: Repository<EventOffer>,
    @InjectRepository(PrivateEventRequest)
    private readonly privateEventRequestRepository: Repository<PrivateEventRequest>,
    @InjectRepository(Vendor)
    private readonly vendorRepository: Repository<Vendor>,
  ) {}

  async getVendorEventOffers(vendorId: string): Promise<EventOffer[]> {
    const vendor = await this.vendorRepository.findOne({ where: { id: vendorId } });
    if (!vendor) throw new NotFoundException('المقدم غير موجود');
    return this.eventOfferRepository.find({
      where: { vendorId, isActive: true },
      order: { serviceType: 'ASC', eventType: 'ASC' },
    });
  }

  async createEventOffer(vendorId: string, dto: CreateEventOfferDto): Promise<EventOffer> {
    const offer = this.eventOfferRepository.create({
      vendorId,
      serviceType: dto.serviceType,
      eventType: dto.eventType,
      title: dto.title?.trim() || null,
      description: dto.description?.trim() || null,
      pricePerPerson: dto.pricePerPerson ?? null,
      priceTotal: dto.priceTotal ?? null,
      minGuests: dto.minGuests ?? 1,
      maxGuests: dto.maxGuests ?? null,
      isActive: dto.isActive ?? true,
    });
    return this.eventOfferRepository.save(offer);
  }

  async updateEventOffer(vendorId: string, offerId: string, dto: Partial<CreateEventOfferDto>): Promise<EventOffer> {
    const offer = await this.eventOfferRepository.findOne({ where: { id: offerId, vendorId } });
    if (!offer) throw new NotFoundException('العرض غير موجود');
    if (dto.serviceType != null) offer.serviceType = dto.serviceType;
    if (dto.eventType != null) offer.eventType = dto.eventType;
    if (dto.title !== undefined) offer.title = dto.title?.trim() || null;
    if (dto.description !== undefined) offer.description = dto.description?.trim() || null;
    if (dto.pricePerPerson !== undefined) offer.pricePerPerson = dto.pricePerPerson;
    if (dto.priceTotal !== undefined) offer.priceTotal = dto.priceTotal;
    if (dto.minGuests != null) offer.minGuests = dto.minGuests;
    if (dto.maxGuests !== undefined) offer.maxGuests = dto.maxGuests;
    if (dto.isActive !== undefined) offer.isActive = dto.isActive;
    return this.eventOfferRepository.save(offer);
  }

  async deleteEventOffer(vendorId: string, offerId: string): Promise<void> {
    const result = await this.eventOfferRepository.delete({ id: offerId, vendorId });
    if (result.affected === 0) throw new NotFoundException('العرض غير موجود');
  }

  async getVendorEventOffersForManagement(vendorId: string): Promise<EventOffer[]> {
    return this.eventOfferRepository.find({
      where: { vendorId },
      order: { serviceType: 'ASC', eventType: 'ASC' },
    });
  }

  async createPrivateEventRequest(userId: string, dto: CreatePrivateEventRequestDto): Promise<PrivateEventRequest> {
    if (!dto.services?.length) {
      throw new BadRequestException('اختر خدمة واحدة على الأقل');
    }
    const vendor = await this.vendorRepository.findOne({ where: { id: dto.vendorId } });
    if (!vendor) throw new NotFoundException('المقدم غير موجود');
    if (vendor.providerCategory !== 'private_events') {
      throw new BadRequestException('هذا المقدم لا يقدم خدمات المناسبات الخاصة');
    }
    const request = this.privateEventRequestRepository.create({
      userId,
      vendorId: dto.vendorId,
      addressId: dto.addressId || null,
      eventType: dto.eventType,
      eventDate: dto.eventDate,
      eventTime: dto.eventTime,
      guestsCount: dto.guestsCount,
      services: dto.services,
      notes: dto.notes?.trim() || null,
      status: 'pending',
    });
    return this.privateEventRequestRepository.save(request);
  }

  async findPrivateEventRequestsByUser(userId: string): Promise<PrivateEventRequest[]> {
    return this.privateEventRequestRepository.find({
      where: { userId },
      relations: ['vendor', 'address'],
      order: { createdAt: 'DESC' },
    });
  }

  async findPrivateEventRequestsByVendor(vendorId: string): Promise<PrivateEventRequest[]> {
    return this.privateEventRequestRepository.find({
      where: { vendorId },
      relations: ['user', 'address'],
      order: { createdAt: 'DESC' },
    });
  }

  async updatePrivateEventRequestStatus(
    vendorId: string,
    requestId: string,
    status: 'accepted' | 'rejected' | 'cancelled',
  ): Promise<PrivateEventRequest> {
    const request = await this.privateEventRequestRepository.findOne({
      where: { id: requestId, vendorId },
      relations: ['user', 'address'],
    });
    if (!request) throw new NotFoundException('الطلب غير موجود');
    if (request.status !== 'pending') {
      throw new BadRequestException('لا يمكن تغيير حالة الطلب');
    }
    request.status = status;
    return this.privateEventRequestRepository.save(request);
  }
}
