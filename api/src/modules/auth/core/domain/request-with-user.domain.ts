import { Request } from 'express';
import { JwtPayload } from '../strategies/jwt-payload.type';

export interface RequestWithUser extends Request {
  user: JwtPayload;
}
