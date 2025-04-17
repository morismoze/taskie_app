import { Module } from '@nestjs/common';
import { AppConfigModule } from 'src/modules/app-config/app-config.module';
import { DatabaseModule } from 'src/modules/database/database.module';
import { RoleSeedModule } from './role/role-seed.module';
import { StatusSeedModule } from './status/status-seed.module';
import { UserSeedModule } from './user/user-seed.module';

@Module({
  imports: [
    RoleSeedModule,
    StatusSeedModule,
    UserSeedModule,
    DatabaseModule,
    AppConfigModule,
  ],
})
export class SeedModule {}
