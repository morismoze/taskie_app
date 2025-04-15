import { Injectable } from '@nestjs/common';
import { Nullable } from 'src/common/types/nullable.type';
import { UserStatus } from './persistence/user-status.entity';
import { UserStatusRepository } from './persistence/user-status.repository';
import { FindOneOptions } from 'typeorm';

@Injectable()
export class UserStatusService {
  constructor(private readonly statusRepository: UserStatusRepository) {}

  async findOne(
    fields: FindOneOptions<UserStatus>,
  ): Promise<Nullable<UserStatus>> {
    return this.statusRepository.findOne(fields);
  }
}
