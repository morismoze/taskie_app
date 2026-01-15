import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional } from 'class-validator';
import {
  IsValidWorkspaceDescription,
  IsValidWorkspaceName,
} from 'src/common/decorators/request-validation-decorators';
import {
  WORKSPACE_DESCRIPTION_MAX_CHARS,
  WORKSPACE_NAME_MAX_CHARS,
  WORKSPACE_NAME_MIN_CHARS,
} from 'src/common/helper/constants';

export class CreateWorkspaceRequest {
  @ApiProperty({
    minLength: WORKSPACE_NAME_MIN_CHARS,
    maxLength: WORKSPACE_NAME_MAX_CHARS,
  })
  @IsValidWorkspaceName()
  name: string;

  @ApiPropertyOptional({
    type: String,
    nullable: true,
    maxLength: WORKSPACE_DESCRIPTION_MAX_CHARS,
  })
  @IsOptional()
  @IsValidWorkspaceDescription()
  description?: string | null;

  constructor(name: string, description?: string | null) {
    this.name = name;
    this.description = description ?? null;
  }
}
