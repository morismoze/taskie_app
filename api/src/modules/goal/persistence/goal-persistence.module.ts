import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { GoalEntity } from './goal.entity';
import { GoalRepository } from './goal.repository';
import { GoalRepositoryImpl } from './goal.repository.impl';

@Module({
  imports: [TypeOrmModule.forFeature([GoalEntity])],
  providers: [
    {
      provide: GoalRepository,
      useClass: GoalRepositoryImpl,
    },
  ],
  exports: [GoalRepository],
})
export class GoalPersistenceModule {}
