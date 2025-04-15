import {
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
} from '@nestjs/common';
import { UserDto } from './dto/user.dto';
import { UserService } from './user.service';

@Controller({
  path: 'user',
})
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Get('all')
  @HttpCode(HttpStatus.OK)
  all(): Promise<UserDto[]> {
    return this.userService.findAll();
  }

  @Delete(':uid')
  @HttpCode(HttpStatus.OK)
  delete(@Param('uid') uid: string): Promise<void> {
    return this.userService.softDelete(uid);
  }
}
