import { MigrationInterface, QueryRunner } from 'typeorm';

/** طبخ منزلي: عرض سعر، انتظار تحقق تحويل، جاهز للاستلام + أعمدة السعر والدفع */
export class HomeCookingQuotePaymentReady1740200000000
  implements MigrationInterface
{
  name = 'HomeCookingQuotePaymentReady1740200000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      DO $$ BEGIN
        ALTER TYPE "event_requests_status_enum" ADD VALUE 'quoted';
      EXCEPTION WHEN duplicate_object THEN null; END $$;
    `);
    await queryRunner.query(`
      DO $$ BEGIN
        ALTER TYPE "event_requests_status_enum" ADD VALUE 'payment_pending';
      EXCEPTION WHEN duplicate_object THEN null; END $$;
    `);
    await queryRunner.query(`
      DO $$ BEGIN
        ALTER TYPE "event_requests_status_enum" ADD VALUE 'ready';
      EXCEPTION WHEN duplicate_object THEN null; END $$;
    `);

    await queryRunner.query(`
      ALTER TABLE "event_requests"
      ADD COLUMN IF NOT EXISTS "quoted_amount" numeric(12, 2) NULL
    `);
    await queryRunner.query(`
      ALTER TABLE "event_requests"
      ADD COLUMN IF NOT EXISTS "quote_notes" text NULL
    `);
    await queryRunner.query(`
      ALTER TABLE "event_requests"
      ADD COLUMN IF NOT EXISTS "quoted_at" TIMESTAMP WITH TIME ZONE NULL
    `);
    await queryRunner.query(`
      ALTER TABLE "event_requests"
      ADD COLUMN IF NOT EXISTS "payment_reference" text NULL
    `);
    await queryRunner.query(`
      ALTER TABLE "event_requests"
      ADD COLUMN IF NOT EXISTS "payment_declared_at" TIMESTAMP WITH TIME ZONE NULL
    `);
    await queryRunner.query(`
      ALTER TABLE "event_requests"
      ADD COLUMN IF NOT EXISTS "payment_verified_at" TIMESTAMP WITH TIME ZONE NULL
    `);
    await queryRunner.query(`
      ALTER TABLE "event_requests"
      ADD COLUMN IF NOT EXISTS "payment_verified_by_admin_id" uuid NULL
    `);
    await queryRunner.query(`
      ALTER TABLE "event_requests"
      ADD COLUMN IF NOT EXISTS "ready_at" TIMESTAMP WITH TIME ZONE NULL
    `);

    // Partial index on payment_pending: see 1740310000000 (PG disallows new enum value in same txn).
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `ALTER TABLE "event_requests" DROP COLUMN IF EXISTS "ready_at"`,
    );
    await queryRunner.query(
      `ALTER TABLE "event_requests" DROP COLUMN IF EXISTS "payment_verified_by_admin_id"`,
    );
    await queryRunner.query(
      `ALTER TABLE "event_requests" DROP COLUMN IF EXISTS "payment_verified_at"`,
    );
    await queryRunner.query(
      `ALTER TABLE "event_requests" DROP COLUMN IF EXISTS "payment_declared_at"`,
    );
    await queryRunner.query(
      `ALTER TABLE "event_requests" DROP COLUMN IF EXISTS "payment_reference"`,
    );
    await queryRunner.query(
      `ALTER TABLE "event_requests" DROP COLUMN IF EXISTS "quoted_at"`,
    );
    await queryRunner.query(
      `ALTER TABLE "event_requests" DROP COLUMN IF EXISTS "quote_notes"`,
    );
    await queryRunner.query(
      `ALTER TABLE "event_requests" DROP COLUMN IF EXISTS "quoted_amount"`,
    );
  }
}
