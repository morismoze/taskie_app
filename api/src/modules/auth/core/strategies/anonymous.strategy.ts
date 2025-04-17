import { Strategy } from 'passport-anonymous';
import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';

@Injectable()
export class AnonymousStrategy extends PassportStrategy(Strategy) {
  constructor() {
    super();
  }

  public validate(payload: unknown, request: unknown): unknown {
    // passport-anonymous puts undefined for req.user
    return request;
  }
}
