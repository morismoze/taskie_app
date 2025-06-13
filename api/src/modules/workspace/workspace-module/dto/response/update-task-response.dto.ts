export interface UpdateTaskResponse {
  id: string;
  title: string;
  description: string | null;
  rewardPoints: number;
  dueDate: string | null;
}
