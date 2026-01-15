import {
  CanActivate,
  ExecutionContext,
  HttpStatus,
  Injectable,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/api-http-exception.type';
import { JwtPayload } from 'src/modules/auth/core/strategies/jwt-payload.type';
import { WorkspaceUserRole } from '../../workspace-user-module/domain/workspace-user-role.enum';

@Injectable()
export class WorkspaceRoleGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const required = this.reflector.get<{
      workspaceIdParam: string;
      role: WorkspaceUserRole;
    }>('workspaceRole', context.getHandler());

    const { workspaceIdParam, role } = required;

    const request = context.switchToHttp().getRequest();
    const user = request.user as JwtPayload;

    const workspaceId = request.params[workspaceIdParam];

    const userWorkspaceRole = user.roles.find(
      (r) => r.workspaceId === workspaceId,
    );

    if (!userWorkspaceRole) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.WORKSPACE_ACCESS_REVOKED,
        },
        HttpStatus.FORBIDDEN,
      );
    }

    if (userWorkspaceRole.role !== role) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INSUFFICIENT_PERMISSIONS,
        },
        HttpStatus.FORBIDDEN,
      );
    }

    return true;
  }
}
