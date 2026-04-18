import { MigrationInterface, QueryRunner } from 'typeorm';

/** تقييمات عامة + تذاكر جودة خاصة للإدارة — مصدر واحد لكل أنواع الخدمات */
export class ServiceExperienceReviewsAndTickets1740461000000
  implements MigrationInterface
{
  name = 'ServiceExperienceReviewsAndTickets1740461000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE TABLE IF NOT EXISTS "service_reviews" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "subject_type" character varying(32) NOT NULL,
        "subject_id" uuid NOT NULL,
        "customer_user_id" uuid NOT NULL,
        "vendor_id" uuid NOT NULL,
        "stars" smallint NOT NULL,
        "public_comment" text NULL,
        "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
        CONSTRAINT "PK_service_reviews" PRIMARY KEY ("id"),
        CONSTRAINT "CHK_service_reviews_stars" CHECK ("stars" >= 1 AND "stars" <= 5),
        CONSTRAINT "FK_service_reviews_customer" FOREIGN KEY ("customer_user_id")
          REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE NO ACTION,
        CONSTRAINT "FK_service_reviews_vendor" FOREIGN KEY ("vendor_id")
          REFERENCES "vendors"("id") ON DELETE CASCADE ON UPDATE NO ACTION,
        CONSTRAINT "UQ_service_reviews_subject_customer" UNIQUE ("subject_type", "subject_id", "customer_user_id")
      )
    `);
    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS "IDX_service_reviews_vendor_created"
      ON "service_reviews" ("vendor_id", "created_at" DESC)
    `);

    await queryRunner.query(`
      CREATE TABLE IF NOT EXISTS "service_quality_tickets" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "subject_type" character varying(32) NOT NULL,
        "subject_id" uuid NOT NULL,
        "customer_user_id" uuid NOT NULL,
        "vendor_id" uuid NOT NULL,
        "category" character varying(64) NOT NULL,
        "private_message" text NOT NULL,
        "detail_scores" jsonb NULL,
        "status" character varying(32) NOT NULL DEFAULT 'open',
        "admin_notes" text NULL,
        "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
        "updated_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
        CONSTRAINT "PK_service_quality_tickets" PRIMARY KEY ("id"),
        CONSTRAINT "FK_service_quality_tickets_customer" FOREIGN KEY ("customer_user_id")
          REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE NO ACTION,
        CONSTRAINT "FK_service_quality_tickets_vendor" FOREIGN KEY ("vendor_id")
          REFERENCES "vendors"("id") ON DELETE CASCADE ON UPDATE NO ACTION
      )
    `);
    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS "IDX_service_quality_tickets_status_created"
      ON "service_quality_tickets" ("status", "created_at" DESC)
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE IF EXISTS "service_quality_tickets"`);
    await queryRunner.query(`DROP TABLE IF EXISTS "service_reviews"`);
  }
}
