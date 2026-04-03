import { MigrationInterface, QueryRunner } from 'typeorm';

export class VendorGeneralMenuOfferingTerms1739200000000
  implements MigrationInterface
{
  name = 'VendorGeneralMenuOfferingTerms1739200000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      ALTER TABLE "vendors"
      ADD COLUMN IF NOT EXISTS "menu_offering_terms_accepted_at" TIMESTAMP WITH TIME ZONE NULL;
    `);
    await queryRunner.query(`
      ALTER TABLE "vendors"
      ADD COLUMN IF NOT EXISTS "menu_offering_terms_version" character varying(64) NULL;
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      ALTER TABLE "vendors" DROP COLUMN IF EXISTS "menu_offering_terms_version";
    `);
    await queryRunner.query(`
      ALTER TABLE "vendors" DROP COLUMN IF EXISTS "menu_offering_terms_accepted_at";
    `);
  }
}
