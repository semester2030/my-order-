import { MigrationInterface, QueryRunner } from 'typeorm';

/**
 * وجبة غداء/عشاء لحجوزات الذبائح والشوي + منع ازدواجية (عميل/مورّد) لنفس التاريخ والوجبة.
 */
export class AddMealSlotAndChefBookingConstraints1740100000000
  implements MigrationInterface
{
  name = 'AddMealSlotAndChefBookingConstraints1740100000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      DO $$ BEGIN
        CREATE TYPE "event_requests_meal_slot_enum" AS ENUM('lunch', 'dinner');
      EXCEPTION
        WHEN duplicate_object THEN null;
      END $$;
    `);

    await queryRunner.query(`
      ALTER TABLE "event_requests"
      ADD COLUMN IF NOT EXISTS "meal_slot" "event_requests_meal_slot_enum" NULL
    `);

    await queryRunner.query(`
      UPDATE "event_requests"
      SET "meal_slot" = CASE
        WHEN "scheduled_time" < TIME '15:00' THEN 'lunch'::"event_requests_meal_slot_enum"
        ELSE 'dinner'::"event_requests_meal_slot_enum"
      END
      WHERE "request_type" IN ('popular_cooking', 'grilling')
        AND "meal_slot" IS NULL
    `);

    await queryRunner.query(`
      UPDATE "event_requests"
      SET "meal_slot" = 'lunch'::"event_requests_meal_slot_enum"
      WHERE "request_type" IN ('popular_cooking', 'grilling')
        AND "meal_slot" IS NULL
    `);

    await queryRunner.query(`
      WITH ranked AS (
        SELECT id,
          ROW_NUMBER() OVER (
            PARTITION BY user_id, scheduled_date, meal_slot
            ORDER BY created_at ASC
          ) AS rn
        FROM event_requests
        WHERE request_type IN ('popular_cooking', 'grilling')
          AND status = 'pending'
          AND meal_slot IS NOT NULL
      )
      UPDATE event_requests er
      SET status = 'cancelled'
      FROM ranked r
      WHERE er.id = r.id AND r.rn > 1
    `);

    await queryRunner.query(`
      WITH ranked AS (
        SELECT id,
          ROW_NUMBER() OVER (
            PARTITION BY vendor_id, scheduled_date, meal_slot
            ORDER BY created_at ASC
          ) AS rn
        FROM event_requests
        WHERE request_type IN ('popular_cooking', 'grilling')
          AND status = 'pending'
          AND meal_slot IS NOT NULL
      )
      UPDATE event_requests er
      SET status = 'cancelled'
      FROM ranked r
      WHERE er.id = r.id AND r.rn > 1
    `);

    await queryRunner.query(`
      CREATE UNIQUE INDEX IF NOT EXISTS "UQ_event_requests_user_date_mealslot_active"
      ON "event_requests" ("user_id", "scheduled_date", "meal_slot")
      WHERE "meal_slot" IS NOT NULL
        AND "request_type" IN ('popular_cooking', 'grilling')
        AND "status" IN ('pending', 'accepted')
    `);

    await queryRunner.query(`
      CREATE UNIQUE INDEX IF NOT EXISTS "UQ_event_requests_vendor_date_mealslot_active"
      ON "event_requests" ("vendor_id", "scheduled_date", "meal_slot")
      WHERE "meal_slot" IS NOT NULL
        AND "request_type" IN ('popular_cooking', 'grilling')
        AND "status" IN ('pending', 'accepted')
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `DROP INDEX IF EXISTS "UQ_event_requests_vendor_date_mealslot_active"`,
    );
    await queryRunner.query(
      `DROP INDEX IF EXISTS "UQ_event_requests_user_date_mealslot_active"`,
    );
    await queryRunner.query(
      `ALTER TABLE "event_requests" DROP COLUMN IF EXISTS "meal_slot"`,
    );
    await queryRunner.query(
      `DROP TYPE IF EXISTS "event_requests_meal_slot_enum"`,
    );
  }
}
