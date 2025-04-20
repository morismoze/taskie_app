import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { TypeOrmModuleOptions, TypeOrmOptionsFactory } from '@nestjs/typeorm';
import { AggregatedConfig } from 'src/modules/app-config/config/config.model';

// 2nd way of configuring TypeORM
// used inside NestJS context, typically for dynamic bootstrapping via DI

@Injectable()
export class TypeOrmConfigLoadService implements TypeOrmOptionsFactory {
  constructor(private configService: ConfigService<AggregatedConfig>) {}

  createTypeOrmOptions(): TypeOrmModuleOptions {
    return {
      type: this.configService.get('database.type', { infer: true }),
      host: this.configService.get('database.host', { infer: true }),
      database: this.configService.get('database.name', { infer: true }),
      username: this.configService.get('database.username', { infer: true }),
      port: this.configService.get('database.port', { infer: true }),
      password: this.configService.get('database.password', { infer: true }),
      dropSchema: false,
      keepConnectionAlive: true,
      logging:
        this.configService.get('app.nodeEnv', { infer: true }) !== 'production',
      entities: [__dirname + '/../**/*.entity{.ts,.js}'],
      migrations: [__dirname + '/migrations/**/*{.ts,.js}'],
    } as TypeOrmModuleOptions;
  }
}
