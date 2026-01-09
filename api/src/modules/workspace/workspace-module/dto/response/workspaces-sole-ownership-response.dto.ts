import { ApiProperty } from '@nestjs/swagger';

export class WorkspaceSoleOwnershipResponse {
  @ApiProperty()
  id!: string;

  @ApiProperty()
  name!: string;
}
