import { MigrationInterface, QueryRunner } from "typeorm";

export class AddUniqueConstraintToTaskAssignment1762082638113 implements MigrationInterface {
    name = 'AddUniqueConstraintToTaskAssignment1762082638113'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "task_assignment" ADD CONSTRAINT "UQ_task_assignment" UNIQUE ("task_id", "assignee_id")`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "task_assignment" DROP CONSTRAINT "UQ_task_assignment"`);
    }

}
