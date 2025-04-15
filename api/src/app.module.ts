import { Module } from '@nestjs/common';
import { AuthModule } from './modules/auth/auth.module';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TypeOrmConfigLoadService } from './database/typeorm-config.service';
import { DataSource, DataSourceOptions } from 'typeorm';

import { UserModule } from './modules/user/user.module';
import { DatabaseModule } from './modules/database/database.module';
import { ApiConfigModule } from './modules/app-config/app-config.module';

@Module({
  imports: [ApiConfigModule, DatabaseModule, AuthModule, UserModule],
})
export class AppModule {}
