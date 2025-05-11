import { GoalCore } from './goal-core.domain';

export interface GoalWithAssigneeCore extends GoalCore {
  accumulatedPoints: number;
  assignee: {
    id: string;
    firstName: string;
    lastName: string;
    profileImageUrl: string | null;
  };
}
