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
import { WorkspaceTasksResponse } from './dto/response/workspace-tasks-response.dto';
import {
  WorkspaceGoalResponse,
  WorkspaceGoalsResponse,
} from './dto/response/workspace-goals-response.dto';
import {
  WorkspaceLeaderboardResponse,
  LeaderboardUserResponse,
} from './dto/response/workspace-leaderboard-response.dto';
import { Task } from 'src/modules/task/task-module/domain/task.domain';
import { UpdateTaskRequest } from './dto/request/update-task-request.dto';
import { UpdateTaskAssignmentsRequest } from './dto/request/update-task-assignment-status-request.dto';
import { UpdateTaskAssignmentsStatusesResponse } from './dto/response/update-task-assignments-statuses-response.dto';
import { Goal } from 'src/modules/goal/domain/goal.domain';
import { UpdateTaskResponse } from './dto/response/update-task-response.dto';
import { UpdateGoalRequest } from './dto/request/update-goal-request.dto';
import { UpdateWorkspaceUserRequest } from './dto/request/update-workspace-user-request.dto';

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
    };

    return response;
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
      // Currently uploading images while creating virtual users is not supported
      profileImageUrl: null,
      role: newWorkspaceUser.workspaceRole,
    };

    return response;
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

    // This is open to change - we could firstly fetch just plain concrete tasks
    // by given workspaceId via the task service function and then for each task fetch its
    // task assignments via the task assignment service function (this would actually be done
    // with only one DB query - where: { task: { id: In(taskIds) } }) - this is something I'm not
    // sure about, because I'm weighing *one more complex query, meaning less DB queries* vs *two
    // simple queries, from different service functions for SRP (single responsiblity principle)
    const { data: tasks, total } =
      await this.taskService.findPaginatedByWorkspaceWithAssignees({
        workspaceId,
        query,
      });

    const response: WorkspaceTasksResponse = {
      items: tasks.map((task) => ({
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
        requiredPoints: goal.requiredPoints,
        status: goal.status,
        accumulatedPoints,
      });
    }

    const response: WorkspaceGoalsResponse = {
      items: responseData,
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

    await this.unitOfWorkService.withTransaction(async () => {
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
    memberId,
    data,
  }: {
    workspaceId: Workspace['id'];
    memberId: WorkspaceUser['id'];
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

    const { updatedWorkspaceUser } =
      await this.unitOfWorkService.withTransaction(async () => {
        const updatedWorkspaceUser = await this.workspaceUserService.update({
          id: memberId,
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

        return { updatedWorkspaceUser };
      });

    const response: WorkspaceUserResponse = {
      id: updatedWorkspaceUser.id,
      firstName: updatedWorkspaceUser.user.firstName,
      lastName: updatedWorkspaceUser.user.lastName,
      profileImageUrl: updatedWorkspaceUser.user.profileImageUrl,
      role: updatedWorkspaceUser.workspaceRole,
    };

    return response;
  }

  async removeUserFromWorkspace({
    workspaceId,
    memberId,
  }: {
    workspaceId: Workspace['id'];
    memberId: WorkspaceUser['id'];
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
      workspaceUserId: memberId,
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
  }): Promise<UpdateTaskResponse> {
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

    const response: UpdateTaskResponse = {
      id: updatedTask.id,
      title: updatedTask.title,
      rewardPoints: updatedTask.rewardPoints,
      description: updatedTask.description,
      dueDate: updatedTask.dueDate,
    };

    return response;
  }

  async updateTaskAssigments({
    workspaceId,
    taskId,
    assignments,
  }: {
    workspaceId: Workspace['id'];
    taskId: Task['id'];
    assignments: UpdateTaskAssignmentsRequest['assignments'];
  }): Promise<UpdateTaskAssignmentsStatusesResponse> {
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

    // We need to check if provided assignee IDs exist as workspace users
    const providedAssigneeIds = assignments.map((item) => item.assigneeId);
    const existingWorkspaceUsers = await this.workspaceUserService.findAllByIds(
      {
        workspaceId,
        ids: providedAssigneeIds,
      },
    );

    if (existingWorkspaceUsers.length !== providedAssigneeIds.length) {
      // One or more provided assignee IDs don't exist as workspace users for provided workspace
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    const updatedTaskAssignments =
      await this.taskAssignmentService.updateAssignessByTaskId({
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
      requiredPoints: updatedGoal.requiredPoints,
      assignee: {
        id: updatedGoal.assignee.id,
        firstName: updatedGoal.assignee.firstName,
        lastName: updatedGoal.assignee.lastName,
        profileImageUrl: updatedGoal.assignee.profileImageUrl,
      },
      status: updatedGoal.status,
      accumulatedPoints,
    };

    return response;
  }
}
