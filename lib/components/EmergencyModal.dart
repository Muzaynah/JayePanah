import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/LanguageProvider.dart';

class EmergencyModal extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onClose;

  const EmergencyModal({
    super.key,
    required this.isOpen,
    required this.onClose,
  });

  Future<void> _handleCall(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final emergencyNumber = prefs.getString('jayepanah_emergency_number') ?? '1122';
    final uri = Uri.parse('tel:$emergencyNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to make call')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isOpen) return const SizedBox.shrink();

    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRTL = languageProvider.isRTL;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          GestureDetector(
            onTap: onClose,
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: 0.95 + (value * 0.05),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Row(
                            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD64545).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.warning_rounded,
                                  color: Color(0xFFD64545),
                                  size: 32,
                                ),
                              ),
                              IconButton(
                                onPressed: onClose,
                                icon: const Icon(Icons.close),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.grey[100],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            languageProvider.t('emergency.title'),
                            style: const TextStyle(
                              fontSize: 24,
                              color: Color(0xFF2C3E50),
                              fontWeight: FontWeight.w600,
                            ),
                            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            languageProvider.t('emergency.text'),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF5A6C7D),
                              height: 1.6,
                            ),
                            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () => _handleCall(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD64545),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                languageProvider.t('emergency.call'),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: OutlinedButton(
                              onPressed: onClose,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF2C3E50),
                                side: BorderSide.none,
                                backgroundColor: Colors.grey[100],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                languageProvider.t('emergency.cancel'),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
