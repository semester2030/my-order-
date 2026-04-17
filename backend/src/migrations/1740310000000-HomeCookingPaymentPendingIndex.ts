import { MigrationInterface, QueryRunner } from 'typeorm';

/** Partial index for home_cooking payment_pending queue (separate migration after enum ADD VALUE). */
export class HomeCookingPaymentPendingIndex1740310000000
  implements MigrationInterface
{
  name = 'HomeCookingPaymentPendingIndex1740310000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS "IDX_event_requests_home_payment_pending"
      ON "event_requests" ("created_at" DESC)
      WHERE "request_type" = 'home_cooking' AND "status" = 'payment_pending'
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `DROP INDEX IF EXISTS "IDX_event_requests_home_payment_pending"`,
    );
  }
}
