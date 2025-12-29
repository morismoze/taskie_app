import { MigrationInterface, QueryRunner } from "typeorm";

export class AddAccessTokenVersionToSessionEntity1766948936035 implements MigrationInterface {
    name = 'AddAccessTokenVersionToSessionEntity1766948936035'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "session" ADD "access_token_version" integer NOT NULL DEFAULT '0'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "session" DROP COLUMN "access_token_version"`);
    }

}
