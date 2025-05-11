import {
  CallHandler,
  ExecutionContext,
  Injectable,
  Logger,
  NestInterceptor,
} from '@nestjs/common';
import { Request } from 'express';
import { Observable } from 'rxjs';
import { RequestMetadata } from '../types/request-metadata.type';

@Injectable()
export class RequestMetadataProcessingInterceptor implements NestInterceptor {
  private readonly logger = new Logger(
    RequestMetadataProcessingInterceptor.name,
  );

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
    };

    request.metadata = metadata;

    this.logger.log(
      `[${method}] ${url} - IP: ${ip} - User-Agent: ${userAgent}`,
    );

    return next.handle();
  }
}
