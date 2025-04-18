import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { PassportModule } from '@nestjs/passport';
import { JwtModule } from '@nestjs/jwt';
import { AuthController } from './auth.controller';
import { JwtStrategy } from './strategies/jwt.strategy';
import { JwtRefreshStrategy } from './strategies/jwt-refresh.strategy';
import { UserModule } from 'src/modules/user/user.module';
import { WorkspaceUserModule } from 'src/modules/workspace/workspace-user-module/workspace-user.module';
import { SessionModule } from 'src/modules/session/session.module';

@Module({
  imports: [
    UserModule,
    WorkspaceUserModule,
    SessionModule,
    PassportModule,
    JwtModule.register({}),
  ],
  controllers: [AuthController],
  providers: [AuthService, JwtStrategy, JwtRefreshStrategy],
  exports: [AuthService],
})
export class AuthModule {}
