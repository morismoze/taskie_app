import { GoalCore } from './goal-core.domain';

export interface GoalWithAssigneeUserCore extends GoalCore {
  assignee: {
    id: string;
    firstName: string;
    lastName: string;
    profileImageUrl: string | null;
  };
  createdBy: {
    id: string; // workspace user ID
    firstName: string;
    lastName: string;
    profileImageUrl: string | null;
  } | null;
}
