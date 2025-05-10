export interface Leaderboard {
  id: string;
  firstName: string;
  lastName: string;
  profileImageUrl: string | null;
  accumulatedPoints: number;
}

export type LeaderboardResponse = Leaderboard[];
