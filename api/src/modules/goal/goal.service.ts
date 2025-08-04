import { HttpStatus, Injectable } from '@nestjs/common';
import { Nullable } from 'src/common/types/nullable.type';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/api-http-exception.type';
import { WorkspaceItemRequestQuery } from 'src/modules/workspace/workspace-module/dto/request/workspace-item-request.dto';
import { CreateGoalRequest } from '../workspace/workspace-module/dto/request/create-goal-request.dto';
import { UpdateGoalRequest } from '../workspace/workspace-module/dto/request/update-goal-request.dto';
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
    query: WorkspaceItemRequestQuery;
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
      assignee: {
        id: newGoal.assignee.id,
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
    data: UpdateGoalRequest;
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

    const newGoal = await this.goalRepository.update({
      id: goalId,
      data: {
        title: data.title,
        description: data.description,
        requiredPoints: data.requiredPoints,
        status: data.status,
        assigneeId: data.assigneeId,
      },
      relations: {
        assignee: {
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
      id: newGoal.id,
      title: newGoal.title,
      description: newGoal.description,
      requiredPoints: newGoal.requiredPoints,
      status: newGoal.status,
      assignee: {
        id: newGoal.assignee.user.id,
        firstName: newGoal.assignee.user.firstName,
        lastName: newGoal.assignee.user.lastName,
        profileImageUrl: newGoal.assignee.user.profileImageUrl,
      },
      createdAt: newGoal.createdAt,
      deletedAt: newGoal.deletedAt,
      updatedAt: newGoal.updatedAt,
    };
  }
}
