import { Controller, Get } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';

const healthPayload = () => ({
  status: 'ok',
  message: 'API is running',
  timestamp: new Date().toISOString(),
});

@ApiTags('health')
@Controller()
export class AppController {
  /** GET / — يعمل حتى بدون /api (للتأكد من أن الخدمة تعمل على Render) */
  @Get()
  @ApiOperation({ summary: 'Root health check' })
  root() {
    return healthPayload();
  }

  /** GET /api/health — مسار ثابت لا يتعارض مع Swagger */
  @Get('health')
  @ApiOperation({ summary: 'API health check' })
  health() {
    return healthPayload();
  }
}
