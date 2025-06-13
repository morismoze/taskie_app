import { RootDomain } from 'src/modules/database/domain/root.domain';

export interface WorkspaceCore extends RootDomain {
  name: string;
  description: string | null;
  pictureUrl: string | null;
}
