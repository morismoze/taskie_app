import { HttpStatus, Injectable } from '@nestjs/common';
import { Nullable } from 'src/common/types/nullable.type';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/api-http-exception.type';
import {
  SortBy,
  WORKSPACE_OBJECTIVE_DEFAULT_QUERY_LIMIT,
  WorkspaceObjectiveRequestQuery,
} from 'src/modules/workspace/workspace-module/dto/request/workspace-objective-request-query.dto';
import { ProgressStatus } from '../task/task-module/domain/progress-status.enum';
import { CreateGoalRequest } from '../workspace/workspace-module/dto/request/create-goal-request.dto';
import { WorkspaceUser } from '../workspace/workspace-user-module/domain/workspace-user.domain';
import { GoalCore } from './domain/goal-core.domain';
import { GoalWithAssigneeUserCore } from './domain/goal-with-assignee-user-core.domain';
import { Goal } from './domain/goal.domain';
import { GoalRepository } from './persistence/goal.repository';

@Injectable()
export class GoalService {
  constructor(private readonly goalRepository: GoalRepository) {}

  async findPaginatedByWorkspaceWithAssignee({
    workspaceId,
    query,
  }: {
    workspaceId: Goal['workspace']['id'];
    query: WorkspaceObjectiveRequestQuery;
  }): Promise<{
    data: GoalWithAssigneeUserCore[];
    totalPages: number;
    total: number;
  }> {
    const effectiveQuery = {
      page: query.page ?? 1,
      limit: query.limit ?? WORKSPACE_OBJECTIVE_DEFAULT_QUERY_LIMIT,
      status: query.status ?? null,
      search: query.search?.trim() || null,
      sort: query.sort ?? SortBy.NEWEST,
    };
    const {
      data: goalEntities,
      totalPages,
      total,
    } = await this.goalRepository.findAllByWorkspaceId({
      workspaceId,
      query: effectiveQuery,
      relations: {
        assignee: {
          user: true,
        },
        createdBy: {
          user: true,
        },
      },
    });

    const goals = goalEntities.map(this.toGoalWithAssigneeUserCore);

    return {
      data: goals,
      totalPages,
      total,
    };
  }

  async create({
    workspaceId,
    createdById,
    data,
  }: {
    workspaceId: Goal['workspace']['id'];
    createdById: WorkspaceUser['id'];
    data: CreateGoalRequest;
  }): Promise<GoalWithAssigneeUserCore> {
    const newGoal = await this.goalRepository.create({
      workspaceId,
      data: {
        title: data.title,
        description: data.description || null,
        requiredPoints: data.requiredPoints,
        assigneeId: data.assignee,
      },
      createdById,
      relations: {
        assignee: {
          user: true,
        },
        createdBy: {
          user: true,
        },
      },
    });

    if (!newGoal) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.SERVER_ERROR,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    return this.toGoalWithAssigneeUserCore(newGoal);
  }

  async findByGoalIdAndWorkspaceId({
    goalId,
    workspaceId,
  }: {
    goalId: Goal['id'];
    workspaceId: Goal['workspace']['id'];
  }): Promise<Nullable<GoalCore>> {
    return await this.goalRepository.findByGoalIdAndWorkspaceId({
      goalId,
      workspaceId,
    });
  }

  async updateByGoalIdAndWorkspaceId({
    goalId,
    workspaceId,
    data,
  }: {
    goalId: Goal['id'];
    workspaceId: Goal['workspace']['id'];
    // Status is updated by the user only in the case of closing the goal
    // using the method closeByGoalIdAndWorkspaceId. Other updates:
    // IN_PROGRESS => COMPLETED or vice versa are done automatically
    // through the DB trigger once the user completes enough tasks
    // and earns enough reward points or get its reward points
    // decreased if it is removed from a task assignment or
    // gets its status on the assignment to another status from
    // COMPLETED.
    data: Partial<
      Omit<Goal, 'assignee' | 'status' | 'workspace' | 'createdBy'> & {
        assigneeId: Goal['assignee']['id'];
      }
    >;
  }): Promise<GoalWithAssigneeUserCore> {
    const goal = await this.findByGoalIdAndWorkspaceId({ goalId, workspaceId });

    if (!goal) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    // Closed goals can't be updated
    if (goal.status === ProgressStatus.CLOSED) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.GOAL_CLOSED,
        },
        HttpStatus.UNPROCESSABLE_ENTITY,
      );
    }

    const updatedGoal = await this.goalRepository.update({
      id: goalId,
      data: {
        title: data.title,
        description: data.description,
        requiredPoints: data.requiredPoints,
        assigneeId: data.assigneeId,
      },
      relations: {
        assignee: {
          user: true,
        },
        createdBy: {
          user: true,
        },
      },
    });

    if (!updatedGoal) {
      // Somebody deleted the goal in the meantime.
      // Currently there is no way to delete a goal,
      // so this is just a sanity check.
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    return this.toGoalWithAssigneeUserCore(updatedGoal);
  }

  async closeByGoalIdAndWorkspaceId({
    goalId,
    workspaceId,
  }: {
    goalId: Goal['id'];
    workspaceId: Goal['workspace']['id'];
  }): Promise<void> {
    // Verify tenancy (ensure goal belongs to this workspace) and enable idempotent early exit
    const goal = await this.findByGoalIdAndWorkspaceId({ goalId, workspaceId });

    if (!goal) {
      throw new ApiHttpException(
        { code: ApiErrorCode.INVALID_PAYLOAD },
        HttpStatus.NOT_FOUND,
      );
    }

    if (goal.status === ProgressStatus.CLOSED) {
      // Early return - idempotency
      return;
    }

    const updatedGoal = await this.goalRepository.update({
      id: goalId,
      data: {
        status: ProgressStatus.CLOSED,
      },
    });

    if (!updatedGoal) {
      // Somebody deleted the goal in the meantime.
      // Currently there is no way to delete a goal,
      // so this is just a sanity check.
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }
  }

  private toGoalWithAssigneeUserCore(goal: any): GoalWithAssigneeUserCore {
    return {
      id: goal.id,
      title: goal.title,
      description: goal.description,
      requiredPoints: goal.requiredPoints,
      status: goal.status,
      assignee: {
        id: goal.assignee.id,
        firstName: goal.assignee.user.firstName,
        lastName: goal.assignee.user.lastName,
        profileImageUrl: goal.assignee.user.profileImageUrl,
      },
      createdBy:
        goal.createdBy === null
          ? null
          : {
              id: goal.createdBy.id,
              firstName: goal.createdBy.user.firstName,
              lastName: goal.createdBy.user.lastName,
              profileImageUrl: goal.createdBy.user.profileImageUrl,
            },
      createdAt: goal.createdAt,
      deletedAt: goal.deletedAt,
      updatedAt: goal.updatedAt,
    };
  }
}
