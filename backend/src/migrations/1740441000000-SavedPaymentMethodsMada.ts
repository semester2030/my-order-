import { MigrationInterface, QueryRunner, Table, TableForeignKey } from 'typeorm';

/**
 * بطاقات مدا المحفوظة للعميل — لا يُخزَّن رقم البطاقة الكامل ولا CVV.
 * gateway_payment_method_id: مرجع المزوّد (حالياً mock_mada_* حتى ربط PSP).
 */
export class SavedPaymentMethodsMada1740441000000 implements MigrationInterface {
  name = 'SavedPaymentMethodsMada1740441000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.createTable(
      new Table({
        name: 'saved_payment_methods',
        columns: [
          {
            name: 'id',
            type: 'uuid',
            isPrimary: true,
            default: 'gen_random_uuid()',
          },
          {
            name: 'user_id',
            type: 'uuid',
            isNullable: false,
          },
          {
            name: 'brand',
            type: 'varchar',
            length: '32',
            default: `'mada'`,
          },
          {
            name: 'gateway_payment_method_id',
            type: 'varchar',
            length: '255',
            isNullable: false,
          },
          {
            name: 'last4',
            type: 'char',
            length: '4',
            isNullable: false,
          },
          {
            name: 'exp_month',
            type: 'smallint',
            isNullable: false,
          },
          {
            name: 'exp_year',
            type: 'smallint',
            isNullable: false,
          },
          {
            name: 'holder_name',
            type: 'varchar',
            length: '200',
            isNullable: false,
          },
          {
            name: 'created_at',
            type: 'timestamptz',
            default: 'now()',
          },
        ],
      }),
      true,
    );

    await queryRunner.createForeignKey(
      'saved_payment_methods',
      new TableForeignKey({
        columnNames: ['user_id'],
        referencedTableName: 'users',
        referencedColumnNames: ['id'],
        onDelete: 'CASCADE',
      }),
    );

    await queryRunner.query(`
      CREATE INDEX "IDX_saved_payment_methods_user_id"
      ON "saved_payment_methods" ("user_id")
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropTable('saved_payment_methods', true);
  }
}
