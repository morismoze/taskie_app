import { LoginResponse } from './login-response.dto';

export type TokenRefreshResponse = Omit<LoginResponse, 'user'>;
