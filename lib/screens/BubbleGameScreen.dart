import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../providers/LanguageProvider.dart';
import '../widgets/bilingual_line.dart';

class _Bubble {
  final Offset startPosition;
  final double size;
  final Color color;
  final Duration duration;
  final DateTime createdAt;
  bool popped = false;

  _Bubble({
    required this.startPosition,
    required this.size,
    required this.color,
    required this.duration,
  }) : createdAt = DateTime.now();

  Offset getPosition(double screenHeight) {
    final elapsed = DateTime.now().difference(createdAt).inMilliseconds / duration.inMilliseconds;
    if (elapsed >= 1.0) {
      return Offset(startPosition.dx, -100);
    }
    final y = startPosition.dy - (screenHeight + 100) * elapsed;
    return Offset(startPosition.dx, y);
  }

  bool hitTest(Offset tapPoint, double screenHeight) {
    final pos = getPosition(screenHeight);
    final distance = (pos - tapPoint).distance;
    return distance <= size / 2;
  }

  bool isOffScreen(double screenHeight) {
    final pos = getPosition(screenHeight);
    return pos.dy < -100;
  }
}

class BubbleGameScreen extends StatefulWidget {
  const BubbleGameScreen({super.key});

  @override
  State<BubbleGameScreen> createState() => _BubbleGameScreenState();
}

class _BubbleGameScreenState extends State<BubbleGameScreen> {
  final List<_Bubble> _bubbles = [];
  int _score = 0;
  DateTime? _lastSpawn;
  late GlobalKey<_BubbleCanvasState> _canvasKey;

  static const List<Color> _bubbleColors = [
    Color(0xFF6B9BD1),
    Color(0xFF2E96DE),
    Color(0xFFB19CD9),
    Color(0xFF7EC17F),
    Color(0xFFE67E22),
    Color(0xFFA0826D),
  ];

  @override
  void initState() {
    super.initState();
    _canvasKey = GlobalKey<_BubbleCanvasState>();
  }

  void _spawnBubble() {
    if (!mounted) return;
    final now = DateTime.now();
    if (_lastSpawn != null && now.difference(_lastSpawn!).inMilliseconds < 2500) {
      return;
    }
    _lastSpawn = now;

    if (_bubbles.length >= 4) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final size = 45.0 + math.Random().nextDouble() * 50;
    final color = _bubbleColors[math.Random().nextInt(_bubbleColors.length)];
    final duration = Duration(milliseconds: 6000 + math.Random().nextInt(2000));

    _bubbles.add(
      _Bubble(
        startPosition: Offset(
          20 + math.Random().nextDouble() * (screenWidth - 40),
          MediaQuery.of(context).size.height,
        ),
        size: size,
        color: color,
        duration: duration,
      ),
    );

    _canvasKey.currentState?.refresh();
  }

  void _onBubbleTap(Offset tapPosition) {
    final screenHeight = MediaQuery.of(context).size.height;
    for (final bubble in _bubbles) {
      if (!bubble.popped) {
        final pos = bubble.getPosition(screenHeight);
        final distance = (pos - tapPosition).distance;
        if (distance <= bubble.size / 2) {
          bubble.popped = true;
          _score++;
          setState(() {});
          _canvasKey.currentState?.refresh();
          break;
        }
      }
    }

    // Clean up old bubbles
    _bubbles.removeWhere((b) => b.popped || b.isOffScreen(screenHeight));
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
        title: BilingualLine(
          translationKey: 'calm.game.title',
          primaryStyle: TextStyle(
            fontSize: 22,
            color: cs.onPrimary,
            fontWeight: FontWeight.w600,
          ),
          secondaryStyle: TextStyle(
            fontSize: 16,
            color: cs.onPrimary.withValues(alpha: 0.8),
          ),
        ),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTapDown: (details) {
              final renderBox = context.findRenderObject() as RenderBox;
              final localPosition = renderBox.globalToLocal(details.globalPosition);
              _onBubbleTap(localPosition);
            },
            child: _BubbleCanvas(
              key: _canvasKey,
              bubbles: _bubbles,
              onNeedSpawn: _spawnBubble,
            ),
          ),
          Positioned(
            top: 70,
            right: 16,
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

class _BubbleCanvas extends StatefulWidget {
  final List<_Bubble> bubbles;
  final VoidCallback onNeedSpawn;

  const _BubbleCanvas({
    required Key key,
    required this.bubbles,
    required this.onNeedSpawn,
  }) : super(key: key);

  @override
  State<_BubbleCanvas> createState() => _BubbleCanvasState();
}

class _BubbleCanvasState extends State<_BubbleCanvas> with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        // Spawn bubble if needed
        if (widget.bubbles.length < 4) {
          Future.microtask(widget.onNeedSpawn);
        }

        // Remove off-screen bubbles
        final screenHeight = MediaQuery.of(context).size.height;
        widget.bubbles.removeWhere((b) => b.isOffScreen(screenHeight));

        return CustomPaint(
          painter: _BubblePainter(widget.bubbles, screenHeight),
          size: Size.infinite,
        );
      },
    );
  }
}

class _BubblePainter extends CustomPainter {
  final List<_Bubble> bubbles;
  final double screenHeight;

  _BubblePainter(this.bubbles, this.screenHeight);

  @override
  void paint(Canvas canvas, Size size) {
    for (final bubble in bubbles) {
      final pos = bubble.getPosition(screenHeight);

      if (pos.dy < -100 || pos.dy > screenHeight + 100) continue;

      if (bubble.popped) {
        // Draw pop animation (fade out)
        final elapsed = DateTime.now().difference(bubble.createdAt).inMilliseconds;
        final alpha = (1.0 - (elapsed % 300) / 300.0 * 0.3).clamp(0.0, 1.0);

        final paint = Paint()
          ..color = bubble.color.withValues(alpha: alpha * 0.3)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(pos, bubble.size / 2, paint);
      } else {
        // Draw bubble
        final paint = Paint()
          ..color = bubble.color
          ..style = PaintingStyle.fill;

        canvas.drawCircle(pos, bubble.size / 2, paint);

        // Bubble shine
        final shinePaint = Paint()
          ..color = Colors.white.withValues(alpha: 0.25)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(
          Offset(pos.dx - bubble.size / 6, pos.dy - bubble.size / 6),
          bubble.size / 8,
          shinePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_BubblePainter oldDelegate) => true;
}
