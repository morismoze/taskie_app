import { IsIn, IsString, Length, MaxLength } from 'class-validator';

export class CreateWorkspaceRequest {
  @IsString()
  @Length(3, 50)
  name: string;

  @IsIn([null, String])
  @MaxLength(80)
  description: string | null;
}
