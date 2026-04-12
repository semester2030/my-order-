import { MigrationInterface, QueryRunner } from 'typeorm';

/**
 * إضافة قيمة grilling لنوع طلب الحدث (شواء خارجي عند العميل).
 */
export class AddGrillingToEventRequestTypeEnum1739300000000
  implements MigrationInterface
{
  name = 'AddGrillingToEventRequestTypeEnum1739300000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `ALTER TYPE "event_requests_request_type_enum" ADD VALUE 'grilling'`,
    );
  }

  public async down(): Promise<void> {
    // إزالة قيمة من enum في PostgreSQL غير مدعومة بسهولة — تُترك للتدقيق اليدوي إن لزم
  }
}
