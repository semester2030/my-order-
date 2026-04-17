import { MigrationInterface, QueryRunner } from 'typeorm';

export class AddRespondByToEventRequests1740000000000
  implements MigrationInterface
{
  name = 'AddRespondByToEventRequests1740000000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      ALTER TABLE "event_requests"
      ADD COLUMN IF NOT EXISTS "respond_by" TIMESTAMPTZ NULL
    `);
    await queryRunner.query(`
      UPDATE "event_requests"
      SET "respond_by" = "created_at" + INTERVAL '48 hours'
      WHERE "respond_by" IS NULL
        AND "status" = 'pending'
        AND "request_type" IN ('popular_cooking', 'grilling')
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      ALTER TABLE "event_requests" DROP COLUMN IF EXISTS "respond_by"
    `);
  }
}
