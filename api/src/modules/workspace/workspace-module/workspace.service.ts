import { HttpStatus, Injectable } from '@nestjs/common';
import { JwtPayload } from 'src/modules/auth/core/strategies/jwt-payload.type';
import { GoalService } from 'src/modules/goal/goal.service';
import { TaskService } from 'src/modules/task/task-module/task.service';
import { UserService } from 'src/modules/user/user.service';
import { WorkspaceUserRole } from '../workspace-user-module/domain/workspace-user-role.enum';
import { WorkspaceUserStatus } from '../workspace-user-module/domain/workspace-user-status.enum';
import { WorkspaceUserService } from '../workspace-user-module/workspace-user.service';
import { Workspace } from './domain/workspace.domain';
import { CreateVirtualWorkspaceUserRequest } from './dto/request/create-virtual-workspace-user-request.dto';
import { CreateWorkspaceRequest } from './dto/request/create-workspace-request.dto';

import { WorkspaceItemRequestQuery } from './dto/request/workspace-item-request.dto';

import { WorkspaceRepository } from './persistence/workspace.repository';
import { CreateTaskRequest } from './dto/request/create-task-request.dto';
import { TaskAssignmentService } from 'src/modules/task/task-assignment/task-assignment.service';
import { UserStatus } from 'src/modules/user/domain/user-status.enum';
import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';

import { CreateWorkspaceInviteLinkResponse } from './dto/response/create-workspace-invite-link-response.dto';
import { WorkspaceInviteService } from '../workspace-invite/workspace-invite.service';
import { getAppWorkspaceJoinDeepLink } from 'src/common/helper/util';
import { WorkspaceInvite } from '../workspace-invite/domain/workspace-invite.domain';
import { ApiHttpException } from 'src/exception/ApiHttpException.type';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { CreateGoalRequest } from './dto/request/create-goal-request.dto';
import { WorkspaceUserCore } from '../workspace-user-module/domain/workspace-user-core.domain';
import { UnitOfWorkService } from 'src/modules/unit-of-work/unit-of-work.service';
import { WorkspaceUser } from '../workspace-user-module/domain/workspace-user.domain';
import {
  WorkspaceResponse,
  WorkspacesResponse,
} from './dto/response/workspaces-response.dto';
import {
  WorkspaceUserResponse,
  WorkspaceUsersResponse,
} from './dto/response/workspace-members-response.dto';
import {
  WorkspaceTaskResponse,
  WorkspaceTasksResponse,
} from './dto/response/workspace-tasks-response.dto';
import { WorkspaceGoalsResponse } from './dto/response/workspace-goals-response.dto';
import {
  LeaderboardResponse,
  LeaderboardUserResponse,
} from './dto/response/workspace-leaderboard-response.dto';
import { Task } from 'src/modules/task/task-module/domain/task.domain';
import { TaskAssignment } from 'src/modules/task/task-assignment/domain/task-assignment.domain';

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
    return this.unitOfWorkService.withTransaction(async () => {
      // 1. create a new empty workspace
      const newWorkspace = await this.workspaceRepository.create({
        data: {
          description: data.description,
          name: data.name,
          pictureUrl: null,
        },
        createdById,
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

      const response: WorkspaceResponse = {
        id: newWorkspace.id,
        name: newWorkspace.name,
        description: newWorkspace.description,
        pictureUrl: newWorkspace.pictureUrl,
      };

      return response;
    });
  }

  async createInviteLink({
    workspaceId,
    createdById,
  }: {
    workspaceId: Workspace['id'];
    createdById: JwtPayload['sub'];
  }): Promise<CreateWorkspaceInviteLinkResponse> {
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

    const invite = await this.workspaceInviteService.createInviteLink({
      workspaceId,
      createdById,
    });

    const response: CreateWorkspaceInviteLinkResponse = {
      inviteLink: getAppWorkspaceJoinDeepLink(invite.token),
    };

    return response;
  }

  async getWorkspaceByInviteLinkToken(
    inviteToken: WorkspaceInvite['token'],
  ): Promise<WorkspaceResponse> {
    // Check if user by ID exists
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
    const creatorWorkspaceUser = (await this.workspaceUserService.findByUserId(
      createdById,
    )) as WorkspaceUserCore;

    return this.unitOfWorkService.withTransaction(async () => {
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

      const response: WorkspaceUserResponse = {
        id: newWorkspaceUser.id,
        firstName: newUser.firstName,
        lastName: newUser.lastName,
        // Currently uploading images while creating virtual users is not supported
        profileImageUrl: null,
        role: newWorkspaceUser.workspaceRole,
      };

      return response;
    });
  }

  async getWorkspacesByUser(
    userId: JwtPayload['sub'],
  ): Promise<WorkspacesResponse> {
    const userWorkspaces = await this.workspaceRepository.findAllByUserId({
      userId,
    });

    const response: WorkspacesResponse = userWorkspaces.map((workspace) => ({
      id: workspace.id,
      name: workspace.name,
      description: workspace.description,
      pictureUrl: workspace.pictureUrl,
    }));

    return response;
  }

  async getWorkspaceMembers(
    workspaceId: Workspace['id'],
  ): Promise<WorkspaceUsersResponse> {
    const workspace = await this.workspaceRepository.findById({
      id: workspaceId,
      relations: {
        members: { user: true },
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

    const response: WorkspaceUsersResponse = workspace.members.map(
      (member) => ({
        id: member.id,
        firstName: member.user.firstName,
        lastName: member.user.lastName,
        profileImageUrl: member.user.profileImageUrl,
        role: member.workspaceRole,
      }),
    );

    return response;
  }

  async getWorkspaceTasks({
    workspaceId,
    query,
  }: {
    workspaceId: Workspace['id'];
    query: WorkspaceItemRequestQuery;
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

    // We go on the Task entity side because this way we ge unique
    // results, since going on the side of TaskAssignment entity
    // we could get more than one assignment per task
    const { data: tasks, total } =
      await this.taskService.findPaginatedByWorkspaceWithAssignees({
        workspaceId,
        query,
      });

    const response: WorkspaceTasksResponse = {
      data: tasks.map((task) => ({
        id: task.id,
        title: task.title,
        rewardPoints: task.rewardPoints,
        assignees: task.assignees.map((assignee) => ({
          id: assignee.id,
          firstName: assignee.firstName,
          lastName: assignee.lastName,
          profileImageUrl: assignee.profileImageUrl,
          status: assignee.status,
        })),
      })),
      total,
    };

    return response;
  }

  async getWorkspaceGoals({
    workspaceId,
    query,
  }: {
    workspaceId: Workspace['id'];
    query: WorkspaceItemRequestQuery;
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

    const { data: goals, total } =
      await this.goalService.findPaginatedByWorkspaceWithAssignee({
        workspaceId,
        query,
      });

    const response: WorkspaceGoalsResponse = {
      data: goals.map((goal) => ({
        id: goal.id,
        assignee: {
          id: goal.assignee.id,
          firstName: goal.assignee.firstName,
          lastName: goal.assignee.lastName,
          profileImageUrl: goal.assignee.profileImageUrl,
        },
        title: goal.title,
        requiredPoints: goal.requiredPoints,
        status: goal.status,
      })),
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

    this.unitOfWorkService.withTransaction(async () => {
      // Create new concrete task
      const newTask = await this.taskService.create({
        workspaceId,
        createdById,
        data,
      });

      // Create new task assignment for each given assignee
      for (const assigneeId of data.assignees) {
        this.taskAssignmentService.create({
          workspaceUserId: assigneeId,
          taskId: newTask.id,
          status: ProgressStatus.IN_PROGRESS,
        });
      }
    });

    return;
  }

  async createGoal({
    workspaceId,
    createdById,
    data,
  }: {
    workspaceId: Workspace['id'];
    createdById: JwtPayload['sub'];
    data: CreateGoalRequest;
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

    // Create new goal
    await this.goalService.create({
      workspaceId,
      createdById,
      data,
    });

    return;
  }

  async getWorkspaceLeaderboard(
    workspaceId: Workspace['id'],
  ): Promise<LeaderboardResponse> {
    /**
     * This service can probably be made better regarding performance
     * by doin a single query on WorkspaceUser entity
     */

    // 1. Get all workspace members
    const workspaceUsers = await this.getWorkspaceMembers(workspaceId);
    const leaderboard: LeaderboardUserResponse[] = await Promise.all(
      workspaceUsers.map(async (workspaceUser) => {
        const accumulatedPoints =
          await this.taskAssignmentService.getAccumulatedPointsForWorkspaceUser(
            {
              workspaceUserId: workspaceUser.id,
              workspaceId,
            },
          );

        return {
          id: workspaceUser.id,
          firstName: workspaceUser.firstName,
          lastName: workspaceUser.lastName,
          profileImageUrl: workspaceUser.profileImageUrl,
          accumulatedPoints: accumulatedPoints,
        };
      }),
    );

    leaderboard.sort((a, b) => b.accumulatedPoints - a.accumulatedPoints);

    return leaderboard;
  }

  async setWorkspaceUserRole({
    workspaceId,
    memberId,
    role,
  }: {
    workspaceId: Workspace['id'];
    memberId: WorkspaceUser['id'];
    role: WorkspaceUser['workspaceRole'];
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

    const updatedWorkspaceUser = await this.workspaceUserService.update(
      memberId,
      {
        workspaceRole: role,
      },
    );

    const response: WorkspaceUserResponse = {
      id: updatedWorkspaceUser.id,
      firstName: updatedWorkspaceUser.user.firstName,
      lastName: updatedWorkspaceUser.user.lastName,
      profileImageUrl: updatedWorkspaceUser.user.profileImageUrl,
      role: updatedWorkspaceUser.workspaceRole,
    };

    return response;
  }

  async updateTaskAssignmentStatus({
    workspaceId,
    taskId,
    assigneeId,
    status,
  }: {
    workspaceId: Workspace['id'];
    taskId: TaskAssignment['task']['id'];
    assigneeId: TaskAssignment['assignee']['id'];
    status: TaskAssignment['status'];
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

    const updatedTaskAssignment =
      await this.taskAssignmentService.updateByTaskIdAndAssigneeId({
        taskId,
        assigneeId,
        status,
      });

    // Search for all the task assignments by task ID again after
    // the update so we can build the response (we do it here because of
    // the single responsibilty rule)
    const taskAssignments =
      await this.taskAssignmentService.findAllByTaskIdWithAssigneeUser(taskId);

    const response: WorkspaceTaskResponse = {
      id: updatedTaskAssignment.task.id,
      title: updatedTaskAssignment.task.title,
      rewardPoints: updatedTaskAssignment.task.rewardPoints,
      assignees: taskAssignments.map((taskAssignment) => ({
        id: taskAssignment.assignee.id,
        firstName: taskAssignment.assignee.user.firstName,
        lastName: taskAssignment.assignee.user.lastName,
        profileImageUrl: taskAssignment.assignee.user.profileImageUrl,
        status: taskAssignment.status,
      })),
    };

    return response;
  }
}
