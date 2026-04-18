import { MigrationInterface, QueryRunner } from 'typeorm';

/** إعلان تعريفي للمطبخ المنزلي: صورة اختيارية مقابل عنصر وجبة كامل. */
export class AddMenuItemProfilePromo1740430000000 implements MigrationInterface {
  name = 'AddMenuItemProfilePromo1740430000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      ALTER TABLE "menu_items"
      ADD COLUMN IF NOT EXISTS "profile_promo" boolean NOT NULL DEFAULT false
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `ALTER TABLE "menu_items" DROP COLUMN IF EXISTS "profile_promo"`,
    );
  }
}
