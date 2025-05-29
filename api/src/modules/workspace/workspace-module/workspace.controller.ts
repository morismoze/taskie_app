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
import { RequireWorkspaceUserRole } from './decorators/workspace-role.decorator';
import { WorkspaceRoleGuard } from './guards/workspace-role.guard';
import { WorkspaceUserRole } from '../workspace-user-module/domain/workspace-user-role.enum';
import { CreateVirtualWorkspaceUserRequest } from './dto/request/create-virtual-workspace-user-request.dto';
import { CreateWorkspaceRequest } from './dto/request/create-workspace-request.dto';
import { WorkspaceService } from './workspace.service';
import { WorkspaceMembershipGuard } from './guards/workspace-membership.guard';
import { WorkspaceItemRequestQuery } from './dto/request/workspace-item-request.dto';
import { CreateTaskRequest } from './dto/request/create-task-request.dto';
import { CreateWorkspaceInviteLinkResponse } from './dto/response/create-workspace-invite-link-response.dto';
import { WorkspaceIdRequestPathParam } from './dto/request/workspace-id-path-param-request.dto';
import { WorkspaceInviteTokenRequestPathParam } from './dto/request/workspace-invite-token-path-param-request.dto';
import { JwtAuthGuard } from 'src/modules/auth/core/guards/jwt-auth.guard';
import { RequestWithUser } from 'src/modules/auth/core/domain/request-with-user.domain';
import { CreateGoalRequest } from './dto/request/create-goal-request.dto';
import { MemberIdRequestPathParam } from './dto/request/member-id-path-param-request.dto';
import { UpdateWorkspaceUserRequest } from './dto/request/update-workspace-user-request.dto';
import { TaskIdRequestPathParam } from './dto/request/task-id-path-param-request.dto';
import {
  WorkspaceResponse,
  WorkspacesResponse,
} from './dto/response/workspaces-response.dto';
import {
  WorkspaceUserResponse,
  WorkspaceUsersResponse,
} from './dto/response/workspace-members-response.dto';
import {
  WorkspaceGoalResponse,
  WorkspaceGoalsResponse,
} from './dto/response/workspace-goals-response.dto';
import { WorkspaceLeaderboardResponse } from './dto/response/workspace-leaderboard-response.dto';
import { WorkspaceTasksResponse } from './dto/response/workspace-tasks-response.dto';
import { UpdateTaskRequest } from './dto/request/update-task-request.dto';
import { UpdateTaskAssignmentsRequest } from './dto/request/update-task-assignment-status-request.dto';
import { UpdateTaskAssignmentsStatusesResponse } from './dto/response/update-task-assignments-statuses-response.dto';
import { UpdateTaskResponse } from './dto/response/update-task-response.dto';
import { UpdateGoalRequest } from './dto/request/update-goal-request.dto';
import { GoalIdRequestPathParam } from './dto/request/goal-id-path-param-request.dto';

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

  @Post(':workspaceId/invites')
  @RequireWorkspaceUserRole('workspaceId', WorkspaceUserRole.MANAGER)
  @UseGuards(JwtAuthGuard, WorkspaceRoleGuard)
  @HttpCode(HttpStatus.CREATED)
  createWorkspaceInviteLink(
    @Param() params: WorkspaceIdRequestPathParam,
    @Req() request: RequestWithUser,
  ): Promise<CreateWorkspaceInviteLinkResponse> {
    return this.workspaceService.createInviteLink({
      workspaceId: params.workspaceId,
      createdById: request.user.sub,
    });
  }

  @Get('invites/:inviteToken')
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.OK)
  getWorkspaceInfoByInviteToken(
    @Param() params: WorkspaceInviteTokenRequestPathParam,
  ): Promise<WorkspaceResponse> {
    return this.workspaceService.getWorkspaceByInviteLinkToken(
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

  @Post(':workspaceId/members/virtual')
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

  @Get(':workspaceId/members')
  @UseGuards(JwtAuthGuard, WorkspaceMembershipGuard)
  @HttpCode(HttpStatus.OK)
  getWorkspaceMembers(
    @Param() params: WorkspaceIdRequestPathParam,
  ): Promise<WorkspaceUsersResponse> {
    return this.workspaceService.getWorkspaceMembers(params.workspaceId);
  }

  @Patch(':workspaceId/members/:memberId')
  @RequireWorkspaceUserRole('workspaceId', WorkspaceUserRole.MANAGER)
  @UseGuards(JwtAuthGuard, WorkspaceRoleGuard)
  @HttpCode(HttpStatus.OK)
  updateWorkspaceUser(
    @Param() { workspaceId }: WorkspaceIdRequestPathParam,
    @Param() { memberId }: MemberIdRequestPathParam,
    @Body() data: UpdateWorkspaceUserRequest,
  ): Promise<WorkspaceUserResponse> {
    return this.workspaceService.updateWorkspaceUser({
      workspaceId,
      memberId,
      data,
    });
  }

  @Delete(':workspaceId/members/:memberId')
  @RequireWorkspaceUserRole('workspaceId', WorkspaceUserRole.MANAGER)
  @UseGuards(JwtAuthGuard, WorkspaceRoleGuard)
  @HttpCode(HttpStatus.NO_CONTENT)
  removeUserFromWorkspace(
    @Param() { workspaceId }: WorkspaceIdRequestPathParam,
    @Param() { memberId }: MemberIdRequestPathParam,
  ): Promise<void> {
    return this.workspaceService.removeUserFromWorkspace({
      workspaceId,
      memberId,
    });
  }

  @Post(':workspaceId/tasks')
  @RequireWorkspaceUserRole('workspaceId', WorkspaceUserRole.MANAGER)
  @UseGuards(JwtAuthGuard, WorkspaceRoleGuard)
  @HttpCode(HttpStatus.NO_CONTENT)
  createTask(
    @Param() params: WorkspaceIdRequestPathParam,
    @Req() request: RequestWithUser,
    @Body() data: CreateTaskRequest,
  ): Promise<void> {
    // Returning nothing in the response because tasks are paginable and sortable by
    // different query params, so it doesn't make sense to return a newly created task
    // in the response if it won't be usable for task list state update in the app
    return this.workspaceService.createTask({
      workspaceId: params.workspaceId,
      createdById: request.user.sub,
      data,
    });
  }

  @Get(':workspaceId/tasks')
  @UseGuards(JwtAuthGuard, WorkspaceMembershipGuard)
  @HttpCode(HttpStatus.OK)
  getTasks(
    @Param() params: WorkspaceIdRequestPathParam,
    @Query() query: WorkspaceItemRequestQuery,
  ): Promise<WorkspaceTasksResponse> {
    return this.workspaceService.getWorkspaceTasks({
      workspaceId: params.workspaceId,
      query,
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
  ): Promise<UpdateTaskResponse> {
    // This endpoint doesn't return WorkspaceTaskResponse because this endpoints
    // doesn't update assignees - we do that via updateTaskAssigments endpoint
    return this.workspaceService.updateTask({
      workspaceId,
      taskId,
      payload,
    });
  }

  @Patch(':workspaceId/tasks/:taskId/assignments')
  @RequireWorkspaceUserRole('workspaceId', WorkspaceUserRole.MANAGER)
  @UseGuards(JwtAuthGuard, WorkspaceRoleGuard)
  @HttpCode(HttpStatus.OK)
  updateTaskAssigments(
    @Param() { workspaceId }: WorkspaceIdRequestPathParam,
    @Param() { taskId }: TaskIdRequestPathParam,
    @Body() { assignments }: UpdateTaskAssignmentsRequest,
  ): Promise<UpdateTaskAssignmentsStatusesResponse> {
    return this.workspaceService.updateTaskAssigments({
      workspaceId,
      taskId,
      assignments,
    });
  }

  @Post(':workspaceId/goals')
  @RequireWorkspaceUserRole('workspaceId', WorkspaceUserRole.MANAGER)
  @UseGuards(JwtAuthGuard, WorkspaceRoleGuard)
  @HttpCode(HttpStatus.NO_CONTENT)
  createGoal(
    @Param() params: WorkspaceIdRequestPathParam,
    @Req() request: RequestWithUser,
    @Body() data: CreateGoalRequest,
  ): Promise<void> {
    // Returning nothing in the response because goals are paginable and sortable by
    // different query params, so it doesn't make sense to return a newly created goal
    // in the response if it won't be usable for goal list state update in the app
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
    @Query() query: WorkspaceItemRequestQuery,
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

  @Get(':workspaceId/leaderboard')
  @UseGuards(JwtAuthGuard, WorkspaceMembershipGuard)
  @HttpCode(HttpStatus.OK)
  getLeaderboard(
    @Param() params: WorkspaceIdRequestPathParam,
  ): Promise<WorkspaceLeaderboardResponse> {
    return this.workspaceService.getWorkspaceLeaderboard(params.workspaceId);
  }
}
