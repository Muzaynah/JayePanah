import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/LanguageProvider.dart';
import '../providers/InterventionStateProvider.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class AssessmentQuestion {
  final String questionKey;
  final String subtitleKey;
  final bool isCritical;

  const AssessmentQuestion({
    required this.questionKey,
    required this.subtitleKey,
    required this.isCritical,
  });
}

const _assessmentQuestions = [
  AssessmentQuestion(
    questionKey: 'assessment.breathing',
    subtitleKey: 'assessment.breathing.sub',
    isCritical: true,
  ),
  AssessmentQuestion(
    questionKey: 'assessment.control',
    subtitleKey: 'assessment.control.sub',
    isCritical: true,
  ),
  AssessmentQuestion(
    questionKey: 'assessment.physical',
    subtitleKey: 'assessment.physical.sub',
    isCritical: false,
  ),
];

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen>
    with SingleTickerProviderStateMixin {
  int _currentQuestion = 0;
  int _severityScore = 0;
  bool _hasCriticalSymptom = false;
  final List<bool?> _answers = List.filled(3, null);
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: DesignSystem.durationNormal,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _answerQuestion(bool answer) {
    _answers[_currentQuestion] = answer;

    final question = _assessmentQuestions[_currentQuestion];
    if (answer && question.isCritical) {
      _hasCriticalSymptom = true;
    }
    if (answer) {
      _severityScore++;
    }

    if (_currentQuestion < _assessmentQuestions.length - 1) {
      _slideController.forward().then((_) {
        setState(() {
          _currentQuestion++;
        });
        _slideController.reset();
      });
    } else {
      _finishAssessment();
    }
  }

  void _finishAssessment() {
    final severity = _hasCriticalSymptom
        ? SeverityLevel.severe
        : _severityScore >= 2
            ? SeverityLevel.moderate
            : SeverityLevel.mild;

    context.read<InterventionStateProvider>().startWithSeverity(severity);
    Navigator.pushReplacementNamed(context, AppRoutes.assessmentResult);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.read<LanguageProvider>();
    final question = _assessmentQuestions[_currentQuestion];

    return Scaffold(
      backgroundColor: DesignSystem.backgroundBase,
      appBar: AppBar(
        title: Text(lang.t('severity.title')),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background blobs
          BackgroundBlob(
            top: -60,
            left: -80,
            width: 280,
            height: 280,
            color: DesignSystem.glassSage,
            opacity: 0.35,
          ),
          BackgroundBlob(
            bottom: 80,
            right: -60,
            width: 240,
            height: 240,
            color: DesignSystem.glassLavender,
            opacity: 0.30,
          ),
          // Main content
          SafeArea(
            child: Column(
              children: [
                // Progress indicator
                Padding(
                  padding: const EdgeInsets.all(DesignSystem.spaceLG),
                  child: Row(
                    children: List.generate(
                      _assessmentQuestions.length,
                      (index) => Expanded(
                        child: Container(
                          height: 4,
                          margin: const EdgeInsets.symmetric(
                            horizontal: DesignSystem.spaceSM,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: index <= _currentQuestion
                                ? DesignSystem.accentSage
                                : DesignSystem.textSecondary.withValues(
                                    alpha: 0.3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Question number
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignSystem.spaceLG,
                  ),
                  child: Text(
                    'Question ${_currentQuestion + 1} of ${_assessmentQuestions.length}',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: DesignSystem.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: DesignSystem.spaceMD),
                // Question card
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignSystem.spaceLG,
                    ),
                    child: GlassCard(
                      tintColor: DesignSystem.glassSage,
                      tintOpacity: 0.22,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            lang.t(question.questionKey),
                            style: GoogleFonts.dmSerifDisplay(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              color: DesignSystem.textPrimary,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: DesignSystem.spaceMD),
                          Text(
                            lang.t(question.subtitleKey),
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: DesignSystem.textSecondary,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: DesignSystem.spaceXL),
                          // Yes/No buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _answerQuestion(true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        DesignSystem.accentSage,
                                  ),
                                  child: Text(lang.t('assessment.yes')),
                                ),
                              ),
                              const SizedBox(width: DesignSystem.spaceMD),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () =>
                                      _answerQuestion(false),
                                  child: Text(lang.t('assessment.no')),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: DesignSystem.spaceXL),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
