export interface LeaderboardUserResponse {
  id: string; // WorkspaceUser ID
  firstName: string;
  lastName: string;
  profileImageUrl: string | null;
  accumulatedPoints: number;
  completedTasks: number;
}

export type WorkspaceLeaderboardResponse = LeaderboardUserResponse[];
