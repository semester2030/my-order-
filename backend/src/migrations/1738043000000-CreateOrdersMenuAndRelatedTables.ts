import {
  MigrationInterface,
  QueryRunner,
  Table,
  TableForeignKey,
  TableIndex,
} from 'typeorm';

/**
 * Creates tables required by vendor/customer flows on Render: addresses, menu_items,
 * video_assets, orders, order_items, payments, carts, cart_items, drivers.
 * Idempotent: each table is created only if it does not exist; enums use duplicate_object handling.
 */
export class CreateOrdersMenuAndRelatedTables1738043000000
  implements MigrationInterface
{
  name = 'CreateOrdersMenuAndRelatedTables1738043000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    // Ensure UUID extension exists (required for uuid_generate_v4())
    await queryRunner.query(`
      CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
    `);

    // ----- Enums (idempotent: ignore if already exist) -----
    await queryRunner.query(`
      DO $$ BEGIN
        CREATE TYPE "order_status_enum" AS ENUM(
          'pending', 'confirmed', 'preparing', 'ready',
          'out_for_delivery', 'delivered', 'cancelled'
        );
      EXCEPTION WHEN duplicate_object THEN NULL;
      END $$;
    `);
    await queryRunner.query(`
      DO $$ BEGIN
        CREATE TYPE "payment_method_enum" AS ENUM('apple_pay', 'mada', 'stc_pay');
      EXCEPTION WHEN duplicate_object THEN NULL;
      END $$;
    `);
    await queryRunner.query(`
      DO $$ BEGIN
        CREATE TYPE "payment_status_enum" AS ENUM(
          'pending', 'processing', 'completed', 'failed', 'refunded'
        );
      EXCEPTION WHEN duplicate_object THEN NULL;
      END $$;
    `);
    await queryRunner.query(`
      DO $$ BEGIN
        CREATE TYPE "video_assets_status_enum" AS ENUM('processing', 'ready', 'failed');
      EXCEPTION WHEN duplicate_object THEN NULL;
      END $$;
    `);
    await queryRunner.query(`
      DO $$ BEGIN
        CREATE TYPE "driver_status_enum" AS ENUM(
          'pending', 'under_review', 'documents_requested',
          'approved', 'rejected', 'suspended', 'inactive'
        );
      EXCEPTION WHEN duplicate_object THEN NULL;
      END $$;
    `);
    await queryRunner.query(`
      DO $$ BEGIN
        CREATE TYPE "license_type_enum" AS ENUM('private', 'public', 'transport');
      EXCEPTION WHEN duplicate_object THEN NULL;
      END $$;
    `);
    await queryRunner.query(`
      DO $$ BEGIN
        CREATE TYPE "vehicle_type_enum" AS ENUM('motorcycle', 'car', 'van', 'truck');
      EXCEPTION WHEN duplicate_object THEN NULL;
      END $$;
    `);

    // ----- 1. addresses (depends on: users) -----
    if (!(await queryRunner.hasTable('addresses'))) {
      await queryRunner.createTable(
        new Table({
          name: 'addresses',
          columns: [
            {
              name: 'id',
              type: 'uuid',
              isPrimary: true,
              generationStrategy: 'uuid',
              default: 'uuid_generate_v4()',
            },
            { name: 'user_id', type: 'uuid', isNullable: false },
            { name: 'label', type: 'varchar', isNullable: false },
            { name: 'street_address', type: 'varchar', isNullable: false },
            { name: 'building', type: 'varchar', isNullable: true },
            { name: 'floor', type: 'varchar', isNullable: true },
            { name: 'apartment', type: 'varchar', isNullable: true },
            { name: 'city', type: 'varchar', isNullable: false },
            { name: 'district', type: 'varchar', isNullable: true },
            { name: 'postal_code', type: 'varchar', isNullable: true },
            {
              name: 'latitude',
              type: 'decimal',
              precision: 10,
              scale: 8,
              isNullable: false,
            },
            {
              name: 'longitude',
              type: 'decimal',
              precision: 11,
              scale: 8,
              isNullable: false,
            },
            {
              name: 'is_default',
              type: 'boolean',
              default: false,
              isNullable: false,
            },
            {
              name: 'is_active',
              type: 'boolean',
              default: true,
              isNullable: false,
            },
            {
              name: 'created_at',
              type: 'timestamp',
              default: 'CURRENT_TIMESTAMP',
              isNullable: false,
            },
            {
              name: 'updated_at',
              type: 'timestamp',
              default: 'CURRENT_TIMESTAMP',
              isNullable: false,
            },
          ],
        }),
        true,
      );
      await queryRunner.createForeignKey(
        'addresses',
        new TableForeignKey({
          columnNames: ['user_id'],
          referencedTableName: 'users',
          referencedColumnNames: ['id'],
          onDelete: 'CASCADE',
        }),
      );
      await queryRunner.createIndex(
        'addresses',
        new TableIndex({ name: 'IDX_addresses_user_id', columnNames: ['user_id'] }),
      );
    }

    // ----- 2. menu_items (depends on: vendors) -----
    if (!(await queryRunner.hasTable('menu_items'))) {
      await queryRunner.createTable(
        new Table({
          name: 'menu_items',
          columns: [
            {
              name: 'id',
              type: 'uuid',
              isPrimary: true,
              generationStrategy: 'uuid',
              default: 'uuid_generate_v4()',
            },
            { name: 'vendor_id', type: 'uuid', isNullable: false },
            { name: 'name', type: 'varchar', isNullable: false },
            { name: 'description', type: 'text', isNullable: true },
            {
              name: 'price',
              type: 'decimal',
              precision: 10,
              scale: 2,
              isNullable: false,
            },
            { name: 'image', type: 'varchar', isNullable: true },
            {
              name: 'is_signature',
              type: 'boolean',
              default: false,
              isNullable: false,
            },
            {
              name: 'is_available',
              type: 'boolean',
              default: true,
              isNullable: false,
            },
            {
              name: 'order_count',
              type: 'int',
              default: 0,
              isNullable: false,
            },
            {
              name: 'created_at',
              type: 'timestamp',
              default: 'CURRENT_TIMESTAMP',
              isNullable: false,
            },
            {
              name: 'updated_at',
              type: 'timestamp',
              default: 'CURRENT_TIMESTAMP',
              isNullable: false,
            },
          ],
        }),
        true,
      );
      await queryRunner.createForeignKey(
        'menu_items',
        new TableForeignKey({
          columnNames: ['vendor_id'],
          referencedTableName: 'vendors',
          referencedColumnNames: ['id'],
          onDelete: 'CASCADE',
        }),
      );
      await queryRunner.createIndex(
        'menu_items',
        new TableIndex({
          name: 'IDX_menu_items_vendor_id',
          columnNames: ['vendor_id'],
        }),
      );
    }

    // ----- 3. video_assets (depends on: menu_items) -----
    if (!(await queryRunner.hasTable('video_assets'))) {
      await queryRunner.createTable(
        new Table({
          name: 'video_assets',
          columns: [
            {
              name: 'id',
              type: 'uuid',
              isPrimary: true,
              generationStrategy: 'uuid',
              default: 'uuid_generate_v4()',
            },
            { name: 'menu_item_id', type: 'uuid', isNullable: false },
            {
              name: 'cloudflare_asset_id',
              type: 'varchar',
              isNullable: false,
              isUnique: true,
            },
            { name: 'playback_url', type: 'varchar', isNullable: false },
            { name: 'thumbnail_url', type: 'varchar', isNullable: true },
            { name: 'duration', type: 'int', isNullable: false },
            {
              name: 'status',
              type: 'video_assets_status_enum',
              default: "'processing'",
              isNullable: false,
            },
            {
              name: 'is_primary',
              type: 'boolean',
              default: false,
              isNullable: false,
            },
            {
              name: 'created_at',
              type: 'timestamp',
              default: 'CURRENT_TIMESTAMP',
              isNullable: false,
            },
            {
              name: 'updated_at',
              type: 'timestamp',
              default: 'CURRENT_TIMESTAMP',
              isNullable: false,
            },
          ],
        }),
        true,
      );
      await queryRunner.createForeignKey(
        'video_assets',
        new TableForeignKey({
          columnNames: ['menu_item_id'],
          referencedTableName: 'menu_items',
          referencedColumnNames: ['id'],
          onDelete: 'CASCADE',
        }),
      );
      await queryRunner.createIndex(
        'video_assets',
        new TableIndex({
          name: 'IDX_video_assets_menu_item_id',
          columnNames: ['menu_item_id'],
        }),
      );
    }

    // ----- 4. orders (depends on: users, vendors, addresses; driver_id added after drivers) -----
    if (!(await queryRunner.hasTable('orders'))) {
      await queryRunner.createTable(
        new Table({
          name: 'orders',
          columns: [
            {
              name: 'id',
              type: 'uuid',
              isPrimary: true,
              generationStrategy: 'uuid',
              default: 'uuid_generate_v4()',
            },
            { name: 'user_id', type: 'uuid', isNullable: false },
            { name: 'vendor_id', type: 'uuid', isNullable: false },
            { name: 'address_id', type: 'uuid', isNullable: false },
            {
              name: 'order_number',
              type: 'varchar',
              isNullable: false,
              isUnique: true,
            },
            {
              name: 'status',
              type: 'order_status_enum',
              default: "'pending'",
              isNullable: false,
            },
            {
              name: 'subtotal',
              type: 'decimal',
              precision: 10,
              scale: 2,
              isNullable: false,
            },
            {
              name: 'delivery_fee',
              type: 'decimal',
              precision: 10,
              scale: 2,
              default: 0,
              isNullable: false,
            },
            {
              name: 'total',
              type: 'decimal',
              precision: 10,
              scale: 2,
              isNullable: false,
            },
            {
              name: 'estimated_delivery_time',
              type: 'timestamp',
              isNullable: true,
            },
            { name: 'delivered_at', type: 'timestamp', isNullable: true },
            { name: 'driver_id', type: 'uuid', isNullable: true },
            {
              name: 'driver_latitude',
              type: 'decimal',
              precision: 10,
              scale: 8,
              isNullable: true,
            },
            {
              name: 'driver_longitude',
              type: 'decimal',
              precision: 11,
              scale: 8,
              isNullable: true,
            },
            {
              name: 'created_at',
              type: 'timestamp',
              default: 'CURRENT_TIMESTAMP',
              isNullable: false,
            },
            {
              name: 'updated_at',
              type: 'timestamp',
              default: 'CURRENT_TIMESTAMP',
              isNullable: false,
            },
          ],
        }),
        true,
      );
      await queryRunner.createForeignKey(
        'orders',
        new TableForeignKey({
          columnNames: ['user_id'],
          referencedTableName: 'users',
          referencedColumnNames: ['id'],
          onDelete: 'CASCADE',
        }),
      );
      await queryRunner.createForeignKey(
        'orders',
        new TableForeignKey({
          columnNames: ['vendor_id'],
          referencedTableName: 'vendors',
          referencedColumnNames: ['id'],
        }),
      );
      await queryRunner.createForeignKey(
        'orders',
        new TableForeignKey({
          columnNames: ['address_id'],
          referencedTableName: 'addresses',
          referencedColumnNames: ['id'],
          onDelete: 'RESTRICT',
        }),
      );
      await queryRunner.createIndex(
        'orders',
        new TableIndex({ name: 'IDX_orders_vendor_id', columnNames: ['vendor_id'] }),
      );
      await queryRunner.createIndex(
        'orders',
        new TableIndex({ name: 'IDX_orders_user_id', columnNames: ['user_id'] }),
      );
    }

    // ----- 5. order_items (depends on: orders, menu_items) -----
    if (!(await queryRunner.hasTable('order_items'))) {
      await queryRunner.createTable(
        new Table({
          name: 'order_items',
          columns: [
            {
              name: 'id',
              type: 'uuid',
              isPrimary: true,
              generationStrategy: 'uuid',
              default: 'uuid_generate_v4()',
            },
            { name: 'order_id', type: 'uuid', isNullable: false },
            { name: 'menu_item_id', type: 'uuid', isNullable: false },
            { name: 'quantity', type: 'int', isNullable: false },
            {
              name: 'price',
              type: 'decimal',
              precision: 10,
              scale: 2,
              isNullable: false,
            },
            {
              name: 'created_at',
              type: 'timestamp',
              default: 'CURRENT_TIMESTAMP',
              isNullable: false,
            },
          ],
        }),
        true,
      );
      await queryRunner.createForeignKey(
        'order_items',
        new TableForeignKey({
          columnNames: ['order_id'],
          referencedTableName: 'orders',
          referencedColumnNames: ['id'],
          onDelete: 'CASCADE',
        }),
      );
      await queryRunner.createForeignKey(
        'order_items',
        new TableForeignKey({
          columnNames: ['menu_item_id'],
          referencedTableName: 'menu_items',
          referencedColumnNames: ['id'],
          onDelete: 'CASCADE',
        }),
      );
      await queryRunner.createIndex(
        'order_items',
        new TableIndex({
          name: 'IDX_order_items_order_id',
          columnNames: ['order_id'],
        }),
      );
    }

    // ----- 6. payments (depends on: orders) -----
    if (!(await queryRunner.hasTable('payments'))) {
      await queryRunner.createTable(
        new Table({
          name: 'payments',
          columns: [
            {
              name: 'id',
              type: 'uuid',
              isPrimary: true,
              generationStrategy: 'uuid',
              default: 'uuid_generate_v4()',
            },
            { name: 'order_id', type: 'uuid', isNullable: false },
            {
              name: 'method',
              type: 'payment_method_enum',
              isNullable: false,
            },
            {
              name: 'status',
              type: 'payment_status_enum',
              default: "'pending'",
              isNullable: false,
            },
            {
              name: 'amount',
              type: 'decimal',
              precision: 10,
              scale: 2,
              isNullable: false,
            },
            { name: 'transaction_id', type: 'varchar', isNullable: true },
            { name: 'gateway_response', type: 'text', isNullable: true },
            { name: 'failure_reason', type: 'text', isNullable: true },
            {
              name: 'created_at',
              type: 'timestamp',
              default: 'CURRENT_TIMESTAMP',
              isNullable: false,
            },
            {
              name: 'updated_at',
              type: 'timestamp',
              default: 'CURRENT_TIMESTAMP',
              isNullable: false,
            },
          ],
        }),
        true,
      );
      await queryRunner.createForeignKey(
        'payments',
        new TableForeignKey({
          columnNames: ['order_id'],
          referencedTableName: 'orders',
          referencedColumnNames: ['id'],
          onDelete: 'CASCADE',
        }),
      );
      await queryRunner.createIndex(
        'payments',
        new TableIndex({
          name: 'IDX_payments_order_id',
          columnNames: ['order_id'],
        }),
      );
    }

    // ----- 7. carts (depends on: users, vendors) -----
    if (!(await queryRunner.hasTable('carts'))) {
      await queryRunner.createTable(
        new Table({
          name: 'carts',
          columns: [
            {
              name: 'id',
              type: 'uuid',
              isPrimary: true,
              generationStrategy: 'uuid',
              default: 'uuid_generate_v4()',
            },
            { name: 'user_id', type: 'uuid', isNullable: false },
            { name: 'vendor_id', type: 'uuid', isNullable: true },
            {
              name: 'subtotal',
              type: 'decimal',
              precision: 10,
              scale: 2,
              default: 0,
              isNullable: false,
            },
            {
              name: 'delivery_fee',
              type: 'decimal',
              precision: 10,
              scale: 2,
              default: 0,
              isNullable: false,
            },
            {
              name: 'total',
              type: 'decimal',
              precision: 10,
              scale: 2,
              default: 0,
              isNullable: false,
            },
            {
              name: 'created_at',
              type: 'timestamp',
              default: 'CURRENT_TIMESTAMP',
              isNullable: false,
            },
            {
              name: 'updated_at',
              type: 'timestamp',
              default: 'CURRENT_TIMESTAMP',
              isNullable: false,
            },
          ],
        }),
        true,
      );
      await queryRunner.createForeignKey(
        'carts',
        new TableForeignKey({
          columnNames: ['user_id'],
          referencedTableName: 'users',
          referencedColumnNames: ['id'],
          onDelete: 'CASCADE',
        }),
      );
      await queryRunner.createForeignKey(
        'carts',
        new TableForeignKey({
          columnNames: ['vendor_id'],
          referencedTableName: 'vendors',
          referencedColumnNames: ['id'],
          onDelete: 'SET NULL',
        }),
      );
    }

    // ----- 8. cart_items (depends on: carts, menu_items) -----
    if (!(await queryRunner.hasTable('cart_items'))) {
      await queryRunner.createTable(
        new Table({
          name: 'cart_items',
          columns: [
            {
              name: 'id',
              type: 'uuid',
              isPrimary: true,
              generationStrategy: 'uuid',
              default: 'uuid_generate_v4()',
            },
            { name: 'cart_id', type: 'uuid', isNullable: false },
            { name: 'menu_item_id', type: 'uuid', isNullable: false },
            {
              name: 'quantity',
              type: 'int',
              default: 1,
              isNullable: false,
            },
            {
              name: 'price',
              type: 'decimal',
              precision: 10,
              scale: 2,
              isNullable: false,
            },
            {
              name: 'created_at',
              type: 'timestamp',
              default: 'CURRENT_TIMESTAMP',
              isNullable: false,
            },
            {
              name: 'updated_at',
              type: 'timestamp',
              default: 'CURRENT_TIMESTAMP',
              isNullable: false,
            },
          ],
        }),
        true,
      );
      await queryRunner.createForeignKey(
        'cart_items',
        new TableForeignKey({
          columnNames: ['cart_id'],
          referencedTableName: 'carts',
          referencedColumnNames: ['id'],
          onDelete: 'CASCADE',
        }),
      );
      await queryRunner.createForeignKey(
        'cart_items',
        new TableForeignKey({
          columnNames: ['menu_item_id'],
          referencedTableName: 'menu_items',
          referencedColumnNames: ['id'],
          onDelete: 'CASCADE',
        }),
      );
    }

    // ----- 9. drivers (depends on: users) -----
    if (!(await queryRunner.hasTable('drivers'))) {
      await queryRunner.createTable(
        new Table({
          name: 'drivers',
          columns: [
            {
              name: 'id',
              type: 'uuid',
              isPrimary: true,
              generationStrategy: 'uuid',
              default: 'uuid_generate_v4()',
            },
            { name: 'user_id', type: 'uuid', isNullable: false, isUnique: true },
            { name: 'full_name', type: 'varchar', isNullable: true },
            { name: 'national_id', type: 'varchar', isNullable: false, isUnique: true },
            { name: 'date_of_birth', type: 'date', isNullable: true },
            { name: 'gender', type: 'varchar', isNullable: true },
            { name: 'nationality', type: 'varchar', isNullable: true },
            { name: 'license_number', type: 'varchar', isNullable: true, isUnique: true },
            {
              name: 'license_type',
              type: 'license_type_enum',
              isNullable: true,
            },
            { name: 'license_issue_date', type: 'date', isNullable: true },
            { name: 'license_expiry_date', type: 'date', isNullable: true },
            { name: 'license_issuing_authority', type: 'varchar', isNullable: true },
            { name: 'license_photo_front', type: 'text', isNullable: true },
            { name: 'license_photo_back', type: 'text', isNullable: true },
            {
              name: 'vehicle_type',
              type: 'vehicle_type_enum',
              isNullable: true,
            },
            { name: 'vehicle_make', type: 'varchar', isNullable: true },
            { name: 'vehicle_model', type: 'varchar', isNullable: true },
            { name: 'vehicle_year', type: 'int', isNullable: true },
            { name: 'vehicle_color', type: 'varchar', isNullable: true },
            { name: 'plate_number', type: 'varchar', isNullable: true, isUnique: true },
            { name: 'plate_region', type: 'varchar', isNullable: true },
            { name: 'vehicle_registration_number', type: 'varchar', isNullable: true },
            { name: 'vehicle_registration_expiry', type: 'date', isNullable: true },
            { name: 'vehicle_photo', type: 'text', isNullable: true },
            { name: 'vehicle_authorization_photo', type: 'text', isNullable: true },
            { name: 'insurance_company', type: 'varchar', isNullable: true },
            { name: 'insurance_policy_number', type: 'varchar', isNullable: true },
            { name: 'insurance_start_date', type: 'date', isNullable: true },
            { name: 'insurance_expiry_date', type: 'date', isNullable: true },
            { name: 'insurance_coverage_type', type: 'varchar', isNullable: true },
            { name: 'insurance_photo', type: 'text', isNullable: true },
            { name: 'phone_number', type: 'varchar', isNullable: false },
            { name: 'email', type: 'varchar', isNullable: true },
            { name: 'emergency_contact_name', type: 'varchar', isNullable: true },
            { name: 'emergency_contact_phone', type: 'varchar', isNullable: true },
            { name: 'address', type: 'jsonb', isNullable: true },
            { name: 'bank_name', type: 'varchar', isNullable: true },
            { name: 'account_number', type: 'varchar', isNullable: true },
            { name: 'account_holder_name', type: 'varchar', isNullable: true },
            { name: 'iban', type: 'varchar', isNullable: true },
            { name: 'swift_code', type: 'varchar', isNullable: true },
            {
              name: 'has_medical_conditions',
              type: 'boolean',
              default: false,
              isNullable: false,
            },
            { name: 'medical_conditions', type: 'text', isNullable: true },
            { name: 'blood_type', type: 'varchar', isNullable: true },
            { name: 'allergies', type: 'text', isNullable: true },
            {
              name: 'terms_and_conditions_accepted',
              type: 'boolean',
              default: false,
              isNullable: false,
            },
            { name: 'terms_accepted_at', type: 'timestamp', isNullable: true },
            {
              name: 'privacy_policy_accepted',
              type: 'boolean',
              default: false,
              isNullable: false,
            },
            { name: 'privacy_accepted_at', type: 'timestamp', isNullable: true },
            {
              name: 'background_check_consent',
              type: 'boolean',
              default: false,
              isNullable: false,
            },
            {
              name: 'location_tracking_consent',
              type: 'boolean',
              default: false,
              isNullable: false,
            },
            {
              name: 'data_processing_consent',
              type: 'boolean',
              default: false,
              isNullable: false,
            },
            {
              name: 'identity_verified',
              type: 'boolean',
              default: false,
              isNullable: false,
            },
            { name: 'identity_verified_at', type: 'timestamp', isNullable: true },
            { name: 'identity_verified_by', type: 'varchar', isNullable: true },
            { name: 'identity_rejection_reason', type: 'text', isNullable: true },
            {
              name: 'license_verified',
              type: 'boolean',
              default: false,
              isNullable: false,
            },
            { name: 'license_verified_at', type: 'timestamp', isNullable: true },
            { name: 'license_rejection_reason', type: 'text', isNullable: true },
            {
              name: 'vehicle_verified',
              type: 'boolean',
              default: false,
              isNullable: false,
            },
            { name: 'vehicle_verified_at', type: 'timestamp', isNullable: true },
            { name: 'vehicle_rejection_reason', type: 'text', isNullable: true },
            {
              name: 'insurance_verified',
              type: 'boolean',
              default: false,
              isNullable: false,
            },
            { name: 'insurance_verified_at', type: 'timestamp', isNullable: true },
            { name: 'insurance_rejection_reason', type: 'text', isNullable: true },
            {
              name: 'background_check_passed',
              type: 'boolean',
              default: false,
              isNullable: false,
            },
            { name: 'background_check_date', type: 'timestamp', isNullable: true },
            {
              name: 'status',
              type: 'driver_status_enum',
              default: "'pending'",
              isNullable: false,
            },
            { name: 'rejection_reason', type: 'text', isNullable: true },
            {
              name: 'is_online',
              type: 'boolean',
              default: false,
              isNullable: false,
            },
            { name: 'last_online_at', type: 'timestamp', isNullable: true },
            {
              name: 'current_latitude',
              type: 'decimal',
              precision: 10,
              scale: 8,
              isNullable: true,
            },
            {
              name: 'current_longitude',
              type: 'decimal',
              precision: 11,
              scale: 8,
              isNullable: true,
            },
            { name: 'last_location_update', type: 'timestamp', isNullable: true },
            { name: 'fcm_token', type: 'varchar', isNullable: true },
            { name: 'profile_photo', type: 'text', isNullable: true },
            { name: 'languages', type: 'text', isNullable: true },
            { name: 'experience_years', type: 'int', isNullable: true },
            {
              name: 'created_at',
              type: 'timestamp',
              default: 'CURRENT_TIMESTAMP',
              isNullable: false,
            },
            {
              name: 'updated_at',
              type: 'timestamp',
              default: 'CURRENT_TIMESTAMP',
              isNullable: false,
            },
          ],
        }),
        true,
      );
      await queryRunner.createForeignKey(
        'drivers',
        new TableForeignKey({
          columnNames: ['user_id'],
          referencedTableName: 'users',
          referencedColumnNames: ['id'],
        }),
      );
      await queryRunner.createIndex(
        'drivers',
        new TableIndex({ name: 'IDX_drivers_user_id', columnNames: ['user_id'] }),
      );
    }

    // ----- 10. orders.driver_id FK (only after drivers exists) -----
    const ordersTable = await queryRunner.getTable('orders');
    const driversTable = await queryRunner.getTable('drivers');
    if (ordersTable && driversTable) {
      const hasDriverFk = ordersTable.foreignKeys.some(
        (fk) =>
          fk.columnNames.indexOf('driver_id') !== -1 &&
          fk.referencedTableName === 'drivers',
      );
      if (!hasDriverFk) {
        await queryRunner.query(`
          DO $$ BEGIN
            ALTER TABLE "orders"
            ADD CONSTRAINT "FK_orders_driver_id"
            FOREIGN KEY ("driver_id") REFERENCES "drivers"("id");
          EXCEPTION WHEN duplicate_object THEN NULL;
          END $$;
        `);
      }
    }
  }

  public async down(_queryRunner: QueryRunner): Promise<void> {
    // Down not implemented: dropping tables would delete data.
    // Re-running up() is idempotent; use a new migration to drop if ever needed.
  }
}
