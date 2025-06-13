import {
  CallHandler,
  ExecutionContext,
  HttpStatus,
  Injectable,
  NestInterceptor,
} from '@nestjs/common';
import { map, Observable } from 'rxjs';
import { ApiResponse } from '../types/api-response.type';

@Injectable()
export class ResponseTransformerInterceptor<T>
  implements NestInterceptor<T, ApiResponse<T> | null>
{
  intercept(
    context: ExecutionContext,
    next: CallHandler,
  ): Observable<ApiResponse<T> | null> {
    return next.handle().pipe(
      map((data) => {
        const httpContext = context.switchToHttp();
        const response = httpContext.getResponse();
        const statusCode = response.statusCode;

        if (statusCode === HttpStatus.NO_CONTENT) {
          return null;
        }

        return { data, error: null };
      }),
    );
  }
}
