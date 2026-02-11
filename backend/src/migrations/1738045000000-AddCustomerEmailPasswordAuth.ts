import { MigrationInterface, QueryRunner } from 'typeorm';

/**
 * Makes phone nullable so customers can register with email+password only.
 * Password is stored in pin_hash (same as vendor).
 */
export class AddCustomerEmailPasswordAuth1738045000000 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      ALTER TABLE users ALTER COLUMN phone DROP NOT NULL
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      UPDATE users SET phone = COALESCE(email, id::text) WHERE phone IS NULL
    `);
    await queryRunner.query(`
      ALTER TABLE users ALTER COLUMN phone SET NOT NULL
    `);
  }
}
