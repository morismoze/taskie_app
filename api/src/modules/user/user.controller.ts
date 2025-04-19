import {
  Controller,
  Delete,
  HttpCode,
  HttpStatus,
  Request,
  UseGuards,
} from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { JwtPayload } from '../auth/core/strategies/domain/jwt-payload.domain';
import { UserService } from './user.service';

@Controller({
  path: 'user',
})
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Delete('me')
  @UseGuards(AuthGuard('jwt'))
  @HttpCode(HttpStatus.NO_CONTENT)
  softDelete(
    @Request() request: Request & { user: JwtPayload },
  ): Promise<void> {
    return this.userService.softDelete(request.user.userId);
  }
}
