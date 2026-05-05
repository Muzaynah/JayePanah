import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/LanguageProvider.dart';
import '../components/EmergencyModal.dart';
import '../theme/calm_palette.dart';

/// Crisis flow controls: home exit button + optional emergency call button.
class CrisisHomeButton extends StatelessWidget {
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? borderColor;
  final bool showEmergency;

  const CrisisHomeButton({
    super.key,
    this.backgroundColor,
    this.iconColor,
    this.borderColor,
    this.showEmergency = true,
  });

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final bg = backgroundColor ?? Colors.white.withCalmAlpha(0.14);
    final fg = iconColor ?? Colors.white;
    final border = borderColor ?? Colors.white.withCalmAlpha(0.22);

    return Stack(
      children: [
        PositionedDirectional(
          top: 8,
          start: 8,
          child: SafeArea(
            child: Semantics(
              label: languageProvider.t('flow.home'),
              button: true,
              child: Material(
                color: bg,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: border, width: 1),
                    ),
                    child: Icon(
                      Icons.home_outlined,
                      color: fg,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (showEmergency)
          PositionedDirectional(
            top: 8,
            end: 8,
            child: SafeArea(
              child: Semantics(
                label: languageProvider.t('home.emergency'),
                button: true,
                child: Material(
                  color: bg,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => EmergencyModal.show(context),
                    child: Container(
                      width: 52,
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: border, width: 1),
                      ),
                      child: Icon(
                        Icons.phone_in_talk_rounded,
                        color: fg,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
