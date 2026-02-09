import { SetMetadata } from '@nestjs/common';

export const ROLES_KEY = 'roles';

/**
 * Allowed role slugs for the endpoint (e.g. ['super_admin', 'ops']).
 * Use after AdminJwtGuard.
 */
export const Roles = (...roles: string[]) => SetMetadata(ROLES_KEY, roles);
