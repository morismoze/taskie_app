import { MigrationInterface, QueryRunner } from "typeorm";

export class Initial1747937387778 implements MigrationInterface {
    name = 'Initial1747937387778'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TYPE "public"."user_provider_enum" AS ENUM('GOOGLE')`);
        await queryRunner.query(`CREATE TYPE "public"."user_status_enum" AS ENUM('ACTIVE', 'INACTIVE')`);
        await queryRunner.query(`CREATE TABLE "user" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "created_at" TIMESTAMP NOT NULL DEFAULT now(), "updated_at" TIMESTAMP NOT NULL DEFAULT now(), "deleted_at" TIMESTAMP, "email" character varying, "first_name" character varying NOT NULL, "last_name" character varying NOT NULL, "profile_image_url" character varying, "provider" "public"."user_provider_enum", "social_id" character varying, "status" "public"."user_status_enum" NOT NULL, CONSTRAINT "UQ_e12875dfb3b1d92d7d7c5377e22" UNIQUE ("email"), CONSTRAINT "UQ_0cd76a8cdee62eeff31d384b730" UNIQUE ("social_id"), CONSTRAINT "PK_cace4a159ff9f2512dd42373760" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "session" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "created_at" TIMESTAMP NOT NULL DEFAULT now(), "updated_at" TIMESTAMP NOT NULL DEFAULT now(), "deleted_at" TIMESTAMP, "hash" character varying NOT NULL, "ip_address" character varying(255) NOT NULL, "device_model" character varying(255), "os_version" character varying(255), "app_version" character varying(255), "user_id" uuid, CONSTRAINT "PK_f55da76ac1c3ac420f444d2ff11" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE INDEX "IDX_30e98e8746699fb9af235410af" ON "session" ("user_id") `);
        await queryRunner.query(`CREATE TYPE "public"."task_assignment_status_enum" AS ENUM('IN_PROGRESS', 'COMPLETED', 'COMPLETED_AS_STALE', 'CLOSED')`);
        await queryRunner.query(`CREATE TABLE "task_assignment" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "created_at" TIMESTAMP NOT NULL DEFAULT now(), "updated_at" TIMESTAMP NOT NULL DEFAULT now(), "deleted_at" TIMESTAMP, "status" "public"."task_assignment_status_enum" NOT NULL DEFAULT 'IN_PROGRESS', "task_id" uuid, "assignee_id" uuid, CONSTRAINT "PK_bbd5007caf5731217005cccdc0d" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "task" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "created_at" TIMESTAMP NOT NULL DEFAULT now(), "updated_at" TIMESTAMP NOT NULL DEFAULT now(), "deleted_at" TIMESTAMP, "title" character varying NOT NULL, "reward_points" smallint NOT NULL, "description" character varying, "due_date" TIMESTAMP, "workspace_id" uuid, "created_by_id" uuid, CONSTRAINT "PK_fb213f79ee45060ba925ecd576e" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "workspace" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "created_at" TIMESTAMP NOT NULL DEFAULT now(), "updated_at" TIMESTAMP NOT NULL DEFAULT now(), "deleted_at" TIMESTAMP, "name" character varying NOT NULL, "description" character varying, "picture_url" character varying, "owned_by_id" uuid, CONSTRAINT "PK_ca86b6f9b3be5fe26d307d09b49" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TYPE "public"."goal_status_enum" AS ENUM('IN_PROGRESS', 'COMPLETED', 'COMPLETED_AS_STALE', 'CLOSED')`);
        await queryRunner.query(`CREATE TABLE "goal" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "created_at" TIMESTAMP NOT NULL DEFAULT now(), "updated_at" TIMESTAMP NOT NULL DEFAULT now(), "deleted_at" TIMESTAMP, "title" character varying NOT NULL, "description" character varying, "required_points" integer NOT NULL, "status" "public"."goal_status_enum" NOT NULL DEFAULT 'IN_PROGRESS', "assignee_id" uuid, "workspace_id" uuid, "created_by_id" uuid, CONSTRAINT "PK_88c8e2b461b711336c836b1e130" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TYPE "public"."workspace_user_workspace_role_enum" AS ENUM('MANAGER', 'MEMBER')`);
        await queryRunner.query(`CREATE TYPE "public"."workspace_user_status_enum" AS ENUM('ACTIVE', 'REMOVED')`);
        await queryRunner.query(`CREATE TABLE "workspace_user" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "created_at" TIMESTAMP NOT NULL DEFAULT now(), "updated_at" TIMESTAMP NOT NULL DEFAULT now(), "deleted_at" TIMESTAMP, "workspace_role" "public"."workspace_user_workspace_role_enum" NOT NULL, "status" "public"."workspace_user_status_enum" NOT NULL, "workspace_id" uuid, "user_id" uuid, "created_by_id" uuid, CONSTRAINT "UQ_workspace_user" UNIQUE ("user_id", "workspace_id"), CONSTRAINT "PK_a09cff0ab849da007d391eb9284" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE INDEX "IDX_b312f71c6b1049d0455261f39d" ON "workspace_user" ("workspace_id") `);
        await queryRunner.query(`CREATE INDEX "IDX_cb830469656d51ce772872fc9d" ON "workspace_user" ("user_id") `);
        await queryRunner.query(`CREATE TYPE "public"."workspace_invite_status_enum" AS ENUM('ACTIVE', 'USED')`);
        await queryRunner.query(`CREATE TABLE "workspace_invite" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "created_at" TIMESTAMP NOT NULL DEFAULT now(), "updated_at" TIMESTAMP NOT NULL DEFAULT now(), "deleted_at" TIMESTAMP, "token" character varying NOT NULL, "expires_at" TIMESTAMP NOT NULL, "status" "public"."workspace_invite_status_enum" NOT NULL DEFAULT 'ACTIVE', "workspace_id" uuid, "invited_by_id" uuid, "used_by_id" uuid, CONSTRAINT "PK_731c4e491678e81c9dce6df62cb" PRIMARY KEY ("id"))`);
        await queryRunner.query(`ALTER TABLE "session" ADD CONSTRAINT "FK_30e98e8746699fb9af235410aff" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "task_assignment" ADD CONSTRAINT "FK_5f8544ee8cfca009e58e0e52d89" FOREIGN KEY ("task_id") REFERENCES "task"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "task_assignment" ADD CONSTRAINT "FK_8c1139f486d991b5cf3919ec78f" FOREIGN KEY ("assignee_id") REFERENCES "workspace_user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "task" ADD CONSTRAINT "FK_4a49d67b2dc62b675e3dfb25296" FOREIGN KEY ("workspace_id") REFERENCES "workspace"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "task" ADD CONSTRAINT "FK_8c02c2c774eff4192dd44533db3" FOREIGN KEY ("created_by_id") REFERENCES "workspace_user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "workspace" ADD CONSTRAINT "FK_df9a8d581c6f90c3d10c1c26199" FOREIGN KEY ("owned_by_id") REFERENCES "user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "goal" ADD CONSTRAINT "FK_4929da92358d82cb8fc93c9ff07" FOREIGN KEY ("assignee_id") REFERENCES "workspace_user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "goal" ADD CONSTRAINT "FK_6280dc46ae812769e3ad9d1b565" FOREIGN KEY ("workspace_id") REFERENCES "workspace"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "goal" ADD CONSTRAINT "FK_df11c203abc7425891da29b2244" FOREIGN KEY ("created_by_id") REFERENCES "workspace_user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "workspace_user" ADD CONSTRAINT "FK_b312f71c6b1049d0455261f39dc" FOREIGN KEY ("workspace_id") REFERENCES "workspace"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "workspace_user" ADD CONSTRAINT "FK_cb830469656d51ce772872fc9d0" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "workspace_user" ADD CONSTRAINT "FK_7f72e35a73bd029e9967b439a64" FOREIGN KEY ("created_by_id") REFERENCES "workspace_user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "workspace_invite" ADD CONSTRAINT "FK_6929020a360e9e7bc05a6a92944" FOREIGN KEY ("workspace_id") REFERENCES "workspace"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "workspace_invite" ADD CONSTRAINT "FK_fb11943de49dc963bfb8ee02bec" FOREIGN KEY ("invited_by_id") REFERENCES "workspace_user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "workspace_invite" ADD CONSTRAINT "FK_6b63d40a8fb3fa9ac5a4f1743ed" FOREIGN KEY ("used_by_id") REFERENCES "workspace_user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "workspace_invite" DROP CONSTRAINT "FK_6b63d40a8fb3fa9ac5a4f1743ed"`);
        await queryRunner.query(`ALTER TABLE "workspace_invite" DROP CONSTRAINT "FK_fb11943de49dc963bfb8ee02bec"`);
        await queryRunner.query(`ALTER TABLE "workspace_invite" DROP CONSTRAINT "FK_6929020a360e9e7bc05a6a92944"`);
        await queryRunner.query(`ALTER TABLE "workspace_user" DROP CONSTRAINT "FK_7f72e35a73bd029e9967b439a64"`);
        await queryRunner.query(`ALTER TABLE "workspace_user" DROP CONSTRAINT "FK_cb830469656d51ce772872fc9d0"`);
        await queryRunner.query(`ALTER TABLE "workspace_user" DROP CONSTRAINT "FK_b312f71c6b1049d0455261f39dc"`);
        await queryRunner.query(`ALTER TABLE "goal" DROP CONSTRAINT "FK_df11c203abc7425891da29b2244"`);
        await queryRunner.query(`ALTER TABLE "goal" DROP CONSTRAINT "FK_6280dc46ae812769e3ad9d1b565"`);
        await queryRunner.query(`ALTER TABLE "goal" DROP CONSTRAINT "FK_4929da92358d82cb8fc93c9ff07"`);
        await queryRunner.query(`ALTER TABLE "workspace" DROP CONSTRAINT "FK_df9a8d581c6f90c3d10c1c26199"`);
        await queryRunner.query(`ALTER TABLE "task" DROP CONSTRAINT "FK_8c02c2c774eff4192dd44533db3"`);
        await queryRunner.query(`ALTER TABLE "task" DROP CONSTRAINT "FK_4a49d67b2dc62b675e3dfb25296"`);
        await queryRunner.query(`ALTER TABLE "task_assignment" DROP CONSTRAINT "FK_8c1139f486d991b5cf3919ec78f"`);
        await queryRunner.query(`ALTER TABLE "task_assignment" DROP CONSTRAINT "FK_5f8544ee8cfca009e58e0e52d89"`);
        await queryRunner.query(`ALTER TABLE "session" DROP CONSTRAINT "FK_30e98e8746699fb9af235410aff"`);
        await queryRunner.query(`DROP TABLE "workspace_invite"`);
        await queryRunner.query(`DROP TYPE "public"."workspace_invite_status_enum"`);
        await queryRunner.query(`DROP INDEX "public"."IDX_cb830469656d51ce772872fc9d"`);
        await queryRunner.query(`DROP INDEX "public"."IDX_b312f71c6b1049d0455261f39d"`);
        await queryRunner.query(`DROP TABLE "workspace_user"`);
        await queryRunner.query(`DROP TYPE "public"."workspace_user_status_enum"`);
        await queryRunner.query(`DROP TYPE "public"."workspace_user_workspace_role_enum"`);
        await queryRunner.query(`DROP TABLE "goal"`);
        await queryRunner.query(`DROP TYPE "public"."goal_status_enum"`);
        await queryRunner.query(`DROP TABLE "workspace"`);
        await queryRunner.query(`DROP TABLE "task"`);
        await queryRunner.query(`DROP TABLE "task_assignment"`);
        await queryRunner.query(`DROP TYPE "public"."task_assignment_status_enum"`);
        await queryRunner.query(`DROP INDEX "public"."IDX_30e98e8746699fb9af235410af"`);
        await queryRunner.query(`DROP TABLE "session"`);
        await queryRunner.query(`DROP TABLE "user"`);
        await queryRunner.query(`DROP TYPE "public"."user_status_enum"`);
        await queryRunner.query(`DROP TYPE "public"."user_provider_enum"`);
    }

}
