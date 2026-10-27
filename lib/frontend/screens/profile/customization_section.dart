import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/config/app_visual_style.dart';
import '../../../core/utils/haptics.dart';
import '../../widgets/glossy_pill.dart';
import '../../widgets/liquid_glass.dart';
import '../../widgets/settings_card.dart';
import '../../widgets/springy_tap.dart';
import 'app_icon_screen.dart';
import 'appearance_screen.dart';
import 'chat_background_screen.dart';
import 'font_settings_screen.dart';
import 'message_actions_screen.dart';
import 'theme_settings_screen.dart';

class _CustomizationCategory {
  final IconData icon;
  final String title;
  final WidgetBuilder builder;
  final Color iconBackground;

  const _CustomizationCategory({
    required this.icon,
    required this.title,
    required this.builder,
    required this.iconBackground,
  });
}

class CustomizationSection extends StatefulWidget {
  const CustomizationSection({super.key});

  @override
  State<CustomizationSection> createState() => _CustomizationSectionState();
}

class _CustomizationSectionState extends State<CustomizationSection> {
  bool _expanded = false;

  static final List<_CustomizationCategory> _categories = [
    _CustomizationCategory(
      icon: Symbols.dark_mode,
      title: 'Тема',
      builder: (context) => const ThemeSettingsScreen(),
      iconBackground: const Color(0xFF5856D6),
    ),
    _CustomizationCategory(
      icon: Symbols.styler,
      title: 'Внешний вид',
      builder: (context) => const AppearanceScreen(),
      iconBackground: const Color(0xFFFF9500),
    ),
    _CustomizationCategory(
      icon: Symbols.wallpaper,
      title: 'Фон чатов',
      builder: (context) => const ChatBackgroundScreen(),
      iconBackground: const Color(0xFF007AFF),
    ),
    _CustomizationCategory(
      icon: Symbols.text_fields,
      title: 'Шрифты',
      builder: (context) => const FontSettingsScreen(),
      iconBackground: const Color(0xFFAF52DE),
    ),
    _CustomizationCategory(
      icon: Symbols.touch_app,
      title: 'Меню действий',
      builder: (context) => const MessageActionsScreen(),
      iconBackground: const Color(0xFF34C759),
    ),
    _CustomizationCategory(
      icon: Symbols.apps,
      title: 'Иконка приложения',
      builder: (context) => const AppIconScreen(),
      iconBackground: const Color(0xFFFF2D55),
    ),
  ];

  void _toggle() {
    Haptics.tap();
    setState(() => _expanded = !_expanded);
  }

  void _open(_CustomizationCategory category) {
    Haptics.tap();
    Navigator.push(context, MaterialPageRoute(builder: category.builder));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isIosGlass = defaultTargetPlatform == TargetPlatform.iOS ||
        AppVisualStyle.current.value == VisualStyle.liquidGlass;

    final content = Column(
      children: [
        _buildHeader(cs, isIosGlass),
        AnimatedSize(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: _expanded
              ? Column(children: _buildCategoryTiles(cs, isIosGlass))
              : const SizedBox(width: double.infinity),
        ),
      ],
    );

    if (isIosGlass) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return GlassSurface(
        liquid: LiquidGlass.isSupported,
        borderRadius: BorderRadius.circular(18),
        frostTint: isDark
            ? const Color(0x731C1C24)
            : const Color(0xB8FFFFFF),
        liquidTint: isDark
            ? const Color(0x381C1C24)
            : const Color(0x80FFFFFF),
        frostSigma: 24,
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.10)
              : Colors.black.withValues(alpha: 0.06),
          width: 0.8,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: content,
        ),
      );
    }

    return GlossyPill(
      color: cs.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(20),
      depth: 6,
      child: content,
    );
  }

  Widget _buildHeader(ColorScheme cs, bool isIosGlass) {
    final leadingWidget = isIosGlass
        ? Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFFF2D55),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Symbols.palette,
              color: Colors.white,
              size: 20,
              weight: 400,
            ),
          )
        : Icon(
            Symbols.palette,
            color: cs.onSurfaceVariant,
            size: 22,
            weight: 400,
          );

    return SpringyTap(
      enabled: isIosGlass,
      pressedScale: 0.99,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggle,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              leadingWidget,
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'Кастомизация',
                  style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: isIosGlass ? -0.2 : 0,
                  ),
                ),
              ),
              AnimatedRotation(
                duration: const Duration(milliseconds: 220),
                turns: _expanded ? 0.5 : 0,
                child: Icon(
                  Symbols.expand_more,
                  color: cs.outline,
                  size: 22,
                  weight: 400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCategoryTiles(ColorScheme cs, bool isIosGlass) {
    final tiles = <Widget>[];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    for (var i = 0; i < _categories.length; i++) {
      final category = _categories[i];
      tiles.add(
        Padding(
          padding: const EdgeInsets.only(left: 60),
          child: Divider(
            height: 0.5,
            thickness: 0.5,
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.08),
          ),
        ),
      );
      tiles.add(
        SettingsNavTile(
          icon: category.icon,
          label: category.title,
          iconBackground: category.iconBackground,
          onTap: () => _open(category),
          isLast: i == _categories.length - 1,
        ),
      );
    }
    return tiles;
  }
}
