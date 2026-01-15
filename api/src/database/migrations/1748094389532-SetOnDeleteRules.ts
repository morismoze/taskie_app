import { MigrationInterface, QueryRunner } from 'typeorm';

export class SetOnDeleteRules1748094389532 implements MigrationInterface {
  name = 'SetOnDeleteRules1748094389532';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `ALTER TABLE "session" DROP CONSTRAINT "FK_30e98e8746699fb9af235410aff"`,
    );
    await queryRunner.query(
      `ALTER TABLE "task_assignment" DROP CONSTRAINT "FK_5f8544ee8cfca009e58e0e52d89"`,
    );
    await queryRunner.query(
      `ALTER TABLE "task_assignment" DROP CONSTRAINT "FK_8c1139f486d991b5cf3919ec78f"`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace_user" DROP CONSTRAINT "FK_b312f71c6b1049d0455261f39dc"`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace_user" DROP CONSTRAINT "FK_cb830469656d51ce772872fc9d0"`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace_user" DROP CONSTRAINT "FK_7f72e35a73bd029e9967b439a64"`,
    );
    await queryRunner.query(
      `ALTER TABLE "task" DROP CONSTRAINT "FK_4a49d67b2dc62b675e3dfb25296"`,
    );
    await queryRunner.query(
      `ALTER TABLE "task" DROP CONSTRAINT "FK_8c02c2c774eff4192dd44533db3"`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace" DROP CONSTRAINT "FK_df9a8d581c6f90c3d10c1c26199"`,
    );
    await queryRunner.query(
      `ALTER TABLE "goal" DROP CONSTRAINT "FK_4929da92358d82cb8fc93c9ff07"`,
    );
    await queryRunner.query(
      `ALTER TABLE "goal" DROP CONSTRAINT "FK_6280dc46ae812769e3ad9d1b565"`,
    );
    await queryRunner.query(
      `ALTER TABLE "goal" DROP CONSTRAINT "FK_df11c203abc7425891da29b2244"`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace_invite" DROP CONSTRAINT "FK_78946aa736bfb295e7273cdd138"`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace_invite" DROP CONSTRAINT "FK_6929020a360e9e7bc05a6a92944"`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace_invite" DROP CONSTRAINT "FK_6b63d40a8fb3fa9ac5a4f1743ed"`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace_invite" DROP COLUMN "status"`,
    );
    await queryRunner.query(
      `DROP TYPE "public"."workspace_invite_status_enum"`,
    );
    await queryRunner.query(
      `ALTER TABLE "session" ADD CONSTRAINT "FK_30e98e8746699fb9af235410aff" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "task_assignment" ADD CONSTRAINT "FK_5f8544ee8cfca009e58e0e52d89" FOREIGN KEY ("task_id") REFERENCES "task"("id") ON DELETE CASCADE ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "task_assignment" ADD CONSTRAINT "FK_8c1139f486d991b5cf3919ec78f" FOREIGN KEY ("assignee_id") REFERENCES "workspace_user"("id") ON DELETE CASCADE ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace_user" ADD CONSTRAINT "FK_b312f71c6b1049d0455261f39dc" FOREIGN KEY ("workspace_id") REFERENCES "workspace"("id") ON DELETE CASCADE ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace_user" ADD CONSTRAINT "FK_cb830469656d51ce772872fc9d0" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace_user" ADD CONSTRAINT "FK_7f72e35a73bd029e9967b439a64" FOREIGN KEY ("created_by_id") REFERENCES "workspace_user"("id") ON DELETE SET NULL ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "task" ADD CONSTRAINT "FK_4a49d67b2dc62b675e3dfb25296" FOREIGN KEY ("workspace_id") REFERENCES "workspace"("id") ON DELETE CASCADE ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "task" ADD CONSTRAINT "FK_8c02c2c774eff4192dd44533db3" FOREIGN KEY ("created_by_id") REFERENCES "workspace_user"("id") ON DELETE SET NULL ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace" ADD CONSTRAINT "FK_df9a8d581c6f90c3d10c1c26199" FOREIGN KEY ("owned_by_id") REFERENCES "user"("id") ON DELETE SET NULL ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "goal" ADD CONSTRAINT "FK_4929da92358d82cb8fc93c9ff07" FOREIGN KEY ("assignee_id") REFERENCES "workspace_user"("id") ON DELETE CASCADE ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "goal" ADD CONSTRAINT "FK_6280dc46ae812769e3ad9d1b565" FOREIGN KEY ("workspace_id") REFERENCES "workspace"("id") ON DELETE CASCADE ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "goal" ADD CONSTRAINT "FK_df11c203abc7425891da29b2244" FOREIGN KEY ("created_by_id") REFERENCES "workspace_user"("id") ON DELETE SET NULL ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace_invite" ADD CONSTRAINT "FK_6929020a360e9e7bc05a6a92944" FOREIGN KEY ("workspace_id") REFERENCES "workspace"("id") ON DELETE CASCADE ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace_invite" ADD CONSTRAINT "FK_78946aa736bfb295e7273cdd138" FOREIGN KEY ("created_by_id") REFERENCES "workspace_user"("id") ON DELETE SET NULL ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace_invite" ADD CONSTRAINT "FK_6b63d40a8fb3fa9ac5a4f1743ed" FOREIGN KEY ("used_by_id") REFERENCES "workspace_user"("id") ON DELETE SET NULL ON UPDATE NO ACTION`,
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `ALTER TABLE "workspace_invite" DROP CONSTRAINT "FK_6b63d40a8fb3fa9ac5a4f1743ed"`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace_invite" DROP CONSTRAINT "FK_78946aa736bfb295e7273cdd138"`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace_invite" DROP CONSTRAINT "FK_6929020a360e9e7bc05a6a92944"`,
    );
    await queryRunner.query(
      `ALTER TABLE "goal" DROP CONSTRAINT "FK_df11c203abc7425891da29b2244"`,
    );
    await queryRunner.query(
      `ALTER TABLE "goal" DROP CONSTRAINT "FK_6280dc46ae812769e3ad9d1b565"`,
    );
    await queryRunner.query(
      `ALTER TABLE "goal" DROP CONSTRAINT "FK_4929da92358d82cb8fc93c9ff07"`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace" DROP CONSTRAINT "FK_df9a8d581c6f90c3d10c1c26199"`,
    );
    await queryRunner.query(
      `ALTER TABLE "task" DROP CONSTRAINT "FK_8c02c2c774eff4192dd44533db3"`,
    );
    await queryRunner.query(
      `ALTER TABLE "task" DROP CONSTRAINT "FK_4a49d67b2dc62b675e3dfb25296"`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace_user" DROP CONSTRAINT "FK_7f72e35a73bd029e9967b439a64"`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace_user" DROP CONSTRAINT "FK_cb830469656d51ce772872fc9d0"`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace_user" DROP CONSTRAINT "FK_b312f71c6b1049d0455261f39dc"`,
    );
    await queryRunner.query(
      `ALTER TABLE "task_assignment" DROP CONSTRAINT "FK_8c1139f486d991b5cf3919ec78f"`,
    );
    await queryRunner.query(
      `ALTER TABLE "task_assignment" DROP CONSTRAINT "FK_5f8544ee8cfca009e58e0e52d89"`,
    );
    await queryRunner.query(
      `ALTER TABLE "session" DROP CONSTRAINT "FK_30e98e8746699fb9af235410aff"`,
    );
    await queryRunner.query(
      `CREATE TYPE "public"."workspace_invite_status_enum" AS ENUM('ACTIVE', 'USED')`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace_invite" ADD "status" "public"."workspace_invite_status_enum" NOT NULL DEFAULT 'ACTIVE'`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace_invite" ADD CONSTRAINT "FK_6b63d40a8fb3fa9ac5a4f1743ed" FOREIGN KEY ("used_by_id") REFERENCES "workspace_user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace_invite" ADD CONSTRAINT "FK_6929020a360e9e7bc05a6a92944" FOREIGN KEY ("workspace_id") REFERENCES "workspace"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace_invite" ADD CONSTRAINT "FK_78946aa736bfb295e7273cdd138" FOREIGN KEY ("created_by_id") REFERENCES "workspace_user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "goal" ADD CONSTRAINT "FK_df11c203abc7425891da29b2244" FOREIGN KEY ("created_by_id") REFERENCES "workspace_user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "goal" ADD CONSTRAINT "FK_6280dc46ae812769e3ad9d1b565" FOREIGN KEY ("workspace_id") REFERENCES "workspace"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "goal" ADD CONSTRAINT "FK_4929da92358d82cb8fc93c9ff07" FOREIGN KEY ("assignee_id") REFERENCES "workspace_user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace" ADD CONSTRAINT "FK_df9a8d581c6f90c3d10c1c26199" FOREIGN KEY ("owned_by_id") REFERENCES "user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "task" ADD CONSTRAINT "FK_8c02c2c774eff4192dd44533db3" FOREIGN KEY ("created_by_id") REFERENCES "workspace_user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "task" ADD CONSTRAINT "FK_4a49d67b2dc62b675e3dfb25296" FOREIGN KEY ("workspace_id") REFERENCES "workspace"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace_user" ADD CONSTRAINT "FK_7f72e35a73bd029e9967b439a64" FOREIGN KEY ("created_by_id") REFERENCES "workspace_user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace_user" ADD CONSTRAINT "FK_cb830469656d51ce772872fc9d0" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "workspace_user" ADD CONSTRAINT "FK_b312f71c6b1049d0455261f39dc" FOREIGN KEY ("workspace_id") REFERENCES "workspace"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "task_assignment" ADD CONSTRAINT "FK_8c1139f486d991b5cf3919ec78f" FOREIGN KEY ("assignee_id") REFERENCES "workspace_user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "task_assignment" ADD CONSTRAINT "FK_5f8544ee8cfca009e58e0e52d89" FOREIGN KEY ("task_id") REFERENCES "task"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "session" ADD CONSTRAINT "FK_30e98e8746699fb9af235410aff" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
  }
}
