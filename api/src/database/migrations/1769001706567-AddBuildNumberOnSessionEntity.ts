import { MigrationInterface, QueryRunner } from 'typeorm';

export class AddBuildNumberOnSessionEntity1769001706567
  implements MigrationInterface
{
  name = 'AddBuildNumberOnSessionEntity1769001706567';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `ALTER TABLE "session" ADD "build_number" character varying(255)`,
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`ALTER TABLE "session" DROP COLUMN "build_number"`);
  }
}
