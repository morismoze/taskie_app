import {
  Controller,
  Delete,
  HttpCode,
  HttpStatus,
  Post,
  Req,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiInternalServerErrorResponse,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { Request } from 'express';
import { AuthService } from './auth.service';
import { RequestWithUser } from './domain/request-with-user.domain';
import { TokenRefreshResponse } from './dto/token-refresh-response.dto';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { JwtRefreshAuthGuard } from './guards/jwt-refresh-auth.guard';
import { JwtRefreshPayload } from './strategies/jwt-refresh-payload.type';

@ApiTags('Auth')
@ApiBearerAuth()
@Controller({
  path: 'auth',
  version: '1',
})
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('refresh')
  @UseGuards(JwtRefreshAuthGuard)
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Refresh access token (use refresh token in the Bearer header)',
  })
  @ApiOkResponse({
    type: TokenRefreshResponse,
  })
  @ApiUnauthorizedResponse({
    description: 'Invalid refresh token',
  })
  @ApiInternalServerErrorResponse({
    description: 'Internal error while updating the session',
  })
  refreshToken(
    @Req() request: Request & { user: JwtRefreshPayload },
  ): Promise<TokenRefreshResponse> {
    return this.authService.refreshToken(request.user);
  }

  @Delete('logout')
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({
    summary: 'Logout the user',
  })
  @ApiNoContentResponse()
  @ApiUnauthorizedResponse({
    description: 'Invalid access token',
  })
  public async logout(@Req() request: RequestWithUser): Promise<void> {
    return this.authService.logout(request.user);
  }
}
