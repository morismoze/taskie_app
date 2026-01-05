import { Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { jwtRefrestStrategyName } from '../strategies/jwt-refresh.strategy';

@Injectable()
export class JwtRefreshAuthGuard extends AuthGuard(jwtRefrestStrategyName) {}
