import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Status } from 'src/modules/status/persistence/status.entity';
import { StatusEnum } from 'src/modules/status/status.enum';
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
