import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? tintColor;
  final double? tintOpacity;
  final BorderRadius? borderRadius;

  const GlassCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(DesignSystem.spaceLG),
    this.onTap,
    this.tintColor,
    this.tintOpacity,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(DesignSystem.radiusLG);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Light mode: white at 50%, border at 75%
    // Dark mode: dark green-tinted at 60%, border at 10%
    final tint = tintColor ?? (isDark ? const Color(0xFF1E2820) : Colors.white);
    final opacity = tintOpacity ?? (isDark ? 0.60 : 0.50);
    final borderOpacity = isDark ? 0.10 : 0.75;
    final blurRadius = isDark ? 16.0 : 14.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          decoration: BoxDecoration(
            color: tint.withValues(alpha: opacity),
            borderRadius: radius,
            border: Border.all(
              color: Colors.white.withValues(alpha: borderOpacity),
              width: 1.0,
            ),
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurRadius, sigmaY: blurRadius),
              child: Padding(
                padding: padding,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// SceneBackground provides the 3-layer background system:
/// 1. Solid base color
/// 2. Gradient overlay
/// 3. Soft blob shapes (infrastructure for glass blur visibility)
class SceneBackground extends StatelessWidget {
  final Widget child;
  final bool isBreathingScreen;

  const SceneBackground({
    Key? key,
    required this.child,
    this.isBreathingScreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isBreathingScreen) {
      // Breathing screen: flat, minimal background
      return Container(
        color: isDark ? const Color(0xFF0E1210) : const Color(0xFFF2F0EA),
        child: child,
      );
    }

    // Standard 3-layer background
    return Container(
      // Layer 1: Base color
      color: isDark ? const Color(0xFF141A18) : const Color(0xFFF4F2ED),
      child: Stack(
        children: [
          // Layer 2: Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: isDark
                  ? const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF141A18),
                        Color(0xFF111520),
                      ],
                      stops: [0.0, 1.0],
                    )
                  : const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFF0EEE8),
                        Color(0xFFEAEDF0),
                      ],
                      stops: [0.0, 1.0],
                    ),
            ),
          ),
          // Layer 3: Soft blob shapes
          if (!isBreathingScreen) ...[
            // Blob 1: Sage green, top-left
            Positioned(
              top: -100,
              left: -80,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: isDark
                        ? [
                            const Color(0xFF4A8C5C).withValues(alpha: 0.30),
                            const Color(0xFF4A8C5C).withValues(alpha: 0.0),
                          ]
                        : [
                            const Color(0xFF9DC4A0).withValues(alpha: 0.55),
                            const Color(0xFF9DC4A0).withValues(alpha: 0.0),
                          ],
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: isDark ? 80 : 60,
                    sigmaY: isDark ? 80 : 60,
                  ),
                ),
              ),
            ),
            // Blob 2: Lavender, right side
            Positioned(
              top: MediaQuery.of(context).size.height * 0.30,
              right: -120,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: isDark
                        ? [
                            const Color(0xFF6B5FA0).withValues(alpha: 0.28),
                            const Color(0xFF6B5FA0).withValues(alpha: 0.0),
                          ]
                        : [
                            const Color(0xFFBDB5D8).withValues(alpha: 0.45),
                            const Color(0xFFBDB5D8).withValues(alpha: 0.0),
                          ],
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: isDark ? 80 : 60,
                    sigmaY: isDark ? 80 : 60,
                  ),
                ),
              ),
            ),
            // Blob 3: Peach, bottom-left
            Positioned(
              bottom: -80,
              left: 40,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: isDark
                        ? [
                            const Color(0xFFC4845A).withValues(alpha: 0.22),
                            const Color(0xFFC4845A).withValues(alpha: 0.0),
                          ]
                        : [
                            const Color(0xFFE5C4AA).withValues(alpha: 0.40),
                            const Color(0xFFE5C4AA).withValues(alpha: 0.0),
                          ],
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: isDark ? 70 : 60,
                    sigmaY: isDark ? 70 : 60,
                  ),
                ),
              ),
            ),
          ],
          // Child content on top of all 3 layers
          child,
        ],
      ),
    );
  }
}

/// Legacy BackgroundBlob for transition period (deprecated, use SceneBackground)
class BackgroundBlob extends StatelessWidget {
  final double top;
  final double left;
  final double? bottom;
  final double? right;
  final double width;
  final double height;
  final Color color;
  final double opacity;

  const BackgroundBlob({
    Key? key,
    this.top = 0,
    this.left = 0,
    this.bottom,
    this.right,
    required this.width,
    required this.height,
    required this.color,
    this.opacity = 0.35,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top > 0 ? top : null,
      left: left > 0 ? left : null,
      bottom: bottom,
      right: right,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: opacity),
              color.withValues(alpha: 0.0),
            ],
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
        ),
      ),
    );
  }
}

class GlassPill extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  const GlassPill({
    Key? key,
    required this.label,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignSystem.radiusPill),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignSystem.spaceLG,
            vertical: DesignSystem.spaceSM + 6,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? DesignSystem.accentSage
                : Colors.white.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(DesignSystem.radiusPill),
            border: Border.all(
              color: isSelected
                  ? DesignSystem.accentSage
                  : Colors.white.withValues(alpha: 0.8),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8FA89A).withValues(alpha: 0.12),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : DesignSystem.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
