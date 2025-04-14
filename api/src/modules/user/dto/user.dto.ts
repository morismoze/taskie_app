import { Exclude, Expose, Transform, Type } from 'class-transformer';
import { IsDate, IsString } from 'class-validator';
import { RoleDto } from 'src/modules/role/dto/role.dto';
import { StatusDto } from 'src/modules/status/dto/status.dto';

@Exclude()
export class UserDto {
  @Expose()
  @IsString()
  uid: string;

  @Expose()
  @IsString()
  email: string;

  @Expose()
  @IsString()
  firstName: string;

  @Expose()
  @IsString()
  lastName: string;

  @Expose()
  @Type(() => RoleDto)
  @Transform(({ value }) => (value.name ? value.name : value))
  role: RoleDto['name'];

  @Expose()
  @Type(() => StatusDto)
  @Transform(({ value }) => (value.name ? value.name : value))
  status: StatusDto['name'];

  @Expose()
  @IsDate()
  createdAt: Date;
}
