import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Role } from 'src/modules/workspace/role-module/persistence/workspace-role.entity';
import { Status } from 'src/modules/user/user-status-module/persistence/user-status.entity';
import { User } from 'src/modules/user/persistence/user.entity';
import { UserSeedService } from './user-seed.service';

@Module({
  imports: [TypeOrmModule.forFeature([User, Role, Status])],
  providers: [UserSeedService],
  exports: [UserSeedService],
})
export class UserSeedModule {}
