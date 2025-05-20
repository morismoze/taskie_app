import { GoalCore } from './goal-core.domain';

export interface GoalWithAssigneeUserCore extends GoalCore {
  assignee: {
    id: string;
    firstName: string;
    lastName: string;
    profileImageUrl: string | null;
  };
}
