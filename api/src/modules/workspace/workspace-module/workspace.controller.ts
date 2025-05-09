import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Post,
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
import {
  WorkspaceTaskResponse,
  WorkspaceTasksResponse,
} from './dto/workspace-tasks-response.dto';
import { WorkspaceItemRequestQuery } from './dto/workspace-item-request.dto';
import { WorkspaceGoalsResponse } from './dto/workspace-goals-response.dto';
import { CreateTaskRequest } from './dto/create-task-request.dto';

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
    @Param('workspaceId') workspaceId: string,
    @Req() request: Request & { user: JwtPayload },
    @Body() newVirtualUser: CreateVirtualWorkspaceUserRequest,
  ): Promise<WorkspaceUserResponse> {
    return this.workspaceService.createVirtualUser({
      workspaceId,
      createdById: request.user.userId,
      data: newVirtualUser,
    });
  }

  @Get(':workspaceId/members')
  @UseGuards(AuthGuard('jwt'), WorkspaceMembershipGuard)
  @HttpCode(HttpStatus.OK)
  getWorkspaceMembers(
    @Param('workspaceId') workspaceId: string,
  ): Promise<WorkspaceUsersResponse> {
    return this.workspaceService.getWorkspaceMembers(workspaceId);
  }

  @Get(':workspaceId/tasks')
  @UseGuards(AuthGuard('jwt'), WorkspaceMembershipGuard)
  @HttpCode(HttpStatus.OK)
  getTasks(
    @Param('workspaceId') workspaceId: string,
    @Query() query: WorkspaceItemRequestQuery,
  ): Promise<WorkspaceTasksResponse> {
    return this.workspaceService.getWorkspaceTasks({
      workspaceId,
      query,
    });
  }

  @Get(':workspaceId/goals')
  @UseGuards(AuthGuard('jwt'), WorkspaceMembershipGuard)
  @HttpCode(HttpStatus.OK)
  getGoals(
    @Param('workspaceId') workspaceId: string,
    @Query() query: WorkspaceItemRequestQuery,
  ): Promise<WorkspaceGoalsResponse> {
    return this.workspaceService.getWorkspaceGoals({
      workspaceId,
      query,
    });
  }

  @Post(':workspaceId/tasks')
  @RequireWorkspaceUserRole('workspaceId', WorkspaceUserRole.MANAGER)
  @UseGuards(AuthGuard('jwt'), WorkspaceRoleGuard)
  @HttpCode(HttpStatus.CREATED)
  createTask(
    @Param('workspaceId') workspaceId: string,
    @Body() data: CreateTaskRequest,
  ): Promise<void> {
    // Returning nothing in the response because tasks are paginable and sortable by
    // different query params, so it doesn't make sense to return a newly created task
    // in the response if it won't be usable for task list state update in the app
    return this.workspaceService.createTask({
      workspaceId,
      data,
    });
  }
}
