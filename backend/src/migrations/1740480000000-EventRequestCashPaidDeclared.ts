import { MigrationInterface, QueryRunner } from 'typeorm';

export class EventRequestCashPaidDeclared1740480000000
  implements MigrationInterface
{
  name = 'EventRequestCashPaidDeclared1740480000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      ALTER TABLE "event_requests"
      ADD COLUMN IF NOT EXISTS "cash_paid_declared_at" TIMESTAMPTZ
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      ALTER TABLE "event_requests"
      DROP COLUMN IF EXISTS "cash_paid_declared_at"
    `);
  }
}
