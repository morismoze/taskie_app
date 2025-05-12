import {
  Controller,
  Delete,
  HttpCode,
  HttpStatus,
  Req,
  UseGuards,
} from '@nestjs/common';
import { Request } from 'express';
import { JwtAuthGuard } from '../auth/core/guards/jwt-auth.guard';
import { JwtPayload } from '../auth/core/strategies/jwt-payload.type';
import { UserService } from './user.service';

@Controller({
  path: 'users',
})
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Delete('me')
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.NO_CONTENT)
  softDelete(@Req() request: Request & { user: JwtPayload }): Promise<void> {
    return this.userService.softDelete(request.user.sub);
  }
}
