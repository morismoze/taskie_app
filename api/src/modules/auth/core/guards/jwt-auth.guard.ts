import { Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { jwtStrategyName } from '../strategies/jwt.strategy';

@Injectable()
export class JwtAuthGuard extends AuthGuard(jwtStrategyName) {}
