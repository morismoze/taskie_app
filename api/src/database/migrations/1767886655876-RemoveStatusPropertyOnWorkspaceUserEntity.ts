import { MigrationInterface, QueryRunner } from "typeorm";

export class RemoveStatusPropertyOnWorkspaceUserEntity1767886655876 implements MigrationInterface {
    name = 'RemoveStatusPropertyOnWorkspaceUserEntity1767886655876'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "workspace_user" DROP COLUMN "status"`);
        await queryRunner.query(`DROP TYPE "public"."workspace_user_status_enum"`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TYPE "public"."workspace_user_status_enum" AS ENUM('ACTIVE', 'REMOVED')`);
        await queryRunner.query(`ALTER TABLE "workspace_user" ADD "status" "public"."workspace_user_status_enum" NOT NULL`);
    }

}
