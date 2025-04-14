import { Injectable } from '@nestjs/common';
import { Nullable } from 'src/common/types/nullable.type';
import { Status } from './persistence/status.entity';
import { StatusRepository } from './persistence/status.repository';
import { FindOneOptions } from 'typeorm';

@Injectable()
export class StatusService {
  constructor(private readonly statusRepository: StatusRepository) {}

  async findOne(fields: FindOneOptions<Status>): Promise<Nullable<Status>> {
    return this.statusRepository.findOne(fields);
  }
}
