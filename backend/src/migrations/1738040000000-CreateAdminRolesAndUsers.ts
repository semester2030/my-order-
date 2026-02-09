import {
  MigrationInterface,
  QueryRunner,
  Table,
  TableForeignKey,
  TableIndex,
} from 'typeorm';

export class CreateAdminRolesAndUsers1738040000000 implements MigrationInterface {
  name = 'CreateAdminRolesAndUsers1738040000000';

  /** Ignore duplicate constraint/index errors (already exists). */
  private async ignoreDuplicate<T>(fn: () => Promise<T>): Promise<void> {
    try {
      await fn();
    } catch (err: any) {
      const code = err?.driverError?.code ?? err?.code;
      if (code !== '42710' && code !== '42P07') throw err; // duplicate_object, duplicate_table
    }
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

    await this.ignoreDuplicate(() =>
      queryRunner.createForeignKey(
        'admin_users',
        new TableForeignKey({
          columnNames: ['role_id'],
          referencedColumnNames: ['id'],
          referencedTableName: 'admin_roles',
          onDelete: 'RESTRICT',
        }),
      ),
    );
    await this.ignoreDuplicate(() =>
      queryRunner.createIndex(
        'admin_users',
        new TableIndex({
          name: 'IDX_admin_users_role_id',
          columnNames: ['role_id'],
        }),
      ),
    );
    await this.ignoreDuplicate(() =>
      queryRunner.createIndex(
        'admin_users',
        new TableIndex({
          name: 'IDX_admin_users_email',
          columnNames: ['email'],
        }),
      ),
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
