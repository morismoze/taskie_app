import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { GoalEntity } from './goal.entity';

@Module({
  imports: [TypeOrmModule.forFeature([GoalEntity])],
  providers: [],
  exports: [],
})
export class GoalPersistenceModule {}
