import { MigrationInterface, QueryRunner, Table } from 'typeorm';

/**
 * جدول سجل التدقيق للإدارة — مطلوب عندما synchronize: false (إنتاج).
 */
export class CreateAuditLogsTable1738056000000 implements MigrationInterface {
  name = 'CreateAuditLogsTable1738056000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    const has = await queryRunner.hasTable('audit_logs');
    if (has) return;

    await queryRunner.createTable(
      new Table({
        name: 'audit_logs',
        columns: [
          {
            name: 'id',
            type: 'uuid',
            isPrimary: true,
            generationStrategy: 'uuid',
            default: 'uuid_generate_v4()',
          },
          {
            name: 'actor_type',
            type: 'varchar',
            length: '50',
            default: "'admin'",
          },
          { name: 'actor_id', type: 'uuid' },
          { name: 'action', type: 'varchar', length: '100' },
          { name: 'entity_type', type: 'varchar', length: '50' },
          { name: 'entity_id', type: 'text' },
          { name: 'old_value', type: 'jsonb', isNullable: true },
          { name: 'new_value', type: 'jsonb', isNullable: true },
          { name: 'reason', type: 'text', isNullable: true },
          { name: 'ip', type: 'varchar', length: '45', isNullable: true },
          { name: 'user_agent', type: 'text', isNullable: true },
          {
            name: 'created_at',
            type: 'timestamptz',
            default: 'CURRENT_TIMESTAMP',
          },
        ],
      }),
      true,
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropTable('audit_logs');
  }
}
