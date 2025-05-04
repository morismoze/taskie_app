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
import { WorkspacesResponse } from './dto/workspaces-response.dto';
import { WorkspaceService } from './workspace.service';
import { WorkspaceMembershipGuard } from './guards/workspace-membership.guard';
import { WorkspaceMembersResponse } from './dto/workspace-members-response.dto';
import { WorkspaceTasksResponse } from './dto/workspace-tasks-response.dto';
import { WorkspaceTasksRequestQuery } from './dto/workspace-tasks-request.dto';

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
  ): Promise<WorkspacesResponse> {
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
  ): Promise<WorkspaceMembersResponse> {
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
  ): Promise<WorkspaceMembersResponse> {
    return this.workspaceService.getWorkspaceMembers(workspaceId);
  }

  @Get(':workspaceId/tasks')
  @UseGuards(AuthGuard('jwt'), WorkspaceMembershipGuard)
  getTasks(
    @Param('workspaceId') workspaceId: string,
    @Query() query: WorkspaceTasksRequestQuery,
  ): Promise<WorkspaceTasksResponse> {
    return this.workspaceService.getWorkspaceTasks({
      workspaceId,
      query,
    });
  }
}
