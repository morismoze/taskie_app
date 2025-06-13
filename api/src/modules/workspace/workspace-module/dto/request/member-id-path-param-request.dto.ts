import { IsNotEmpty, IsUUID } from 'class-validator';

export class MemberIdRequestPathParam {
  @IsNotEmpty()
  @IsUUID()
  memberId: string;

  constructor(memberId: string) {
    this.memberId = memberId;
  }
}
