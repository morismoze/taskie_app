import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional } from 'class-validator';
import {
  IsValidWorkspaceDescription,
  IsValidWorkspaceName,
} from 'src/common/decorators/request-validation-decorators';

export class CreateWorkspaceRequest {
  @ApiProperty()
  @IsValidWorkspaceName()
  name!: string;

  @ApiPropertyOptional({
    type: String,
    nullable: true,
  })
  @IsOptional()
  @IsValidWorkspaceDescription()
  description!: string | null;

  constructor(name: string, description?: string | null) {
    this.name = name;
    this.description = description ?? null;
  }
}
