import { HttpStatus, Injectable } from '@nestjs/common';
import { DateTime } from 'luxon';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/api-http-exception.type';
import { JwtPayload } from 'src/modules/auth/core/strategies/jwt-payload.type';
import { Goal } from 'src/modules/goal/domain/goal.domain';
import { GoalService } from 'src/modules/goal/goal.service';
import { TaskAssignmentService } from 'src/modules/task/task-assignment/task-assignment.service';
import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';
import { Task } from 'src/modules/task/task-module/domain/task.domain';
import { TaskService } from 'src/modules/task/task-module/task.service';
import { UnitOfWorkService } from 'src/modules/unit-of-work/unit-of-work.service';
import { UserStatus } from 'src/modules/user/domain/user-status.enum';
import { UserService } from 'src/modules/user/user.service';
import { WorkspaceInvite } from '../workspace-invite/domain/workspace-invite.domain';
import { WorkspaceInviteService } from '../workspace-invite/workspace-invite.service';
import { WorkspaceUserCore } from '../workspace-user-module/domain/workspace-user-core.domain';
import { WorkspaceUserRole } from '../workspace-user-module/domain/workspace-user-role.enum';
import { WorkspaceUserStatus } from '../workspace-user-module/domain/workspace-user-status.enum';
import { WorkspaceUser } from '../workspace-user-module/domain/workspace-user.domain';
import { WorkspaceUserService } from '../workspace-user-module/workspace-user.service';
import { Workspace } from './domain/workspace.domain';
import { AddTaskAssigneeRequest } from './dto/request/add-task-assignee-request.dto';
import { CreateGoalRequest } from './dto/request/create-goal-request.dto';
import { CreateTaskRequest } from './dto/request/create-task-request.dto';
import { CreateVirtualWorkspaceUserRequest } from './dto/request/create-virtual-workspace-user-request.dto';
import { CreateWorkspaceRequest } from './dto/request/create-workspace-request.dto';
import { RemoveTaskAssigneeRequest } from './dto/request/remove-task-assignee-request.dto';
import { UpdateGoalRequest } from './dto/request/update-goal-request.dto';
import { UpdateTaskAssignmentsRequest } from './dto/request/update-task-assignment-request.dto';
import { UpdateTaskRequest } from './dto/request/update-task-request.dto';
import { UpdateWorkspaceRequest } from './dto/request/update-workspace-request.dto';
import { UpdateWorkspaceUserRequest } from './dto/request/update-workspace-user-request.dto';
import { WorkspaceObjectiveRequestQuery } from './dto/request/workspace-item-request.dto';
import { AddTaskAssigneeResponse } from './dto/response/add-task-assignee-response.dto';
import { CreateWorkspaceInviteTokenResponse } from './dto/response/create-workspace-invite-token-response.dto';
import { UpdateTaskAssignmentsStatusesResponse } from './dto/response/update-task-assignments-statuses-response.dto';
import {
  WorkspaceGoalResponse,
  WorkspaceGoalsResponse,
} from './dto/response/workspace-goals-response.dto';
import { WorkspaceLeaderboardResponse } from './dto/response/workspace-leaderboard-response.dto';
import {
  WorkspaceTaskResponse,
  WorkspaceTasksResponse,
} from './dto/response/workspace-tasks-response.dto';
import { WorkspaceUserAccumulatedPointsResponse } from './dto/response/workspace-user-accumulated-points-response.dto';
import {
  WorkspaceUserResponse,
  WorkspaceUsersResponse,
} from './dto/response/workspace-users-response.dto';
import {
  WorkspaceResponse,
  WorkspacesResponse,
} from './dto/response/workspaces-response.dto';
import { WorkspaceRepository } from './persistence/workspace.repository';

@Injectable()
export class WorkspaceService {
  constructor(
    private readonly workspaceRepository: WorkspaceRepository,
    private readonly workspaceUserService: WorkspaceUserService,
    private readonly userService: UserService,
    private readonly taskService: TaskService,
    private readonly goalService: GoalService,
    private readonly taskAssignmentService: TaskAssignmentService,
    private readonly workspaceInviteService: WorkspaceInviteService,
    private readonly unitOfWorkService: UnitOfWorkService,
  ) {}

  async create({
    data,
    createdById,
  }: {
    createdById: JwtPayload['sub'];
    data: CreateWorkspaceRequest;
  }): Promise<WorkspaceResponse> {
    const { newWorkspace } = await this.unitOfWorkService.withTransaction(
      async () => {
        // 1. create a new empty workspace
        const newWorkspace = await this.workspaceRepository.create({
          data: {
            description: data.description,
            name: data.name,
            pictureUrl: null,
          },
          createdById,
          relations: {
            createdBy: true,
          },
        });

        if (!newWorkspace) {
          throw new ApiHttpException(
            {
              code: ApiErrorCode.SERVER_ERROR,
            },
            HttpStatus.INTERNAL_SERVER_ERROR,
          );
        }

        // 2. create a new workspace user for the owner
        await this.workspaceUserService.create({
          workspaceId: newWorkspace.id,
          userId: createdById,
          createdById: null,
          workspaceRole: WorkspaceUserRole.MANAGER,
          status: WorkspaceUserStatus.ACTIVE,
        });

        return { newWorkspace };
      },
    );

    const response: WorkspaceResponse = {
      id: newWorkspace.id,
      name: newWorkspace.name,
      description: newWorkspace.description,
      pictureUrl: newWorkspace.pictureUrl,
      createdAt: DateTime.fromJSDate(newWorkspace.createdAt).toISO()!,
      createdBy:
        newWorkspace.createdBy === null
          ? null
          : {
              id: newWorkspace.createdBy.id,
              firstName: newWorkspace.createdBy.firstName,
              lastName: newWorkspace.createdBy.lastName,
              profileImageUrl: newWorkspace.createdBy.profileImageUrl,
            },
    };

    return response;
  }

  async updateWorkspace({
    workspaceId,
    data,
  }: {
    workspaceId: Workspace['id'];
    data: UpdateWorkspaceRequest;
  }): Promise<WorkspaceResponse> {
    const workspace = await this.workspaceRepository.findById({
      id: workspaceId,
      relations: {
        members: {
          user: true,
        },
      },
    });

    if (!workspace) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    const updatedWorkspace = await this.workspaceRepository.update({
      id: workspaceId,
      data,
      relations: {
        createdBy: true,
      },
    });

    if (!updatedWorkspace) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.SERVER_ERROR,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    const response: WorkspaceResponse = {
      id: updatedWorkspace.id,
      name: updatedWorkspace.name,
      description: updatedWorkspace.description,
      pictureUrl: updatedWorkspace.pictureUrl,
      createdAt: DateTime.fromJSDate(updatedWorkspace.createdAt).toISO()!,
      createdBy:
        updatedWorkspace.createdBy === null
          ? null
          : {
              id: updatedWorkspace.createdBy.id,
              firstName: updatedWorkspace.createdBy.firstName,
              lastName: updatedWorkspace.createdBy.lastName,
              profileImageUrl: updatedWorkspace.createdBy.profileImageUrl,
            },
    };

    return response;
  }

  async createInviteToken({
    workspaceId,
    createdById,
  }: {
    workspaceId: Workspace['id'];
    createdById: JwtPayload['sub'];
  }): Promise<CreateWorkspaceInviteTokenResponse> {
    // Check if workspace exists
    const workspace = await this.workspaceRepository.findById({
      id: workspaceId,
      relations: {
        members: {
          user: true,
        },
      },
    });

    if (!workspace) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    const invite = await this.workspaceInviteService.createInviteToken({
      workspaceId,
      createdById,
    });

    const response: CreateWorkspaceInviteTokenResponse = {
      token: invite.token,
      expiresAt: DateTime.fromJSDate(invite.expiresAt).toISO()!,
    };

    return response;
  }

  async getWorkspaceInfoByWorkspaceInviteToken(
    inviteToken: WorkspaceInvite['token'],
  ): Promise<WorkspaceResponse> {
    // Check if workspace invite exists
    const workspaceInvite =
      await this.workspaceInviteService.findByTokenWithWorkspace(inviteToken);

    if (!workspaceInvite) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    const response: WorkspaceResponse = {
      id: workspaceInvite.workspace.id,
      name: workspaceInvite.workspace.name,
      description: workspaceInvite.workspace.description,
      pictureUrl: workspaceInvite.workspace.pictureUrl,
      createdAt: DateTime.fromJSDate(workspaceInvite.createdAt).toISO()!,
      createdBy:
        workspaceInvite.workspace.createdBy === null
          ? null
          : {
              id: workspaceInvite.workspace.createdBy.id,
              firstName: workspaceInvite.workspace.createdBy.firstName,
              lastName: workspaceInvite.workspace.createdBy.lastName,
              profileImageUrl:
                workspaceInvite.workspace.createdBy.profileImageUrl,
            },
    };

    return response;
  }

  async joinWorkspace({
    inviteToken,
    usedById,
  }: {
    inviteToken: WorkspaceInvite['token'];
    usedById: JwtPayload['sub'];
  }): Promise<WorkspaceResponse> {
    const updatedWorkspaceInvite =
      await this.workspaceInviteService.claimInvite({
        token: inviteToken,
        usedById,
      });

    const response: WorkspaceResponse = {
      id: updatedWorkspaceInvite.workspace.id,
      name: updatedWorkspaceInvite.workspace.name,
      description: updatedWorkspaceInvite.workspace.description,
      pictureUrl: updatedWorkspaceInvite.workspace.pictureUrl,
      createdAt: DateTime.fromJSDate(updatedWorkspaceInvite.createdAt).toISO()!,
      createdBy:
        updatedWorkspaceInvite.workspace.createdBy === null
          ? null
          : {
              id: updatedWorkspaceInvite.workspace.createdBy.id,
              firstName: updatedWorkspaceInvite.workspace.createdBy.firstName,
              lastName: updatedWorkspaceInvite.workspace.createdBy.lastName,
              profileImageUrl:
                updatedWorkspaceInvite.workspace.createdBy.profileImageUrl,
            },
    };

    return response;
  }

  async createVirtualUser({
    workspaceId,
    createdById,
    data,
  }: {
    workspaceId: Workspace['id'];
    createdById: JwtPayload['sub'];
    data: CreateVirtualWorkspaceUserRequest;
  }): Promise<WorkspaceUserResponse> {
    const workspace = await this.workspaceRepository.findById({
      id: workspaceId,
      relations: {
        members: {
          user: true,
        },
      },
    });

    if (!workspace) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    // Using assertion because workspace user should be always found based on how JWT works (custom secret)
    const creatorWorkspaceUser =
      (await this.workspaceUserService.findByUserIdAndWorkspaceId({
        userId: createdById,
        workspaceId,
      })) as WorkspaceUserCore;

    const { newUser, newWorkspaceUser } =
      await this.unitOfWorkService.withTransaction(async () => {
        // 1. Create core user
        const newUser = await this.userService.createVirtualUser({
          firstName: data.firstName,
          lastName: data.lastName,
          status: UserStatus.ACTIVE,
        });

        // 2. Create a workspace user relation linking the user to the workspace
        const newWorkspaceUser = await this.workspaceUserService.create({
          workspaceId: workspace.id,
          userId: newUser.id,
          createdById: creatorWorkspaceUser.id,
          workspaceRole: WorkspaceUserRole.MEMBER,
          status: WorkspaceUserStatus.ACTIVE,
        });

        return { newUser, newWorkspaceUser };
      });

    const response: WorkspaceUserResponse = {
      id: newWorkspaceUser.id,
      firstName: newUser.firstName,
      lastName: newUser.lastName,
      email: null,
      // Currently uploading images while creating virtual users is not supported
      profileImageUrl: null,
      role: newWorkspaceUser.workspaceRole,
      userId: newUser.id,
      createdBy:
        newWorkspaceUser.createdBy === null
          ? null
          : {
              id: newWorkspaceUser.createdBy.id,
              firstName: newWorkspaceUser.createdBy.firstName,
              lastName: newWorkspaceUser.createdBy.lastName,
              profileImageUrl: newWorkspaceUser.createdBy.profileImageUrl,
            },
      createdAt: DateTime.fromJSDate(newWorkspaceUser.createdAt).toISO()!,
    };

    return response;
  }

  async getWorkspacesByUser(
    userId: JwtPayload['sub'],
  ): Promise<WorkspacesResponse> {
    const userWorkspaces = await this.workspaceRepository.findAllByUserId({
      userId,
      relations: {
        createdBy: true,
      },
    });

    const response: WorkspacesResponse = userWorkspaces.map((workspace) => ({
      id: workspace.id,
      name: workspace.name,
      description: workspace.description,
      pictureUrl: workspace.pictureUrl,
      createdAt: DateTime.fromJSDate(workspace.createdAt).toISO()!,
      createdBy:
        workspace.createdBy === null
          ? null
          : {
              id: workspace.createdBy.id,
              firstName: workspace.createdBy.firstName,
              lastName: workspace.createdBy.lastName,
              profileImageUrl: workspace.createdBy.profileImageUrl,
            },
    }));

    return response;
  }

  async getWorkspaceUsers(
    workspaceId: Workspace['id'],
  ): Promise<WorkspaceUsersResponse> {
    const workspace = await this.workspaceRepository.findById({
      id: workspaceId,
      relations: {
        members: {
          user: true,
          createdBy: {
            user: true,
          },
        },
      },
    });

    if (!workspace) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    const response: WorkspaceUsersResponse = workspace.members
      .map((member) => ({
        id: member.id,
        firstName: member.user.firstName,
        lastName: member.user.lastName,
        email: member.user.email,
        profileImageUrl: member.user.profileImageUrl,
        role: member.workspaceRole,
        userId: member.user.id,
        createdBy:
          member.createdBy === null
            ? null
            : {
                id: member.createdBy.id,
                firstName: member.createdBy.user.firstName,
                lastName: member.createdBy.user.lastName,
                profileImageUrl: member.createdBy.user.profileImageUrl,
              },
        createdAt: DateTime.fromJSDate(member.createdAt).toISO()!,
      }))
      .sort((wu1, wu2) => {
        // Sort by full name
        const wu1FullName = `${wu1.firstName + wu1.lastName}`;
        const wu2FullName = `${wu2.firstName + wu2.lastName}`;

        if (wu1FullName > wu2FullName) {
          return 1;
        } else if (wu1FullName < wu2FullName) {
          return -1;
        } else {
          return 0;
        }
      });

    return response;
  }

  async getWorkspaceTasks({
    workspaceId,
    query,
  }: {
    workspaceId: Workspace['id'];
    query: WorkspaceObjectiveRequestQuery;
  }): Promise<WorkspaceTasksResponse> {
    const workspace = await this.workspaceRepository.findById({
      id: workspaceId,
    });

    if (!workspace) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    // This is open to change - we could firstly fetch just plain concrete tasks
    // by given workspaceId via the task service function and then for each task fetch its
    // task assignments via the task assignment service function (this would actually be done
    // with only one DB query - where: { task: { id: In(taskIds) } }) - this is something I'm not
    // sure about, because I'm weighing *one more complex query, meaning less DB queries* vs *two
    // simple queries, from different service functions for SRP (single responsiblity principle)
    const {
      data: tasks,
      totalPages,
      total,
    } = await this.taskService.findPaginatedByWorkspaceWithAssignees({
      workspaceId,
      query,
    });

    const response: WorkspaceTasksResponse = {
      items: tasks.map((task) => ({
        id: task.id,
        title: task.title,
        description: task.description,
        dueDate:
          task.dueDate === null
            ? null
            : DateTime.fromJSDate(task.dueDate).toISO()!,
        rewardPoints: task.rewardPoints,
        assignees: task.assignees.map((assignee) => ({
          id: assignee.id,
          firstName: assignee.firstName,
          lastName: assignee.lastName,
          profileImageUrl: assignee.profileImageUrl,
          status: assignee.status,
        })),
        createdBy:
          task.createdBy === null
            ? null
            : {
                id: task.createdBy.id,
                firstName: task.createdBy.firstName,
                lastName: task.createdBy.lastName,
                profileImageUrl: task.createdBy.profileImageUrl,
              },
        createdAt: DateTime.fromJSDate(task.createdAt).toISO()!,
      })),
      totalPages,
      total,
    };

    return response;
  }

  async createTask({
    workspaceId,
    createdById,
    data,
  }: {
    workspaceId: Workspace['id'];
    createdById: JwtPayload['sub'];
    data: CreateTaskRequest;
  }): Promise<WorkspaceTaskResponse> {
    const workspace = await this.workspaceRepository.findById({
      id: workspaceId,
    });

    if (!workspace) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    const createdByWorkspaceUser =
      await this.workspaceUserService.findByUserIdAndWorkspaceId({
        userId: createdById,
        workspaceId,
      });

    if (!createdByWorkspaceUser) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    return await this.unitOfWorkService.withTransaction(async () => {
      // Create new concrete task
      const newTask = await this.taskService.create({
        workspaceId,
        createdById: createdByWorkspaceUser.id,
        data,
      });

      let response: WorkspaceTaskResponse = {
        ...newTask,
        dueDate:
          newTask.dueDate === null
            ? null
            : DateTime.fromJSDate(newTask.dueDate).toISO()!,
        assignees: [], // This is filled in the code below
        createdBy:
          newTask.createdBy === null
            ? null
            : {
                id: newTask.createdBy.id,
                firstName: newTask.createdBy.firstName,
                lastName: newTask.createdBy.lastName,
                profileImageUrl: newTask.createdBy.profileImageUrl,
              },
        createdAt: DateTime.fromJSDate(newTask.createdAt).toISO()!,
      };

      // Create new task assignment for each given assignee
      for (const assigneeId of data.assignees) {
        const newTaskAssignment = await this.taskAssignmentService.create({
          workspaceUserId: assigneeId,
          taskId: newTask.id,
          status: ProgressStatus.IN_PROGRESS,
        });
        response.assignees.push({
          id: newTaskAssignment.assignee.id,
          firstName: newTaskAssignment.assignee.user.firstName,
          lastName: newTaskAssignment.assignee.user.lastName,
          status: newTaskAssignment.status,
          profileImageUrl: newTaskAssignment.assignee.user.profileImageUrl,
        });
      }

      return response;
    });
  }

  async createGoal({
    workspaceId,
    createdById,
    data,
  }: {
    workspaceId: Workspace['id'];
    createdById: JwtPayload['sub'];
    data: CreateGoalRequest;
  }): Promise<WorkspaceGoalResponse> {
    const workspace = await this.workspaceRepository.findById({
      id: workspaceId,
    });

    if (!workspace) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    const createdByWorkspaceUser =
      await this.workspaceUserService.findByUserIdAndWorkspaceId({
        userId: createdById,
        workspaceId,
      });

    if (!createdByWorkspaceUser) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    // We firstly need to check if the provided required points is
    // greater than workspace user's current accumulated points
    const workspaceUserAccumulatedPoints =
      await this.workspaceUserService.getWorkspaceUserAccumulatedPoints({
        workspaceId,
        workspaceUserId: data.assignee,
      });

    // getWorkspaceUserAccumulatedPoints will also in the SQL query check if
    // the provided workspace user ID exists
    if (workspaceUserAccumulatedPoints == null) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    if (data.requiredPoints <= workspaceUserAccumulatedPoints) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.UNPROCESSABLE_ENTITY,
      );
    }

    const newGoal = await this.goalService.create({
      workspaceId,
      createdById: createdByWorkspaceUser.id,
      data,
    });

    const response: WorkspaceGoalResponse = {
      id: newGoal.id,
      title: newGoal.title,
      description: newGoal.description,
      requiredPoints: newGoal.requiredPoints,
      accumulatedPoints: workspaceUserAccumulatedPoints,
      assignee: {
        id: newGoal.assignee.id,
        firstName: newGoal.assignee.firstName,
        lastName: newGoal.assignee.lastName,
        profileImageUrl: newGoal.assignee.profileImageUrl,
      },
      status: newGoal.status,
      createdBy:
        newGoal.createdBy === null
          ? null
          : {
              id: newGoal.createdBy.id,
              firstName: newGoal.createdBy.firstName,
              lastName: newGoal.createdBy.lastName,
              profileImageUrl: newGoal.createdBy.profileImageUrl,
            },
      createdAt: DateTime.fromJSDate(newGoal.createdAt).toISO()!,
    };

    return response;
  }

  async getWorkspaceGoals({
    workspaceId,
    query,
  }: {
    workspaceId: Workspace['id'];
    query: WorkspaceObjectiveRequestQuery;
  }): Promise<WorkspaceGoalsResponse> {
    const workspace = await this.workspaceRepository.findById({
      id: workspaceId,
    });

    if (!workspace) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    const {
      data: goals,
      totalPages,
      total,
    } = await this.goalService.findPaginatedByWorkspaceWithAssignee({
      workspaceId,
      query,
    });

    const responseData: WorkspaceGoalsResponse['items'] = [];

    for (const goal of goals) {
      const accumulatedPoints =
        await this.taskAssignmentService.getAccumulatedPointsForWorkspaceUser({
          workspaceUserId: goal.assignee.id,
          workspaceId,
        });
      responseData.push({
        id: goal.id,
        assignee: {
          id: goal.assignee.id,
          firstName: goal.assignee.firstName,
          lastName: goal.assignee.lastName,
          profileImageUrl: goal.assignee.profileImageUrl,
        },
        title: goal.title,
        description: goal.description,
        requiredPoints: goal.requiredPoints,
        status: goal.status,
        accumulatedPoints,
        createdBy:
          goal.createdBy === null
            ? null
            : {
                id: goal.createdBy.id,
                firstName: goal.createdBy.firstName,
                lastName: goal.createdBy.lastName,
                profileImageUrl: goal.createdBy.profileImageUrl,
              },
        createdAt: DateTime.fromJSDate(goal.createdAt).toISO()!,
      });
    }

    const response: WorkspaceGoalsResponse = {
      items: responseData,
      totalPages,
      total,
    };

    return response;
  }

  async updateGoal({
    workspaceId,
    goalId,
    payload,
  }: {
    workspaceId: Workspace['id'];
    goalId: Goal['id'];
    payload: UpdateGoalRequest;
  }): Promise<WorkspaceGoalResponse> {
    const workspace = await this.workspaceRepository.findById({
      id: workspaceId,
    });

    if (!workspace) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    if (payload.assigneeId) {
      // We need to check if provided assignee ID exists as a workspace user
      const workspaceUser = this.workspaceUserService.findById(
        payload.assigneeId,
      );

      if (!workspaceUser) {
        throw new ApiHttpException(
          {
            code: ApiErrorCode.INVALID_PAYLOAD,
          },
          HttpStatus.NOT_FOUND,
        );
      }
    }

    const updatedGoal = await this.goalService.updateByGoalIdAndWorkspaceId({
      goalId,
      workspaceId,
      data: payload,
    });

    const accumulatedPoints =
      await this.taskAssignmentService.getAccumulatedPointsForWorkspaceUser({
        workspaceUserId: updatedGoal.assignee.id,
        workspaceId,
      });

    const response: WorkspaceGoalResponse = {
      id: updatedGoal.id,
      title: updatedGoal.title,
      description: updatedGoal.description,
      requiredPoints: updatedGoal.requiredPoints,
      assignee: {
        id: updatedGoal.assignee.id,
        firstName: updatedGoal.assignee.firstName,
        lastName: updatedGoal.assignee.lastName,
        profileImageUrl: updatedGoal.assignee.profileImageUrl,
      },
      status: updatedGoal.status,
      accumulatedPoints,
      createdBy:
        updatedGoal.createdBy === null
          ? null
          : {
              id: updatedGoal.createdBy.id,
              firstName: updatedGoal.createdBy.firstName,
              lastName: updatedGoal.createdBy.lastName,
              profileImageUrl: updatedGoal.createdBy.profileImageUrl,
            },
      createdAt: DateTime.fromJSDate(updatedGoal.createdAt).toISO()!,
    };

    return response;
  }

  async closeGoal({
    workspaceId,
    goalId,
  }: {
    workspaceId: Workspace['id'];
    goalId: Goal['id'];
  }): Promise<void> {
    // Closed goal can't be updated
    await this.goalService.closeByGoalIdAndWorkspaceId({
      goalId,
      workspaceId,
    });
  }

  async getWorkspaceUserAccumulatedPoints({
    workspaceId,
    workspaceUserId,
  }: {
    workspaceId: WorkspaceUser['workspace']['id'];
    workspaceUserId: WorkspaceUser['id'];
  }): Promise<WorkspaceUserAccumulatedPointsResponse> {
    const accumulatedPoints =
      await this.workspaceUserService.getWorkspaceUserAccumulatedPoints({
        workspaceId,
        workspaceUserId,
      });

    // getWorkspaceUserAccumulatedPoints will check in the SQL query if
    // the provided workspace user ID exists together with the workspace ID
    if (accumulatedPoints == null) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    return {
      accumulatedPoints: accumulatedPoints,
    };
  }

  async getWorkspaceLeaderboard(
    workspaceId: Workspace['id'],
  ): Promise<WorkspaceLeaderboardResponse> {
    const workspace = await this.workspaceRepository.findById({
      id: workspaceId,
    });

    if (!workspace) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    const leaderboardData =
      await this.workspaceUserService.getLeaderboardData(workspaceId);

    return leaderboardData;
  }

  async updateWorkspaceUser({
    workspaceId,
    workspaceUserId,
    data,
  }: {
    workspaceId: Workspace['id'];
    workspaceUserId: WorkspaceUser['id'];
    data: UpdateWorkspaceUserRequest;
  }): Promise<WorkspaceUserResponse> {
    const workspace = await this.workspaceRepository.findById({
      id: workspaceId,
    });

    if (!workspace) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    const { updatedWorkspaceUserId } =
      await this.unitOfWorkService.withTransaction(async () => {
        const updatedWorkspaceUser = await this.workspaceUserService.update({
          id: workspaceUserId,
          data: {
            workspaceRole: data.role,
          },
        });

        if (data.firstName || data.lastName) {
          await this.userService.update({
            id: updatedWorkspaceUser.user.id,
            data: {
              firstName: data.firstName,
              lastName: data.lastName,
            },
          });
        }

        return { updatedWorkspaceUserId: updatedWorkspaceUser.id };
      });

    // This is freshly updated workspace user because former code is
    // executed inside a transaction, so doing this find inside would result
    // in not updated workspace user.
    const updatedWorkspaceUser =
      await this.workspaceUserService.findByIdWithUserAndCreatedByUser(
        updatedWorkspaceUserId,
      );

    if (updatedWorkspaceUser == null) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.SERVER_ERROR,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    const response: WorkspaceUserResponse = {
      id: updatedWorkspaceUser.id,
      firstName: updatedWorkspaceUser.user.firstName,
      lastName: updatedWorkspaceUser.user.lastName,
      email: updatedWorkspaceUser.user.email,
      profileImageUrl: updatedWorkspaceUser.user.profileImageUrl,
      role: updatedWorkspaceUser.workspaceRole,
      userId: updatedWorkspaceUser.user.id,
      createdAt: DateTime.fromJSDate(updatedWorkspaceUser.createdAt).toISO()!,
      createdBy:
        updatedWorkspaceUser.createdBy === null
          ? null
          : {
              id: updatedWorkspaceUser.createdBy.id,
              firstName: updatedWorkspaceUser.createdBy.firstName,
              lastName: updatedWorkspaceUser.createdBy.lastName,
              profileImageUrl: updatedWorkspaceUser.createdBy.profileImageUrl,
            },
    };

    return response;
  }

  async getWorkspaceUserAdditionalDetails({
    workspaceId,
    workspaceUserId,
  }: {
    workspaceId: Workspace['id'];
    workspaceUserId: WorkspaceUser['id'];
  }): Promise<void> {
    const workspace = await this.workspaceRepository.findById({
      id: workspaceId,
    });

    if (!workspace) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    await this.workspaceUserService.delete({
      workspaceId,
      workspaceUserId,
    });
  }

  async removeUserFromWorkspace({
    workspaceId,
    workspaceUserId,
  }: {
    workspaceId: Workspace['id'];
    workspaceUserId: WorkspaceUser['id'];
  }): Promise<void> {
    const workspace = await this.workspaceRepository.findById({
      id: workspaceId,
    });

    if (!workspace) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    await this.workspaceUserService.delete({
      workspaceId,
      workspaceUserId,
    });
  }

  async leaveWorkspace({
    workspaceId,
    userId,
  }: {
    workspaceId: Workspace['id'];
    userId: JwtPayload['sub'];
  }): Promise<void> {
    const workspaceUser =
      await this.workspaceUserService.findByUserIdAndWorkspaceId({
        workspaceId,
        userId,
      });

    if (!workspaceUser) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    await this.workspaceUserService.delete({
      workspaceId,
      workspaceUserId: workspaceUser.id,
    });
  }

  async updateTask({
    workspaceId,
    taskId,
    payload,
  }: {
    workspaceId: Workspace['id'];
    taskId: Task['id'];
    payload: UpdateTaskRequest;
  }): Promise<WorkspaceTaskResponse> {
    const workspace = await this.workspaceRepository.findById({
      id: workspaceId,
    });

    if (!workspace) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    // Closed task can't be updated
    await this.checkTaskIsClosed(taskId);

    // This method internally checks if task exists for taskId/workspaceId combo
    const updatedTask = await this.taskService.updateByTaskIdAndWorkspaceId({
      taskId,
      workspaceId,
      data: {
        title: payload.title,
        description: payload.description,
        rewardPoints: payload.rewardPoints,
        dueDate: payload.dueDate,
      },
    });

    const response: WorkspaceTaskResponse = {
      id: updatedTask.id,
      title: updatedTask.title,
      rewardPoints: updatedTask.rewardPoints,
      description: updatedTask.description,
      dueDate:
        updatedTask.dueDate === null
          ? null
          : DateTime.fromJSDate(updatedTask.dueDate).toISO()!,
      assignees: updatedTask.assignees.map((assignee) => ({
        id: assignee.id,
        firstName: assignee.firstName,
        lastName: assignee.lastName,
        profileImageUrl: assignee.profileImageUrl,
        status: assignee.status,
      })),
      createdBy:
        updatedTask.createdBy === null
          ? null
          : {
              id: updatedTask.createdBy.id,
              firstName: updatedTask.createdBy.firstName,
              lastName: updatedTask.createdBy.lastName,
              profileImageUrl: updatedTask.createdBy.profileImageUrl,
            },
      createdAt: DateTime.fromJSDate(updatedTask.createdAt).toISO()!,
    };

    return response;
  }

  async closeTask({
    workspaceId,
    taskId,
  }: {
    workspaceId: Workspace['id'];
    taskId: Task['id'];
  }): Promise<void> {
    const task = await this.taskService.findByTaskIdAndWorkspaceId({
      taskId,
      workspaceId,
    });

    if (!task) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    // Closed task can't be updated
    await this.checkTaskIsClosed(taskId);

    await this.taskAssignmentService.closeAssignmentsByTaskId(taskId);
  }

  async addTaskAssignee({
    workspaceId,
    taskId,
    payload,
  }: {
    workspaceId: Workspace['id'];
    taskId: Task['id'];
    payload: AddTaskAssigneeRequest;
  }): Promise<AddTaskAssigneeResponse> {
    const task = await this.taskService.findByTaskIdAndWorkspaceId({
      taskId,
      workspaceId,
    });

    if (!task) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    // Closed task can't be updated
    await this.checkTaskIsClosed(taskId);

    // We need to check if provided assignee IDs exist as this specific workspace users
    const existingWorkspaceUsers =
      await this.workspaceUserService.findByIdsAndWorkspaceIdWithUserAndCreatedByUser(
        {
          ids: payload.assigneeIds,
          workspaceId,
        },
      );

    if (!existingWorkspaceUsers) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.UNPROCESSABLE_ENTITY,
      );
    }

    await this.taskAssignmentService.createMultiple({
      workspaceUserIds: payload.assigneeIds,
      status: ProgressStatus.IN_PROGRESS,
      taskId,
    });

    const mappedResponse = existingWorkspaceUsers.map((workspaceUser) => {
      return {
        id: workspaceUser.id,
        firstName: workspaceUser.user.firstName,
        lastName: workspaceUser.user.lastName,
        email: workspaceUser.user.email,
        profileImageUrl: workspaceUser.user.profileImageUrl,
        role: workspaceUser.workspaceRole,
        userId: workspaceUser.user.id,
        createdBy:
          workspaceUser.createdBy === null
            ? null
            : {
                id: workspaceUser.createdBy.id,
                firstName: workspaceUser.createdBy.firstName,
                lastName: workspaceUser.createdBy.lastName,
                profileImageUrl: workspaceUser.createdBy.profileImageUrl,
              },
        createdAt: DateTime.fromJSDate(workspaceUser.createdAt).toISO()!,
        status: ProgressStatus.IN_PROGRESS,
      };
    });

    return mappedResponse;
  }

  /**
   * This is idempotennt solution because it uses Typeorm's
   * delete funtion, which doesn't check if the record actually
   * exists. This is actually a good solution for the case
   * when a Manager2 tries to remove a assignee which was already
   * removed by Manager1 (Manager2 had stale tasks response). In
   * that case, 204 status will be sent to Manager2 (even though
   * there was no actual deletion) and frontend will then manually
   * remove that assignee from the tasks cache.
   */
  async removeTaskAssignee({
    workspaceId,
    taskId,
    payload,
  }: {
    workspaceId: Workspace['id'];
    taskId: Task['id'];
    payload: RemoveTaskAssigneeRequest;
  }): Promise<void> {
    const task = await this.taskService.findByTaskIdAndWorkspaceId({
      taskId,
      workspaceId,
    });

    if (!task) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    // Closed task can't be updated
    await this.checkTaskIsClosed(taskId);

    await this.taskAssignmentService.deleteByTaskIdAndAssigneeId({
      assigneeId: payload.assigneeId,
      taskId,
    });
  }

  async updateTaskAssignments({
    workspaceId,
    taskId,
    assignments,
  }: {
    workspaceId: Workspace['id'];
    taskId: Task['id'];
    assignments: UpdateTaskAssignmentsRequest['assignments'];
  }): Promise<UpdateTaskAssignmentsStatusesResponse> {
    const task = await this.taskService.findByTaskIdAndWorkspaceId({
      taskId,
      workspaceId,
    });

    if (!task) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    // Closed task can't be updated
    await this.checkTaskIsClosed(taskId);

    // We need to check if provided assignee IDs exist as this specific task assignments
    const providedAssigneeIds = assignments.map((item) => item.assigneeId);
    const existingTaskAssignments =
      await this.taskAssignmentService.findAllByTaskIdAndAssigneeIds({
        taskId,
        assigneeIds: providedAssigneeIds,
      });

    if (existingTaskAssignments.length !== providedAssigneeIds.length) {
      // One or more provided assignee IDs doesn't exist in task assignments for the given task
      throw new ApiHttpException(
        {
          code: ApiErrorCode.TASK_ASSIGNEES_INVALID,
        },
        HttpStatus.UNPROCESSABLE_ENTITY,
      );
    }

    const updatedTaskAssignments =
      await this.taskAssignmentService.updateAssignmentsByTaskId({
        taskId,
        workspaceId,
        data: assignments,
      });

    const response: UpdateTaskAssignmentsStatusesResponse =
      updatedTaskAssignments.map((taskAssignment) => ({
        assigneeId: taskAssignment.assignee.id,
        status: taskAssignment.status,
      }));

    return response;
  }

  private async checkTaskIsClosed(taskId: string) {
    // Check if the task is closed (all task
    // assignments have ProgressStatus.Closed status).
    // It is enough to check if only one assignment
    // has status set to Closed, because a task can be
    // closed via special endpoint in which all statuses
    // are set to Closed. In the updateTaskAssignments
    // endpoint there is request payload validation
    // which defines that the status can be set to
    // any ProgressStatus value except Closed.
    const taskAssignments =
      await this.taskAssignmentService.findAllByTaskId(taskId);

    for (const assignment of taskAssignments) {
      if (assignment.status === ProgressStatus.CLOSED) {
        throw new ApiHttpException(
          {
            code: ApiErrorCode.TASK_CLOSED,
          },
          HttpStatus.UNPROCESSABLE_ENTITY,
        );
      }
    }
  }
}
