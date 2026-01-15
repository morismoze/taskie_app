import { MigrationInterface, QueryRunner } from 'typeorm';

export class AddNotCompletedValueToProgressStatusEnum1754561976902
  implements MigrationInterface
{
  name = 'AddNotCompletedValueToProgressStatusEnum1754561976902';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `ALTER TYPE "public"."task_assignment_status_enum" RENAME TO "task_assignment_status_enum_old"`,
    );
    await queryRunner.query(
      `CREATE TYPE "public"."task_assignment_status_enum" AS ENUM('IN_PROGRESS', 'COMPLETED', 'COMPLETED_AS_STALE', 'NOT_COMPLETED', 'CLOSED')`,
    );
    await queryRunner.query(
      `ALTER TABLE "task_assignment" ALTER COLUMN "status" DROP DEFAULT`,
    );
    await queryRunner.query(
      `ALTER TABLE "task_assignment" ALTER COLUMN "status" TYPE "public"."task_assignment_status_enum" USING "status"::"text"::"public"."task_assignment_status_enum"`,
    );
    await queryRunner.query(
      `ALTER TABLE "task_assignment" ALTER COLUMN "status" SET DEFAULT 'IN_PROGRESS'`,
    );
    await queryRunner.query(
      `DROP TYPE "public"."task_assignment_status_enum_old"`,
    );
    await queryRunner.query(
      `ALTER TYPE "public"."goal_status_enum" RENAME TO "goal_status_enum_old"`,
    );
    await queryRunner.query(
      `CREATE TYPE "public"."goal_status_enum" AS ENUM('IN_PROGRESS', 'COMPLETED', 'COMPLETED_AS_STALE', 'NOT_COMPLETED', 'CLOSED')`,
    );
    await queryRunner.query(
      `ALTER TABLE "goal" ALTER COLUMN "status" DROP DEFAULT`,
    );
    await queryRunner.query(
      `ALTER TABLE "goal" ALTER COLUMN "status" TYPE "public"."goal_status_enum" USING "status"::"text"::"public"."goal_status_enum"`,
    );
    await queryRunner.query(
      `ALTER TABLE "goal" ALTER COLUMN "status" SET DEFAULT 'IN_PROGRESS'`,
    );
    await queryRunner.query(`DROP TYPE "public"."goal_status_enum_old"`);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `CREATE TYPE "public"."goal_status_enum_old" AS ENUM('IN_PROGRESS', 'COMPLETED', 'COMPLETED_AS_STALE', 'CLOSED')`,
    );
    await queryRunner.query(
      `ALTER TABLE "goal" ALTER COLUMN "status" DROP DEFAULT`,
    );
    await queryRunner.query(
      `ALTER TABLE "goal" ALTER COLUMN "status" TYPE "public"."goal_status_enum_old" USING "status"::"text"::"public"."goal_status_enum_old"`,
    );
    await queryRunner.query(
      `ALTER TABLE "goal" ALTER COLUMN "status" SET DEFAULT 'IN_PROGRESS'`,
    );
    await queryRunner.query(`DROP TYPE "public"."goal_status_enum"`);
    await queryRunner.query(
      `ALTER TYPE "public"."goal_status_enum_old" RENAME TO "goal_status_enum"`,
    );
    await queryRunner.query(
      `CREATE TYPE "public"."task_assignment_status_enum_old" AS ENUM('IN_PROGRESS', 'COMPLETED', 'COMPLETED_AS_STALE', 'CLOSED')`,
    );
    await queryRunner.query(
      `ALTER TABLE "task_assignment" ALTER COLUMN "status" DROP DEFAULT`,
    );
    await queryRunner.query(
      `ALTER TABLE "task_assignment" ALTER COLUMN "status" TYPE "public"."task_assignment_status_enum_old" USING "status"::"text"::"public"."task_assignment_status_enum_old"`,
    );
    await queryRunner.query(
      `ALTER TABLE "task_assignment" ALTER COLUMN "status" SET DEFAULT 'IN_PROGRESS'`,
    );
    await queryRunner.query(`DROP TYPE "public"."task_assignment_status_enum"`);
    await queryRunner.query(
      `ALTER TYPE "public"."task_assignment_status_enum_old" RENAME TO "task_assignment_status_enum"`,
    );
  }
}
