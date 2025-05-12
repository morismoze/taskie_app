import {
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Injectable,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { JwtPayload } from 'src/modules/auth/core/strategies/jwt-payload.type';

@Injectable()
export class WorkspaceMembershipGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    const user = request.user as JwtPayload;
    const workspaceId = request.params['workspaceId'];

    // Check if the user is a member of the workspace
    const isMember = user.roles.some((r) => r.workspaceId === workspaceId);

    if (!isMember) {
      throw new ForbiddenException();
    }

    return true;
  }
}
