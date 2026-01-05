import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional } from 'class-validator';
import {
  IsValidWorkspaceDescription,
  IsValidWorkspaceName,
} from 'src/common/decorators/request-validation-decorators';

export class UpdateWorkspaceRequest {
  @ApiPropertyOptional({
    type: String,
    nullable: false,
  })
  @IsOptional()
  @IsValidWorkspaceName()
  name?: string;

  @ApiPropertyOptional({
    type: String,
    nullable: true, // Allows null - clears description
  })
  @IsOptional()
  @IsValidWorkspaceDescription()
  description?: string | null;

  constructor(name?: string, description?: string) {
    this.name = name;
    this.description = description;
  }
}
