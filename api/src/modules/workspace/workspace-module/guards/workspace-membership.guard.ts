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

@Injectable()
export class WorkspaceMembershipGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    const user = request.user as JwtPayload;
    const workspaceId = request.params['workspaceId'];

    // Check if the user is a part of the workspace
    const isWorkspaceUser = user.roles.some(
      (r) => r.workspaceId === workspaceId,
    );

    if (!isWorkspaceUser) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.WORKSPACE_ACCESS_REVOKED,
        },
        HttpStatus.FORBIDDEN,
      );
    }

    return true;
  }
}
