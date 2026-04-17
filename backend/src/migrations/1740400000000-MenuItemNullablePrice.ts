import { MigrationInterface, QueryRunner } from 'typeorm';

/** السعر اختياري (مطبخ منزلي — تفاوض/عرض سعر لاحقاً). */
export class MenuItemNullablePrice1740400000000 implements MigrationInterface {
  name = 'MenuItemNullablePrice1740400000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      ALTER TABLE "menu_items"
      ALTER COLUMN "price" DROP NOT NULL
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      UPDATE "menu_items" SET "price" = 0 WHERE "price" IS NULL
    `);
    await queryRunner.query(`
      ALTER TABLE "menu_items"
      ALTER COLUMN "price" SET NOT NULL
    `);
  }
}
