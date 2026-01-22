import { AppMetadataContext } from 'src/common/types/request-metadata.type';

declare module 'express' {
  interface Request {
    metadata: AppMetadataContext;
  }
}
