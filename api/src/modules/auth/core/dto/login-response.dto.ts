import { ApiProperty } from '@nestjs/swagger';
import { UserResponse } from 'src/modules/user/dto/response/user-response.dto';

export class LoginResponse {
  @ApiProperty()
  accessToken!: string;

  @ApiProperty()
  refreshToken!: string;

  @ApiProperty()
  tokenExpires!: number;

  @ApiProperty({
    type: () => UserResponse,
  })
  user!: UserResponse;
}
