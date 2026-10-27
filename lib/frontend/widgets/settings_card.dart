import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/config/app_shape.dart';
import '../../core/config/app_visual_style.dart';
import '../../core/utils/haptics.dart';
import 'glossy_pill.dart';
import 'liquid_glass.dart';
import 'springy_tap.dart';

class SettingsPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final BorderRadius? borderRadius;

  const SettingsPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(20, 18, 20, 20),
    this.color,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isIosGlass = defaultTargetPlatform == TargetPlatform.iOS ||
        AppVisualStyle.current.value == VisualStyle.liquidGlass;
    final radius = borderRadius ??
        (isIosGlass
            ? const BorderRadius.all(Radius.circular(18))
            : AppShape.cardRadius);

    if (isIosGlass) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: GlassSurface(
          liquid: LiquidGlass.isSupported,
          borderRadius: radius,
          frostTint: color ??
              (isDark
                  ? const Color(0x731C1C24)
                  : const Color(0xB8FFFFFF)),
          liquidTint: color != null
              ? color!.withValues(alpha: color!.a * 0.7)
              : (isDark
                  ? const Color(0x381C1C24)
                  : const Color(0x80FFFFFF)),
          frostSigma: 24,
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.10)
                : Colors.black.withValues(alpha: 0.06),
            width: 0.8,
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ),
      );
    }

    return GlossyPill(
      color: color ?? cs.surfaceContainerHigh,
      borderRadius: AppShape.cardRadius,
      padding: padding,
      depth: 6,
      child: child,
    );
  }
}

class SettingsCard extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;

  const SettingsCard({
    super.key,
    required this.children,
    this.margin,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isIosGlass = defaultTargetPlatform == TargetPlatform.iOS ||
        AppVisualStyle.current.value == VisualStyle.liquidGlass;
    final radius = borderRadius ??
        (isIosGlass
            ? const BorderRadius.all(Radius.circular(18))
            : AppShape.cardRadius);

    if (isIosGlass) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return Container(
        margin: margin ?? const EdgeInsets.symmetric(vertical: 6),
        child: GlassSurface(
          liquid: LiquidGlass.isSupported,
          borderRadius: radius,
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
            borderRadius: radius,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i != children.length - 1)
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
                ],
              ],
            ),
          ),
        ),
      );
    }

    return GlossyPill(
      color: cs.surfaceContainerHigh,
      borderRadius: AppShape.cardRadius,
      depth: 6,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1)
              Padding(
                padding: const EdgeInsets.only(left: 58),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: cs.outlineVariant.withValues(alpha: 0.35),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class SettingsToggleTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;
  final Color? iconColor;
  final Color? iconBackground;

  const SettingsToggleTile({
    super.key,
    required this.icon,
    required this.label,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.iconColor,
    this.iconBackground,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isIosGlass = defaultTargetPlatform == TargetPlatform.iOS ||
        AppVisualStyle.current.value == VisualStyle.liquidGlass;

    final leadingWidget = isIosGlass
        ? Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBackground ?? cs.primary.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: iconBackground != null
                  ? Colors.white
                  : (iconColor ?? cs.primary),
              size: 20,
              weight: 400,
            ),
          )
        : Icon(icon, color: cs.onSurfaceVariant, size: 22, weight: 400);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: enabled ? 1.0 : 0.4,
      child: IgnorePointer(
        ignoring: !enabled,
        child: SpringyTap(
          enabled: isIosGlass,
          pressedScale: 0.99,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Haptics.selection();
              onChanged(!value);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  leadingWidget,
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            color: cs.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.2,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            style: TextStyle(
                              color: cs.onSurfaceVariant,
                              fontSize: 13,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (isIosGlass)
                    CupertinoSwitch(
                      value: value,
                      activeTrackColor: cs.primary,
                      onChanged: (val) {
                        Haptics.selection();
                        onChanged(val);
                      },
                    )
                  else
                    Switch(
                      value: value,
                      onChanged: (val) {
                        Haptics.selection();
                        onChanged(val);
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsNavTile extends StatelessWidget {
  final IconData? icon;
  final Widget? leading;
  final String label;
  final String? subtitle;
  final Color? tintColor;
  final Color? iconBackground;
  final VoidCallback? onTap;
  final bool isLast;
  final Widget? trailing;

  const SettingsNavTile({
    super.key,
    this.icon,
    this.leading,
    required this.label,
    this.subtitle,
    this.tintColor,
    this.iconBackground,
    this.onTap,
    this.isLast = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isIosGlass = defaultTargetPlatform == TargetPlatform.iOS ||
        AppVisualStyle.current.value == VisualStyle.liquidGlass;

    final leadingWidget = leading ??
        (icon != null
            ? (isIosGlass
                ? Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: iconBackground ??
                          (tintColor != null
                              ? tintColor!.withValues(alpha: 0.18)
                              : cs.primary.withValues(alpha: 0.18)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      icon,
                      color: iconBackground != null
                          ? Colors.white
                          : (tintColor ?? cs.primary),
                      size: 20,
                      weight: 400,
                    ),
                  )
                : Icon(
                    icon,
                    color: tintColor ?? cs.onSurfaceVariant,
                    size: 22,
                    weight: 400,
                  ))
            : null);

    return SpringyTap(
      enabled: isIosGlass && onTap != null,
      pressedScale: 0.99,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (onTap != null) {
            Haptics.tap();
            onTap!();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              if (leadingWidget != null) ...[
                leadingWidget,
                const SizedBox(width: 14),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: tintColor ?? cs.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.2,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          color: cs.onSurfaceVariant,
                          fontSize: 13,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ] else
                Icon(
                  Symbols.chevron_right,
                  color: cs.outline.withValues(alpha: 0.6),
                  size: 20,
                  weight: 400,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
