import { HttpStatus, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { AggregatedConfig } from 'src/config/config.model';
import ms from 'ms';
import { User } from 'src/modules/user/persistence/user.entity';
import { LoginRequestDto } from './dto/login-request.dto';
import { LoginResponseDto } from './dto/login-response.dto';
import bcrypt from 'bcryptjs';
import { JwtPayload } from './strategies/models/jwt-payload.model';
import { UserService } from '../user/user.service';
import { UserDto } from '../user/dto/user.dto';
import { StatusEnum } from '../status/status.enum';
import { plainToInstance } from 'class-transformer';
import { RegisterRequestDto } from './dto/register-request.dto';
import { RoleEnum } from '../role/role.enum';
import { ERROR_CODES } from 'src/exception/error-codes';
import { ApiHttpException } from 'src/exception/ApiHttpException.model';

@Injectable()
export class AuthService {
  constructor(
    private readonly jwtService: JwtService,
    private readonly userService: UserService,
    private readonly configService: ConfigService<AggregatedConfig>,
  ) {}

  async register(registerDto: RegisterRequestDto): Promise<LoginResponseDto> {
    const createdUser = await this.userService.create({
      ...registerDto,
      role: {
        name: RoleEnum.user,
      },
      status: {
        name: StatusEnum.active,
      },
    });
    const { token, refreshToken, tokenExpires } = await this.getTokensData({
      uid: createdUser.uid,
      role: createdUser.role,
    });

    return {
      token,
      refreshToken,
      tokenExpires,
      user: plainToInstance(UserDto, createdUser),
    };
  }

  async login(authDto: LoginRequestDto): Promise<LoginResponseDto> {
    const user = await this.userService.findOne({
      where: {
        email: authDto.email,
      },
    });

    if (!user) {
      throw new ApiHttpException(
        {
          field: 'email',
          message: ERROR_CODES.INVALID_CREDENTIALS.message,
        },
        HttpStatus.UNPROCESSABLE_ENTITY,
      );
    }

    if (user.status.name === StatusEnum.inactive) {
      throw new ApiHttpException(
        {
          field: 'status',
          message: ERROR_CODES.INVALID_CREDENTIALS.message,
        },
        HttpStatus.UNPROCESSABLE_ENTITY,
      );
    }

    const isValidPassword = await bcrypt.compare(
      authDto.password,
      user.password,
    );

    if (!isValidPassword) {
      throw new ApiHttpException(
        {
          field: 'password',
          message: ERROR_CODES.INVALID_CREDENTIALS.message,
        },
        HttpStatus.UNPROCESSABLE_ENTITY,
      );
    }

    const { token, refreshToken, tokenExpires } = await this.getTokensData({
      uid: user.uid,
      role: user.role,
    });

    return {
      refreshToken,
      token,
      tokenExpires,
      user: plainToInstance(UserDto, user),
    };
  }

  async me(userJwtPayload: JwtPayload): Promise<UserDto> {
    const user = this.userService.findOne({
      where: {
        uid: userJwtPayload.sub,
      },
    });

    return plainToInstance(UserDto, user);
  }

  async refreshToken(
    data: Omit<JwtPayload, 'role'>,
  ): Promise<Omit<LoginResponseDto, 'user'>> {
    const user = await this.userService.findOne({
      where: {
        uid: data.sub,
      },
    });

    const { token, refreshToken, tokenExpires } = await this.getTokensData({
      uid: user!.uid,
      role: user!.role,
    });

    return {
      token,
      refreshToken,
      tokenExpires,
    };
  }

  private async getTokensData(data: { uid: User['uid']; role: User['role'] }) {
    const tokenExpiresIn = this.configService.getOrThrow('auth.expires', {
      infer: true,
    });
    const refreshTokenExpiresIn = this.configService.getOrThrow(
      'auth.refreshExpires',
      {
        infer: true,
      },
    );
    const tokenExpires = Date.now() + ms(tokenExpiresIn);
    const refreshTokenExpires = Date.now() + ms(refreshTokenExpiresIn);

    const [token, refreshToken] = await Promise.all([
      await this.jwtService.signAsync(
        {
          sub: data.uid,
          role: data.role,
        },
        {
          secret: this.configService.getOrThrow('auth.secret', { infer: true }),
          expiresIn: tokenExpiresIn,
        },
      ),
      await this.jwtService.signAsync(
        {
          sub: data.uid,
        },
        {
          secret: this.configService.getOrThrow('auth.refreshSecret', {
            infer: true,
          }),
          expiresIn: refreshTokenExpires,
        },
      ),
    ]);

    return {
      token,
      refreshToken,
      tokenExpires,
    };
  }
}
