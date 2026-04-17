import { MigrationInterface, QueryRunner } from 'typeorm';

/** إفطار ضمن وجبة الطبخ المنزلي (مع غداء/عشاء). */
export class AddBreakfastMealSlotEnum1740410000000
  implements MigrationInterface
{
  name = 'AddBreakfastMealSlotEnum1740410000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      DO $$ BEGIN
        ALTER TYPE "event_requests_meal_slot_enum" ADD VALUE 'breakfast';
      EXCEPTION
        WHEN duplicate_object THEN null;
      END $$;
    `);
  }

  public async down(): Promise<void> {
    /* إزالة قيمة من enum في PostgreSQL غير م trivial — تُترك القيمة. */
  }
}
