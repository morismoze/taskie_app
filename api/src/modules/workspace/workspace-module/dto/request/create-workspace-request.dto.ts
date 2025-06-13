import {
  IsNotEmpty,
  IsOptional,
  IsString,
  Length,
  MaxLength,
} from 'class-validator';

export class CreateWorkspaceRequest {
  @IsNotEmpty()
  @IsString()
  @Length(3, 50)
  name: string;

  @IsOptional()
  @IsString()
  @MaxLength(250)
  description: string | null;

  constructor(name: string, description?: string) {
    this.name = name;
    this.description = description !== undefined ? description : null;
  }
}
