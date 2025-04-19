import { SetMetadata } from '@nestjs/common';
import { WorkspaceUserRole } from '../workspace-user-module/domain/workspace-user-role.enum';

/**
 * This custom decorator just attaches metadata to the route handler.
 * More specifically, it attaches the key workspaceRole with the
 * value { workspaceIdParam, role }
 */
export const RequireWorkspaceRole = (
  workspaceIdParam: string,
  role: WorkspaceUserRole,
) => SetMetadata('workspaceRole', { workspaceIdParam, role });
