/**
 * موديول «السائقين» يمثل مستقبلاً عاملي التوصيل (ليس جزءاً من المنتج الحالي).
 * أسماء الجداول والكيانات تبقى للتوافق مع قاعدة البيانات وواجهات قديمة.
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { DriversController } from './drivers.controller';
import { DriversService } from './drivers.service';
import { Driver } from './entities/driver.entity';
import { User } from '../users/entities/user.entity';
import { UsersModule } from '../users/users.module';

@Module({
  imports: [TypeOrmModule.forFeature([Driver, User]), UsersModule],
  controllers: [DriversController],
  providers: [DriversService],
  exports: [DriversService, TypeOrmModule],
})
export class DriversModule {}
