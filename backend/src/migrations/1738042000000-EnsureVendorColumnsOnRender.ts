import { MigrationInterface, QueryRunner } from 'typeorm';

/**
 * Ensures vendors table has all columns required by Vendor entity on Render.
 * Use ADD COLUMN IF NOT EXISTS so it is safe when columns were already added by AddVendorRegistrationFields.
 * Fixes: QueryFailedError: column Vendor.delivery_zones does not exist
 */
export class EnsureVendorColumnsOnRender1738042000000 implements MigrationInterface {
  name = 'EnsureVendorColumnsOnRender1738042000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      ALTER TABLE "vendors" ADD COLUMN IF NOT EXISTS "delivery_zones" text;
    `);
    await queryRunner.query(`
      ALTER TABLE "vendors" ADD COLUMN IF NOT EXISTS "working_hours" jsonb;
    `);
    await queryRunner.query(`
      ALTER TABLE "vendors" ADD COLUMN IF NOT EXISTS "provider_category" character varying;
    `);
    await queryRunner.query(`
      ALTER TABLE "vendors" ADD COLUMN IF NOT EXISTS "popular_cooking_add_ons" jsonb;
    `);
    await queryRunner.query(`
      ALTER TABLE "vendors" ADD COLUMN IF NOT EXISTS "restaurant_video" character varying;
    `);
  }

  public async down(_queryRunner: QueryRunner): Promise<void> {
    // No-op: dropping columns could break existing data; re-run up() is idempotent
  }
}
