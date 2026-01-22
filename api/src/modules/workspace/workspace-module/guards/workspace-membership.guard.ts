import {
  CanActivate,
  ExecutionContext,
  HttpStatus,
  Injectable,
} from '@nestjs/common';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/api-http-exception.type';
import { JwtPayload } from 'src/modules/auth/core/strategies/jwt-payload.type';
import { AppLogger } from 'src/modules/logger/app-logger';

@Injectable()
export class WorkspaceMembershipGuard implements CanActivate {
  constructor(private readonly logger: AppLogger) {}

  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    const user = request.user as JwtPayload;
    const workspaceId = request.params['workspaceId'];

    // Check if the user is a part of the workspace
    const isWorkspaceUser = user.roles.some(
      (r) => r.workspaceId === workspaceId,
    );

    // In the JWT strategy we throw 401 exception if ATV is incorrect.
    // So how does this work if the user got 401, since JwtAuthGuard
    // happens before this guard? It's because when frontend gets 401
    // it automatically does token refresh and retries the request.
    // The JwtAuthGuard will then pass normally, and this guard will
    // trigger and throw here.
    if (!isWorkspaceUser) {
      this.logger.warn(
        {
          msg: 'Access Denied: User not a member of workspace',
          userId: user.sub,
          workspaceId: workspaceId,
        },
        WorkspaceMembershipGuard.name,
      );

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
