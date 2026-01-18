import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { HealthCheckResult, HealthCheckStatus } from '@nestjs/terminus';

enum HealthCheckStatusEnum {
  OK = 'ok',
  ERROR = 'error',
  SHUTTING_DOWN = 'shutting_down',
}

enum HealthIndicatorStatusEnum {
  UP = 'up',
  DOWN = 'down',
}

class HealthMetricBaseDto {
  @ApiProperty({ enum: HealthIndicatorStatusEnum })
  status!: HealthIndicatorStatusEnum;
}

class HealthMetricDto extends HealthMetricBaseDto {
  @ApiPropertyOptional({ example: 'Connection timeout' })
  message?: string;
}

class HealthIndicatorsDto {
  @ApiPropertyOptional({ type: HealthMetricDto })
  database?: HealthMetricDto;

  @ApiPropertyOptional({ type: HealthMetricDto })
  memory_heap?: HealthMetricDto;

  @ApiPropertyOptional({ type: HealthMetricDto })
  memory_rss?: HealthMetricDto;

  @ApiPropertyOptional({ type: HealthMetricDto })
  storage?: HealthMetricDto;

  // To satisfy TypeScript's index signature requirement
  [key: string]: any;
}

class HealthIndicatorsInfoDto {
  @ApiPropertyOptional({ type: HealthMetricBaseDto })
  database?: HealthMetricBaseDto;

  @ApiPropertyOptional({ type: HealthMetricBaseDto })
  memory_heap?: HealthMetricBaseDto;

  @ApiPropertyOptional({ type: HealthMetricBaseDto })
  memory_rss?: HealthMetricBaseDto;

  @ApiPropertyOptional({ type: HealthMetricBaseDto })
  storage?: HealthMetricBaseDto;

  // To satisfy TypeScript's index signature requirement
  [key: string]: any;
}

export class HealthLivenessResponse implements HealthCheckResult {
  @ApiProperty({ enum: HealthCheckStatusEnum })
  status!: HealthCheckStatus; // To satisfy TypeScript

  @ApiPropertyOptional({
    type: HealthIndicatorsInfoDto,
    description:
      'The info object contains information of each health indicator which is of status "up"',
  })
  info?: HealthIndicatorsInfoDto;

  @ApiPropertyOptional({
    type: HealthIndicatorsDto,
    description:
      'The error object contains information of each health indicator which is of status "down"',
  })
  error?: Partial<HealthIndicatorsDto>;

  @ApiPropertyOptional({
    type: HealthIndicatorsDto,
    description:
      'The details object contains information of every health indicator',
  })
  details!: HealthIndicatorsDto;
}
