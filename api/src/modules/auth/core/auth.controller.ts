import {
  Body,
  Controller,
  Delete,
  HttpCode,
  HttpStatus,
  Post,
  Req,
  UseGuards,
} from '@nestjs/common';
import { Request } from 'express';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/api-http-exception.type';
import { AuthService } from './auth.service';
import { RequestWithUser } from './domain/request-with-user.domain';
import { TokenRefreshRequest } from './dto/token-refresh-request.dto';
import { TokenRefreshResponse } from './dto/token-refresh-response.dto';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { JwtRefreshAuthGuard } from './guards/jwt-refresh-auth.guard';
import { JwtRefreshPayload } from './strategies/jwt-refresh-payload.type';

@Controller({
  path: 'auth',
})
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('refresh')
  @UseGuards(JwtRefreshAuthGuard)
  @HttpCode(HttpStatus.OK)
  refresh(
    @Req() request: Request & { user: JwtRefreshPayload },
    @Body() _: TokenRefreshRequest,
  ): Promise<TokenRefreshResponse> {
    return this.authService.refreshToken(request.user);
  }

  @Delete('logout')
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.NO_CONTENT)
  public async logout(@Req() request: RequestWithUser): Promise<void> {
    throw new ApiHttpException(
      {
        code: ApiErrorCode.SERVER_ERROR,
      },
      HttpStatus.INTERNAL_SERVER_ERROR,
    );
    return this.authService.logout(request.user);
  }
}
