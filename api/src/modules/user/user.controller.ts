import {
  Controller,
  Delete,
  HttpCode,
  HttpStatus,
  Param,
} from '@nestjs/common';
import { UserService } from './user.service';

@Controller({
  path: 'user',
})
export class UserController {
  constructor(private readonly userService: UserService) {}

  /**
   * This endpoint is invoked when a user wants to delete itself from the system
   * or when a Manager wants to delete virtual user from the system
   */
  @Delete(':id')
  @HttpCode(HttpStatus.OK)
  softDelete(@Param('id') id: string): Promise<void> {
    return this.userService.softDelete(id);
  }
}
