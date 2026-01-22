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
import { AppLogger } from 'src/modules/logger/app-logger';
import { WorkspaceUserRole } from '../../workspace-user-module/domain/workspace-user-role.enum';

@Injectable()
export class WorkspaceRoleGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly logger: AppLogger,
  ) {}

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

    // In the JWT strategy we throw 401 exception if ATV is incorrect.
    // So how does this work if the user got 401, since JwtAuthGuard
    // happens before this guard? It's because when frontend gets 401
    // it automatically does token refresh and retries the request.
    // The JwtAuthGuard will then pass normally, and this guard will
    // trigger and throw here.

    if (!userWorkspaceRole) {
      this.logger.warn(
        {
          msg: 'Access Denied: User not a member of workspace',
          userId: user.sub,
          workspaceId: workspaceId,
        },
        WorkspaceRoleGuard.name,
      );

      throw new ApiHttpException(
        {
          code: ApiErrorCode.WORKSPACE_ACCESS_REVOKED,
        },
        HttpStatus.FORBIDDEN,
      );
    }

    if (userWorkspaceRole.role !== role) {
      this.logger.warn(
        {
          msg: 'Access Denied: Insufficient Permissions',
          userId: user.sub,
          workspaceId: workspaceId,
          requiredRole: role,
          actualRole: userWorkspaceRole.role,
        },
        WorkspaceRoleGuard.name,
      );

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
