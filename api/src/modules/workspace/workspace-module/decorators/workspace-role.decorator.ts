import { SetMetadata } from '@nestjs/common';
import { WorkspaceUserRole } from '../../workspace-user-module/domain/workspace-user-role.enum';

/**
 * This custom decorator just attaches metadata from the path param to the route handler.
 * More specifically, it attaches the key workspaceRole with the
 * value { workspaceIdParam, role }
 */
export const RequireWorkspaceUserRole = (
  workspaceIdParam: string,
  role: WorkspaceUserRole,
) => SetMetadata('workspaceRole', { workspaceIdParam, role });
