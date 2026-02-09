import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Address } from './entities/address.entity';

@Injectable()
export class AddressesService {
  constructor(
    @InjectRepository(Address)
    private readonly addressRepository: Repository<Address>,
  ) {}

  async getAddresses(userId: string) {
    const addresses = await this.addressRepository.find({
      where: {
        userId,
        isActive: true,
      },
      order: {
        isDefault: 'DESC',
        createdAt: 'DESC',
      },
    });
    // Convert to snake_case for Flutter compatibility
    return addresses.map((address) => ({
      id: address.id,
      user_id: address.userId,
      label: address.label,
      street_address: address.streetAddress,
      building: address.building,
      floor: address.floor,
      apartment: address.apartment,
      city: address.city,
      district: address.district,
      postal_code: address.postalCode,
      latitude: address.latitude,
      longitude: address.longitude,
      is_default: address.isDefault,
      is_active: address.isActive,
      created_at: address.createdAt.toISOString(),
      updated_at: address.updatedAt.toISOString(),
    }));
  }

  async getDefaultAddress(userId: string) {
    const address = await this.addressRepository.findOne({
      where: {
        userId,
        isDefault: true,
        isActive: true,
      },
    });
    if (!address) {
      return null;
    }
    // Convert to snake_case for Flutter compatibility
    return {
      id: address.id,
      user_id: address.userId,
      label: address.label,
      street_address: address.streetAddress,
      building: address.building,
      floor: address.floor,
      apartment: address.apartment,
      city: address.city,
      district: address.district,
      postal_code: address.postalCode,
      latitude: address.latitude,
      longitude: address.longitude,
      is_default: address.isDefault,
      is_active: address.isActive,
      created_at: address.createdAt.toISOString(),
      updated_at: address.updatedAt.toISOString(),
    };
  }

  async addAddress(userId: string, addressData: Partial<Address>) {
    const address = this.addressRepository.create({
      ...addressData,
      userId,
    });
    const savedAddress = await this.addressRepository.save(address);
    // Convert to snake_case for Flutter compatibility
    return {
      id: savedAddress.id,
      user_id: savedAddress.userId,
      label: savedAddress.label,
      street_address: savedAddress.streetAddress,
      building: savedAddress.building,
      floor: savedAddress.floor,
      apartment: savedAddress.apartment,
      city: savedAddress.city,
      district: savedAddress.district,
      postal_code: savedAddress.postalCode,
      latitude: savedAddress.latitude,
      longitude: savedAddress.longitude,
      is_default: savedAddress.isDefault,
      is_active: savedAddress.isActive,
      created_at: savedAddress.createdAt.toISOString(),
      updated_at: savedAddress.updatedAt.toISOString(),
    };
  }

  async updateAddress(
    userId: string,
    id: string,
    addressData: Partial<Address>,
  ) {
    // Verify address belongs to user
    const address = await this.addressRepository.findOne({
      where: { id, userId },
    });

    if (!address) {
      throw new NotFoundException('Address not found or does not belong to user');
    }

    await this.addressRepository.update(id, addressData);
    const updatedAddress = await this.addressRepository.findOne({ where: { id, userId } });
    if (!updatedAddress) {
      throw new NotFoundException('Address not found after update');
    }
    // Convert to snake_case for Flutter compatibility
    return {
      id: updatedAddress.id,
      user_id: updatedAddress.userId,
      label: updatedAddress.label,
      street_address: updatedAddress.streetAddress,
      building: updatedAddress.building,
      floor: updatedAddress.floor,
      apartment: updatedAddress.apartment,
      city: updatedAddress.city,
      district: updatedAddress.district,
      postal_code: updatedAddress.postalCode,
      latitude: updatedAddress.latitude,
      longitude: updatedAddress.longitude,
      is_default: updatedAddress.isDefault,
      is_active: updatedAddress.isActive,
      created_at: updatedAddress.createdAt.toISOString(),
      updated_at: updatedAddress.updatedAt.toISOString(),
    };
  }

  async deleteAddress(userId: string, id: string) {
    // Verify address belongs to user
    const address = await this.addressRepository.findOne({
      where: { id, userId },
    });

    if (!address) {
      throw new NotFoundException('Address not found or does not belong to user');
    }

    await this.addressRepository.delete(id);
    return { message: 'Address deleted successfully' };
  }
}
