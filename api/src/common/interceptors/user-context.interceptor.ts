import {
  CallHandler,
  ExecutionContext,
  Injectable,
  NestInterceptor,
} from '@nestjs/common';
import { ClsService } from 'nestjs-cls';
import { Observable } from 'rxjs';
import { JwtPayload } from 'src/modules/auth/core/strategies/jwt-payload.type';

@Injectable()
export class UserContextInterceptor implements NestInterceptor {
  constructor(private readonly cls: ClsService) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const user: JwtPayload = request.user; // This is returned by the JWT strategy

    if (user && user.sub) {
      // Save userId to the CLS context - now it is available in any place
      // throughout the app. This is needed to be done this way, using
      // the async local storage, because userId is per request. If we
      // would e.g. set userId on the logger class, parallel requests
      // would overwrite it.
      this.cls.set('userId', user.sub);
    }

    return next.handle();
  }
}
