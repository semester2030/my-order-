import { MigrationInterface, QueryRunner } from 'typeorm';

export class VendorEmailLegalCompliance1739100000000
  implements MigrationInterface
{
  name = 'VendorEmailLegalCompliance1739100000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      ALTER TABLE "users"
      ADD COLUMN IF NOT EXISTS "email_verified_at" TIMESTAMP WITH TIME ZONE NULL;
    `);
    await queryRunner.query(`
      ALTER TABLE "vendors"
      ADD COLUMN IF NOT EXISTS "legal_accepted_at" TIMESTAMP WITH TIME ZONE NULL;
    `);
    await queryRunner.query(`
      ALTER TABLE "vendors"
      ADD COLUMN IF NOT EXISTS "legal_document_version" character varying(64) NULL;
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      ALTER TABLE "vendors" DROP COLUMN IF EXISTS "legal_document_version";
    `);
    await queryRunner.query(`
      ALTER TABLE "vendors" DROP COLUMN IF EXISTS "legal_accepted_at";
    `);
    await queryRunner.query(`
      ALTER TABLE "users" DROP COLUMN IF EXISTS "email_verified_at";
    `);
  }
}
