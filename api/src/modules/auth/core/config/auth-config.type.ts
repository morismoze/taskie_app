export type AuthConfig = {
  secret: string;
  expires: number;
  refreshSecret: string;
  refreshExpires: number;
};
