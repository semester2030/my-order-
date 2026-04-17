import { MigrationInterface, QueryRunner } from 'typeorm';

/** طبخ منزلي: تسليم من المطبخ + إتمام باستلام العميل + رمز إتمام للإدارة */
export class HomeCookingHandoverCompletion1740300000000
  implements MigrationInterface
{
  name = 'HomeCookingHandoverCompletion1740300000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      DO $$ BEGIN
        ALTER TYPE "event_requests_status_enum" ADD VALUE 'handed_over';
      EXCEPTION WHEN duplicate_object THEN null; END $$;
    `);
    await queryRunner.query(`
      DO $$ BEGIN
        ALTER TYPE "event_requests_status_enum" ADD VALUE 'completed';
      EXCEPTION WHEN duplicate_object THEN null; END $$;
    `);

    await queryRunner.query(`
      ALTER TABLE "event_requests"
      ADD COLUMN IF NOT EXISTS "handed_over_at" TIMESTAMP WITH TIME ZONE NULL
    `);
    await queryRunner.query(`
      ALTER TABLE "event_requests"
      ADD COLUMN IF NOT EXISTS "handover_notes" text NULL
    `);
    await queryRunner.query(`
      ALTER TABLE "event_requests"
      ADD COLUMN IF NOT EXISTS "completed_at" TIMESTAMP WITH TIME ZONE NULL
    `);
    await queryRunner.query(`
      ALTER TABLE "event_requests"
      ADD COLUMN IF NOT EXISTS "completion_certificate_code" varchar(32) NULL
    `);

    await queryRunner.query(`
      CREATE UNIQUE INDEX IF NOT EXISTS "UQ_event_requests_completion_certificate_code"
      ON "event_requests" ("completion_certificate_code")
      WHERE "completion_certificate_code" IS NOT NULL
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `DROP INDEX IF EXISTS "UQ_event_requests_completion_certificate_code"`,
    );
    await queryRunner.query(
      `ALTER TABLE "event_requests" DROP COLUMN IF EXISTS "completion_certificate_code"`,
    );
    await queryRunner.query(
      `ALTER TABLE "event_requests" DROP COLUMN IF EXISTS "completed_at"`,
    );
    await queryRunner.query(
      `ALTER TABLE "event_requests" DROP COLUMN IF EXISTS "handover_notes"`,
    );
    await queryRunner.query(
      `ALTER TABLE "event_requests" DROP COLUMN IF EXISTS "handed_over_at"`,
    );
  }
}
