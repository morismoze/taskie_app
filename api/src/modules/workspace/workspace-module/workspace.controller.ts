import {
  Body,
  Controller,
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
import { CreateVirtualWorkspaceUserRequest } from './dto/create-workspace-user.dto';
import { WorkspaceService } from './workspace.service';

@Controller({
  path: 'workspace',
})
export class AuthController {
  constructor(private readonly workspaceService: WorkspaceService) {}

  @Post('/workspace/:workspaceId/user')
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
