import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/LanguageProvider.dart';
import '../routes/app_routes.dart';
import '../components/EmergencyModal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool _showEmergency = false;
  late AnimationController _backgroundController;
  late AnimationController _cardController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);
    
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOut),
    );
    
    _cardController.forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF4A9B99), Color(0xFF6B9A9E)],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned(
                    top: -80,
                    right: -80,
                    child: Opacity(
                      opacity: 0.1 + (_backgroundController.value * 0.1),
                      child: Transform.scale(
                        scale: 1.0 + (_backgroundController.value * 0.2),
                        child: Container(
                          width: 320,
                          height: 320,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -80,
                    left: -80,
                    child: Opacity(
                      opacity: 0.1 + ((1 - _backgroundController.value) * 0.05),
                      child: Transform.scale(
                        scale: 1.0 + ((1 - _backgroundController.value) * 0.3),
                        child: Container(
                          width: 384,
                          height: 384,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                  child: Row(
                    textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(
                              languageProvider.t('home.title'),
                              style: const TextStyle(
                                fontSize: 32,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                              ),
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              languageProvider.t('home.subtitle'),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                fontWeight: FontWeight.w400,
                              ),
                              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                        children: [
                          _ActionButton(
                            icon: Icons.menu_book_rounded,
                            onPressed: () => Navigator.pushNamed(context, AppRoutes.education),
                            tooltip: languageProvider.t('home.learn'),
                          ),
                          const SizedBox(width: 8),
                          _ActionButton(
                            icon: Icons.settings_rounded,
                            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
                            tooltip: languageProvider.t('home.settings'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 5,
                              child: _ModeCard(
                                title: languageProvider.t('home.self.title'),
                                subtitle: languageProvider.t('home.self.subtitle'),
                                icon: Icons.self_improvement_rounded,
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xFF4A9B99), Color(0xFF5A8B89)],
                                ),
                                iconColor: const Color(0xFF4A9B99),
                                onTap: () => Navigator.pushNamed(context, AppRoutes.selfRegulation),
                                isRTL: isRTL,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              flex: 5,
                              child: _ModeCard(
                                title: languageProvider.t('home.helper.title'),
                                subtitle: languageProvider.t('home.helper.subtitle'),
                                icon: Icons.people_rounded,
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xFF7FA99E), Color(0xFF8FAA85)],
                                ),
                                iconColor: const Color(0xFF7FA99E),
                                onTap: () => Navigator.pushNamed(context, AppRoutes.helperGuidance),
                                isRTL: isRTL,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: _EmergencyButton(
                    onPressed: () {
                      setState(() {
                        _showEmergency = true;
                      });
                    },
                    label: languageProvider.t('home.emergency'),
                    isRTL: isRTL,
                  ),
                ),
              ],
            ),
          ),
          if (_showEmergency)
            EmergencyModal(
              isOpen: _showEmergency,
              onClose: () {
                setState(() {
                  _showEmergency = false;
                });
              },
            ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;

  const _ActionButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.15),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

class _ModeCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
  final Color iconColor;
  final VoidCallback onTap;
  final bool isRTL;

  const _ModeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.iconColor,
    required this.onTap,
    required this.isRTL,
  });

  @override
  State<_ModeCard> createState() => _ModeCardState();
}

class _ModeCardState extends State<_ModeCard> with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _hoverController.forward(),
      onTapUp: (_) {
        _hoverController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _hoverController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: widget.iconColor.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 12),
                spreadRadius: -5,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(28),
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  crossAxisAlignment: widget.isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: widget.gradient,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: widget.iconColor.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.icon,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: widget.isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 26,
                            color: Color(0xFF2C3E50),
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                            height: 1.2,
                          ),
                          textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.subtitle,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF5A6C7D),
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                          textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmergencyButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final bool isRTL;

  const _EmergencyButton({
    required this.onPressed,
    required this.label,
    required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD64545).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Material(
        color: const Color(0xFFD64545),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: double.infinity,
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
