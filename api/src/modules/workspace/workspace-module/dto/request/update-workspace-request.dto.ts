import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, ValidateIf } from 'class-validator';
import {
  IsValidWorkspaceDescription,
  IsValidWorkspaceName,
} from 'src/common/decorators/request-validation-decorators';
import {
  WORKSPACE_DESCRIPTION_MAX_CHARS,
  WORKSPACE_NAME_MAX_CHARS,
  WORKSPACE_NAME_MIN_CHARS,
} from 'src/common/helper/constants';

export class UpdateWorkspaceRequest {
  @ApiPropertyOptional({
    minLength: WORKSPACE_NAME_MIN_CHARS,
    maxLength: WORKSPACE_NAME_MAX_CHARS,
  })
  @ValidateIf((_, v) => v !== undefined) // Optional, but null is invalid
  @IsValidWorkspaceName()
  name?: string;

  @ApiPropertyOptional({
    type: String,
    nullable: true,
    description: 'Setting it to null, removes description',
    maxLength: WORKSPACE_DESCRIPTION_MAX_CHARS,
  })
  @IsOptional() // Optional, and null is valid
  @IsValidWorkspaceDescription()
  description?: string | null;

  constructor(name?: string, description?: string | null) {
    this.name = name;
    this.description = description;
  }
}
