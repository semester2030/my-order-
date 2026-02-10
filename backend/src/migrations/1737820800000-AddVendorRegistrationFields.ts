import { MigrationInterface, QueryRunner, Table, TableColumn, TableForeignKey, TableIndex } from 'typeorm';

export class AddVendorRegistrationFields1737820800000 implements MigrationInterface {
  name = 'AddVendorRegistrationFields1737820800000';

  private async addColumnIfNotExists(
    queryRunner: QueryRunner,
    tableName: string,
    column: TableColumn,
  ): Promise<void> {
    const table = await queryRunner.getTable(tableName);
    if (table && !table.findColumnByName(column.name)) {
      await queryRunner.addColumn(tableName, column);
    }
  }

  public async up(queryRunner: QueryRunner): Promise<void> {
    // Create enum types only if they don't exist (idempotent for existing DBs)
    await queryRunner.query(`
      DO $$ BEGIN
        CREATE TYPE "vendor_status_enum" AS ENUM('pending_approval', 'under_review', 'approved', 'rejected', 'suspended');
      EXCEPTION WHEN duplicate_object THEN NULL;
      END $$;
    `);
    await queryRunner.query(`
      DO $$ BEGIN
        CREATE TYPE "verification_status_enum" AS ENUM('pending', 'verified', 'rejected', 'expired');
      EXCEPTION WHEN duplicate_object THEN NULL;
      END $$;
    `);
    await queryRunner.query(`
      DO $$ BEGIN
        CREATE TYPE "certificate_type_enum" AS ENUM('health', 'municipal', 'food_safety', 'other');
      EXCEPTION WHEN duplicate_object THEN NULL;
      END $$;
    `);
    await queryRunner.query(`
      DO $$ BEGIN
        CREATE TYPE "staff_role_enum" AS ENUM('owner', 'manager', 'chef', 'waiter', 'cashier', 'viewer');
      EXCEPTION WHEN duplicate_object THEN NULL;
      END $$;
    `);
    await queryRunner.query(`
      DO $$ BEGIN
        CREATE TYPE "vendors_type_enum" AS ENUM('fine_dining', 'premium_casual', 'gourmet_desserts');
      EXCEPTION WHEN duplicate_object THEN NULL;
      END $$;
    `);

    // Create users table if missing (fresh DB e.g. on Render)
    if (!(await queryRunner.hasTable('users'))) {
      await queryRunner.createTable(
        new Table({
          name: 'users',
          columns: [
            { name: 'id', type: 'uuid', isPrimary: true, generationStrategy: 'uuid', default: 'uuid_generate_v4()' },
            { name: 'phone', type: 'varchar', isUnique: true, isNullable: false },
            { name: 'name', type: 'varchar', isNullable: true },
            { name: 'email', type: 'varchar', isUnique: true, isNullable: true },
            { name: 'pin_hash', type: 'varchar', isNullable: true },
            { name: 'is_verified', type: 'boolean', default: false, isNullable: false },
            { name: 'is_active', type: 'boolean', default: true, isNullable: false },
            { name: 'created_at', type: 'timestamp', default: 'CURRENT_TIMESTAMP', isNullable: false },
            { name: 'updated_at', type: 'timestamp', default: 'CURRENT_TIMESTAMP', isNullable: false },
          ],
        }),
        true,
      );
    }

    // Create vendors table if missing (fresh DB e.g. on Render)
    if (!(await queryRunner.hasTable('vendors'))) {
      await queryRunner.createTable(
        new Table({
          name: 'vendors',
          columns: [
            { name: 'id', type: 'uuid', isPrimary: true, generationStrategy: 'uuid', default: 'uuid_generate_v4()' },
            { name: 'name', type: 'varchar', isUnique: true, isNullable: false },
            { name: 'type', type: 'vendors_type_enum', default: "'premium_casual'", isNullable: false },
            { name: 'description', type: 'text', isNullable: true },
            { name: 'phone_number', type: 'varchar', isNullable: false },
            { name: 'address', type: 'varchar', isNullable: false },
            { name: 'city', type: 'varchar', isNullable: false },
            { name: 'latitude', type: 'decimal', precision: 10, scale: 8, isNullable: false },
            { name: 'longitude', type: 'decimal', precision: 11, scale: 8, isNullable: false },
            { name: 'logo', type: 'varchar', isNullable: true },
            { name: 'cover', type: 'varchar', isNullable: true },
            { name: 'is_active', type: 'boolean', default: true, isNullable: false },
            { name: 'rating', type: 'decimal', precision: 3, scale: 2, default: 0, isNullable: false },
            { name: 'rating_count', type: 'int', default: 0, isNullable: false },
            { name: 'created_at', type: 'timestamp', default: 'CURRENT_TIMESTAMP', isNullable: false },
            { name: 'updated_at', type: 'timestamp', default: 'CURRENT_TIMESTAMP', isNullable: false },
          ],
        }),
        true,
      );
    }

    // Add new columns to vendors table (only if missing)
    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'trade_name',
        type: 'varchar',
        isUnique: true,
        isNullable: true,
      }),
    );
    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'email',
        type: 'varchar',
        isUnique: true,
        isNullable: false,
      }),
    );

    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'website',
        type: 'varchar',
        isNullable: true,
      }),
    );

    // Commercial Registration
    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'commercial_registration_number',
        type: 'varchar',
        isUnique: true,
        isNullable: true,
      }),
    );

    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'commercial_registration_issue_date',
        type: 'date',
        isNullable: true,
      }),
    );

    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'commercial_registration_expiry_date',
        type: 'date',
        isNullable: true,
      }),
    );

    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'commercial_registration_image',
        type: 'varchar',
        isNullable: true,
      }),
    );

    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'commercial_registration_status',
        type: 'verification_status_enum',
        default: "'pending'",
        isNullable: false,
      }),
    );

    // Location updates
    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'city',
        type: 'varchar',
        isNullable: false,
        default: "''",
      }),
    );

    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'district',
        type: 'varchar',
        isNullable: true,
      }),
    );

    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'postal_code',
        type: 'varchar',
        isNullable: true,
      }),
    );

    // Delivery
    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'delivery_fee',
        type: 'decimal',
        precision: 10,
        scale: 2,
        default: 0,
        isNullable: false,
      }),
    );

    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'delivery_radius',
        type: 'int',
        default: 10,
        isNullable: false,
      }),
    );

    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'estimated_delivery_time',
        type: 'int',
        default: 30,
        isNullable: false,
      }),
    );

    // Owner Information
    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'owner_name',
        type: 'varchar',
        isNullable: false,
        default: "''",
      }),
    );

    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'owner_phone',
        type: 'varchar',
        isNullable: false,
        default: "''",
      }),
    );

    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'owner_email',
        type: 'varchar',
        isNullable: false,
        default: "''",
      }),
    );

    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'owner_id_number',
        type: 'varchar',
        isUnique: true,
        isNullable: false,
        default: "''",
      }),
    );

    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'owner_id_image',
        type: 'varchar',
        isNullable: false,
        default: "''",
      }),
    );

    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'owner_nationality',
        type: 'varchar',
        isNullable: true,
      }),
    );

    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'owner_address',
        type: 'text',
        isNullable: true,
      }),
    );

    // Banking
    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'bank_name',
        type: 'varchar',
        isNullable: true,
      }),
    );

    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'bank_account_number',
        type: 'varchar',
        isNullable: true,
      }),
    );

    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'iban',
        type: 'varchar',
        isNullable: true,
      }),
    );

    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'account_holder_name',
        type: 'varchar',
        isNullable: true,
      }),
    );

    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'bank_statement',
        type: 'varchar',
        isNullable: true,
      }),
    );

    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'swift_code',
        type: 'varchar',
        isNullable: true,
      }),
    );

    // Media
    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'restaurant_images',
        type: 'text',
        isArray: true,
        isNullable: true,
      }),
    );

    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'restaurant_video',
        type: 'varchar',
        isNullable: true,
      }),
    );

    // Working Hours
    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'working_hours',
        type: 'jsonb',
        isNullable: true,
      }),
    );
    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'delivery_zones',
        type: 'text',
        isNullable: true,
      }),
    );
    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'provider_category',
        type: 'varchar',
        isNullable: true,
      }),
    );
    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'popular_cooking_add_ons',
        type: 'jsonb',
        isNullable: true,
      }),
    );

    // Status
    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'registration_status',
        type: 'vendor_status_enum',
        default: "'pending_approval'",
        isNullable: false,
      }),
    );

    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'is_accepting_orders',
        type: 'boolean',
        default: false,
        isNullable: false,
      }),
    );

    // Approval
    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'approved_at',
        type: 'timestamp',
        isNullable: true,
      }),
    );

    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'approved_by',
        type: 'varchar',
        isNullable: true,
      }),
    );

    await this.addColumnIfNotExists(
      queryRunner,
      'vendors',
      new TableColumn({
        name: 'rejection_reason',
        type: 'text',
        isNullable: true,
      }),
    );

    // Create vendor_certificates table (only if not exists)
    if (!(await queryRunner.hasTable('vendor_certificates'))) {
      await queryRunner.createTable(
      new Table({
        name: 'vendor_certificates',
        columns: [
          {
            name: 'id',
            type: 'uuid',
            isPrimary: true,
            generationStrategy: 'uuid',
            default: 'uuid_generate_v4()',
          },
          {
            name: 'vendor_id',
            type: 'uuid',
            isNullable: false,
          },
          {
            name: 'type',
            type: 'certificate_type_enum',
            isNullable: false,
          },
          {
            name: 'certificate_number',
            type: 'varchar',
            isNullable: false,
          },
          {
            name: 'issue_date',
            type: 'date',
            isNullable: false,
          },
          {
            name: 'expiry_date',
            type: 'date',
            isNullable: false,
          },
          {
            name: 'certificate_image',
            type: 'varchar',
            isNullable: false,
          },
          {
            name: 'status',
            type: 'verification_status_enum',
            default: "'pending'",
            isNullable: false,
          },
          {
            name: 'verified_at',
            type: 'timestamp',
            isNullable: true,
          },
          {
            name: 'verified_by',
            type: 'varchar',
            isNullable: true,
          },
          {
            name: 'rejection_reason',
            type: 'text',
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
            onUpdate: 'CURRENT_TIMESTAMP',
            isNullable: false,
          },
        ],
      }),
      true,
    );
      await queryRunner.createForeignKey(
        'vendor_certificates',
        new TableForeignKey({
          columnNames: ['vendor_id'],
          referencedColumnNames: ['id'],
          referencedTableName: 'vendors',
          onDelete: 'CASCADE',
        }),
      );
      await queryRunner.createIndex(
        'vendor_certificates',
        new TableIndex({
          name: 'IDX_vendor_certificates_vendor_id',
          columnNames: ['vendor_id'],
        }),
      );
    }

    // Create vendor_staff table (only if not exists)
    if (!(await queryRunner.hasTable('vendor_staff'))) {
      await queryRunner.createTable(
      new Table({
        name: 'vendor_staff',
        columns: [
          {
            name: 'id',
            type: 'uuid',
            isPrimary: true,
            generationStrategy: 'uuid',
            default: 'uuid_generate_v4()',
          },
          {
            name: 'vendor_id',
            type: 'uuid',
            isNullable: false,
          },
          {
            name: 'user_id',
            type: 'uuid',
            isUnique: true,
            isNullable: false,
          },
          {
            name: 'role',
            type: 'staff_role_enum',
            isNullable: false,
          },
          {
            name: 'permissions',
            type: 'text',
            isArray: true,
            isNullable: true,
          },
          {
            name: 'is_active',
            type: 'boolean',
            default: true,
            isNullable: false,
          },
          {
            name: 'invited_by',
            type: 'uuid',
            isNullable: true,
          },
          {
            name: 'invited_at',
            type: 'timestamp',
            isNullable: true,
          },
          {
            name: 'accepted_at',
            type: 'timestamp',
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
            onUpdate: 'CURRENT_TIMESTAMP',
            isNullable: false,
          },
        ],
      }),
      true,
    );
      await queryRunner.createForeignKey(
        'vendor_staff',
        new TableForeignKey({
          columnNames: ['vendor_id'],
          referencedColumnNames: ['id'],
          referencedTableName: 'vendors',
          onDelete: 'CASCADE',
        }),
      );
      await queryRunner.createIndex(
        'vendor_staff',
        new TableIndex({
          name: 'IDX_vendor_staff_vendor_id',
          columnNames: ['vendor_id'],
        }),
      );
      await queryRunner.createIndex(
        'vendor_staff',
        new TableIndex({
          name: 'IDX_vendor_staff_user_id',
          columnNames: ['user_id'],
        }),
      );
    }
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // Drop foreign keys
    await queryRunner.dropForeignKey('vendor_staff', 'FK_vendor_staff_vendor_id');
    await queryRunner.dropForeignKey('vendor_certificates', 'FK_vendor_certificates_vendor_id');

    // Drop indexes
    await queryRunner.dropIndex('vendor_staff', 'IDX_vendor_staff_user_id');
    await queryRunner.dropIndex('vendor_staff', 'IDX_vendor_staff_vendor_id');
    await queryRunner.dropIndex('vendor_certificates', 'IDX_vendor_certificates_vendor_id');

    // Drop tables
    await queryRunner.dropTable('vendor_staff');
    await queryRunner.dropTable('vendor_certificates');

    // Drop columns from vendors table
    const vendorTable = await queryRunner.getTable('vendors');
    if (vendorTable) {
      const columnsToDrop = [
        'rejection_reason',
        'approved_by',
        'approved_at',
        'registration_status',
        'working_hours',
        'delivery_zones',
        'provider_category',
        'popular_cooking_add_ons',
        'restaurant_video',
        'restaurant_images',
        'swift_code',
        'bank_statement',
        'account_holder_name',
        'iban',
        'bank_account_number',
        'bank_name',
        'owner_address',
        'owner_nationality',
        'owner_id_image',
        'owner_id_number',
        'owner_email',
        'owner_phone',
        'owner_name',
        'estimated_delivery_time',
        'delivery_radius',
        'delivery_fee',
        'postal_code',
        'district',
        'city',
        'commercial_registration_status',
        'commercial_registration_image',
        'commercial_registration_expiry_date',
        'commercial_registration_issue_date',
        'commercial_registration_number',
        'website',
        'email',
        'trade_name',
      ];

      for (const columnName of columnsToDrop) {
        const column = vendorTable.findColumnByName(columnName);
        if (column) {
          await queryRunner.dropColumn('vendors', columnName);
        }
      }
    }

    // Drop enum types
    await queryRunner.query(`DROP TYPE IF EXISTS "staff_role_enum"`);
    await queryRunner.query(`DROP TYPE IF EXISTS "certificate_type_enum"`);
    await queryRunner.query(`DROP TYPE IF EXISTS "verification_status_enum"`);
    await queryRunner.query(`DROP TYPE IF EXISTS "vendor_status_enum"`);
  }
}
