import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Patch,
  Post,
  Query,
  Req,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiForbiddenResponse,
  ApiInternalServerErrorResponse,
  ApiNoContentResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiParam,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { RequestWithUser } from 'src/modules/auth/core/domain/request-with-user.domain';
import { JwtAuthGuard } from 'src/modules/auth/core/guards/jwt-auth.guard';
import { WorkspaceUserRole } from '../workspace-user-module/domain/workspace-user-role.enum';
import { RequireWorkspaceUserRole } from './decorators/workspace-role.decorator';
import { AddTaskAssigneeRequest } from './dto/request/add-task-assignee-request.dto';
import { CreateGoalRequest } from './dto/request/create-goal-request.dto';
import { CreateTaskRequest } from './dto/request/create-task-request.dto';
import { CreateVirtualWorkspaceUserRequest } from './dto/request/create-virtual-workspace-user-request.dto';
import { CreateWorkspaceRequest } from './dto/request/create-workspace-request.dto';
import { GoalIdRequestPathParam } from './dto/request/goal-id-path-param-request.dto';
import { RemoveTaskAssigneeRequest } from './dto/request/remove-task-assignee-request.dto';
import { TaskIdRequestPathParam } from './dto/request/task-id-path-param-request.dto';
import { UpdateGoalRequest } from './dto/request/update-goal-request.dto';
import { UpdateTaskAssignmentsRequest } from './dto/request/update-task-assignment-request.dto';
import { UpdateTaskRequest } from './dto/request/update-task-request.dto';
import { UpdateWorkspaceRequest } from './dto/request/update-workspace-request.dto';
import { UpdateWorkspaceUserRequest } from './dto/request/update-workspace-user-request.dto';
import { WorkspaceIdRequestPathParam } from './dto/request/workspace-id-path-param-request.dto';
import { WorkspaceInviteTokenRequestPathParam } from './dto/request/workspace-invite-token-path-param-request.dto';
import { WorkspaceObjectiveRequestQuery } from './dto/request/workspace-item-request.dto';
import { WorkspaceUserIdRequestPathParam } from './dto/request/workspace-user-id-path-param-request.dto';
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
import { WorkspaceUserResponse } from './dto/response/workspace-users-response.dto';
import { WorkspaceResponse } from './dto/response/workspaces-response.dto';
import { WorkspaceMembershipGuard } from './guards/workspace-membership.guard';
import { WorkspaceRoleGuard } from './guards/workspace-role.guard';
import { WorkspaceService } from './workspace.service';

@ApiTags('Workspaces')
@ApiBearerAuth()
@ApiUnauthorizedResponse({
  description: 'Invalid access token',
})
@Controller({
  path: 'workspaces',
  version: '1',
})
export class WorkspaceController {
  constructor(private readonly workspaceService: WorkspaceService) {}

  @Post()
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Create a new workspace',
  })
  @ApiCreatedResponse({
    type: WorkspaceResponse,
  })
  @ApiInternalServerErrorResponse({
    description: 'Internal error while creating the workspace',
  })
  createWorkspace(
    @Req() request: RequestWithUser,
    @Body() payload: CreateWorkspaceRequest,
  ): Promise<WorkspaceResponse> {
    // Complete RESTful endpoint would just return Location header
    // with the path to the newly created resource
    return this.workspaceService.create({
      createdById: request.user.sub,
      data: payload,
    });
  }

  @Patch(':workspaceId')
  @RequireWorkspaceUserRole('workspaceId', WorkspaceUserRole.MANAGER)
  @UseGuards(JwtAuthGuard, WorkspaceRoleGuard)
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Update workspace details',
    description: 'Minimal required workspace role: MANAGER',
  })
  @ApiParam({
    name: 'workspaceId',
    required: true,
    schema: { type: 'string', format: 'uuid' },
  })
  @ApiOkResponse({
    type: WorkspaceResponse,
  })
  @ApiForbiddenResponse({
    description: 'Requires minimal workspace role MANAGER',
  })
  @ApiNotFoundResponse({
    description: 'Provided {workspaceId} was not found',
  })
  @ApiInternalServerErrorResponse({
    description: 'Internal error while updating the workspace',
  })
  updateWorkspace(
    @Param() { workspaceId }: WorkspaceIdRequestPathParam,
    @Body() payload: UpdateWorkspaceRequest,
  ): Promise<WorkspaceResponse> {
    return this.workspaceService.updateWorkspace({
      workspaceId,
      data: payload,
    });
  }

  @Post(':workspaceId/invites')
  @RequireWorkspaceUserRole('workspaceId', WorkspaceUserRole.MANAGER)
  @UseGuards(JwtAuthGuard, WorkspaceRoleGuard)
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary:
      'Create workspace invite token to be used in the workspace invite link',
    description: 'Minimal required workspace role: MANAGER',
  })
  @ApiParam({
    name: 'workspaceId',
    required: true,
    schema: { type: 'string', format: 'uuid' },
  })
  @ApiCreatedResponse({
    type: CreateWorkspaceInviteTokenResponse,
  })
  @ApiForbiddenResponse({
    description: 'Requires minimal workspace role MANAGER',
  })
  @ApiNotFoundResponse({
    description: 'Provided {workspaceId} was not found',
  })
  @ApiInternalServerErrorResponse({
    description: 'Internal error while creating the workspace invite token',
  })
  createWorkspaceInviteToken(
    @Param() params: WorkspaceIdRequestPathParam,
    @Req() request: RequestWithUser,
  ): Promise<CreateWorkspaceInviteTokenResponse> {
    return this.workspaceService.createInviteToken({
      workspaceId: params.workspaceId,
      createdById: request.user.sub,
    });
  }

  @Get('invites/:inviteToken')
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Get workspace information by the workspace {inviteToken}',
  })
  @ApiParam({
    name: 'inviteToken',
    required: true,
    schema: { type: 'string', format: 'uuid' },
  })
  @ApiOkResponse({
    type: WorkspaceResponse,
  })
  @ApiNotFoundResponse({
    description: 'Provided {inviteToken} was not found',
  })
  getWorkspaceInfoByWorkspaceInviteToken(
    @Param() params: WorkspaceInviteTokenRequestPathParam,
  ): Promise<WorkspaceResponse> {
    return this.workspaceService.getWorkspaceInfoByWorkspaceInviteToken(
      params.inviteToken,
    );
  }

  @Post('invites/:inviteToken/join')
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Join a workspace by workspace {inviteToken}',
  })
  @ApiParam({
    name: 'inviteToken',
    required: true,
    schema: { type: 'string', format: 'uuid' },
  })
  @ApiCreatedResponse({
    type: WorkspaceResponse,
  })
  @ApiNotFoundResponse({
    description: 'Provided {inviteToken} was not found',
  })
  @ApiBadRequestResponse({
    description:
      '• User is already part of the workspace\n\n' +
      '• The {invite token} was already used\n\n' +
      '• The {invite token} has expired',
  })
  @ApiInternalServerErrorResponse({
    description: 'Internal error while updating the workspace invite',
  })
  joinWorkspace(
    @Param() params: WorkspaceInviteTokenRequestPathParam,
    @Req() request: RequestWithUser,
  ): Promise<WorkspaceResponse> {
    return this.workspaceService.joinWorkspace({
      inviteToken: params.inviteToken,
      usedById: request.user.sub,
    });
  }

  @Get('me')
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: "Get current authenticated user's workspaces",
  })
  @ApiOkResponse({
    type: WorkspaceResponse,
    isArray: true,
  })
  getUserWorkspaces(@Req() req: RequestWithUser): Promise<WorkspaceResponse[]> {
    return this.workspaceService.getWorkspacesByUser(req.user.sub);
  }

  @Post(':workspaceId/users/virtual')
  @RequireWorkspaceUserRole('workspaceId', WorkspaceUserRole.MANAGER)
  @UseGuards(JwtAuthGuard, WorkspaceRoleGuard)
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Create a virtual user for the {workspaceId} workspace',
    description: 'Minimal required workspace role: MANAGER',
  })
  @ApiParam({
    name: 'workspaceId',
    required: true,
    schema: { type: 'string', format: 'uuid' },
  })
  @ApiCreatedResponse({
    type: WorkspaceUserResponse,
  })
  @ApiForbiddenResponse({
    description: 'Requires minimal workspace role MANAGER',
  })
  @ApiNotFoundResponse({
    description: 'Provided {workspaceId} was not found',
  })
  @ApiInternalServerErrorResponse({
    description:
      '• Internal error while creating the core user\n\n' +
      '• Internal error while creating the workspace user',
  })
  createVirtualUser(
    @Param() params: WorkspaceIdRequestPathParam,
    @Req() request: RequestWithUser,
    @Body() newVirtualUser: CreateVirtualWorkspaceUserRequest,
  ): Promise<WorkspaceUserResponse> {
    return this.workspaceService.createVirtualUser({
      workspaceId: params.workspaceId,
      createdById: request.user.sub,
      data: newVirtualUser,
    });
  }

  @Get(':workspaceId/users')
  @UseGuards(JwtAuthGuard, WorkspaceMembershipGuard)
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Get users in the {workspaceId} workspace',
    description: 'Minimal required workspace role: MEMBER',
  })
  @ApiParam({
    name: 'workspaceId',
    required: true,
    schema: { type: 'string', format: 'uuid' },
  })
  @ApiOkResponse({
    type: WorkspaceUserResponse,
    isArray: true,
  })
  @ApiForbiddenResponse({
    description: 'Requires minimal workspace role MEMBER',
  })
  @ApiNotFoundResponse({
    description: 'Provided {workspaceId} was not found',
  })
  @ApiInternalServerErrorResponse({
    description:
      '• Internal error while creating the core user\n\n' +
      '• Internal error while creating the workspace user',
  })
  getWorkspaceUsers(
    @Param() params: WorkspaceIdRequestPathParam,
  ): Promise<WorkspaceUserResponse[]> {
    return this.workspaceService.getWorkspaceUsers(params.workspaceId);
  }

  @Patch(':workspaceId/users/:workspaceUserId')
  @RequireWorkspaceUserRole('workspaceId', WorkspaceUserRole.MANAGER)
  @UseGuards(JwtAuthGuard, WorkspaceRoleGuard)
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Update workspace user details',
    description:
      '• Minimal required workspace role: MANAGER.\n\n' +
      '• MANAGERS can change firstName and lastName properties of virtual users and role property on non-virtual users.',
  })
  @ApiParam({
    name: 'workspaceId',
    required: true,
    schema: { type: 'string', format: 'uuid' },
  })
  @ApiParam({
    name: 'workspaceUserId',
    required: true,
    schema: { type: 'string', format: 'uuid' },
  })
  @ApiOkResponse({
    type: WorkspaceUserResponse,
  })
  @ApiForbiddenResponse({
    description: 'Requires minimal workspace role MANAGER',
  })
  @ApiNotFoundResponse({
    description:
      '• Provided {workspaceId} was not found\n\n' +
      '• Provided {workspaceUserId} is not part of the provided {workspaceId} workspace\n\n' +
      '• Core user was not found' +
      '• Internal error',
  })
  @ApiInternalServerErrorResponse({
    description:
      '• Internal error while updating the core user\n\n' +
      '• Internal error while updating the workspace user',
  })
  updateWorkspaceUser(
    @Param() { workspaceId }: WorkspaceIdRequestPathParam,
    @Param() { workspaceUserId }: WorkspaceUserIdRequestPathParam,
    @Body() data: UpdateWorkspaceUserRequest,
  ): Promise<WorkspaceUserResponse> {
    return this.workspaceService.updateWorkspaceUser({
      workspaceId,
      workspaceUserId,
      data,
    });
  }

  @Get(':workspaceId/users/:workspaceUserId/points')
  @UseGuards(JwtAuthGuard, WorkspaceMembershipGuard)
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: "Get workspace user's accumulated points",
    description: 'Minimal required workspace role: MEMBER',
  })
  @ApiParam({
    name: 'workspaceId',
    required: true,
    schema: { type: 'string', format: 'uuid' },
  })
  @ApiParam({
    name: 'workspaceUserId',
    required: true,
    schema: { type: 'string', format: 'uuid' },
  })
  @ApiOkResponse({
    type: WorkspaceUserAccumulatedPointsResponse,
  })
  @ApiForbiddenResponse({
    description: 'Requires minimal workspace role MEMBER',
  })
  @ApiNotFoundResponse({
    description:
      'Provided {workspaceUserId} is not part of the provided {workspaceId} workspace',
  })
  getWorkspaceUserAccumulatedPoints(
    @Param() { workspaceId }: WorkspaceIdRequestPathParam,
    @Param() { workspaceUserId }: WorkspaceUserIdRequestPathParam,
  ): Promise<WorkspaceUserAccumulatedPointsResponse> {
    return this.workspaceService.getWorkspaceUserAccumulatedPoints({
      workspaceId,
      workspaceUserId,
    });
  }

  // This endpoint needs to be before the one below
  // because of path param pattern recognition
  @Delete(':workspaceId/users/me')
  @UseGuards(JwtAuthGuard, WorkspaceMembershipGuard)
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({
    summary: 'Leave a workspace',
    description: 'Minimal required workspace role: MEMBER',
  })
  @ApiParam({
    name: 'workspaceId',
    required: true,
    schema: { type: 'string', format: 'uuid' },
  })
  @ApiNoContentResponse()
  @ApiForbiddenResponse({
    description: 'Requires minimal workspace role MEMBER',
  })
  @ApiNotFoundResponse({
    description:
      '• Provided {workspaceId} was not found\n\n' +
      '• Provided {workspaceUserId} is not part of the provided {workspaceId} workspace',
  })
  @ApiInternalServerErrorResponse({
    description: 'Internal error',
  })
  leaveWorkspace(
    @Param() { workspaceId }: WorkspaceIdRequestPathParam,
    @Req() request: RequestWithUser,
  ): Promise<void> {
    return this.workspaceService.leaveWorkspace({
      workspaceId,
      userId: request.user.sub,
    });
  }

  @Delete(':workspaceId/users/:workspaceUserId')
  @RequireWorkspaceUserRole('workspaceId', WorkspaceUserRole.MANAGER)
  @UseGuards(JwtAuthGuard, WorkspaceRoleGuard)
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({
    summary: 'Remove workspace user',
    description: 'Minimal required workspace role: MANAGER',
  })
  @ApiParam({
    name: 'workspaceId',
    required: true,
    schema: { type: 'string', format: 'uuid' },
  })
  @ApiParam({
    name: 'workspaceUserId',
    required: true,
    schema: { type: 'string', format: 'uuid' },
  })
  @ApiNoContentResponse()
  @ApiForbiddenResponse({
    description: 'Requires minimal workspace role MANAGER',
  })
  @ApiNotFoundResponse({
    description:
      '• Provided {workspaceId} was not found\n\n' +
      '• Provided {workspaceUserId} is not part of the provided {workspaceId} workspace\n\n' +
      '• Internal error',
  })
  @ApiInternalServerErrorResponse({
    description: 'Internal error',
  })
  removeUserFromWorkspace(
    @Param() { workspaceId }: WorkspaceIdRequestPathParam,
    @Param() { workspaceUserId }: WorkspaceUserIdRequestPathParam,
  ): Promise<void> {
    return this.workspaceService.removeUserFromWorkspace({
      workspaceId,
      workspaceUserId,
    });
  }

  @Get(':workspaceId/tasks')
  @UseGuards(JwtAuthGuard, WorkspaceMembershipGuard)
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Get workspace tasks',
    description: 'Minimal required workspace role: MEMBER',
  })
  @ApiParam({
    name: 'workspaceId',
    required: true,
    schema: { type: 'string', format: 'uuid' },
  })
  @ApiOkResponse({
    type: WorkspaceTasksResponse,
  })
  @ApiForbiddenResponse({
    description: 'Requires minimal workspace role MEMBER',
  })
  @ApiNotFoundResponse({
    description: 'Provided {workspaceId} was not found',
  })
  getTasks(
    @Param() params: WorkspaceIdRequestPathParam,
    @Query() query: WorkspaceObjectiveRequestQuery,
  ): Promise<WorkspaceTasksResponse> {
    return this.workspaceService.getWorkspaceTasks({
      workspaceId: params.workspaceId,
      query,
    });
  }

  @Post(':workspaceId/tasks')
  @RequireWorkspaceUserRole('workspaceId', WorkspaceUserRole.MANAGER)
  @UseGuards(JwtAuthGuard, WorkspaceRoleGuard)
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Create task',
    description: 'Minimal required workspace role: MANAGER',
  })
  @ApiParam({
    name: 'workspaceId',
    required: true,
    schema: { type: 'string', format: 'uuid' },
  })
  @ApiCreatedResponse({
    type: WorkspaceTaskResponse,
  })
  @ApiForbiddenResponse({
    description: 'Requires minimal workspace role MANAGER',
  })
  @ApiNotFoundResponse({
    description:
      '• Provided {workspaceId} was not found\n\n' +
      '• Creator user is not part of the {workspaceId} workspace',
  })
  @ApiInternalServerErrorResponse({
    description:
      '• Internal error while creating the task\n\n' +
      '• Internal error while creating task assignments',
  })
  createTask(
    @Param() params: WorkspaceIdRequestPathParam,
    @Req() request: RequestWithUser,
    @Body() data: CreateTaskRequest,
  ): Promise<WorkspaceTaskResponse> {
    return this.workspaceService.createTask({
      workspaceId: params.workspaceId,
      createdById: request.user.sub,
      data,
    });
  }

  @Patch(':workspaceId/tasks/:taskId')
  @RequireWorkspaceUserRole('workspaceId', WorkspaceUserRole.MANAGER)
  @UseGuards(JwtAuthGuard, WorkspaceRoleGuard)
  @HttpCode(HttpStatus.OK)
  updateTask(
    @Param() { workspaceId }: WorkspaceIdRequestPathParam,
    @Param() { taskId }: TaskIdRequestPathParam,
    @Body() payload: UpdateTaskRequest,
  ): Promise<WorkspaceTaskResponse> {
    return this.workspaceService.updateTask({
      workspaceId,
      taskId,
      payload,
    });
  }

  @Patch(':workspaceId/tasks/:taskId/close')
  @RequireWorkspaceUserRole('workspaceId', WorkspaceUserRole.MANAGER)
  @UseGuards(JwtAuthGuard, WorkspaceRoleGuard)
  @HttpCode(HttpStatus.NO_CONTENT)
  closeTask(
    @Param() { workspaceId }: WorkspaceIdRequestPathParam,
    @Param() { taskId }: TaskIdRequestPathParam,
  ): Promise<void> {
    return this.workspaceService.closeTask({
      workspaceId,
      taskId,
    });
  }

  @Post(':workspaceId/tasks/:taskId/assignments')
  @RequireWorkspaceUserRole('workspaceId', WorkspaceUserRole.MANAGER)
  @UseGuards(JwtAuthGuard, WorkspaceRoleGuard)
  @HttpCode(HttpStatus.OK)
  addTaskAssignees(
    @Param() { workspaceId }: WorkspaceIdRequestPathParam,
    @Param() { taskId }: TaskIdRequestPathParam,
    @Body() payload: AddTaskAssigneeRequest,
  ): Promise<AddTaskAssigneeResponse> {
    return this.workspaceService.addTaskAssignees({
      workspaceId,
      taskId,
      payload,
    });
  }

  @Delete(':workspaceId/tasks/:taskId/assignments')
  @RequireWorkspaceUserRole('workspaceId', WorkspaceUserRole.MANAGER)
  @UseGuards(JwtAuthGuard, WorkspaceRoleGuard)
  @HttpCode(HttpStatus.NO_CONTENT)
  removeTaskAssignee(
    @Param() { workspaceId }: WorkspaceIdRequestPathParam,
    @Param() { taskId }: TaskIdRequestPathParam,
    @Body() payload: RemoveTaskAssigneeRequest,
  ): Promise<void> {
    return this.workspaceService.removeTaskAssignee({
      workspaceId,
      taskId,
      payload,
    });
  }

  @Patch(':workspaceId/tasks/:taskId/assignments')
  @RequireWorkspaceUserRole('workspaceId', WorkspaceUserRole.MANAGER)
  @UseGuards(JwtAuthGuard, WorkspaceRoleGuard)
  @HttpCode(HttpStatus.OK)
  updateTaskAssignments(
    @Param() { workspaceId }: WorkspaceIdRequestPathParam,
    @Param() { taskId }: TaskIdRequestPathParam,
    @Body() { assignments }: UpdateTaskAssignmentsRequest,
  ): Promise<UpdateTaskAssignmentsStatusesResponse> {
    return this.workspaceService.updateTaskAssignments({
      workspaceId,
      taskId,
      assignments,
    });
  }

  @Post(':workspaceId/goals')
  @RequireWorkspaceUserRole('workspaceId', WorkspaceUserRole.MANAGER)
  @UseGuards(JwtAuthGuard, WorkspaceRoleGuard)
  @HttpCode(HttpStatus.CREATED)
  createGoal(
    @Param() params: WorkspaceIdRequestPathParam,
    @Req() request: RequestWithUser,
    @Body() data: CreateGoalRequest,
  ): Promise<WorkspaceGoalResponse> {
    return this.workspaceService.createGoal({
      workspaceId: params.workspaceId,
      createdById: request.user.sub,
      data,
    });
  }

  @Get(':workspaceId/goals')
  @UseGuards(JwtAuthGuard, WorkspaceMembershipGuard)
  @HttpCode(HttpStatus.OK)
  getGoals(
    @Param() params: WorkspaceIdRequestPathParam,
    @Query() query: WorkspaceObjectiveRequestQuery,
  ): Promise<WorkspaceGoalsResponse> {
    return this.workspaceService.getWorkspaceGoals({
      workspaceId: params.workspaceId,
      query,
    });
  }

  @Patch(':workspaceId/goals/:goalId')
  @RequireWorkspaceUserRole('workspaceId', WorkspaceUserRole.MANAGER)
  @UseGuards(JwtAuthGuard, WorkspaceRoleGuard)
  @HttpCode(HttpStatus.OK)
  updateGoal(
    @Param() { workspaceId }: WorkspaceIdRequestPathParam,
    @Param() { goalId }: GoalIdRequestPathParam,
    @Body() payload: UpdateGoalRequest,
  ): Promise<WorkspaceGoalResponse> {
    return this.workspaceService.updateGoal({
      workspaceId,
      goalId,
      payload,
    });
  }

  @Patch(':workspaceId/goals/:goalId/close')
  @RequireWorkspaceUserRole('workspaceId', WorkspaceUserRole.MANAGER)
  @UseGuards(JwtAuthGuard, WorkspaceRoleGuard)
  @HttpCode(HttpStatus.NO_CONTENT)
  closeGoal(
    @Param() { workspaceId }: WorkspaceIdRequestPathParam,
    @Param() { goalId }: GoalIdRequestPathParam,
  ): Promise<void> {
    return this.workspaceService.closeGoal({
      workspaceId,
      goalId,
    });
  }

  @Get(':workspaceId/leaderboard')
  @UseGuards(JwtAuthGuard, WorkspaceMembershipGuard)
  @HttpCode(HttpStatus.OK)
  getLeaderboard(
    @Param() params: WorkspaceIdRequestPathParam,
  ): Promise<WorkspaceLeaderboardResponse> {
    return this.workspaceService.getWorkspaceLeaderboard(params.workspaceId);
  }
}
