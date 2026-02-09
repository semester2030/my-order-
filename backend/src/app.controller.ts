import { Controller, Get } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';

@ApiTags('health')
@Controller()
export class AppController {
  @Get()
  @ApiOperation({ summary: 'API health check' })
  health() {
    return {
      status: 'ok',
      message: 'API is running',
      timestamp: new Date().toISOString(),
    };
  }
}
