import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ConflictException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Cart } from './entities/cart.entity';
import { CartItem } from './entities/cart-item.entity';
import { MenuItem } from '../menu/entities/menu-item.entity';
import { Vendor } from '../vendors/entities/vendor.entity';
import { AddToCartDto } from './dto/add-to-cart.dto';
import { UpdateCartItemDto } from './dto/update-cart-item.dto';

@Injectable()
export class CartService {
  private readonly BASE_DELIVERY_FEE = 10; // Base delivery fee in SAR

  constructor(
    @InjectRepository(Cart)
    private readonly cartRepository: Repository<Cart>,
    @InjectRepository(CartItem)
    private readonly cartItemRepository: Repository<CartItem>,
    @InjectRepository(MenuItem)
    private readonly menuItemRepository: Repository<MenuItem>,
    @InjectRepository(Vendor)
    private readonly vendorRepository: Repository<Vendor>,
  ) {}

  /**
   * Get or create user cart
   */
  private async getOrCreateCart(userId: string): Promise<Cart> {
    let cart = await this.cartRepository.findOne({
      where: { userId },
      relations: ['items', 'items.menuItem', 'vendor'],
    });

    if (!cart) {
      cart = this.cartRepository.create({
        userId,
        subtotal: 0,
        deliveryFee: 0,
        total: 0,
      });
      cart = await this.cartRepository.save(cart);
    }

    return cart;
  }

  /**
   * Calculate cart totals
   */
  private async calculateCartTotals(cart: Cart): Promise<Cart> {
    let subtotal = 0;

    if (cart.items && cart.items.length > 0) {
      for (const item of cart.items) {
        subtotal += parseFloat(item.price.toString()) * item.quantity;
      }
    }

    cart.subtotal = subtotal;
    cart.deliveryFee = cart.vendorId ? this.BASE_DELIVERY_FEE : 0;
    cart.total = subtotal + cart.deliveryFee;

    return this.cartRepository.save(cart);
  }

  /**
   * Get cart with formatted response
   */
  async getCart(userId: string) {
    const cart = await this.getOrCreateCart(userId);

    if (!cart.items || cart.items.length === 0) {
      return {
        id: cart.id,
        vendor: null,
        items: [],
        subtotal: 0,
        deliveryFee: 0,
        total: 0,
      };
    }

    return {
      id: cart.id,
      vendor: cart.vendor
        ? {
            id: cart.vendor.id,
            name: cart.vendor.name,
            logo: cart.vendor.logo,
          }
        : null,
      items: cart.items.map((item) => ({
        id: item.id,
        menuItem: {
          id: item.menuItem.id,
          name: item.menuItem.name,
          image: item.menuItem.image,
          price: parseFloat(item.menuItem.price.toString()),
        },
        quantity: item.quantity,
        price: parseFloat(item.price.toString()),
        subtotal: parseFloat(item.price.toString()) * item.quantity,
      })),
      subtotal: parseFloat(cart.subtotal.toString()),
      deliveryFee: parseFloat(cart.deliveryFee.toString()),
      total: parseFloat(cart.total.toString()),
    };
  }

  /**
   * Add item to cart
   * Enforces single vendor rule
   */
  async addToCart(userId: string, dto: AddToCartDto) {
    const { menuItemId, quantity } = dto;

    // Get menu item
    const menuItem = await this.menuItemRepository.findOne({
      where: { id: menuItemId },
      relations: ['vendor'],
    });

    if (!menuItem) {
      throw new NotFoundException('Menu item not found');
    }

    if (!menuItem.isAvailable) {
      throw new BadRequestException('Menu item is not available');
    }

    // Get or create cart
    const cart = await this.getOrCreateCart(userId);

    // Single vendor enforcement
    if (cart.vendorId && cart.vendorId !== menuItem.vendorId) {
      throw new ConflictException(
        'Cannot add items from different vendors. Please clear your cart first.',
      );
    }

    // Set vendor if not set
    if (!cart.vendorId) {
      cart.vendorId = menuItem.vendorId;
      await this.cartRepository.save(cart);
    }

    // Check if item already exists in cart
    const existingItem = await this.cartItemRepository.findOne({
      where: {
        cartId: cart.id,
        menuItemId: menuItem.id,
      },
    });

    if (existingItem) {
      // Update quantity
      existingItem.quantity += quantity;
      await this.cartItemRepository.save(existingItem);
    } else {
      // Create new cart item
      const cartItem = this.cartItemRepository.create({
        cartId: cart.id,
        menuItemId: menuItem.id,
        quantity,
        price: menuItem.price,
      });
      await this.cartItemRepository.save(cartItem);
    }

    // Recalculate totals
    const updatedCart = await this.cartRepository.findOne({
      where: { id: cart.id },
      relations: ['items'],
    });

    await this.calculateCartTotals(updatedCart);

    return {
      message: 'Item added to cart successfully',
      cart: await this.getCart(userId),
    };
  }

  /**
   * Update cart item quantity
   */
  async updateCartItem(userId: string, itemId: string, dto: UpdateCartItemDto) {
    const { quantity } = dto;

    const cartItem = await this.cartItemRepository.findOne({
      where: { id: itemId },
      relations: ['cart'],
    });

    if (!cartItem) {
      throw new NotFoundException('Cart item not found');
    }

    // Verify cart belongs to user
    if (cartItem.cart.userId !== userId) {
      throw new BadRequestException('Cart item does not belong to user');
    }

    cartItem.quantity = quantity;
    await this.cartItemRepository.save(cartItem);

    // Recalculate totals
    const cart = await this.cartRepository.findOne({
      where: { id: cartItem.cartId },
      relations: ['items'],
    });

    await this.calculateCartTotals(cart);

    return {
      message: 'Cart item updated successfully',
      cart: await this.getCart(userId),
    };
  }

  /**
   * Remove cart item
   */
  async removeCartItem(userId: string, itemId: string) {
    const cartItem = await this.cartItemRepository.findOne({
      where: { id: itemId },
      relations: ['cart'],
    });

    if (!cartItem) {
      throw new NotFoundException('Cart item not found');
    }

    // Verify cart belongs to user
    if (cartItem.cart.userId !== userId) {
      throw new BadRequestException('Cart item does not belong to user');
    }

    await this.cartItemRepository.remove(cartItem);

    // Recalculate totals
    const cart = await this.cartRepository.findOne({
      where: { id: cartItem.cartId },
      relations: ['items'],
    });

    await this.calculateCartTotals(cart);

    return {
      message: 'Item removed from cart successfully',
      cart: await this.getCart(userId),
    };
  }

  /**
   * Clear cart
   */
  async clearCart(userId: string) {
    const cart = await this.getOrCreateCart(userId);

    // Remove all items
    await this.cartItemRepository.delete({ cartId: cart.id });

    // Reset cart
    cart.vendorId = null;
    cart.subtotal = 0;
    cart.deliveryFee = 0;
    cart.total = 0;

    await this.cartRepository.save(cart);

    return {
      message: 'Cart cleared successfully',
      cart: await this.getCart(userId),
    };
  }
}
