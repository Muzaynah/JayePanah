import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../providers/LanguageProvider.dart';

class DotTapScreen extends StatefulWidget {
  const DotTapScreen({super.key});

  @override
  State<DotTapScreen> createState() => _DotTapScreenState();
}

class _DotTapScreenState extends State<DotTapScreen> with SingleTickerProviderStateMixin {
  late AnimationController _dotController;
  Offset? _currentDotPosition;
  int _score = 0;
  bool _showDot = false;
  late Future<void> _nextDotFuture;

  static const List<Color> _dotColors = [
    Color(0xFF6B9BD1),
    Color(0xFF2E96DE),
    Color(0xFFB19CD9),
    Color(0xFF7EC17F),
    Color(0xFFE67E22),
  ];

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _nextDotFuture = _showNextDot();
  }

  @override
  void dispose() {
    _dotController.dispose();
    super.dispose();
  }

  Future<void> _showNextDot() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final screenSize = MediaQuery.of(context).size;
    final dotSize = 50.0;
    final padding = 100.0;

    final x = padding + math.Random().nextDouble() * (screenSize.width - padding * 2);
    final y = padding + math.Random().nextDouble() * (screenSize.height - padding * 2 - 120);

    setState(() {
      _currentDotPosition = Offset(x, y);
      _showDot = true;
    });

    _dotController.forward(from: 0);

    await Future.delayed(const Duration(seconds: 3));
    if (mounted && _showDot) {
      setState(() => _showDot = false);
      _nextDotFuture = _showNextDot();
    }
  }

  void _onDotTapped() {
    if (_showDot && _currentDotPosition != null) {
      _score++;
      setState(() => _showDot = false);
      _dotController.stop();
      _nextDotFuture = _showNextDot();
    }
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
          lang.t('calm.dot.title'),
          style: TextStyle(
            fontSize: 22,
            color: cs.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTapDown: (_) => _onDotTapped(),
            child: Container(
              color: theme.scaffoldBackgroundColor,
              child: Center(
                child: _showDot && _currentDotPosition != null
                    ? Stack(
                        children: [
                          Positioned(
                            left: _currentDotPosition!.dx - 25,
                            top: _currentDotPosition!.dy - 25,
                            child: ScaleTransition(
                              scale: _dotController,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _dotColors[math.Random().nextInt(_dotColors.length)],
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: FadeTransition(
                                    opacity: _dotController,
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withValues(alpha: 0.4),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Text(
                        lang.t('calm.dot.waiting'),
                        style: TextStyle(
                          fontSize: 18,
                          color: cs.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
              ),
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
                '$_score',
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
}
