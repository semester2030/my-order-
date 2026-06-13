import { MigrationInterface, QueryRunner } from 'typeorm';

export class EventRequestPaymentMethod1740470000000
  implements MigrationInterface
{
  name = 'EventRequestPaymentMethod1740470000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      ALTER TABLE "event_requests"
      ADD COLUMN IF NOT EXISTS "payment_method" varchar(32)
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      ALTER TABLE "event_requests"
      DROP COLUMN IF EXISTS "payment_method"
    `);
  }
}
