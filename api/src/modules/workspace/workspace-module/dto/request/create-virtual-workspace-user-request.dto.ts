import { ApiProperty } from '@nestjs/swagger';
import { IsValidPersonName } from 'src/common/decorators/request-validation-decorators';
import {
  PERSON_NAME_MAX_CHARS,
  PERSON_NAME_MIN_CHARS,
} from 'src/common/helper/constants';

export class CreateVirtualWorkspaceUserRequest {
  @ApiProperty({
    minLength: PERSON_NAME_MIN_CHARS,
    maxLength: PERSON_NAME_MAX_CHARS,
  })
  @IsValidPersonName()
  firstName: string;

  @ApiProperty({
    minLength: PERSON_NAME_MIN_CHARS,
    maxLength: PERSON_NAME_MAX_CHARS,
  })
  @IsValidPersonName()
  lastName: string;

  constructor(firstName: string, lastName: string) {
    this.firstName = firstName;
    this.lastName = lastName;
  }
}
