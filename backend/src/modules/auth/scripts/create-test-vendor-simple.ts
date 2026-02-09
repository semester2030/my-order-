/**
 * Simple script to create test vendor account
 * Run this in a Node.js REPL or add to a migration
 * 
 * Usage:
 * import { createTestVendor } from './create-test-vendor-simple';
 * await createTestVendor(dataSource);
 */

import { DataSource } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { User } from '../../users/entities/user.entity';
import { Vendor } from '../../vendors/entities/vendor.entity';
import { VendorStaff } from '../../vendors/entities/vendor-staff.entity';
import { StaffRole } from '../../vendors/enums';

export async function createTestVendor(dataSource: DataSource) {
  const userRepository = dataSource.getRepository(User);
  const vendorRepository = dataSource.getRepository(Vendor);
  const staffRepository = dataSource.getRepository(VendorStaff);

  const TEST_EMAIL = 'cy-20@outlook.com';
  const TEST_PASSWORD = 'test123456';
  const TEST_PHONE = '+966501234567';

  try {
    // Hash password
    const passwordHash = await bcrypt.hash(TEST_PASSWORD, 10);

    // Check if user exists
    let user = await userRepository.findOne({ where: { email: TEST_EMAIL } });

    if (!user) {
      // Create user
      user = userRepository.create({
        phone: TEST_PHONE,
        name: 'Test Vendor',
        email: TEST_EMAIL,
        pinHash: passwordHash,
        isVerified: true,
        isActive: true,
      });
      user = await userRepository.save(user);
      console.log('✅ User created:', user.id);
    } else {
      // Update password if user exists
      user.pinHash = passwordHash;
      user.isVerified = true;
      user.isActive = true;
      user = await userRepository.save(user);
      console.log('✅ User updated:', user.id);
    }

    // Check if vendor exists
    let vendor = await vendorRepository.findOne({
      where: { email: TEST_EMAIL },
    });

    if (!vendor) {
      // Create vendor
      vendor = vendorRepository.create({
        name: 'Test Restaurant',
        tradeName: 'Test Restaurant',
        email: TEST_EMAIL,
        phoneNumber: TEST_PHONE,
        latitude: 24.7136,
        longitude: 46.6753,
        address: 'Test Address',
        city: 'Riyadh',
        district: 'Test District',
        isActive: true,
        isAcceptingOrders: true,
      });
      vendor = await vendorRepository.save(vendor);
      console.log('✅ Vendor created:', vendor.id);
    } else {
      console.log('✅ Vendor exists:', vendor.id);
    }

    // Check if staff exists
    let staff = await staffRepository.findOne({
      where: { userId: user.id, vendorId: vendor.id },
    });

    if (!staff) {
      // Create staff
      staff = staffRepository.create({
        vendorId: vendor.id,
        userId: user.id,
        role: StaffRole.OWNER,
        permissions: ['*'],
        isActive: true,
        acceptedAt: new Date(),
      });
      await staffRepository.save(staff);
      console.log('✅ Staff created:', staff.id);
    } else {
      console.log('✅ Staff exists:', staff.id);
    }

    console.log('\n🎉 Test vendor account created successfully!');
    console.log(`📧 Email: ${TEST_EMAIL}`);
    console.log(`🔑 Password: ${TEST_PASSWORD}`);
    console.log(`👤 User ID: ${user.id}`);
    console.log(`🏪 Vendor ID: ${vendor.id}`);
    console.log(`👔 Staff ID: ${staff.id}`);

    return { user, vendor, staff };
  } catch (error) {
    console.error('❌ Error creating test vendor:', error);
    throw error;
  }
}
