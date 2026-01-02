import { HttpStatus, Injectable } from '@nestjs/common';
import { Nullable } from 'src/common/types/nullable.type';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/api-http-exception.type';
import { WorkspaceObjectiveRequestQuery } from 'src/modules/workspace/workspace-module/dto/request/workspace-item-request.dto';
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
    const {
      data: goalEntities,
      totalPages,
      total,
    } = await this.goalRepository.findAllByWorkspaceId({
      workspaceId,
      query,
      relations: {
        assignee: {
          user: true,
        },
        createdBy: {
          user: true,
        },
      },
    });

    const goals: GoalWithAssigneeUserCore[] = [];

    for (const goal of goalEntities) {
      goals.push({
        id: goal.id,
        title: goal.title,
        description: goal.description,
        requiredPoints: goal.requiredPoints,
        status: goal.status,
        assignee: {
          id: goal.assignee.id, // Workspace user ID
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
      });
    }

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

    return {
      ...newGoal,
      createdBy:
        newGoal.createdBy === null
          ? null
          : {
              id: newGoal.createdBy.id, // Workspace user ID
              firstName: newGoal.createdBy.user.firstName,
              lastName: newGoal.createdBy.user.lastName,
              profileImageUrl: newGoal.createdBy.user.profileImageUrl,
            },
      assignee: {
        id: newGoal.assignee.id, // Workspace user ID
        firstName: newGoal.assignee.user.firstName,
        lastName: newGoal.assignee.user.lastName,
        profileImageUrl: newGoal.assignee.user.profileImageUrl,
      },
    };
  }

  async findById(id: Goal['id']): Promise<Nullable<GoalCore>> {
    return await this.goalRepository.findById({
      id,
    });
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
    data: Partial<
      Omit<Goal, 'assignee' | 'workspace' | 'createdBy'> & {
        status: ProgressStatus;
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
        status: data.status,
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
      throw new ApiHttpException(
        {
          code: ApiErrorCode.SERVER_ERROR,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    return {
      id: updatedGoal.id,
      title: updatedGoal.title,
      description: updatedGoal.description,
      requiredPoints: updatedGoal.requiredPoints,
      status: updatedGoal.status,
      assignee: {
        id: updatedGoal.assignee.id, // Workspace user ID
        firstName: updatedGoal.assignee.user.firstName,
        lastName: updatedGoal.assignee.user.lastName,
        profileImageUrl: updatedGoal.assignee.user.profileImageUrl,
      },
      createdBy:
        updatedGoal.createdBy === null
          ? null
          : {
              id: updatedGoal.createdBy.id, // Workspace user ID
              firstName: updatedGoal.createdBy.user.firstName,
              lastName: updatedGoal.createdBy.user.lastName,
              profileImageUrl: updatedGoal.createdBy.user.profileImageUrl,
            },
      createdAt: updatedGoal.createdAt,
      deletedAt: updatedGoal.deletedAt,
      updatedAt: updatedGoal.updatedAt,
    };
  }

  async closeByGoalIdAndWorkspaceId({
    goalId,
    workspaceId,
  }: {
    goalId: Goal['id'];
    workspaceId: Goal['workspace']['id'];
  }): Promise<void> {
    await this.updateByGoalIdAndWorkspaceId({
      goalId,
      workspaceId,
      data: {
        status: ProgressStatus.CLOSED,
      },
    });
  }
}
