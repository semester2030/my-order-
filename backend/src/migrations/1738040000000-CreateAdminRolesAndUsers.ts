import {
  MigrationInterface,
  QueryRunner,
  Table,
  TableForeignKey,
  TableIndex,
} from 'typeorm';

export class CreateAdminRolesAndUsers1738040000000 implements MigrationInterface {
  name = 'CreateAdminRolesAndUsers1738040000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
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

    await queryRunner.createForeignKey(
      'admin_users',
      new TableForeignKey({
        columnNames: ['role_id'],
        referencedColumnNames: ['id'],
        referencedTableName: 'admin_roles',
        onDelete: 'RESTRICT',
      }),
    );

    await queryRunner.createIndex(
      'admin_users',
      new TableIndex({
        name: 'IDX_admin_users_role_id',
        columnNames: ['role_id'],
      }),
    );

    await queryRunner.createIndex(
      'admin_users',
      new TableIndex({
        name: 'IDX_admin_users_email',
        columnNames: ['email'],
      }),
    );

    await queryRunner.query(`
      INSERT INTO admin_roles (id, name, slug) VALUES
        (uuid_generate_v4(), 'Super Admin', 'super_admin'),
        (uuid_generate_v4(), 'Operations', 'ops'),
        (uuid_generate_v4(), 'Finance', 'finance'),
        (uuid_generate_v4(), 'Support', 'support'),
        (uuid_generate_v4(), 'Quality', 'quality');
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropTable('admin_users');
    await queryRunner.dropTable('admin_roles');
  }
}
