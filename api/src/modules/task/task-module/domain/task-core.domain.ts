import { RootDomain } from 'src/modules/database/domain/root.domain';

export interface TaskCore extends RootDomain {
  title: string;
  rewardPoints: number;
  description: string | null;
  dueDate: string | null;
}
