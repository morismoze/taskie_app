import {
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Injectable,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
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

    const hasRole = user.roles.some(
      (r) => r.workspaceId === workspaceId && r.role === role,
    );

    if (!hasRole) {
      throw new ForbiddenException();
    }

    return true;
  }
}
