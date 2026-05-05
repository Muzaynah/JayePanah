import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/LanguageProvider.dart';
import '../providers/app_settings_provider.dart';
import '../theme/calm_palette.dart';

/// During initial onboarding only: primary line + the other language below.
/// After onboarding, shows a single line in the active app language.
class BilingualLine extends StatelessWidget {
  final String translationKey;
  final TextStyle? primaryStyle;
  final TextStyle? secondaryStyle;
  final TextAlign textAlign;
  final EdgeInsetsGeometry padding;

  const BilingualLine({
    super.key,
    required this.translationKey,
    this.primaryStyle,
    this.secondaryStyle,
    this.textAlign = TextAlign.center,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final showBoth = context.watch<AppSettingsProvider>().showBilingualCaptions;
    final isRTL = lang.isRTL;
    final primaryDir = isRTL ? TextDirection.rtl : TextDirection.ltr;
    final secondaryDir = isRTL ? TextDirection.ltr : TextDirection.rtl;
    final other = lang.tAlternate(translationKey);
    final baseSecondary = Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 16,
              height: 1.45,
            ) ??
        const TextStyle(fontSize: 16, height: 1.45);

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: textAlign == TextAlign.center
            ? CrossAxisAlignment.center
            : (isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start),
        children: [
          Text(
            lang.t(translationKey),
            style: primaryStyle,
            textAlign: textAlign,
            textDirection: primaryDir,
          ),
          if (showBoth && other.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              other,
              style: secondaryStyle ??
                  baseSecondary.copyWith(
                    color: (primaryStyle?.color ?? baseSecondary.color)?.withCalmAlpha(0.72),
                  ),
              textAlign: textAlign,
              textDirection: secondaryDir,
            ),
          ],
        ],
      ),
    );
  }
}
