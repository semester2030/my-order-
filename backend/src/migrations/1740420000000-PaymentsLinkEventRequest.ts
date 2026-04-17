import {
  MigrationInterface,
  QueryRunner,
  TableForeignKey,
} from 'typeorm';

/**
 * Links card PSP rows to home-cooking quotes: exactly one of (order_id, event_request_id).
 * Existing rows keep order_id; new home-cooking card payments use event_request_id only.
 */
export class PaymentsLinkEventRequest1740420000000 implements MigrationInterface {
  name = 'PaymentsLinkEventRequest1740420000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    const paymentsTable = await queryRunner.getTable('payments');
    if (!paymentsTable) {
      return;
    }
    if (paymentsTable.columns.find((c) => c.name === 'event_request_id')) {
      return;
    }

    const orderFk = paymentsTable.foreignKeys.find(
      (fk) =>
        fk.columnNames.length === 1 && fk.columnNames[0] === 'order_id',
    );
    if (orderFk) {
      await queryRunner.dropForeignKey('payments', orderFk);
    }

    await queryRunner.query(
      `ALTER TABLE "payments" ALTER COLUMN "order_id" DROP NOT NULL`,
    );

    await queryRunner.query(
      `ALTER TABLE "payments" ADD COLUMN "event_request_id" uuid NULL`,
    );
    await queryRunner.query(`
      ALTER TABLE "payments"
      ADD CONSTRAINT "FK_payments_event_request_id"
      FOREIGN KEY ("event_request_id") REFERENCES "event_requests"("id")
      ON DELETE CASCADE ON UPDATE NO ACTION
    `);

    await queryRunner.query(`
      ALTER TABLE "payments"
      ADD CONSTRAINT "CHK_payments_order_xor_event_request"
      CHECK (
        ("order_id" IS NOT NULL AND "event_request_id" IS NULL)
        OR ("order_id" IS NULL AND "event_request_id" IS NOT NULL)
      )
    `);

    await queryRunner.query(`
      CREATE UNIQUE INDEX "UQ_payments_home_one_active_per_event"
      ON "payments" ("event_request_id")
      WHERE "event_request_id" IS NOT NULL
        AND ("status")::text IN ('pending', 'processing')
    `);

    await queryRunner.query(`
      CREATE INDEX "IDX_payments_event_request_id"
      ON "payments" ("event_request_id")
    `);

    await queryRunner.createForeignKey(
      'payments',
      new TableForeignKey({
        name: 'FK_payments_order_id',
        columnNames: ['order_id'],
        referencedTableName: 'orders',
        referencedColumnNames: ['id'],
        onDelete: 'CASCADE',
      }),
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    const paymentsTable = await queryRunner.getTable('payments');
    if (!paymentsTable?.columns.find((c) => c.name === 'event_request_id')) {
      return;
    }

    await queryRunner.query(
      `DELETE FROM "payments" WHERE "event_request_id" IS NOT NULL`,
    );

    await queryRunner.query(
      `DROP INDEX IF EXISTS "UQ_payments_home_one_active_per_event"`,
    );
    await queryRunner.query(
      `DROP INDEX IF EXISTS "IDX_payments_event_request_id"`,
    );
    await queryRunner.query(
      `ALTER TABLE "payments" DROP CONSTRAINT IF EXISTS "CHK_payments_order_xor_event_request"`,
    );
    await queryRunner.query(
      `ALTER TABLE "payments" DROP CONSTRAINT IF EXISTS "FK_payments_event_request_id"`,
    );

    const t = await queryRunner.getTable('payments');
    const orderFk = t?.foreignKeys.find(
      (fk) =>
        fk.columnNames.length === 1 && fk.columnNames[0] === 'order_id',
    );
    if (orderFk) {
      await queryRunner.dropForeignKey('payments', orderFk);
    }

    await queryRunner.query(
      `ALTER TABLE "payments" DROP COLUMN IF EXISTS "event_request_id"`,
    );

    await queryRunner.query(
      `ALTER TABLE "payments" ALTER COLUMN "order_id" SET NOT NULL`,
    );

    await queryRunner.createForeignKey(
      'payments',
      new TableForeignKey({
        name: 'FK_payments_order_id',
        columnNames: ['order_id'],
        referencedTableName: 'orders',
        referencedColumnNames: ['id'],
        onDelete: 'CASCADE',
      }),
    );
  }
}
