import { IsEnum, IsOptional } from 'class-validator';
import { IsValidPersonName } from 'src/common/validations/utils';
import { WorkspaceUserRole } from '../../../workspace-user-module/domain/workspace-user-role.enum';

export class UpdateWorkspaceUserRequest {
  /**
   * Firstname and lastname are for virtual users
   */

  @IsValidPersonName({ required: false })
  firstName?: string;

  @IsValidPersonName({ required: false })
  lastName?: string;

  @IsOptional()
  @IsEnum(WorkspaceUserRole)
  role?: WorkspaceUserRole;

  constructor(firstName?: string, lastName?: string, role?: WorkspaceUserRole) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.role = role;
  }
}
