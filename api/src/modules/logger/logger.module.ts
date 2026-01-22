import { Global, Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { LoggerModule } from 'nestjs-pino';
import { Environment } from 'src/config/app.config';
import { AggregatedConfig } from 'src/config/config.type';
import { AppLogger } from './app-logger';
import { PinoAppLogger } from './pino-app-logger.adapter';

@Global()
@Module({
  imports: [
    LoggerModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (configService: ConfigService<AggregatedConfig>) => {
        const env = configService.getOrThrow('app.nodeEnv', { infer: true });
        const isProd = env === Environment.PRODUCTION;

        return {
          pinoHttp: {
            // On production we want only the warn/error levels
            level: isProd ? 'warn' : 'debug',

            // In prod use 'pino-loki' to send to Grafana Loki logs
            // In development use 'pino-pretty' for nice console print
            transport: isProd
              ? {
                  target: 'pino-loki',
                  options: {
                    batching: true, // Send logs in groups (better perf)
                    interval: 5, // Every 5 seconds send a package
                    host: configService.getOrThrow('grafana.logs.loki.host', {
                      infer: true,
                    }),
                    basicAuth: {
                      username: configService.getOrThrow(
                        'grafana.logs.loki.user',
                        {
                          infer: true,
                        },
                      ),
                      password: configService.getOrThrow(
                        'grafana.logs.loki.apiKey',
                        {
                          infer: true,
                        },
                      ),
                    },
                    labels: { app: 'taskie-api', env: env },
                  },
                }
              : {
                  target: 'pino-pretty',
                  options: {
                    singleLine: true,
                    translateTime: 'SYS:yyyy-mm-dd HH:MM:ss',
                    ignore: 'pid,hostname',
                  },
                },
            autoLogging: false, // Stop logging every HTTP request
          },
        };
      },
    }),
  ],
  providers: [{ provide: AppLogger, useClass: PinoAppLogger }],
  exports: [AppLogger],
})
export class AppLoggerModule {}
