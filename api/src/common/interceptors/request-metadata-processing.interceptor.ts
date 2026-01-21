import {
  CallHandler,
  ExecutionContext,
  Injectable,
  NestInterceptor,
} from '@nestjs/common';
import { Request } from 'express';
import { Observable } from 'rxjs';
import { AppLogger } from 'src/modules/logger/app-logger';
import { RequestMetadata } from '../types/request-metadata.type';

@Injectable()
export class RequestMetadataProcessingInterceptor implements NestInterceptor {
  constructor(private readonly logger: AppLogger) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest<Request>();
    const headers = request.headers;
    const url = request.url;
    const method = request.method;
    const ip = request.ip;
    const userAgent = request.headers['user-agent'] || 'unknown';
    const metadata: RequestMetadata = {
      deviceModel: (headers['x-device-model'] as string) || null,
      osVersion: (headers['x-os-version'] as string) || null,
      appVersion: (headers['x-app-version'] as string) || null,
      buildNumber: (headers['x-build-number'] as string) || null,
    };

    request.metadata = metadata;

    this.logger.log(
      {
        msg: `Incoming Request [${method}] ${url}`,
        req: { method, url, ip, userAgent },
        metadata: metadata,
      },
      RequestMetadataProcessingInterceptor.name,
    );

    return next.handle();
  }
}
