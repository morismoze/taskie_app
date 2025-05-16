import { IsEnum, IsNotEmpty } from 'class-validator';
import { WorkspaceUserRole } from '../../../workspace-user-module/domain/workspace-user-role.enum';

export class SetWorkspaceUserRoleRequest {
  @IsNotEmpty()
  @IsEnum(WorkspaceUserRole)
  role: WorkspaceUserRole;

  constructor(role: WorkspaceUserRole) {
    this.role = role;
  }
}
