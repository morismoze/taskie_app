import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { TypeOrmModuleOptions, TypeOrmOptionsFactory } from '@nestjs/typeorm';
import { AggregatedConfig } from 'src/config/config.type';

// TypeORM config used inside NestJS context, typically for dynamic bootstrapping via DI

@Injectable()
export class TypeOrmConfigLoadService implements TypeOrmOptionsFactory {
  constructor(private configService: ConfigService<AggregatedConfig>) {}

  createTypeOrmOptions(): TypeOrmModuleOptions {
    return {
      type: this.configService.get('database.type', { infer: true }),
      host: this.configService.get('database.host', { infer: true }),
      port: this.configService.get('database.port', { infer: true }),
      database: this.configService.get('database.name', { infer: true }),
      username: this.configService.get('database.username', { infer: true }),
      password: this.configService.get<string>('database.password', {
        infer: true,
      }),
      dropSchema: false,
      entities: [__dirname + '/../modules/**/*.entity{.ts,.js}'],
      migrations: [__dirname + '/migrations/**/*{.ts,.js}'],
      poolSize: this.configService.get('database.poolSize', { infer: true }),
    } as TypeOrmModuleOptions;
  }
}
