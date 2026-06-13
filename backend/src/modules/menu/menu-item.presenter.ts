import { MenuItem } from './entities/menu-item.entity';

export type PublicMenuItemResponse = {
  id: string;
  vendorId: string;
  name: string;
  description: string | null;
  price: number | null;
  /** صورة الوجبة التي يرفعها الطبّاخ — ليس ثَمبنيل الفيديو الإعلاني */
  image: string | null;
  isSignature: boolean;
  isAvailable: boolean;
};

function resolveUploadUrl(raw: string | null | undefined): string | null {
  if (!raw?.trim()) return null;
  const t = raw.trim();
  if (t.startsWith('http://') || t.startsWith('https://')) return t;
  const origin =
    process.env.PUBLIC_APP_ORIGIN?.replace(/\/$/, '') ??
    process.env.RENDER_EXTERNAL_URL?.replace(/\/$/, '') ??
    'http://localhost:3001';
  if (t.startsWith('/')) return `${origin}${t}`;
  return `${origin}/uploads/${t}`;
}

function parsePrice(price: MenuItem['price']): number | null {
  if (price === null || price === undefined) return null;
  if (typeof price === 'number') return price;
  const parsed = parseFloat(String(price));
  return Number.isNaN(parsed) ? null : parsed;
}

export function toPublicMenuItem(item: MenuItem): PublicMenuItemResponse {
  return {
    id: item.id,
    vendorId: item.vendorId,
    name: item.name,
    description: item.description ?? null,
    price: parsePrice(item.price),
    image: resolveUploadUrl(item.image),
    isSignature: item.isSignature,
    isAvailable: item.isAvailable,
  };
}

export function toPublicMenuItems(items: MenuItem[]): PublicMenuItemResponse[] {
  return items.map((item) => toPublicMenuItem(item));
}
