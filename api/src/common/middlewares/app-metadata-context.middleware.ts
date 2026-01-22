import { Injectable, NestMiddleware } from '@nestjs/common';
import { NextFunction, Request } from 'express';
import { ClsService } from 'nestjs-cls';
import { CLS_CONTEXT_APP_METADATA_KEY } from '../helper/constants';

export interface AppMetadataClsContext {
  deviceModel: string | null;
  osVersion: string | null;
  appVersion: string | null;
  buildNumber: string | null;
}

// Implemented as Middleware to ensure execution before Guards (auth guards implement JWT strategies).
// This guarantees that metadata is captured in CLS even for 401 Unauthorized requests,
// allowing us to log device info (e.g., app version) during auth failures.
@Injectable()
export class AppMetadataContextMiddleware implements NestMiddleware {
  constructor(private readonly cls: ClsService) {}

  use(req: Request, res: Response, next: NextFunction) {
    const headers = req.headers;

    const metadata: AppMetadataClsContext = {
      deviceModel: (headers['x-device-model'] as string) || null,
      osVersion: (headers['x-os-version'] as string) || null,
      appVersion: (headers['x-app-version'] as string) || null,
      buildNumber: (headers['x-build-number'] as string) || null,
    };

    this.cls.set<AppMetadataClsContext>(CLS_CONTEXT_APP_METADATA_KEY, metadata);

    next();
  }
}
