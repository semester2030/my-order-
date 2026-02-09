/// Design System Facade - Single import for all design tokens
/// 
/// Usage:
/// ```dart
/// import 'package:customer_app/core/theme/design_system.dart';
/// 
/// // Colors
/// AppColors.primary
/// SemanticColors.success
/// GradientColors.primaryGradient
/// 
/// // Typography
/// TextStyles.headlineLarge
/// FontSizes.bodyLarge
/// 
/// // Spacing
/// Insets.md
/// Gaps.mdV
/// 
/// // Shapes
/// AppRadius.lg
/// AppBorders.defaultBorder
/// 
/// // Shadows
/// AppShadows.elevation2
/// 
/// // Animations
/// AppDurations.medium
/// AppCurves.smooth
/// 
/// // Icons
/// IconSizes.md
/// AppIcons.home
/// ```
library design_system;

// Colors
export 'colors/app_colors.dart';
export 'colors/semantic_colors.dart';
export 'colors/gradient_colors.dart';

// Typography
export 'typography/text_styles.dart';
export 'typography/font_sizes.dart';
export 'typography/font_families.dart';

// Spacing
export 'spacing/insets.dart';
export 'spacing/gaps.dart';

// Shapes
export 'shapes/radius.dart';
export 'shapes/borders.dart';
export 'shapes/card_shapes.dart';

// Shadows
export 'shadows/app_shadows.dart';

// Animations
export 'animations/durations.dart';
export 'animations/curves.dart';
export 'animations/transitions.dart';

// Icons
export 'icons/icon_sizes.dart';
export 'icons/app_icons.dart';

// Components
export 'components/button_theme.dart';
export 'components/card_theme.dart';
export 'components/input_theme.dart';
export 'components/bottom_sheet_theme.dart';
export 'components/video_overlay_theme.dart';
export 'components/cta_hierarchy.dart';

// Accessibility
export 'accessibility/contrast_checker.dart';

// Dark Theme
export 'dark_theme.dart';
