import { IsOptional } from 'class-validator';
import {
  IsValidWorkspaceDescription,
  IsValidWorkspaceName,
} from 'src/common/decorators/request-validation-decorators';

export class UpdateWorkspaceRequest {
  @IsOptional()
  @IsValidWorkspaceName()
  name?: string;

  @IsOptional()
  @IsValidWorkspaceDescription()
  description?: string;

  constructor(name?: string, description?: string) {
    this.name = name;
    this.description = description;
  }
}
