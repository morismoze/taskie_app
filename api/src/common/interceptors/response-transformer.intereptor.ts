import {
  CallHandler,
  ExecutionContext,
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
    _context: ExecutionContext,
    next: CallHandler,
  ): Observable<ApiResponse<T> | null> {
    return next.handle().pipe(
      map((data) => {
        if (data === undefined) {
          return null;
        }

        return { data, error: null };
      }),
    );
  }
}
