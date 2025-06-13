import { MigrationInterface, QueryRunner } from "typeorm";

export class SetDateFieldsAsTimestampsWithTimezones1748371986239 implements MigrationInterface {
    name = 'SetDateFieldsAsTimestampsWithTimezones1748371986239'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "user" DROP COLUMN "created_at"`);
        await queryRunner.query(`ALTER TABLE "user" ADD "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "user" DROP COLUMN "updated_at"`);
        await queryRunner.query(`ALTER TABLE "user" ADD "updated_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "user" DROP COLUMN "deleted_at"`);
        await queryRunner.query(`ALTER TABLE "user" ADD "deleted_at" TIMESTAMP WITH TIME ZONE`);
        await queryRunner.query(`ALTER TABLE "session" DROP COLUMN "created_at"`);
        await queryRunner.query(`ALTER TABLE "session" ADD "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "session" DROP COLUMN "updated_at"`);
        await queryRunner.query(`ALTER TABLE "session" ADD "updated_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "session" DROP COLUMN "deleted_at"`);
        await queryRunner.query(`ALTER TABLE "session" ADD "deleted_at" TIMESTAMP WITH TIME ZONE`);
        await queryRunner.query(`ALTER TABLE "task" DROP COLUMN "created_at"`);
        await queryRunner.query(`ALTER TABLE "task" ADD "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "task" DROP COLUMN "updated_at"`);
        await queryRunner.query(`ALTER TABLE "task" ADD "updated_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "task" DROP COLUMN "deleted_at"`);
        await queryRunner.query(`ALTER TABLE "task" ADD "deleted_at" TIMESTAMP WITH TIME ZONE`);
        await queryRunner.query(`ALTER TABLE "task" DROP COLUMN "due_date"`);
        await queryRunner.query(`ALTER TABLE "task" ADD "due_date" TIMESTAMP WITH TIME ZONE`);
        await queryRunner.query(`ALTER TABLE "task_assignment" DROP COLUMN "created_at"`);
        await queryRunner.query(`ALTER TABLE "task_assignment" ADD "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "task_assignment" DROP COLUMN "updated_at"`);
        await queryRunner.query(`ALTER TABLE "task_assignment" ADD "updated_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "task_assignment" DROP COLUMN "deleted_at"`);
        await queryRunner.query(`ALTER TABLE "task_assignment" ADD "deleted_at" TIMESTAMP WITH TIME ZONE`);
        await queryRunner.query(`ALTER TABLE "workspace_user" DROP COLUMN "created_at"`);
        await queryRunner.query(`ALTER TABLE "workspace_user" ADD "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "workspace_user" DROP COLUMN "updated_at"`);
        await queryRunner.query(`ALTER TABLE "workspace_user" ADD "updated_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "workspace_user" DROP COLUMN "deleted_at"`);
        await queryRunner.query(`ALTER TABLE "workspace_user" ADD "deleted_at" TIMESTAMP WITH TIME ZONE`);
        await queryRunner.query(`ALTER TABLE "goal" DROP COLUMN "created_at"`);
        await queryRunner.query(`ALTER TABLE "goal" ADD "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "goal" DROP COLUMN "updated_at"`);
        await queryRunner.query(`ALTER TABLE "goal" ADD "updated_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "goal" DROP COLUMN "deleted_at"`);
        await queryRunner.query(`ALTER TABLE "goal" ADD "deleted_at" TIMESTAMP WITH TIME ZONE`);
        await queryRunner.query(`ALTER TABLE "workspace" DROP COLUMN "created_at"`);
        await queryRunner.query(`ALTER TABLE "workspace" ADD "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "workspace" DROP COLUMN "updated_at"`);
        await queryRunner.query(`ALTER TABLE "workspace" ADD "updated_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "workspace" DROP COLUMN "deleted_at"`);
        await queryRunner.query(`ALTER TABLE "workspace" ADD "deleted_at" TIMESTAMP WITH TIME ZONE`);
        await queryRunner.query(`ALTER TABLE "workspace_invite" DROP COLUMN "created_at"`);
        await queryRunner.query(`ALTER TABLE "workspace_invite" ADD "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "workspace_invite" DROP COLUMN "updated_at"`);
        await queryRunner.query(`ALTER TABLE "workspace_invite" ADD "updated_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "workspace_invite" DROP COLUMN "deleted_at"`);
        await queryRunner.query(`ALTER TABLE "workspace_invite" ADD "deleted_at" TIMESTAMP WITH TIME ZONE`);
        await queryRunner.query(`ALTER TABLE "workspace_invite" DROP COLUMN "expires_at"`);
        await queryRunner.query(`ALTER TABLE "workspace_invite" ADD "expires_at" TIMESTAMP WITH TIME ZONE NOT NULL`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "workspace_invite" DROP COLUMN "expires_at"`);
        await queryRunner.query(`ALTER TABLE "workspace_invite" ADD "expires_at" TIMESTAMP NOT NULL`);
        await queryRunner.query(`ALTER TABLE "workspace_invite" DROP COLUMN "deleted_at"`);
        await queryRunner.query(`ALTER TABLE "workspace_invite" ADD "deleted_at" TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE "workspace_invite" DROP COLUMN "updated_at"`);
        await queryRunner.query(`ALTER TABLE "workspace_invite" ADD "updated_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "workspace_invite" DROP COLUMN "created_at"`);
        await queryRunner.query(`ALTER TABLE "workspace_invite" ADD "created_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "workspace" DROP COLUMN "deleted_at"`);
        await queryRunner.query(`ALTER TABLE "workspace" ADD "deleted_at" TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE "workspace" DROP COLUMN "updated_at"`);
        await queryRunner.query(`ALTER TABLE "workspace" ADD "updated_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "workspace" DROP COLUMN "created_at"`);
        await queryRunner.query(`ALTER TABLE "workspace" ADD "created_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "goal" DROP COLUMN "deleted_at"`);
        await queryRunner.query(`ALTER TABLE "goal" ADD "deleted_at" TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE "goal" DROP COLUMN "updated_at"`);
        await queryRunner.query(`ALTER TABLE "goal" ADD "updated_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "goal" DROP COLUMN "created_at"`);
        await queryRunner.query(`ALTER TABLE "goal" ADD "created_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "workspace_user" DROP COLUMN "deleted_at"`);
        await queryRunner.query(`ALTER TABLE "workspace_user" ADD "deleted_at" TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE "workspace_user" DROP COLUMN "updated_at"`);
        await queryRunner.query(`ALTER TABLE "workspace_user" ADD "updated_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "workspace_user" DROP COLUMN "created_at"`);
        await queryRunner.query(`ALTER TABLE "workspace_user" ADD "created_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "task_assignment" DROP COLUMN "deleted_at"`);
        await queryRunner.query(`ALTER TABLE "task_assignment" ADD "deleted_at" TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE "task_assignment" DROP COLUMN "updated_at"`);
        await queryRunner.query(`ALTER TABLE "task_assignment" ADD "updated_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "task_assignment" DROP COLUMN "created_at"`);
        await queryRunner.query(`ALTER TABLE "task_assignment" ADD "created_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "task" DROP COLUMN "due_date"`);
        await queryRunner.query(`ALTER TABLE "task" ADD "due_date" TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE "task" DROP COLUMN "deleted_at"`);
        await queryRunner.query(`ALTER TABLE "task" ADD "deleted_at" TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE "task" DROP COLUMN "updated_at"`);
        await queryRunner.query(`ALTER TABLE "task" ADD "updated_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "task" DROP COLUMN "created_at"`);
        await queryRunner.query(`ALTER TABLE "task" ADD "created_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "session" DROP COLUMN "deleted_at"`);
        await queryRunner.query(`ALTER TABLE "session" ADD "deleted_at" TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE "session" DROP COLUMN "updated_at"`);
        await queryRunner.query(`ALTER TABLE "session" ADD "updated_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "session" DROP COLUMN "created_at"`);
        await queryRunner.query(`ALTER TABLE "session" ADD "created_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "user" DROP COLUMN "deleted_at"`);
        await queryRunner.query(`ALTER TABLE "user" ADD "deleted_at" TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE "user" DROP COLUMN "updated_at"`);
        await queryRunner.query(`ALTER TABLE "user" ADD "updated_at" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "user" DROP COLUMN "created_at"`);
        await queryRunner.query(`ALTER TABLE "user" ADD "created_at" TIMESTAMP NOT NULL DEFAULT now()`);
    }

}
