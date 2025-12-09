import * as fs from 'fs';
import * as path from 'path';
import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateTaskAssignmentsAfterUpdateTrigger1765275524547
  implements MigrationInterface
{
  public async up(queryRunner: QueryRunner): Promise<void> {
    const triggerSQL = fs.readFileSync(
      path.join(
        __dirname,
        '../triggers/task-assignment-status-update.trigger.sql',
      ),
      'utf8',
    );

    await queryRunner.query(triggerSQL);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      DROP TRIGGER IF EXISTS task_assignment_after_update ON task_assignment;
      DROP FUNCTION IF EXISTS get_contextual_member_accumulated_points();
      DROP FUNCTION IF EXISTS check_task_assignment_status_change();
    `);
  }
}
