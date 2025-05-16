import { HttpStatus, Injectable } from '@nestjs/common';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/ApiHttpException.type';
import { WorkspaceItemRequestQuery } from 'src/modules/workspace/workspace-module/dto/request/workspace-item-request.dto';
import { TaskAssignmentService } from '../task/task-assignment/task-assignment.service';
import { CreateGoalRequest } from '../workspace/workspace-module/dto/request/create-goal-request.dto';
import { GoalCore } from './domain/goal-core.domain';
import { GoalWithAssigneeCore } from './domain/goal-with-assignee-core.domain';
import { Goal } from './domain/goal.domain';
import { GoalRepository } from './persistence/goal.repository';

@Injectable()
export class GoalService {
  constructor(
    private readonly goalRepository: GoalRepository,
    private readonly taskAssignmentService: TaskAssignmentService,
  ) {}

  async findPaginatedByWorkspaceWithAssignee({
    workspaceId,
    query,
  }: {
    workspaceId: Goal['workspace']['id'];
    query: WorkspaceItemRequestQuery;
  }): Promise<{
    data: GoalWithAssigneeCore[];
    total: number;
  }> {
    const { data: goalEntities, total } =
      await this.goalRepository.findAllByWorkspaceId({
        workspaceId,
        query,
        relations: {
          assignee: {
            user: true,
          },
        },
      });

    const goals: GoalWithAssigneeCore[] = [];

    for (const goal of goalEntities) {
      const accumulatedPoints =
        await this.taskAssignmentService.getAccumulatedPointsForWorkspaceUser({
          workspaceUserId: goal.assignee.id,
          workspaceId,
        });

      goals.push({
        id: goal.id,
        title: goal.title,
        description: goal.description,
        requiredPoints: goal.requiredPoints,
        accumulatedPoints,
        status: goal.status,
        assignee: {
          id: goal.assignee.user.id,
          firstName: goal.assignee.user.firstName,
          lastName: goal.assignee.user.lastName,
          profileImageUrl: goal.assignee.user.profileImageUrl,
        },
        createdAt: goal.createdAt,
        deletedAt: goal.deletedAt,
        updatedAt: goal.updatedAt,
      });
    }

    return {
      data: goals,
      total: total,
    };
  }

  async create({
    workspaceId,
    createdById,
    data,
  }: {
    workspaceId: Goal['workspace']['id'];
    createdById: Goal['createdBy']['id'];
    data: CreateGoalRequest;
  }): Promise<GoalCore> {
    const newGoal = await this.goalRepository.create({
      workspaceId,
      data: {
        title: data.title,
        description: data.description,
        requiredPoints: data.requiredPoints,
        assigneeId: data.assignee,
      },
      createdById,
    });

    if (!newGoal) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.SERVER_ERROR,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    return newGoal;
  }
}
