import {
  CallHandler,
  ExecutionContext,
  Injectable,
  NestInterceptor,
} from '@nestjs/common';
import { ClsService } from 'nestjs-cls';
import { Observable } from 'rxjs';
import { JwtPayload } from 'src/modules/auth/core/strategies/jwt-payload.type';
import { CLS_CONTEXT_USER_ID_KEY } from '../helper/constants';

// User ID
export type UserClsContext = string;

// Not a Middleware, but rather a Interceptor because, even though
// Inteceptors execute after guards, it doesn't make sense to execute
// it on 401 responses. Also guards read the user also from the request
// so no need to inject CLS service in them. We use CLS service in other services.
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
      this.cls.set<UserClsContext>(CLS_CONTEXT_USER_ID_KEY, user.sub);
    }

    return next.handle();
  }
}
