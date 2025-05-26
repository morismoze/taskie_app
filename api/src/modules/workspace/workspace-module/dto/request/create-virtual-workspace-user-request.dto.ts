import { IsValidPersonName } from 'src/common/validations/utils';

export class CreateVirtualWorkspaceUserRequest {
  @IsValidPersonName({ required: true })
  firstName: string;

  @IsValidPersonName({ required: true })
  lastName: string;

  constructor(firstName: string, lastName: string) {
    this.firstName = firstName;
    this.lastName = lastName;
  }
}
