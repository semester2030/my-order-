import { MigrationInterface, QueryRunner, Table, TableForeignKey } from 'typeorm';

export class VendorPayoutProfilesAndPayoutRequests1740450000000
  implements MigrationInterface
{
  name = 'VendorPayoutProfilesAndPayoutRequests1740450000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE TYPE "vendor_payout_profile_status_enum" AS ENUM (
        'unverified',
        'pending_kyc',
        'verified',
        'suspended'
      )
    `);
    await queryRunner.query(`
      CREATE TYPE "payout_request_status_enum" AS ENUM (
        'pending',
        'submitted',
        'processing',
        'completed',
        'failed'
      )
    `);

    await queryRunner.createTable(
      new Table({
        name: 'vendor_payout_profiles',
        columns: [
          {
            name: 'id',
            type: 'uuid',
            isPrimary: true,
            default: 'gen_random_uuid()',
          },
          {
            name: 'vendor_id',
            type: 'uuid',
            isUnique: true,
            isNullable: false,
          },
          {
            name: 'verification_status',
            type: 'vendor_payout_profile_status_enum',
            default: "'unverified'",
          },
          {
            name: 'external_connected_account_id',
            type: 'varchar',
            length: '255',
            isNullable: true,
          },
          {
            name: 'created_at',
            type: 'timestamptz',
            default: 'now()',
          },
          {
            name: 'updated_at',
            type: 'timestamptz',
            default: 'now()',
          },
        ],
      }),
      true,
    );

    await queryRunner.createForeignKey(
      'vendor_payout_profiles',
      new TableForeignKey({
        columnNames: ['vendor_id'],
        referencedTableName: 'vendors',
        referencedColumnNames: ['id'],
        onDelete: 'CASCADE',
      }),
    );

    await queryRunner.createTable(
      new Table({
        name: 'payout_requests',
        columns: [
          {
            name: 'id',
            type: 'uuid',
            isPrimary: true,
            default: 'gen_random_uuid()',
          },
          {
            name: 'vendor_id',
            type: 'uuid',
            isNullable: false,
          },
          {
            name: 'amount',
            type: 'decimal',
            precision: 12,
            scale: 2,
            isNullable: false,
          },
          {
            name: 'currency',
            type: 'varchar',
            length: '3',
            default: "'SAR'",
          },
          {
            name: 'status',
            type: 'payout_request_status_enum',
            default: "'pending'",
          },
          {
            name: 'source_type',
            type: 'varchar',
            length: '32',
            isNullable: true,
          },
          {
            name: 'source_id',
            type: 'uuid',
            isNullable: true,
          },
          {
            name: 'idempotency_key',
            type: 'varchar',
            length: '120',
            isUnique: true,
            isNullable: false,
          },
          {
            name: 'provider_payout_id',
            type: 'varchar',
            length: '255',
            isNullable: true,
          },
          {
            name: 'failure_reason',
            type: 'text',
            isNullable: true,
          },
          {
            name: 'meta',
            type: 'jsonb',
            isNullable: true,
          },
          {
            name: 'created_at',
            type: 'timestamptz',
            default: 'now()',
          },
          {
            name: 'completed_at',
            type: 'timestamptz',
            isNullable: true,
          },
        ],
      }),
      true,
    );

    await queryRunner.createForeignKey(
      'payout_requests',
      new TableForeignKey({
        columnNames: ['vendor_id'],
        referencedTableName: 'vendors',
        referencedColumnNames: ['id'],
        onDelete: 'RESTRICT',
      }),
    );

    await queryRunner.query(`
      CREATE INDEX "IDX_payout_requests_vendor_id_created"
      ON "payout_requests" ("vendor_id", "created_at" DESC)
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropTable('payout_requests', true);
    await queryRunner.dropTable('vendor_payout_profiles', true);
    await queryRunner.query(`DROP TYPE IF EXISTS "payout_request_status_enum"`);
    await queryRunner.query(
      `DROP TYPE IF EXISTS "vendor_payout_profile_status_enum"`,
    );
  }
}
