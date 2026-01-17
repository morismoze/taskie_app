import { Controller, Get } from '@nestjs/common';
import {
  ApiOkResponse,
  ApiOperation,
  ApiServiceUnavailableResponse,
  ApiTags,
} from '@nestjs/swagger';
import {
  DiskHealthIndicator,
  HealthCheck,
  HealthCheckService,
  MemoryHealthIndicator,
  TypeOrmHealthIndicator,
} from '@nestjs/terminus';
import { HealthLivenessResponse } from './dto/response/health-liveness-response.dto';

@ApiTags('Health')
@Controller({
  path: 'health',
  version: '1',
})
export class HealthController {
  constructor(
    private readonly health: HealthCheckService,
    private readonly db: TypeOrmHealthIndicator,
    private readonly memory: MemoryHealthIndicator,
    private readonly disk: DiskHealthIndicator,
  ) {}

  @Get('liveness')
  @ApiOperation({
    summary: 'Get liveness health check status',
  })
  @ApiOkResponse({
    type: HealthLivenessResponse,
  })
  // For some reason, it looks like the Terminus package
  // builds 503 response Swagger doc, and it is not correct
  // as it mentions redis service, so this is overridden here
  @ApiServiceUnavailableResponse({
    description: 'The Health Check is not successful',
  })
  @HealthCheck()
  check(): Promise<HealthLivenessResponse> {
    return this.health.check([
      // 'database' is the key in the returned JSON object
      // and timeout is set in the case the database is not
      // responding
      () => this.db.pingCheck('database', { timeout: 1500 }),
      // Checks JavaScript heap (objects, variables, closures, etc).
      // If heap size is more than 150MB, it will return error.
      () => this.memory.checkHeap('memory_heap', 150 * 1024 * 1024),
      // Checks Resident Set Size - the portion of memory occupied by
      // the whole NestJS process on the server RAM. This counts
      // code segment, stack, and heap. If RSS is more than 150MB,
      // it will return error.
      () => this.memory.checkRSS('memory_rss', 300 * 1024 * 1024),
      // If disc space gets over 80% used, it will return error.
      // '/' path is used to check the root partition, but inside
      // the Docker container, it checks the whole container's
      // allocated storage.
      () =>
        this.disk.checkStorage('storage', { thresholdPercent: 0.8, path: '/' }),
    ]);
  }
}
