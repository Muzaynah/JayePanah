import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/LanguageProvider.dart';
import '../providers/app_settings_provider.dart';
import '../theme/calm_palette.dart';
import '../widgets/bilingual_line.dart';

/// Text / accent colors for the emergency sheet 
class EmergencyPanelStyle {
  final Color panel;
  final Color onPanel;
  final Color muted;
  final Color accent;

  const EmergencyPanelStyle({
    required this.panel,
    required this.onPanel,
    required this.muted,
    required this.accent,
  });

  static EmergencyPanelStyle of(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return EmergencyPanelStyle(
      panel: dark ? CalmPalette.darkCrisisBg : const Color(0xFFE8EDF1),
      onPanel: dark ? const Color(0xFFE4E9EE) : const Color(0xFF1A2832),
      muted: dark ? const Color(0xFFB0BEC8) : const Color(0xFF4A5A66),
      accent: dark ? CalmPalette.darkCalmBlue : CalmPalette.lightCalmBlue,
    );
  }
}

class EmergencyHeroPhoneChip extends StatelessWidget {
  static const String heroTag = 'jaye_emergency_phone_chip';

  const EmergencyHeroPhoneChip({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final accent = dark ? CalmPalette.darkCalmBlue : CalmPalette.lightCalmBlue;
    return Material(
      color: accent.withCalmAlpha(0.22),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: accent.withCalmAlpha(0.5), width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 56,
        height: 56,
        child: Center(
          child: Icon(Icons.phone_in_talk_rounded, color: accent, size: 28),
        ),
      ),
    );
  }
}

/// Simple emergency dialog — flat [Material] card (no glass / shadow hacks on the shell).
class EmergencyModal extends StatelessWidget {
  final VoidCallback onClose;
  final bool heroFromHome;
  /// Drives staggered fade for body content after [Hero] (from-home path only uses delayed interval).
  final Animation<double> routeAnimation;

  const EmergencyModal({
    super.key,
    required this.onClose,
    required this.routeAnimation,
    this.heroFromHome = false,
  });

  /// [PageRouteBuilder] + non-zero duration so [Hero] has time to fly
  static Future<void> show(BuildContext context, {bool fromHome = false}) {
    final nav = Navigator.of(context, rootNavigator: true);
    final reduceMotion = Provider.of<AppSettingsProvider>(context, listen: false).reduceMotion;
    final barrierLabel = MaterialLocalizations.of(context).modalBarrierDismissLabel;
    final duration = reduceMotion
        ? Duration.zero
        : Duration(milliseconds: fromHome ? 600 : 320);

    return nav.push<void>(
      PageRouteBuilder<void>(
        opaque: false,
        barrierDismissible: true,
        barrierLabel: barrierLabel,
        barrierColor: Colors.black.withCalmAlpha(0.55),
        transitionDuration: duration,
        pageBuilder: (dialogContext, animation, secondaryAnimation) {
          return EmergencyModal(
            heroFromHome: fromHome,
            routeAnimation: animation,
            onClose: () => Navigator.of(dialogContext).pop(),
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          );
        },
      ),
    );
  }

  static Future<void> launchCall(BuildContext context) async {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    final emergencyNumber = prefs.getString('jayepanah_emergency_number') ?? '1122';
    final uri = Uri.parse('tel:$emergencyNumber');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(languageProvider.t('emergency.call_failed'))),
          );
        }
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(languageProvider.t('emergency.call_failed'))),
        );
      }
    }
  }

  static Future<void> launchContactCall(BuildContext context) async {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    final contactNumber = prefs.getString('jayepanah_trusted_contact');

    if (contactNumber == null || contactNumber.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(languageProvider.t('emergency.no_contact'))),
        );
      }
      return;
    }

    final uri = Uri.parse('tel:$contactNumber');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(languageProvider.t('emergency.call_failed'))),
          );
        }
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(languageProvider.t('emergency.call_failed'))),
        );
      }
    }
  }

  static Future<void> launchContactSms(BuildContext context) async {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    final contactNumber = prefs.getString('jayepanah_trusted_contact');
    final messageTemplate = prefs.getString('jayepanah_message_template');

    if (contactNumber == null || contactNumber.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(languageProvider.t('emergency.no_contact'))),
        );
      }
      return;
    }

    final message = messageTemplate ?? languageProvider.t('settings.message.default');
    final uri = Uri.parse('sms:$contactNumber?body=${Uri.encodeComponent(message)}');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(languageProvider.t('emergency.call_failed'))),
          );
        }
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(languageProvider.t('emergency.call_failed'))),
        );
      }
    }
  }

  Future<String?> _getTrustedContact() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jayepanah_trusted_contact');
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final style = EmergencyPanelStyle.of(context);

    final phoneLead = heroFromHome
        ? Hero(
            tag: EmergencyHeroPhoneChip.heroTag,
            child: const EmergencyHeroPhoneChip(),
          )
        : const EmergencyHeroPhoneChip();

    // Title / body / buttons: smooth fade after the shell (and Hero, from home) has appeared.
    final Animation<double> detailsFade = heroFromHome
        ? CurvedAnimation(
            parent: routeAnimation,
            curve: const Interval(0.48, 1.0, curve: Curves.easeInOut),
          )
        : CurvedAnimation(
            parent: routeAnimation,
            curve: const Interval(0.18, 1.0, curve: Curves.easeInOut),
          );

    final fadedBody = FadeTransition(
      opacity: detailsFade,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          BilingualLine(
            translationKey: 'emergency.title',
            textAlign: TextAlign.start,
            primaryStyle: TextStyle(
              fontSize: 22,
              color: style.onPanel,
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
            secondaryStyle: TextStyle(
              fontSize: 15,
              color: style.muted,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          BilingualLine(
            translationKey: 'emergency.text',
            textAlign: TextAlign.start,
            primaryStyle: TextStyle(
              fontSize: 16,
              color: style.muted,
              height: 1.5,
            ),
            secondaryStyle: TextStyle(
              fontSize: 15,
              color: style.muted.withCalmAlpha(0.88),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: () => EmergencyModal.launchCall(context),
              style: FilledButton.styleFrom(
                backgroundColor: style.accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                languageProvider.t('emergency.call'),
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
              ),
            ),
          ),
          const SizedBox(height: 12),
          FutureBuilder<String?>(
            future: _getTrustedContact(),
            builder: (context, snapshot) {
              final hasContact = snapshot.data != null && snapshot.data!.isNotEmpty;
              if (!hasContact) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () => EmergencyModal.launchContactCall(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: style.accent,
                      side: BorderSide(color: style.accent.withCalmAlpha(0.5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      languageProvider.t('emergency.contact_call'),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                    ),
                  ),
                ),
              );
            },
          ),
          FutureBuilder<String?>(
            future: _getTrustedContact(),
            builder: (context, snapshot) {
              final hasContact = snapshot.data != null && snapshot.data!.isNotEmpty;
              if (!hasContact) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () => EmergencyModal.launchContactSms(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: style.accent,
                      side: BorderSide(color: style.accent.withCalmAlpha(0.5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      languageProvider.t('emergency.contact_sms'),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: onClose,
              style: OutlinedButton.styleFrom(
                foregroundColor: style.onPanel,
                side: BorderSide(color: style.muted.withCalmAlpha(0.45)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                languageProvider.t('emergency.cancel'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
              ),
            ),
          ),
        ],
      ),
    );

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Material(
          color: style.panel,
          elevation: 10,
          shadowColor: Colors.black.withCalmAlpha(0.35),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: style.muted.withCalmAlpha(dark ? 0.4 : 0.28),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: phoneLead,
                ),
                fadedBody,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
