import {
  Controller,
  Get,
  Post,
  Body,
  Put,
  Param,
  Delete,
  UseGuards,
  Request,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { CartService } from './cart.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { User } from '../users/entities/user.entity';
import { AddToCartDto } from './dto/add-to-cart.dto';
import { UpdateCartItemDto } from './dto/update-cart-item.dto';

@ApiTags('cart')
@Controller('cart')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class CartController {
  constructor(private readonly cartService: CartService) {}

  @Get()
  @ApiOperation({ summary: 'Get cart' })
  async getCart(@Request() req: { user: User }) {
    return this.cartService.getCart(req.user.id);
  }

  @Post('add')
  @ApiOperation({ summary: 'Add item to cart' })
  async addToCart(@Request() req: { user: User }, @Body() dto: AddToCartDto) {
    return this.cartService.addToCart(req.user.id, dto);
  }

  @Put('update/:id')
  @ApiOperation({ summary: 'Update cart item quantity' })
  async updateCartItem(
    @Request() req: { user: User },
    @Param('id') id: string,
    @Body() dto: UpdateCartItemDto,
  ) {
    return this.cartService.updateCartItem(req.user.id, id, dto);
  }

  @Delete('remove/:id')
  @ApiOperation({ summary: 'Remove cart item' })
  async removeCartItem(@Request() req: { user: User }, @Param('id') id: string) {
    return this.cartService.removeCartItem(req.user.id, id);
  }

  @Delete('clear')
  @ApiOperation({ summary: 'Clear cart' })
  async clearCart(@Request() req: { user: User }) {
    return this.cartService.clearCart(req.user.id);
  }
}
