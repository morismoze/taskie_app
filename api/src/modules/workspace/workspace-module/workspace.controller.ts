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
  Put,
  Query,
  Req,
  UseGuards,
} from '@nestjs/common';
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
import {
  WorkspaceUserResponse,
  WorkspaceUsersResponse,
} from './dto/response/workspace-users-response.dto';
import {
  WorkspaceResponse,
  WorkspacesResponse,
} from './dto/response/workspaces-response.dto';
import { WorkspaceMembershipGuard } from './guards/workspace-membership.guard';
import { WorkspaceRoleGuard } from './guards/workspace-role.guard';
import { WorkspaceService } from './workspace.service';

@Controller({
  path: 'workspaces',
})
export class WorkspaceController {
  constructor(private readonly workspaceService: WorkspaceService) {}

  @Post()
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.CREATED)
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
  getWorkspaceInfoByWorkspaceInviteToken(
    @Param() params: WorkspaceInviteTokenRequestPathParam,
  ): Promise<WorkspaceResponse> {
    return this.workspaceService.getWorkspaceInfoByWorkspaceInviteToken(
      params.inviteToken,
    );
  }

  @Put('invites/:inviteToken/join')
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.CREATED)
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
  getUserWorkspaces(@Req() req: RequestWithUser): Promise<WorkspacesResponse> {
    return this.workspaceService.getWorkspacesByUser(req.user.sub);
  }

  @Post(':workspaceId/users/virtual')
  @RequireWorkspaceUserRole('workspaceId', WorkspaceUserRole.MANAGER)
  @UseGuards(JwtAuthGuard, WorkspaceRoleGuard)
  @HttpCode(HttpStatus.CREATED)
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
  getWorkspaceUsers(
    @Param() params: WorkspaceIdRequestPathParam,
  ): Promise<WorkspaceUsersResponse> {
    return this.workspaceService.getWorkspaceUsers(params.workspaceId);
  }

  @Patch(':workspaceId/users/:workspaceUserId')
  @RequireWorkspaceUserRole('workspaceId', WorkspaceUserRole.MANAGER)
  @UseGuards(JwtAuthGuard, WorkspaceRoleGuard)
  @HttpCode(HttpStatus.OK)
  updateWorkspaceUser(
    @Param() { workspaceId }: WorkspaceIdRequestPathParam,
    @Param() { workspaceUserId }: WorkspaceUserIdRequestPathParam,
    @Body() data: UpdateWorkspaceUserRequest,
    @Req() request: RequestWithUser,
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

  @Post(':workspaceId/tasks/:taskId/close')
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

  @Post(':workspaceId/goals/:goalId/close')
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
