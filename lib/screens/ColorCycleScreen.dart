import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/LanguageProvider.dart';

class ColorCycleScreen extends StatefulWidget {
  const ColorCycleScreen({super.key});

  @override
  State<ColorCycleScreen> createState() => _ColorCycleScreenState();
}

class _ColorCycleScreenState extends State<ColorCycleScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  int _cycles = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _colorAnimation = ColorTween(
      begin: const Color(0xFF6B9BD1),
      end: const Color(0xFF7EC17F),
    ).animate(_controller);

    _controller.addListener(() {
      if (_controller.value > 0.9 && _cycles < (_controller.value * 10).toInt()) {
        setState(() {
          _cycles = (_controller.value * 10).toInt();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageProvider>();
    final isRTL = lang.isRTL;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: cs.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            isRTL ? Icons.chevron_right : Icons.chevron_left,
            color: cs.onPrimary,
          ),
        ),
        title: Text(
          lang.t('calm.color.title'),
          style: TextStyle(
            fontSize: 22,
            color: cs.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  lang.t('calm.color.subtitle'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: cs.onSurface.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 48),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _colorAnimation.value ?? const Color(0xFF6B9BD1),
                          boxShadow: [
                            BoxShadow(
                              color: (_colorAnimation.value ?? const Color(0xFF6B9BD1))
                                  .withValues(alpha: 0.4),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 48),
                Text(
                  _getInstruction(_controller.value),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: cs.onSurface,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$_cycles',
                style: TextStyle(
                  fontSize: 18,
                  color: cs.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getInstruction(double progress) {
    final normalizedProgress = progress % 1.0;
    final lang = context.read<LanguageProvider>();

    if (normalizedProgress < 0.25) {
      return lang.t('calm.color.inhale');
    } else if (normalizedProgress < 0.5) {
      return lang.t('calm.color.hold');
    } else if (normalizedProgress < 0.75) {
      return lang.t('calm.color.exhale');
    } else {
      return lang.t('calm.color.hold');
    }
  }
}
