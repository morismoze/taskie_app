export type LoginResponse = {
  accessToken: string;
  refreshToken: string;
  tokenExpires: number;
  user: {
    id: string;
    firstName: string;
    lastName: string;
    email: string | null;
    profileImageUrl: string | null;
    createdAt: string;
  };
};
