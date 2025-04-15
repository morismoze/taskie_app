import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TypeOrmConfigLoadService } from 'src/database/typeorm-config.service';
import { DataSource, DataSourceOptions } from 'typeorm';

@Module({
  imports: [
    // bootstraps a TypeORM database connection dynamically, using config that's loaded via ConfigService
    TypeOrmModule.forRootAsync({
      // uses TypeOrmConfigLoadService service to load DB config
      useClass: TypeOrmConfigLoadService,
      // initializes and returns a TypeORM DataSource
      dataSourceFactory: async (options: DataSourceOptions) => {
        return new DataSource(options).initialize();
      },
    }),
  ],
})
export class DatabaseModule {}
