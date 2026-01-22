import {
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Req,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiConflictResponse,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { RequestWithUser } from '../auth/core/domain/request-with-user.domain';
import { JwtAuthGuard } from '../auth/core/guards/jwt-auth.guard';
import { UserResponse } from './dto/response/user-response.dto';
import { UserService } from './user.service';

@ApiTags('Users')
@ApiBearerAuth()
@ApiUnauthorizedResponse({
  description: 'Invalid access token',
})
@Controller({
  path: 'users',
  version: '1',
})
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Get('me')
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Get current authenticated user',
  })
  @ApiOkResponse({
    type: UserResponse,
  })
  me(@Req() request: RequestWithUser): Promise<UserResponse> {
    return this.userService.me(request.user);
  }

  @Delete('me')
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({
    summary: 'Delete current authenticated user',
  })
  @ApiNoContentResponse()
  @ApiConflictResponse({
    description:
      'Cannot delete account. User is the sole manager of one or more workspaces containing other non-virtual members.',
  })
  deleteMe(@Req() request: RequestWithUser): Promise<void> {
    return this.userService.delete(request.user.sub);
  }
}
