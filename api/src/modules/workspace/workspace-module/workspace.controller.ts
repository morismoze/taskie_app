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
import { AuthGuard } from '@nestjs/passport';
import { Request } from 'express';
import { JwtPayload } from 'src/modules/auth/core/strategies/domain/jwt-payload.domain';
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

@Controller({
  path: 'workspaces',
})
export class WorkspaceController {
  constructor(private readonly workspaceService: WorkspaceService) {}

  @Post()
  @UseGuards(AuthGuard('jwt'))
  @HttpCode(HttpStatus.CREATED)
  async createWorkspace(
    @Req() request: Request & { user: JwtPayload },
    @Body() payload: CreateWorkspaceRequest,
  ): Promise<WorkspaceResponse> {
    // Complete RESTful endpoint would just return Location header
    // with the path to the newly created resource
    return this.workspaceService.create({
      createdById: request.user.userId,
      data: payload,
    });
  }

  @Post(':workspaceId/invites')
  @RequireWorkspaceUserRole('workspaceId', WorkspaceUserRole.MANAGER)
  @UseGuards(AuthGuard('jwt'), WorkspaceRoleGuard)
  @HttpCode(HttpStatus.CREATED)
  async createWorkspaceInviteLink(
    @Param() params: WorkspaceIdRequestParam,
    @Req() request: Request & { user: JwtPayload },
  ): Promise<CreateWorkspaceInviteLinkResponse> {
    return this.workspaceService.createInviteLink({
      workspaceId: params.workspaceId,
      createdById: request.user.userId,
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
  @UseGuards(AuthGuard('jwt'))
  @HttpCode(HttpStatus.CREATED)
  async joinWorkspace(
    @Param() params: WorkspaceInviteTokenRequestPathParam,
    @Req() request: Request & { user: JwtPayload },
  ): Promise<void> {
    return this.workspaceService.joinWorkspace({
      inviteToken: params.inviteToken,
      usedById: request.user.userId,
    });
  }

  @Get('me')
  @UseGuards(AuthGuard('jwt'))
  @HttpCode(HttpStatus.OK)
  getUserWorkspaces(
    @Req() req: Request & { user: JwtPayload },
  ): Promise<WorkspacesResponse> {
    return this.workspaceService.getWorkspacesByUser(req.user.userId);
  }

  @Post(':workspaceId/virtual-users')
  @RequireWorkspaceUserRole('workspaceId', WorkspaceUserRole.MANAGER)
  @UseGuards(AuthGuard('jwt'), WorkspaceRoleGuard)
  @HttpCode(HttpStatus.CREATED)
  createVirtualUser(
    @Param() params: WorkspaceIdRequestParam,
    @Req() request: Request & { user: JwtPayload },
    @Body() newVirtualUser: CreateVirtualWorkspaceUserRequest,
  ): Promise<WorkspaceUserResponse> {
    return this.workspaceService.createVirtualUser({
      workspaceId: params.workspaceId,
      createdById: request.user.userId,
      data: newVirtualUser,
    });
  }

  @Get(':workspaceId/members')
  @UseGuards(AuthGuard('jwt'), WorkspaceMembershipGuard)
  @HttpCode(HttpStatus.OK)
  getWorkspaceMembers(
    @Param() params: WorkspaceIdRequestParam,
  ): Promise<WorkspaceUsersResponse> {
    return this.workspaceService.getWorkspaceMembers(params.workspaceId);
  }

  @Get(':workspaceId/tasks')
  @UseGuards(AuthGuard('jwt'), WorkspaceMembershipGuard)
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
  @UseGuards(AuthGuard('jwt'), WorkspaceMembershipGuard)
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
  @UseGuards(AuthGuard('jwt'), WorkspaceRoleGuard)
  @HttpCode(HttpStatus.NO_CONTENT)
  createTask(
    @Param() params: WorkspaceIdRequestParam,
    @Req() request: Request & { user: JwtPayload },
    @Body() data: CreateTaskRequest,
  ): Promise<void> {
    // Returning nothing in the response because tasks are paginable and sortable by
    // different query params, so it doesn't make sense to return a newly created task
    // in the response if it won't be usable for task list state update in the app
    return this.workspaceService.createTask({
      workspaceId: params.workspaceId,
      createdById: request.user.userId,
      data,
    });
  }

  @Get(':workspaceId/leaderboard')
  @UseGuards(AuthGuard('jwt'), WorkspaceRoleGuard)
  @HttpCode(HttpStatus.NO_CONTENT)
  getLeaderboard(
    @Param() params: WorkspaceIdRequestParam,
  ): Promise<LeaderboardResponse> {
    return this.workspaceService.getWorkspaceLeaderboard(params.workspaceId);
  }
}
