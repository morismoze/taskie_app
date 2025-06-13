import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TypeOrmConfigLoadService } from 'src/database/typeorm-config.service';
import { DataSource, DataSourceOptions } from 'typeorm';

@Module({
  imports: [
    TypeOrmModule.forRootAsync({
      useClass: TypeOrmConfigLoadService,
      dataSourceFactory: async (options?: DataSourceOptions) => {
        if (!options) {
          throw new Error(`Data source options is undefined`);
        }
        return await new DataSource(options).initialize();
      },
    }),
  ],
})
export class DatabaseModule {}
