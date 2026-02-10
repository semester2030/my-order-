import {
  MigrationInterface,
  QueryRunner,
  Table,
  TableForeignKey,
  TableIndex,
} from 'typeorm';

export class CreateAdminRolesAndUsers1738040000000 implements MigrationInterface {
  name = 'CreateAdminRolesAndUsers1738040000000';

  /** Only add FK if it does not exist (avoids aborting the transaction). */
  private async addForeignKeyIfNotExists(
    queryRunner: QueryRunner,
    table: string,
    fk: TableForeignKey,
  ): Promise<void> {
    const refTable = fk.referencedTableName;
    const rows = await queryRunner.query(
      `SELECT 1 FROM pg_constraint c
       JOIN pg_class t ON t.oid = c.conrelid
       JOIN pg_namespace n ON n.oid = t.relnamespace
       WHERE n.nspname = 'public' AND t.relname = $1 AND c.contype = 'f'
       AND c.confrelid = (SELECT oid FROM pg_class WHERE relname = $2 AND relnamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'public'))`,
      [table, refTable],
    );
    if (Array.isArray(rows) && rows.length > 0) return;
    await queryRunner.createForeignKey(table, fk);
  }

  /** Only create index if it does not exist. */
  private async createIndexIfNotExists(
    queryRunner: QueryRunner,
    table: string,
    index: TableIndex,
  ): Promise<void> {
    const name = index.name;
    const rows = await queryRunner.query(
      `SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = $1`,
      [name],
    );
    if (Array.isArray(rows) && rows.length > 0) return;
    await queryRunner.createIndex(table, index);
  }

  public async up(queryRunner: QueryRunner): Promise<void> {
    if (!(await queryRunner.hasTable('admin_roles'))) {
      await queryRunner.createTable(
      new Table({
        name: 'admin_roles',
        columns: [
          {
            name: 'id',
            type: 'uuid',
            isPrimary: true,
            generationStrategy: 'uuid',
            default: 'uuid_generate_v4()',
          },
          {
            name: 'name',
            type: 'varchar',
            length: '100',
            isUnique: true,
            isNullable: false,
          },
          {
            name: 'slug',
            type: 'varchar',
            length: '50',
            isUnique: true,
            isNullable: false,
          },
          {
            name: 'created_at',
            type: 'timestamp',
            default: 'CURRENT_TIMESTAMP',
            isNullable: false,
          },
        ],
      }),
      true,
    );
    }

    if (!(await queryRunner.hasTable('admin_users'))) {
      await queryRunner.createTable(
      new Table({
        name: 'admin_users',
        columns: [
          {
            name: 'id',
            type: 'uuid',
            isPrimary: true,
            generationStrategy: 'uuid',
            default: 'uuid_generate_v4()',
          },
          {
            name: 'email',
            type: 'varchar',
            isUnique: true,
            isNullable: false,
          },
          {
            name: 'password_hash',
            type: 'varchar',
            isNullable: false,
          },
          {
            name: 'role_id',
            type: 'uuid',
            isNullable: false,
          },
          {
            name: 'name',
            type: 'varchar',
            isNullable: false,
          },
          {
            name: 'is_active',
            type: 'boolean',
            default: true,
            isNullable: false,
          },
          {
            name: 'created_at',
            type: 'timestamp',
            default: 'CURRENT_TIMESTAMP',
            isNullable: false,
          },
          {
            name: 'updated_at',
            type: 'timestamp',
            default: 'CURRENT_TIMESTAMP',
            isNullable: false,
          },
        ],
      }),
      true,
    );
    }

    const fk = new TableForeignKey({
      columnNames: ['role_id'],
      referencedColumnNames: ['id'],
      referencedTableName: 'admin_roles',
      onDelete: 'RESTRICT',
    });
    await this.addForeignKeyIfNotExists(queryRunner, 'admin_users', fk);

    await this.createIndexIfNotExists(
      queryRunner,
      'admin_users',
      new TableIndex({ name: 'IDX_admin_users_role_id', columnNames: ['role_id'] }),
    );
    await this.createIndexIfNotExists(
      queryRunner,
      'admin_users',
      new TableIndex({ name: 'IDX_admin_users_email', columnNames: ['email'] }),
    );

    // Insert default roles only if not already present
    await queryRunner.query(`
      INSERT INTO admin_roles (id, name, slug) VALUES
        (uuid_generate_v4(), 'Super Admin', 'super_admin'),
        (uuid_generate_v4(), 'Operations', 'ops'),
        (uuid_generate_v4(), 'Finance', 'finance'),
        (uuid_generate_v4(), 'Support', 'support'),
        (uuid_generate_v4(), 'Quality', 'quality')
      ON CONFLICT (slug) DO NOTHING;
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropTable('admin_users');
    await queryRunner.dropTable('admin_roles');
  }
}
