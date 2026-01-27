import { Module } from '@nestjs/common';
import { LoggerModule } from 'nestjs-pino';
import { LoggerMobileController } from './logger-mobile.controller';

@Module({
  imports: [LoggerModule],
  controllers: [LoggerMobileController],
})
export class LoggerMobileModule {}
