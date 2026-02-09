import {
  Controller,
  Get,
  Post,
  Param,
  Delete,
  UseGuards,
  Body,
  Request,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { OrdersService } from './orders.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { User } from '../users/entities/user.entity';
import { CreateOrderDto } from './dto/create-order.dto';

@ApiTags('orders')
@Controller('orders')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class OrdersController {
  constructor(private readonly ordersService: OrdersService) {}

  @Post()
  @ApiOperation({ summary: 'Create order from cart' })
  async createOrder(
    @Request() req: { user: User },
    @Body() dto: CreateOrderDto,
  ) {
    return this.ordersService.createOrder(req.user.id, dto);
  }

  @Get()
  @ApiOperation({ summary: 'Get user orders' })
  async getOrders(@Request() req: { user: User }) {
    return this.ordersService.getOrders(req.user.id);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get order details' })
  async getOrderDetails(
    @Request() req: { user: User },
    @Param('id') id: string,
  ) {
    return this.ordersService.getOrderDetails(id, req.user.id);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Cancel order' })
  async cancelOrder(@Request() req: { user: User }, @Param('id') id: string) {
    return this.ordersService.cancelOrder(id, req.user.id);
  }
}
