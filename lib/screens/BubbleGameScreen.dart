import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:vibration/vibration.dart';
import '../providers/LanguageProvider.dart';

class _Bubble {
  final Offset startPosition;
  final double size;
  final Color color;
  final Duration duration;
  final DateTime createdAt;
  bool popped = false;
  bool missHandled = false;
  DateTime? poppedAt;

  _Bubble({
    required this.startPosition,
    required this.size,
    required this.color,
    required this.duration,
  }) : createdAt = DateTime.now();

  Offset getPosition(double canvasHeight, DateTime now) {
    if (popped && poppedAt != null) {
      final elapsedBeforePop = poppedAt!.difference(createdAt).inMilliseconds / duration.inMilliseconds;
      final y = startPosition.dy - (canvasHeight + 350) * elapsedBeforePop;
      return Offset(startPosition.dx, y);
    }
    final elapsed = now.difference(createdAt).inMilliseconds / duration.inMilliseconds;
    if (elapsed >= 1.0) return Offset(startPosition.dx, -350);
    final y = startPosition.dy - (canvasHeight + 350) * elapsed;
    return Offset(startPosition.dx, y);
  }

  bool isOffScreen(double canvasHeight, DateTime now) {
    final pos = getPosition(canvasHeight, now);
    return pos.dy <= -250;
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
  int _misses = 0;
  DateTime? _lastSpawn;
  bool _isGameOver = false;

  static const List<Color> _bubbleColors = [
    Color(0xFF6B9BD1), Color(0xFF2E96DE), Color(0xFFB19CD9),
    Color(0xFF7EC17F), Color(0xFFE67E22), Color(0xFFA0826D),
    Color(0xFFF17CB0), Color(0xFF4FC3C8), Color(0xFFFFC75F),
    Color(0xFF845EC2),
  ];

  void _spawnBubble(Size canvasSize) {
    if (!mounted || _isGameOver) return;
    final now = DateTime.now();
    if (_lastSpawn != null && now.difference(_lastSpawn!).inMilliseconds < 1000) return;
    _lastSpawn = now;

    if (_bubbles.length >= 8) return;

    final size = 75.0 + math.Random().nextDouble() * 25;
    setState(() {
      _bubbles.add(_Bubble(
        startPosition: Offset(
          size + math.Random().nextDouble() * (canvasSize.width - size * 2),
          canvasSize.height + size,
        ),
        size: size,
        color: _bubbleColors[math.Random().nextInt(_bubbleColors.length)],
        duration: Duration(milliseconds: 3000 + math.Random().nextInt(2000)),
      ));
    });
  }

  void _onBubbleTap(Offset tapPosition, double canvasHeight) {
    if (_isGameOver) return;
    final now = DateTime.now();
    for (final bubble in _bubbles) {
      if (!bubble.popped) {
        final pos = bubble.getPosition(canvasHeight, now);
        final distance = (pos - tapPosition).distance;
        
        // Extremely forgiving hitbox (1.2x bubble radius)
        if (distance <= (bubble.size * 0.6)) { 
          setState(() {
            bubble.popped = true;
            bubble.poppedAt = now;
            _score++;
          });
          SystemSound.play(SystemSoundType.click);
          Vibration.vibrate(duration: 40);
          break;
        }
      }
    }
  }

  void _onBubbleMissed() {
    if (!mounted || _isGameOver) return;
    setState(() {
      _misses++;
      if (_misses >= 3) _isGameOver = true;
    });
    Vibration.vibrate(duration: 200);
  }

  void _restartGame() {
    setState(() {
      _bubbles.clear();
      _score = 0;
      _misses = 0;
      _isGameOver = false;
      _lastSpawn = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageProvider>();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: cs.primary,
        title: Text(lang.t('calm.game.title'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(lang, cs),
              Expanded(
                child: ClipRect(
                  child: LayoutBuilder(builder: (context, constraints) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapDown: (details) => _onBubbleTap(details.localPosition, constraints.maxHeight),
                      child: _BubbleCanvas(
                        bubbles: _bubbles,
                        isGameOver: _isGameOver,
                        canvasHeight: constraints.maxHeight,
                        onNeedSpawn: () => _spawnBubble(Size(constraints.maxWidth, constraints.maxHeight)),
                        onBubbleMissed: _onBubbleMissed,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          if (_isGameOver) _buildGameOverOverlay(lang, cs),
        ],
      ),
    );
  }

  Widget _buildHeader(LanguageProvider lang, ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(0.08),
        border: Border(bottom: BorderSide(color: cs.primary.withOpacity(0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lang.t('calm.game.score').toUpperCase(), style: TextStyle(fontSize: 12, color: cs.primary.withOpacity(0.6), fontWeight: FontWeight.w900)),
              Text('$_score', style: TextStyle(fontSize: 32, color: cs.primary, fontWeight: FontWeight.w900)),
            ],
          ),
          Row(
            children: List.generate(3, (i) => Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Icon(
                i >= _misses ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                color: i >= _misses ? Colors.redAccent : cs.primary.withOpacity(0.2),
                size: 36,
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildGameOverOverlay(LanguageProvider lang, ColorScheme cs) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.sentiment_dissatisfied_rounded, size: 72, color: Colors.orange),
              const SizedBox(height: 16),
              Text(lang.t('calm.game.over'), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('${lang.t('calm.game.score')}: $_score', style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: _restartGame,
                  child: Text(lang.t('calm.game.playagain')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BubbleCanvas extends StatefulWidget {
  final List<_Bubble> bubbles;
  final bool isGameOver;
  final double canvasHeight;
  final VoidCallback onNeedSpawn;
  final VoidCallback onBubbleMissed;

  const _BubbleCanvas({required this.bubbles, required this.isGameOver, required this.canvasHeight, required this.onNeedSpawn, required this.onBubbleMissed});

  @override
  State<_BubbleCanvas> createState() => _BubbleCanvasState();
}

class _BubbleCanvasState extends State<_BubbleCanvas> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final now = DateTime.now();
        if (!widget.isGameOver) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            widget.onNeedSpawn();
            for (var b in widget.bubbles) {
              if (!b.popped && !b.missHandled && b.isOffScreen(widget.canvasHeight, now)) {
                b.missHandled = true;
                widget.onBubbleMissed();
              }
            }
            widget.bubbles.removeWhere((b) => 
              b.isOffScreen(widget.canvasHeight, now) ||
              (b.popped && b.poppedAt != null && now.difference(b.poppedAt!).inMilliseconds > 250)
            );
          });
        }
        return CustomPaint(
          painter: _BubblePainter(widget.bubbles, widget.canvasHeight, now),
          size: Size.infinite,
        );
      },
    );
  }
}

class _BubblePainter extends CustomPainter {
  final List<_Bubble> bubbles;
  final double canvasHeight;
  final DateTime now;
  _BubblePainter(this.bubbles, this.canvasHeight, this.now);

  @override
  void paint(Canvas canvas, Size size) {
    for (final b in bubbles) {
      final pos = b.getPosition(canvasHeight, now);
      double opacity = 0.65;
      double scale = 1.0;

      if (b.popped && b.poppedAt != null) {
        final elapsed = now.difference(b.poppedAt!).inMilliseconds;
        final progress = (elapsed / 250).clamp(0.0, 1.0);
        opacity = 0.65 * (1.0 - progress);
        scale = 1.0 + (progress * 0.8);
      }

      final paint = Paint()..color = b.color.withOpacity(opacity)..style = PaintingStyle.fill;
      canvas.drawCircle(pos, (b.size / 2) * scale, paint);
      
      final shinePaint = Paint()..color = Colors.white.withOpacity(opacity * 0.5);
      canvas.drawCircle(Offset(pos.dx - b.size / 6, pos.dy - b.size / 6), (b.size / 8) * scale, shinePaint);
      
      final borderPaint = Paint()..color = Colors.white.withOpacity(opacity * 0.3)..style = PaintingStyle.stroke..strokeWidth = 2;
      canvas.drawCircle(pos, (b.size / 2) * scale, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
