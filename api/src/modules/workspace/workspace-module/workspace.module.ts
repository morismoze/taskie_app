import { Module } from '@nestjs/common';
import { WorkspacePersistenceModule } from './persistence/workspace-persistence.module';

@Module({
  imports: [WorkspacePersistenceModule],
})
export class WorkspaceModule {}
