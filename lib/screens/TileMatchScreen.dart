import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/LanguageProvider.dart';

class TileMatchScreen extends StatefulWidget {
  const TileMatchScreen({super.key});

  @override
  State<TileMatchScreen> createState() => _TileMatchScreenState();
}

class _TileMatchScreenState extends State<TileMatchScreen> with SingleTickerProviderStateMixin {
  late List<int> _tiles;
  late List<bool> _revealed;
  late List<bool> _matched;
  int? _firstTap;
  int? _secondTap;
  int _matches = 0;
  bool _isProcessing = false;
  late AnimationController _flipController;

  static const List<Color> _tileColors = [
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
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _initGame();
  }

  void _initGame() {
    _tiles = [];
    for (int i = 0; i < 6; i++) {
      _tiles.add(i);
      _tiles.add(i);
    }
    _tiles.shuffle();
    _revealed = List.filled(12, false);
    _matched = List.filled(12, false);
    _matches = 0;
    _firstTap = null;
    _secondTap = null;
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _onTileTap(int index) async {
    if (_isProcessing || _revealed[index] || _matched[index]) return;

    setState(() {
      _revealed[index] = true;
    });

    await _flipController.forward();

    if (_firstTap == null) {
      _firstTap = index;
      await _flipController.reverse();
    } else if (_secondTap == null) {
      _secondTap = index;
      _isProcessing = true;

      if (_tiles[_firstTap!] == _tiles[_secondTap!]) {
        setState(() {
          _matched[_firstTap!] = true;
          _matched[_secondTap!] = true;
          _matches++;
        });
        _firstTap = null;
        _secondTap = null;
        _isProcessing = false;

        if (_matches == 6) {
          Future.delayed(const Duration(milliseconds: 500), () {
            _showWinDialog();
          });
        }
      } else {
        await Future.delayed(const Duration(milliseconds: 1000));
        setState(() {
          _revealed[_firstTap!] = false;
          _revealed[_secondTap!] = false;
        });
        await _flipController.reverse();
        _firstTap = null;
        _secondTap = null;
        _isProcessing = false;
      }
    }
  }

  void _showWinDialog() {
    final lang = context.read<LanguageProvider>();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(lang.t('calm.match.won')),
        content: Text(lang.t('calm.match.playagain')),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _initGame());
            },
            child: Text(lang.t('calm.match.restart')),
          ),
        ],
      ),
    );
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
          lang.t('calm.match.title'),
          style: TextStyle(
            fontSize: 22,
            color: cs.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _onTileTap(index),
                      child: AnimatedBuilder(
                        animation: _flipController,
                        builder: (context, child) {
                          final isFlipped = _revealed[index];
                          final angle = isFlipped
                              ? _flipController.value * 3.14159
                              : (1 - _flipController.value) * 3.14159;

                          return Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(angle),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: _matched[index]
                                    ? _tileColors[_tiles[index]].withValues(alpha: 0.3)
                                    : (_revealed[index]
                                        ? _tileColors[_tiles[index]]
                                        : cs.surfaceContainer),
                                border: Border.all(
                                  color: cs.outline.withValues(alpha: 0.3),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: _matched[index]
                                  ? Icon(
                                      Icons.check_rounded,
                                      color: _tileColors[_tiles[index]],
                                      size: 24,
                                    )
                                  : (_revealed[index]
                                      ? Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white.withValues(alpha: 0.3),
                                          ),
                                          width: 20,
                                          height: 20,
                                        )
                                      : Icon(
                                          Icons.help_outline_rounded,
                                          color: cs.onSurface.withValues(alpha: 0.4),
                                          size: 24,
                                        )),
                            ),
                          );
                        },
                      ),
                    );
                  },
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
                '$_matches/6',
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
