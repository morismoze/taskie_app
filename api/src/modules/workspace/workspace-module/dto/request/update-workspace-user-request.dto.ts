import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsEnum, IsOptional } from 'class-validator';
import { IsValidPersonName } from 'src/common/decorators/request-validation-decorators';
import {
  PERSON_NAME_MAX_CHARS,
  PERSON_NAME_MIN_CHARS,
} from 'src/common/helper/constants';
import { WorkspaceUserRole } from '../../../workspace-user-module/domain/workspace-user-role.enum';

export class UpdateWorkspaceUserRequest {
  /**
   * Firstname and lastname are for virtual users
   */

  @ApiPropertyOptional({
    description: 'Can be changed only on virtual users',
    minLength: PERSON_NAME_MIN_CHARS,
    maxLength: PERSON_NAME_MAX_CHARS,
  })
  @IsOptional()
  @IsValidPersonName()
  firstName?: string;

  @ApiPropertyOptional({
    description: 'Can be changed only on virtual users',
    minLength: PERSON_NAME_MIN_CHARS,
    maxLength: PERSON_NAME_MAX_CHARS,
  })
  @IsOptional()
  @IsValidPersonName()
  lastName?: string;

  @ApiPropertyOptional({
    description: 'Can be changed only on non-virtual users',
    enum: WorkspaceUserRole,
  })
  @IsOptional()
  @IsEnum(WorkspaceUserRole)
  role?: WorkspaceUserRole;

  constructor(firstName?: string, lastName?: string, role?: WorkspaceUserRole) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.role = role;
  }
}
