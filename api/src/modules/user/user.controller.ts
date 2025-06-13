import {
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Req,
  UseGuards,
} from '@nestjs/common';
import { RequestWithUser } from '../auth/core/domain/request-with-user.domain';
import { JwtAuthGuard } from '../auth/core/guards/jwt-auth.guard';
import { UserResponse } from './dto/user-response.dto';
import { UserService } from './user.service';

@Controller({
  path: 'users',
})
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Get('me')
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.OK)
  me(@Req() request: RequestWithUser): Promise<UserResponse> {
    return this.userService.me(request.user);
  }

  @Delete('me')
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.NO_CONTENT)
  softDelete(@Req() request: RequestWithUser): Promise<void> {
    return this.userService.delete(request.user.sub);
  }
}
