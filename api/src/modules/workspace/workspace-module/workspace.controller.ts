import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Post,
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
import { CreateVirtualWorkspaceUserResponse } from './dto/create-virtual-workspace-user-response.dto copy';
import { CreateWorkspaceRequest } from './dto/create-workspace-request.dto';
import { WorkspacesPreviewsResponse } from './dto/workspaces-preview-response.dto';
import { WorkspaceService } from './workspace.service';
import { WorkspaceMembershipGuard } from './guards/workspace-membership.guard';
import { WorkspaceMembersResponse } from './dto/workspace-members-response.dto';

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
  ): Promise<WorkspacesPreviewsResponse> {
    return this.workspaceService.create(request.user.userId, payload);
  }

  @Get('me')
  @UseGuards(AuthGuard('jwt'))
  @HttpCode(HttpStatus.OK)
  getUserWorkspaces(
    @Req() req: Request & { user: JwtPayload },
  ): Promise<WorkspacesPreviewsResponse> {
    return this.workspaceService.getUserWorkspaces(req.user.userId);
  }

  @Post(':workspaceId/virtual-users')
  @RequireWorkspaceUserRole('workspaceId', WorkspaceUserRole.MANAGER)
  @UseGuards(AuthGuard('jwt'), WorkspaceRoleGuard)
  @HttpCode(HttpStatus.CREATED)
  createVirtualUser(
    @Param('workspaceId') workspaceId: string,
    @Req() request: Request & { user: JwtPayload },
    @Body() newVirtualUser: CreateVirtualWorkspaceUserRequest,
  ): Promise<CreateVirtualWorkspaceUserResponse> {
    return this.workspaceService.createVirtualUser(
      workspaceId,
      request.user.userId,
      newVirtualUser,
    );
  }

  @Get(':workspaceId/members')
  @UseGuards(AuthGuard('jwt'), WorkspaceMembershipGuard)
  @HttpCode(HttpStatus.OK)
  getWorkspaceMembers(
    @Param('workspaceId') workspaceId: string,
    @Req() request: Request & { user: JwtPayload },
  ): Promise<WorkspaceMembersResponse> {
    return this.workspaceService.getWorkspaceMembers(
      workspaceId,
      request.user.userId,
    );
  }
}
