import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Status } from 'src/modules/user/user-status-module/persistence/user-status.entity';
import { StatusEnum } from 'src/modules/user/user-status-module/user-status.enum';
import { Repository } from 'typeorm';

@Injectable()
export class StatusSeedService {
  constructor(
    @InjectRepository(Status)
    private repository: Repository<Status>,
  ) {}

  async run() {
    const count = await this.repository.count();

    if (!count) {
      await this.repository.save([
        this.repository.create({
          name: StatusEnum.active,
        }),
        this.repository.create({
          name: StatusEnum.inactive,
        }),
      ]);
    }
  }
}
