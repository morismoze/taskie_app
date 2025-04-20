import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Post,
  Request,
  UseGuards,
} from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { JwtPayload } from 'src/modules/auth/core/strategies/domain/jwt-payload.domain';
import { RequireWorkspaceRole } from '../guards/workspace-role.decorator';
import { WorkspaceRoleGuard } from '../guards/workspace-role.guard';
import { WorkspaceUserRole } from '../workspace-user-module/domain/workspace-user-role.enum';
import { CreateVirtualWorkspaceUserRequest } from './dto/create-virtual-workspace-user-request.dto';
import { CreateWorkspaceRequest } from './dto/create-workspace-request.dto';
import { WorkspacesPreviewsResponse } from './dto/workspaces-preview-response.dto';
import { WorkspaceService } from './workspace.service';

@Controller({
  path: 'workspaces',
})
export class AuthController {
  constructor(private readonly workspaceService: WorkspaceService) {}

  @Post()
  @UseGuards(AuthGuard('jwt'))
  @HttpCode(HttpStatus.CREATED)
  async createWorkspace(
    @Request() request: Request & { user: JwtPayload },
    @Body() payload: CreateWorkspaceRequest,
  ): Promise<WorkspacesPreviewsResponse> {
    return this.workspaceService.create(request.user.userId, payload);
  }

  @Get('me')
  @UseGuards(AuthGuard('jwt'))
  @HttpCode(HttpStatus.OK)
  getUserWorkspaces(
    @Request() req: Request & { user: JwtPayload },
  ): Promise<WorkspacesPreviewsResponse> {
    return this.workspaceService.getUserWorkspaces(req.user.userId);
  }

  @Post('/:workspaceId/virutal-user')
  @RequireWorkspaceRole('workspaceId', WorkspaceUserRole.MANAGER)
  @UseGuards(AuthGuard('jwt'), WorkspaceRoleGuard)
  @HttpCode(HttpStatus.NO_CONTENT)
  createVirtualUser(
    @Param('workspaceId') workspaceId: string,
    @Request() request: Request & { user: JwtPayload },
    @Body() newVirtualUser: CreateVirtualWorkspaceUserRequest,
  ): Promise<void> {
    return this.workspaceService.createVirtualUser(
      workspaceId,
      request.user.userId,
      newVirtualUser,
    );
  }
}
