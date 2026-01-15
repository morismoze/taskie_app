import { MigrationInterface, QueryRunner } from 'typeorm';

export class RenameWorkspaceInviteEntityCreatedByColumn1748086482509
  implements MigrationInterface
{
  name = 'RenameWorkspaceInviteEntityCreatedByColumn1748086482509';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `ALTER TABLE "workspace_invite" DROP CONSTRAINT "FK_fb11943de49dc963bfb8ee02bec"`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace_invite" RENAME COLUMN "invited_by_id" TO "created_by_id"`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace_invite" ADD CONSTRAINT "FK_78946aa736bfb295e7273cdd138" FOREIGN KEY ("created_by_id") REFERENCES "workspace_user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `ALTER TABLE "workspace_invite" DROP CONSTRAINT "FK_78946aa736bfb295e7273cdd138"`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace_invite" RENAME COLUMN "created_by_id" TO "invited_by_id"`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace_invite" ADD CONSTRAINT "FK_fb11943de49dc963bfb8ee02bec" FOREIGN KEY ("invited_by_id") REFERENCES "workspace_user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
  }
}
