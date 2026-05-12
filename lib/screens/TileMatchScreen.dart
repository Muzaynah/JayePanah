import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import '../providers/LanguageProvider.dart';

class TileMatchScreen extends StatefulWidget {
  const TileMatchScreen({super.key});

  @override
  State<TileMatchScreen> createState() => _TileMatchScreenState();
}

class _TileMatchScreenState extends State<TileMatchScreen> {
  late List<int> _tiles;
  late List<bool> _revealed;
  late List<bool> _matched;
  int? _firstTap;
  int? _secondTap;
  int _matches = 0;
  int _tries = 0;
  int _elapsedSeconds = 0;
  bool _isProcessing = false;
  Timer? _timer;

  static const List<Color> _tileColors = [
    Color(0xFF6B9BD1), Color(0xFF2E96DE), Color(0xFFB19CD9),
    Color(0xFF7EC17F), Color(0xFFE67E22), Color(0xFFA0826D),
    Color(0xFFF17CB0), Color(0xFF4FC3C8),
  ];

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
    _tries = 0;
    _elapsedSeconds = 0;
    _firstTap = null;
    _secondTap = null;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _elapsedSeconds++);
    });
  }

  void _onTileTap(int index) async {
    if (_isProcessing || _revealed[index] || _matched[index]) return;

    setState(() => _revealed[index] = true);
    HapticFeedback.lightImpact();

    if (_firstTap == null) {
      _firstTap = index;
      return;
    }

    _secondTap = index;
    _isProcessing = true;
    _tries++;

    if (_tiles[_firstTap!] == _tiles[_secondTap!]) {
      setState(() {
        _matched[_firstTap!] = true;
        _matched[_secondTap!] = true;
        _matches++;
      });

      // Success Feedback
      Vibration.vibrate(duration: 60);
      SystemSound.play(SystemSoundType.click);

      _firstTap = null;
      _secondTap = null;
      _isProcessing = false;

      if (_matches == 6) {
        _timer?.cancel();
        Future.delayed(const Duration(milliseconds: 500), _showWinDialog);
      }
      return;
    }

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _revealed[_firstTap!] = false;
      _revealed[_secondTap!] = false;
    });
    _firstTap = null;
    _secondTap = null;
    _isProcessing = false;
  }

  void _showWinDialog() {
    final lang = context.read<LanguageProvider>();
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(lang.t('calm.match.won'), style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.stars_rounded, size: 64, color: Colors.amber),
            const SizedBox(height: 16),
            Text('${lang.t('calm.match.tries')}: $_tries'),
            Text('${lang.t('calm.match.time')}: ${_formatElapsed(_elapsedSeconds)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(_initGame);
            },
            child: Text(lang.t('calm.match.restart')),
          ),
        ],
      ),
    );
  }

  String _formatElapsed(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remaining = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remaining';
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageProvider>();
    final isRTL = lang.isRTL;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: cs.primary,
        title: Text(lang.t('calm.match.title'), style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildScoreBoard(lang, cs),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 12,
              itemBuilder: (context, index) => _buildTile(index, cs),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBoard(LanguageProvider lang, ColorScheme cs) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.primary.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${lang.t('calm.match.tries')}: $_tries', style: TextStyle(fontSize: 16, color: cs.primary, fontWeight: FontWeight.bold)),
              Text('${lang.t('calm.match.time')}: ${_formatElapsed(_elapsedSeconds)}', style: TextStyle(fontSize: 14, color: cs.primary.withOpacity(0.7))),
            ],
          ),
          Text('$_matches/6', style: TextStyle(fontSize: 28, color: cs.primary, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildTile(int index, ColorScheme cs) {
    final tileColor = _tileColors[_tiles[index] % _tileColors.length];
    final isRevealed = _revealed[index] || _matched[index];

    return GestureDetector(
      onTap: () => _onTileTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isRevealed ? tileColor.withOpacity(0.15) : cs.surfaceContainerHigh,
          border: Border.all(color: isRevealed ? tileColor : cs.outline.withOpacity(0.2), width: 2),
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: isRevealed
              ? Icon(_matched[index] ? Icons.check_circle : Icons.blur_on, color: tileColor, size: 32)
              : Icon(Icons.help_outline, color: cs.onSurface.withOpacity(0.1), size: 28),
          ),
        ),
      ),
    );
  }
}
