import { ApiProperty } from '@nestjs/swagger';
import { IsValidPersonName } from 'src/common/decorators/request-validation-decorators';

export class CreateVirtualWorkspaceUserRequest {
  @ApiProperty()
  @IsValidPersonName()
  firstName: string;

  @ApiProperty()
  @IsValidPersonName()
  lastName: string;

  constructor(firstName: string, lastName: string) {
    this.firstName = firstName;
    this.lastName = lastName;
  }
}
