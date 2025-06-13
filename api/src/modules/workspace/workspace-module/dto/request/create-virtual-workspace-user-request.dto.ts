import { IsValidPersonName } from 'src/common/decorators/request-validation-decorators';

export class CreateVirtualWorkspaceUserRequest {
  @IsValidPersonName()
  firstName: string;

  @IsValidPersonName()
  lastName: string;

  constructor(firstName: string, lastName: string) {
    this.firstName = firstName;
    this.lastName = lastName;
  }
}
