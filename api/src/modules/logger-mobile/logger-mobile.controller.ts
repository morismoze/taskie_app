import {
  Body,
  Controller,
  HttpCode,
  HttpStatus,
  Post,
  Req,
} from '@nestjs/common';
import { ApiNoContentResponse, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Request } from 'express';
import { AppLogger } from '../logger/app-logger';
import {
  CreateMobileLogRequest,
  LogLevel,
} from './dto/request/create-mobile-log-request.dto';

@ApiTags('Mobile App Telemetry')
@Controller({
  path: 'mobile-logs',
  version: '1',
})
export class LoggerMobileController {
  constructor(private readonly logger: AppLogger) {}

  @Post()
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({
    summary:
      'Gathers logs from the mobile app and sends to the logging service',
  })
  @ApiNoContentResponse()
  logFromMobile(@Req() request: Request, @Body() data: CreateMobileLogRequest) {
    const { userId, level, message, context, stackTrace } = data;

    const logPayload = {
      userId,
      message,
      // This is important, as it is the only way to filter logs on Grafana
      source: 'taskie-app',
      ip: request.ip,
    };

    if ([LogLevel.ERROR, LogLevel.FATAL].includes(level)) {
      this.logger.error(logPayload, stackTrace, context);
    } else if (level === LogLevel.WARN) {
      this.logger.warn(logPayload, context);
    }
  }
}
