import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Role } from 'src/modules/role/persistence/role.entity';
import { Status } from 'src/modules/status/persistence/status.entity';
import { User } from 'src/modules/user/persistence/user.entity';
import { UserSeedService } from './user-seed.service';

@Module({
  imports: [TypeOrmModule.forFeature([User, Role, Status])],
  providers: [UserSeedService],
  exports: [UserSeedService],
})
export class UserSeedModule {}
