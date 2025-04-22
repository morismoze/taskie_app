import {
  CallHandler,
  ExecutionContext,
  Injectable,
  NestInterceptor,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { RequestMetadata } from '../types/request-metadata.type';

@Injectable()
export class RequestMetadataProcessingInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const headers = request.headers;

    const metadata: RequestMetadata = {
      deviceId: headers['x-device-id'] || null,
      deviceModel: headers['x-device-model'] || null,
      osVersion: headers['x-os-version'] || null,
      appVersion: headers['x-app-version'] || null,
    };

    request.metadata = metadata;

    return next.handle();
  }
}
