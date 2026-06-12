/// برومت تصوير احترافي للأطباق — للاستخدام مع أدوات توليد الصور (مثل ChatGPT / Midjourney).
abstract final class DishPhotoPrompts {
  static const String base = '''
Create an ultra-premium professional food photography shot for a home cooking marketplace app.

Style: luxury food commercial photography, highly realistic, cinematic, appetizing, premium restaurant quality.

Focus on:
• high detail food texture
• steam rising naturally
• rich colors
• realistic lighting
• premium plating
• fresh ingredients visible
• clean presentation
• elegant composition

Scene requirements:
• food centered clearly
• shallow depth of field
• soft warm lighting
• realistic shadows
• high-end kitchen or dining background blurred
• premium Saudi / Middle Eastern food presentation
• natural garnishes
• authentic homemade feeling
• no people

Food types:
• Saudi kabsa
• mandi
• grilled meat
• lamb dishes
• whole lamb serving
• mixed BBQ
• buffet trays
• traditional rice dishes

Composition:
• hero shot
• top-tier food styling
• visually irresistible
• premium marketplace listing photo
• realistic food commercial look

Quality:
• ultra HD
• photorealistic
• 8k
• sharp focus
• clean background
• premium mobile app product image

STRICT RULES:
• no text
• no watermark
• no logo
• no hands
• no utensils covering the food
• no low-quality plating
• no cartoon
• no illustration''';

  static const Map<String, String> categoryAddon = {
    'home_cooking':
        'homemade Saudi food, warm family style serving, authentic home kitchen feeling',
    'popular_cooking':
        'whole lamb feast, large tray, traditional Saudi serving, wedding style presentation',
    'grilling':
        'charcoal grilling, fire flames, smoke, outdoor BBQ atmosphere, Syrian grill style',
    'private_events':
        'luxury buffet setup, catering presentation, large event dining, elegant banquet arrangement',
  };

  static String fullForCategory(String? providerCategory) {
    final key = providerCategory?.trim();
    final addon = categoryAddon[key] ?? categoryAddon['home_cooking']!;
    return '$base\n\nCategory focus:\n$addon';
  }
}
