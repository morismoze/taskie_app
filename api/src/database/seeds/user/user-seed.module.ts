import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Role } from 'src/modules/workspace/workspace-role.entity';
import { Status } from 'src/modules/user/user-status-module/persistence/user-status.entity';
import { UserEntity } from 'src/modules/user/persistence/user.entity';
import { UserSeedService } from './user-seed.service';

@Module({
  imports: [TypeOrmModule.forFeature([UserEntity, Role, Status])],
  providers: [UserSeedService],
  exports: [UserSeedService],
})
export class UserSeedModule {}
