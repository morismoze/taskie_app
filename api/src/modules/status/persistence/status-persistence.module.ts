import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Status } from './status.entity';
import { StatusRepository } from './status.repository';

@Module({
  imports: [TypeOrmModule.forFeature([Status])],
  providers: [StatusRepository],
  exports: [StatusRepository],
})
export class StatusPersistenceModule {}
