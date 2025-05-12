import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Post,
  Put,
  Query,
  Req,
  UseGuards,
} from '@nestjs/common';
import { RequireWorkspaceUserRole } from './decorators/workspace-role.decorator';
import { WorkspaceRoleGuard } from './guards/workspace-role.guard';
import { WorkspaceUserRole } from '../workspace-user-module/domain/workspace-user-role.enum';
import { CreateVirtualWorkspaceUserRequest } from './dto/create-virtual-workspace-user-request.dto';
import { CreateWorkspaceRequest } from './dto/create-workspace-request.dto';
import {
  WorkspaceResponse,
  WorkspacesResponse,
} from './dto/workspaces-response.dto';
import { WorkspaceService } from './workspace.service';
import { WorkspaceMembershipGuard } from './guards/workspace-membership.guard';
import {
  WorkspaceUserResponse,
  WorkspaceUsersResponse,
} from './dto/workspace-members-response.dto';
import { WorkspaceTasksResponse } from './dto/workspace-tasks-response.dto';
import { WorkspaceItemRequestQuery } from './dto/workspace-item-request.dto';
import { WorkspaceGoalsResponse } from './dto/workspace-goals-response.dto';
import { CreateTaskRequest } from './dto/create-task-request.dto';
import { LeaderboardResponse } from './dto/workspace-leaderboard-response.dto';
import { CreateWorkspaceInviteLinkResponse } from './dto/create-workspace-invite-link-response.dto';
import { WorkspaceIdRequestParam } from './dto/workspace-id-path-param-request.dto';
import { WorkspaceInviteTokenRequestPathParam } from './dto/workspace-invite-token-path-param-request.dto';
import { JwtAuthGuard } from 'src/modules/auth/core/guards/jwt-auth.guard';
import { RequestWithUser } from 'src/modules/auth/core/domain/request-with-user.domain';
import { CreateGoalRequest } from './dto/create-goal-request.dto';

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
    @Param() params: WorkspaceIdRequestParam,
    @Req() request: RequestWithUser,
  ): Promise<CreateWorkspaceInviteLinkResponse> {
    return this.workspaceService.createInviteLink({
      workspaceId: params.workspaceId,
      createdById: request.user.sub,
    });
  }

  @Get('invites/:inviteToken')
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
  ): Promise<void> {
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

  @Post(':workspaceId/virtual-users')
  @RequireWorkspaceUserRole('workspaceId', WorkspaceUserRole.MANAGER)
  @UseGuards(JwtAuthGuard, WorkspaceRoleGuard)
  @HttpCode(HttpStatus.CREATED)
  createVirtualUser(
    @Param() params: WorkspaceIdRequestParam,
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
    @Param() params: WorkspaceIdRequestParam,
  ): Promise<WorkspaceUsersResponse> {
    return this.workspaceService.getWorkspaceMembers(params.workspaceId);
  }

  @Get(':workspaceId/tasks')
  @UseGuards(JwtAuthGuard, WorkspaceMembershipGuard)
  @HttpCode(HttpStatus.OK)
  getTasks(
    @Param() params: WorkspaceIdRequestParam,
    @Query() query: WorkspaceItemRequestQuery,
  ): Promise<WorkspaceTasksResponse> {
    return this.workspaceService.getWorkspaceTasks({
      workspaceId: params.workspaceId,
      query,
    });
  }

  @Get(':workspaceId/goals')
  @UseGuards(JwtAuthGuard, WorkspaceMembershipGuard)
  @HttpCode(HttpStatus.OK)
  getGoals(
    @Param() params: WorkspaceIdRequestParam,
    @Query() query: WorkspaceItemRequestQuery,
  ): Promise<WorkspaceGoalsResponse> {
    return this.workspaceService.getWorkspaceGoals({
      workspaceId: params.workspaceId,
      query,
    });
  }

  @Post(':workspaceId/tasks')
  @RequireWorkspaceUserRole('workspaceId', WorkspaceUserRole.MANAGER)
  @UseGuards(JwtAuthGuard, WorkspaceRoleGuard)
  @HttpCode(HttpStatus.NO_CONTENT)
  createTask(
    @Param() params: WorkspaceIdRequestParam,
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

  @Post(':workspaceId/goals')
  @RequireWorkspaceUserRole('workspaceId', WorkspaceUserRole.MANAGER)
  @UseGuards(JwtAuthGuard, WorkspaceRoleGuard)
  @HttpCode(HttpStatus.NO_CONTENT)
  createGoal(
    @Param() params: WorkspaceIdRequestParam,
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

  @Get(':workspaceId/leaderboard')
  @UseGuards(JwtAuthGuard, WorkspaceRoleGuard)
  @HttpCode(HttpStatus.NO_CONTENT)
  getLeaderboard(
    @Param() params: WorkspaceIdRequestParam,
  ): Promise<LeaderboardResponse> {
    return this.workspaceService.getWorkspaceLeaderboard(params.workspaceId);
  }
}
