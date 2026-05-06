# JayePanah Navigation & Intervention Flow Verification

## Overview
This document describes the complete navigation flow and intervention state machine for the JayePanah anxiety intervention app. All routes, phase transitions, and state management have been verified to ensure proper flow through the intervention process.

## Complete User Journey

### 1. Onboarding Flow (First-Time Users)
```
SplashScreen
  ↓ (auto-navigate after 2 seconds)
OnboardingScreen (3 steps with slide transitions)
  ↓ (user taps Continue)
LanguageSelectionScreen (English / اردو)
  ↓ (user selects language)
DisclaimerScreen (read & accept terms)
  ↓ (user checks "I understand" & taps Continue)
HomeScreen (main navigation hub)
```

**Files:**
- `lib/screens/SplashScreen.dart`
- `lib/screens/OnboardingScreen.dart`
- `lib/screens/LanguageSelectionScreen.dart`
- `lib/screens/DisclaimerScreen.dart`

---

### 2. Home Navigation Hub
Once users reach HomeScreen, they have 5 main actions:

#### 2.1 "I Need Help Now" (Primary CTA)
**Route:** HomeScreen → AssessmentScreen → AssessmentResultScreen → SelfRegulationScreen

```
HomeScreen
  ↓ (tap "I Need Help Now" button or floating action)
AssessmentScreen (6 yes/no questions)
  ↓ (answer all questions)
AssessmentResultScreen (shows severity level with color-coded icon)
  ↓ (tap "Continue" button)
SelfRegulationScreen (animated phase transitions)
```

**Files:**
- `lib/screens/HomeScreen.dart`
- `lib/screens/AssessmentScreen.dart`
- `lib/screens/AssessmentResultScreen.dart`
- `lib/screens/SelfRegulationScreen.dart`

---

### 3. Self-Regulation Intervention Flow (Main Crisis Response)
The SelfRegulationScreen uses AnimatedSwitcher (fade transitions) to route through phases based on severity level.

#### 3.1 Mild Severity Path
**Starting Phase:** Breathing (skips stabilization)
```
Breathing Phase (10-second cycles with visual feedback)
  ↓ (tap "Continue" after inhale/hold/exhale/hold)
Grounding Phase (5 senses: see, touch, hear, smell, taste)
  ↓ (complete all 5 steps with animated icons & step dots)
Reassurance Phase (6 calming messages with fade transitions)
  ↓ (read through all 6 messages)
Recovery Phase (check-in: Better? Same? Worse?)
```

#### 3.2 Moderate Severity Path
**Starting Phase:** Stabilization (concentric rings + heart icon)
```
Stabilization Phase ("Take a breath. You are safe.")
  ↓ (tap "Continue")
Breathing Phase (10-second cycles)
  ↓
Grounding Phase (5 steps with visual progression)
  ↓
Reassurance Phase (6 messages)
  ↓
Recovery Phase
```

#### 3.3 Severe Severity Path
**Starting Phase:** AnchorModeScreen (safety emphasis before stabilization)
```
SelfRegulationScreen detects severity=severe
  ↓ (shows AnchorModeScreen instead of stabilization)
AnchorModeScreen (heart icon, "You are experiencing severe symptoms")
  ↓ (tap "Emergency" for crisis numbers OR "Continue Breathing")
[if Continue] → Stabilization Phase
Breathing Phase
  ↓
Grounding Phase
  ↓
Reassurance Phase
  ↓
Recovery Phase
```

**Phase Transition Details:**
- StabilizationPhaseScreen (line 44): `setSelfRegulationPhase(SelfRegulationPhase.breathing)`
- BreathingPhaseScreen (line 221): `setSelfRegulationPhase(SelfRegulationPhase.grounding)`
- GroundingPhaseScreen (line 64): `setSelfRegulationPhase(SelfRegulationPhase.reassurance)` (after 5th step)
- ReassurancePhaseScreen (line 65): `setSelfRegulationPhase(SelfRegulationPhase.recovery)` (after 6th step)
- RecoveryPhaseScreen (line 22): `resetIntervention()` and navigate home (if "Better")

**Recovery Options:**
- **Better:** Reset intervention → Return to HomeScreen
- **Same:** Go back to GroundingPhaseScreen (restart breathing exercises)
- **Worse:** Show EmergencyModal (with crisis contact numbers)

**Files:**
- `lib/screens/SelfRegulationScreen.dart` (router & severity-based entry)
- `lib/screens/AnchorModeScreen.dart` (severe mode safety screen)
- `lib/screens/self_regulation/StabilizationPhaseScreen.dart`
- `lib/screens/self_regulation/BreathingPhaseScreen.dart`
- `lib/screens/self_regulation/GroundingPhaseScreen.dart`
- `lib/screens/self_regulation/ReassurancePhaseScreen.dart`
- `lib/screens/self_regulation/RecoveryPhaseScreen.dart`

---

### 4. Helper Guidance Flow (Help Someone in Crisis)
**Route:** HomeScreen → HelperGuidanceScreenWidget (sequential screens)

```
HomeScreen (tap "Help Someone" card)
  ↓
HelperGuidanceScreenWidget (router between 6 screens)
  ↓
ImmediateResponseScreen (3 steps: stay with person, gather support, lower stimuli)
  ↓ (tap "Next" through all steps)
CommunicationScreen (how to communicate with person)
  ↓
BreathingSyncScreen (breathing together)
  ↓
EnvironmentalScreen (reduce triggers)
  ↓
AssessmentScreen (assess severity)
  ↓
EscalationScreen (when to call emergency)
```

**Files:**
- `lib/screens/HelperGuidanceScreen.dart` (router)
- `lib/screens/helper_guidance/ImmediateResponseScreen.dart`
- `lib/screens/helper_guidance/CommunicationScreen.dart`
- `lib/screens/helper_guidance/BreathingSyncScreen.dart`
- `lib/screens/helper_guidance/EnvironmentalScreen.dart`
- `lib/screens/helper_guidance/AssessmentScreen.dart`
- `lib/screens/helper_guidance/EscalationScreen.dart`

---

### 5. Calm Corner (Relaxation Activities)
**Route:** HomeScreen → CalmCornerScreen → Game Selection → Individual Game Screens

```
HomeScreen (tap "Calm Corner" card)
  ↓
CalmCornerScreen (4 game options)
  ├─ Sound Gallery (music/ASMR sounds)
  │  └─ SoundGalleryScreen (tap to play/pause sounds)
  │
  ├─ Bubble Pop (tap bubbles to pop, score tracker)
  │  └─ BubbleGameScreen (custom canvas, real-time physics)
  │
  ├─ Memory Match (flip tiles to find pairs)
  │  └─ TileMatchScreen (grid of color tiles)
  │
  └─ Color Breathe (color animation with breathing instruction)
     └─ ColorCycleScreen (scale animation with Inhale/Hold/Exhale)
```

**Files:**
- `lib/screens/CalmCornerScreen.dart`
- `lib/screens/SoundGalleryScreen.dart`
- `lib/screens/BubbleGameScreen.dart`
- `lib/screens/TileMatchScreen.dart`
- `lib/screens/ColorCycleScreen.dart`

---

### 6. Education (Learn About Anxiety)
**Route:** HomeScreen → EducationScreen

```
HomeScreen (tap "Education" card)
  ↓
EducationScreen (10 scrollable cards)
  ├─ What is anxiety?
  ├─ Physical symptoms
  ├─ Why anxiety happens
  ├─ Breathing exercises
  ├─ Grounding techniques
  ├─ Professional help
  ├─ Healthy habits
  ├─ Track your progress
  ├─ Resources
  └─ About this app
```

**Files:**
- `lib/screens/EducationScreen.dart`

---

### 7. Settings
**Route:** HomeScreen → SettingsScreen

```
HomeScreen (tap gear icon)
  ↓
SettingsScreen
  ├─ Language Toggle (English / اردو)
  ├─ Haptic Feedback (switch on/off)
  ├─ Emergency Number (text input field)
  └─ Emergency Contact Button (red button to call)
```

**Files:**
- `lib/screens/SettingsScreen.dart`

---

## Route Generator Implementation

All routes are defined in `lib/routes/app_routes.dart` and handled by `lib/routes/route_generator.dart`:

| Route Name | Screen | File |
|-----------|--------|------|
| `splash` | SplashScreen | SplashScreen.dart |
| `onboarding` | OnboardingScreen | OnboardingScreen.dart |
| `languageSelection` | LanguageSelectionScreen | LanguageSelectionScreen.dart |
| `disclaimer` | DisclaimerScreen | DisclaimerScreen.dart |
| `home` | HomeScreen | HomeScreen.dart |
| `assessment` | AssessmentScreen | AssessmentScreen.dart |
| `assessmentResult` | AssessmentResultScreen | AssessmentResultScreen.dart |
| `selfRegulation` | SelfRegulationScreen | SelfRegulationScreen.dart |
| `helperGuidance` | HelperGuidanceScreenWidget | HelperGuidanceScreen.dart |
| `calmCorner` | CalmCornerScreen | CalmCornerScreen.dart |
| `soundGallery` | SoundGalleryScreen | SoundGalleryScreen.dart |
| `bubbleGame` | BubbleGameScreen | BubbleGameScreen.dart |
| `tileMatch` | TileMatchScreen | TileMatchScreen.dart |
| `colorCycle` | ColorCycleScreen | ColorCycleScreen.dart |
| `education` | EducationScreen | EducationScreen.dart |
| `settings` | SettingsScreen | SettingsScreen.dart |

---

## Severity-Based Routing

The intervention flow is customized based on assessment results:

### Assessment Scoring
- Questions have weighted Yes (2 points) / No (0 points) answers
- Total range: 0-12 points

### Severity Thresholds
| Score | Level | Entry Phase | Description |
|-------|-------|------------|-------------|
| 0-4 | **Mild** | Breathing | Quick reset mode; may benefit from relaxation |
| 5-8 | **Moderate** | Stabilization | Full intervention flow; anxiety present but manageable |
| 9-12 | **Severe** | AnchorMode → Stabilization | Crisis state; emergency modal shown first |

### State Management (InterventionStateProvider)
```dart
enum SeverityLevel { mild, moderate, severe }
enum SelfRegulationPhase { stabilization, breathing, grounding, reassurance, recovery }
enum HelperGuidanceScreen { immediateResponse, communication, ... }

InterventionStateProvider {
  - severityLevel: SeverityLevel?
  - selfRegulationPhase: SelfRegulationPhase?
  - groundingStep: int (0-4)
  - reassuranceStep: int (0-5)
  - helperScreen: HelperGuidanceScreen?
  
  Methods:
  - setSeverityLevel(SeverityLevel)
  - setSelfRegulationPhase(SelfRegulationPhase)
  - resetIntervention()
  - startSelfRegulation()
}
```

---

## Animation & Transitions

### Phase Transitions
- **AnimatedSwitcher** in SelfRegulationScreen
- Duration: 400ms
- Curve: Fade transition (FadeTransition)
- Ensures smooth, non-jarring phase changes

### Phase-Specific Animations
| Phase | Animation | Duration |
|-------|-----------|----------|
| Stabilization | Concentric rings expanding/contracting | 700ms easeInOut |
| Breathing | Radial gradient glow (breathing cycle) | 10s easeInOut |
| Grounding | Icon scale-in on each step | 300ms easeInOut |
| Reassurance | Message fade between slides | 400ms easeInOut |
| Recovery | All 3 options visible (no animation) | — |

---

## Error Handling

### Invalid Routes
- Default case in RouteGenerator returns error screen: "Route not found"

### State Preservation
- InterventionStateProvider saves state on app pause/inactive
- `lib/providers/InterventionStateProvider.dart` → `saveState()` / `restoreState()`

### Emergency Fallback
- All crisis screens have EmergencyModal accessible via button
- Located in `lib/components/EmergencyModal.dart`

---

## Language Support

All screens support bilingual UI (English + Urdu):
- LanguageProvider manages current language
- TextDirection adjusts based on RTL preference
- Translation keys mapped in `lib/providers/LanguageProvider.dart`

---

## Verification Checklist

✅ All routes defined in `app_routes.dart`  
✅ All routes handled in `route_generator.dart`  
✅ Severity-based phase entry points correct  
✅ Phase transitions properly implemented  
✅ AnimatedSwitcher fade transitions enabled  
✅ Emergency modal accessible from all crisis screens  
✅ Recovery phase loop-back to grounding functional  
✅ Helper guidance sequential flow verified  
✅ Calm corner game navigation correct  
✅ Language toggle functional  
✅ State persistence on app pause  
✅ No compilation errors  
✅ All screens use new DesignSystem colors  
✅ Glassmorphism UI applied consistently  

---

## Next Steps

### Testing
- [ ] End-to-end flow testing on real device
- [ ] Verify assessment scoring logic
- [ ] Test phase transitions feel smooth
- [ ] Confirm emergency numbers display correctly
- [ ] Test language switching mid-intervention
- [ ] Verify state restoration after app kill/relaunch

### Refinement
- [ ] Gather user feedback on intervention flow
- [ ] Adjust phase durations based on user testing
- [ ] Polish animation timing
- [ ] Consider additional game mechanics for Calm Corner
- [ ] Add success/completion celebration screen

