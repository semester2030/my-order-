import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateEventRequestsTable1738046000000 implements MigrationInterface {
  name = 'CreateEventRequestsTable1738046000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    // إنشاء الـ enums فقط إن لم تكن موجودة (آمن عند إعادة التشغيل)
    await queryRunner.query(`
      DO $$ BEGIN
        CREATE TYPE "event_requests_request_type_enum" AS ENUM('popular_cooking', 'home_cooking');
      EXCEPTION WHEN duplicate_object THEN NULL;
      END $$;
    `);
    await queryRunner.query(`
      DO $$ BEGIN
        CREATE TYPE "event_requests_status_enum" AS ENUM('pending', 'accepted', 'rejected', 'cancelled');
      EXCEPTION WHEN duplicate_object THEN NULL;
      END $$;
    `);
    await queryRunner.query(`
      CREATE TABLE IF NOT EXISTS "event_requests" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "user_id" uuid NOT NULL,
        "vendor_id" uuid NOT NULL,
        "address_id" uuid,
        "request_type" "event_requests_request_type_enum" NOT NULL,
        "scheduled_date" date NOT NULL,
        "scheduled_time" time NOT NULL,
        "guests_count" integer NOT NULL DEFAULT 1,
        "add_ons" jsonb,
        "dish_ids" jsonb,
        "delivery" boolean,
        "notes" text,
        "status" "event_requests_status_enum" NOT NULL DEFAULT 'pending',
        "created_at" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "PK_event_requests" PRIMARY KEY ("id"),
        CONSTRAINT "FK_event_requests_user" FOREIGN KEY ("user_id") REFERENCES "users"("id"),
        CONSTRAINT "FK_event_requests_vendor" FOREIGN KEY ("vendor_id") REFERENCES "vendors"("id"),
        CONSTRAINT "FK_event_requests_address" FOREIGN KEY ("address_id") REFERENCES "addresses"("id")
      )
    `);
    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS "IDX_event_requests_user_id" ON "event_requests" ("user_id");
    `);
    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS "IDX_event_requests_vendor_id" ON "event_requests" ("vendor_id");
    `);
    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS "IDX_event_requests_status" ON "event_requests" ("status");
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE "event_requests"`);
    await queryRunner.query(`DROP TYPE "event_requests_status_enum"`);
    await queryRunner.query(`DROP TYPE "event_requests_request_type_enum"`);
  }
}
