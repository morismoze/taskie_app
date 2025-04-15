import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UserStatus } from './user-status.entity';

@Injectable()
export class UserStatusRepository extends Repository<UserStatus> {
  constructor(
    @InjectRepository(UserStatus)
    private readonly statusRepository: Repository<UserStatus>,
  ) {
    super(
      statusRepository.target,
      statusRepository.manager,
      statusRepository.queryRunner,
    );
  }
}
