import {
  Injectable,
  ConflictException,
  NotFoundException,
  BadRequestException,
  InternalServerErrorException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { AdminUser } from './entities/admin-user.entity';
import { AdminRole } from './entities/admin-role.entity';
import { AuditService } from './audit.service';
import { CreateAdminUserDto } from './dto/create-admin-user.dto';
import { UpdateAdminUserDto } from './dto/update-admin-user.dto';

const BCRYPT_ROUNDS = 10;

type ReqForAudit = { ip?: string; headers?: { 'user-agent'?: string } };

export interface AdminUserPublic {
  id: string;
  email: string;
  name: string;
  isActive: boolean;
  createdAt: Date;
  role: { slug: string; name: string };
}

@Injectable()
export class AdminUsersService {
  constructor(
    @InjectRepository(AdminUser)
    private readonly adminUserRepo: Repository<AdminUser>,
    @InjectRepository(AdminRole)
    private readonly adminRoleRepo: Repository<AdminRole>,
    private readonly auditService: AuditService,
  ) {}

  private toPublic(admin: AdminUser): AdminUserPublic {
    return {
      id: admin.id,
      email: admin.email,
      name: admin.name,
      isActive: admin.isActive,
      createdAt: admin.createdAt,
      role: { slug: admin.role.slug, name: admin.role.name },
    };
  }

  async listRoles(): Promise<
    Array<{ id: string; name: string; slug: string }>
  > {
    const roles = await this.adminRoleRepo.find({
      order: { slug: 'ASC' },
    });
    return roles.map((r) => ({
      id: r.id,
      name: r.name,
      slug: r.slug,
    }));
  }

  async listUsers(): Promise<AdminUserPublic[]> {
    const users = await this.adminUserRepo.find({
      relations: ['role'],
      order: { createdAt: 'ASC' },
    });
    return users.map((u) => this.toPublic(u));
  }

  async createUser(
    dto: CreateAdminUserDto,
    actorId: string,
    req?: ReqForAudit,
  ): Promise<AdminUserPublic> {
    const email = dto.email.toLowerCase().trim();
    const existing = await this.adminUserRepo.findOne({ where: { email } });
    if (existing) {
      throw new ConflictException('Email already registered');
    }
    const role = await this.adminRoleRepo.findOne({
      where: { slug: dto.roleSlug },
    });
    if (!role) {
      throw new BadRequestException(`Unknown role: ${dto.roleSlug}`);
    }
    const passwordHash = await bcrypt.hash(dto.password, BCRYPT_ROUNDS);
    const user = this.adminUserRepo.create({
      email,
      name: dto.name.trim(),
      passwordHash,
      roleId: role.id,
      isActive: true,
    });
    const saved = await this.adminUserRepo.save(user);
    const full = await this.adminUserRepo.findOne({
      where: { id: saved.id },
      relations: ['role'],
    });
    if (!full) throw new InternalServerErrorException();
    await this.auditService.log({
      actorId,
      action: 'ADMIN_USER_CREATED',
      entityType: 'admin_user',
      entityId: full.id,
      newValue: {
        email: full.email,
        name: full.name,
        roleSlug: full.role.slug,
      },
      req,
    });
    return this.toPublic(full);
  }

  async updateUser(
    id: string,
    dto: UpdateAdminUserDto,
    actorId: string,
    req?: ReqForAudit,
  ): Promise<AdminUserPublic> {
    const user = await this.adminUserRepo.findOne({
      where: { id },
      relations: ['role'],
    });
    if (!user) throw new NotFoundException('Admin user not found');

    if (
      dto.name === undefined &&
      dto.roleSlug === undefined &&
      dto.isActive === undefined
    ) {
      return this.toPublic(user);
    }

    const oldSnap = {
      name: user.name,
      roleSlug: user.role.slug,
      isActive: user.isActive,
    };

    if (dto.isActive === false && id === actorId) {
      throw new BadRequestException('Cannot deactivate your own account');
    }

    if (dto.name !== undefined) user.name = dto.name.trim();

    if (dto.roleSlug !== undefined) {
      const nextRole = await this.adminRoleRepo.findOne({
        where: { slug: dto.roleSlug },
      });
      if (!nextRole) {
        throw new BadRequestException(`Unknown role: ${dto.roleSlug}`);
      }
      if (user.role.slug === 'super_admin' && dto.roleSlug !== 'super_admin') {
        const superCount = await this.adminUserRepo
          .createQueryBuilder('u')
          .innerJoin('u.role', 'r')
          .where('r.slug = :slug', { slug: 'super_admin' })
          .andWhere('u.is_active = true')
          .getCount();
        if (superCount <= 1) {
          throw new BadRequestException(
            'Cannot change role: at least one active super_admin is required',
          );
        }
      }
      user.roleId = nextRole.id;
      user.role = nextRole;
    }

    if (dto.isActive !== undefined) {
      if (user.role.slug === 'super_admin' && dto.isActive === false) {
        const superActive = await this.adminUserRepo
          .createQueryBuilder('u')
          .innerJoin('u.role', 'r')
          .where('r.slug = :slug', { slug: 'super_admin' })
          .andWhere('u.is_active = true')
          .getCount();
        if (superActive <= 1) {
          throw new BadRequestException(
            'Cannot deactivate the last active super_admin',
          );
        }
      }
      user.isActive = dto.isActive;
    }

    await this.adminUserRepo.save(user);
    const full = await this.adminUserRepo.findOne({
      where: { id },
      relations: ['role'],
    });
    if (!full) throw new NotFoundException('Admin user not found');

    await this.auditService.log({
      actorId,
      action: 'ADMIN_USER_UPDATED',
      entityType: 'admin_user',
      entityId: id,
      oldValue: oldSnap,
      newValue: {
        name: full.name,
        roleSlug: full.role.slug,
        isActive: full.isActive,
      },
      req,
    });

    return this.toPublic(full);
  }

  async resetPassword(
    id: string,
    plainPassword: string,
    actorId: string,
    req?: ReqForAudit,
  ): Promise<{ success: true }> {
    const user = await this.adminUserRepo.findOne({ where: { id } });
    if (!user) throw new NotFoundException('Admin user not found');
    user.passwordHash = await bcrypt.hash(plainPassword, BCRYPT_ROUNDS);
    await this.adminUserRepo.save(user);
    await this.auditService.log({
      actorId,
      action: 'ADMIN_USER_PASSWORD_RESET',
      entityType: 'admin_user',
      entityId: id,
      newValue: { targetEmail: user.email },
      req,
    });
    return { success: true };
  }
}
