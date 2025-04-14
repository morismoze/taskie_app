import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Status } from './status.entity';

@Injectable()
export class StatusRepository extends Repository<Status> {
  constructor(
    @InjectRepository(Status)
    private readonly statusRepository: Repository<Status>,
  ) {
    super(
      statusRepository.target,
      statusRepository.manager,
      statusRepository.queryRunner,
    );
  }
}
