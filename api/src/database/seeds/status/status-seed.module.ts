import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Status } from 'src/modules/status/persistence/status.entity';
import { StatusSeedService } from './status-seed.service';

@Module({
  imports: [TypeOrmModule.forFeature([Status])],
  providers: [StatusSeedService],
  exports: [StatusSeedService],
})
export class StatusSeedModule {}
