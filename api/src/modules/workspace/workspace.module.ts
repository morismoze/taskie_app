import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Workspace } from '../persistence/workspace.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Workspace, WorkspaceUser])],
  providers: [WorkspaceService],
  controllers: [WorkspaceController],
  exports: [WorkspaceService],
})
export class WorkspaceModule {}
