import {
  Controller,
  Delete,
  HttpCode,
  HttpStatus,
  Req,
  UseGuards,
} from '@nestjs/common';
import { RequestWithUser } from '../auth/core/domain/request-with-user.domain';
import { JwtAuthGuard } from '../auth/core/guards/jwt-auth.guard';
import { UserService } from './user.service';

@Controller({
  path: 'users',
})
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Delete('me')
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.NO_CONTENT)
  softDelete(@Req() request: RequestWithUser): Promise<void> {
    return this.userService.softDelete(request.user.sub);
  }
}
