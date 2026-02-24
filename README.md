## JayePanah – Psychological First Aid for Panic

JayePanah is a Flutter application that provides structured, ethical, and culturally aware psychological first aid during panic episodes.  
It implements two main modes:

- **Self‑Regulation Mode** – for people experiencing panic themselves.
- **Helper Guidance Mode** – for someone supporting a person in panic.

The app is a **first‑aid tool**, not a replacement for professional mental health care.

---

## Project Structure (Flutter side)

All application code lives under `lib/`:

- `lib/main.dart`
- `lib/app.dart`
- `lib/routes/`
- `lib/providers/`
- `lib/theme/`
- `lib/components/`
- `lib/screens/`

Below is a detailed explanation of **what each file does** and **how flows are wired together**, followed by notes on further changes.

---

## Entry point and app shell

### `lib/main.dart`
- **Responsibilities**
  - Standard Flutter entry point.
  - Calls `runApp(const App());`.
- **When to touch**
  - Rarely. Only if you need to change the root widget or integrate platform‑level bootstrapping.

### `lib/app.dart`
- **Responsibilities**
  - Wraps the whole app in `MultiProvider`:
    - `LanguageProvider` – manages language, translations, and RTL vs LTR.
    - `InterventionStateProvider` – manages progress/state across self‑regulation and helper flows.
  - Builds a single `MaterialApp` with:
    - Title: `JayePanah`.
    - `AppTheme.lightTheme` and `AppTheme.darkTheme`.
    - `locale` bound to the current language (`en`/`ur`).
    - Routing via `RouteGenerator.generateRoute`.
    - `initialRoute` = splash.
- **When to touch**
  - To add new global providers.
  - To add localization delegates or modify top‑level theming/locale behavior.

---

## Routing

### `lib/routes/app_routes.dart`
- **Responsibilities**
  - Central list of route string constants:
    - `/` (splash), `/onboarding`, `/language`, `/disclaimer`, `/home`,
      `/settings`, `/education`, `/self-regulation`, `/helper-guidance`.
- **When to touch**
  - When adding a new screen that should be navigable via `Navigator.pushNamed`.

### `lib/routes/route_generator.dart`
- **Responsibilities**
  - Maps `AppRoutes.*` to actual screen widgets via `MaterialPageRoute`.
  - Current routes:
    - `AppRoutes.splash` → `SplashScreen`
    - `AppRoutes.onboarding` → `OnboardingScreen`
    - `AppRoutes.languageSelection` → `LanguageSelectionScreen`
    - `AppRoutes.disclaimer` → `DisclaimerScreen`
    - `AppRoutes.home` → `HomeScreen`
    - `AppRoutes.education` → `EducationScreen`
    - `AppRoutes.selfRegulation` → `SelfRegulationScreen`
    - `AppRoutes.helperGuidance` → `HelperGuidanceScreenWidget`
    - `AppRoutes.settings` → `SettingsScreen`
- **When to touch**
  - To register new screens, or change navigation behavior (e.g. custom transitions).

---

## Global state and translations

### `lib/providers/LanguageProvider.dart`
- **Responsibilities**
  - `ChangeNotifier` managing:
    - `currentLanguage` (`'en'` or `'ur'`).
    - `isRTL` (true for Urdu).
    - `t(key)` translation lookup.
  - Persists language choice in `SharedPreferences` (`jayepanah_language`).
  - Contains **all app copy** in both English and Urdu:
    - App name/tagline.
    - Onboarding texts.
    - Language selection texts.
    - Disclaimer.
    - Home labels & tooltips.
    - Settings sections and descriptions.
    - Education content.
    - Emergency modal text.
    - Self‑regulation phase texts (stabilization, breathing, grounding, reassurance, recovery).
    - Helper guidance texts.
- **When to touch**
  - To add or update user‑facing text.
  - To add more languages (extend the `_translations` map and `supportedLocales` in `App`).

### `lib/providers/InterventionStateProvider.dart`
- **Responsibilities**
  - Central state for both intervention modes.
  - Enums:
    - `SelfRegulationPhase` – `stabilization`, `breathing`, `grounding`, `reassurance`, `recovery`.
    - `HelperGuidanceScreen` – `immediateResponse`, `communication`, `breathingSync`, `environmental`, `assessment`, `escalation`.
  - Tracks:
    - Current `selfRegulationPhase`.
    - Current `helperScreen`.
    - Grounding step index (for 5‑4‑3‑2‑1).
    - Reassurance step index.
    - Whether breathing is paused.
    - Session start timestamp.
    - User’s recovery response.
  - Persists state via `SharedPreferences`:
    - Phase index, helper screen index, grounding/reassurance indices, session start time.
  - Public API:
    - `startSelfRegulation()`, `setSelfRegulationPhase(...)`.
    - `setHelperScreen(...)`.
    - `setGroundingStep(...)`, `setReassuranceStep(...)`.
    - `setBreathingPaused(...)`.
    - `setRecoveryResponse(...)`.
    - `resetIntervention()` – clears current flow.
    - `saveState()` – writes current state to `SharedPreferences`.
- **When to touch**
  - To add new phases or helper screens.
  - To change persistence strategy or extend state with more context (e.g. metrics).

---

## Theming

### `lib/theme/app_theme.dart`
- **Responsibilities**
  - Defines `AppTheme.lightTheme` and `AppTheme.darkTheme` using Material 3 and `ColorScheme.fromSeed`.
  - Central place to later add typography, custom color schemes, etc.
- **When to touch**
  - To refine the global visual style, fonts, component themes.

---

## Core components

### `lib/components/EmergencyModal.dart`
- **Responsibilities**
  - Re‑usable emergency escalation modal:
    - Dimmed background, modal card with title, description, and actions.
    - Text is fully localized and respects RTL via `LanguageProvider`.
    - Primary action: call configured emergency number via `url_launcher`.
    - Secondary action: cancel/close.
  - Reads:
    - `jayepanah_emergency_number` from `SharedPreferences` (default `1122`).
- **When to touch**
  - To change emergency behavior (e.g. SMS, multiple numbers).
  - To refine emergency messaging.

---

## Screens – App lifecycle & onboarding

### `lib/screens/SplashScreen.dart`
- **Responsibilities**
  - Gradient splash with breathing‑like animation of the app name/tagline.
  - After 3 seconds, checks `jayepanah_onboarding_complete`:
    - If true → navigate to `home`.
    - If false → navigate to `onboarding`.
  - Uses `LanguageProvider` for texts and RTL.
  - Guards against using `BuildContext` after async operations by checking `mounted`.
- **When to touch**
  - To change splash duration/animation.
  - To adjust initial routing logic.

### `lib/screens/OnboardingScreen.dart`
- **Responsibilities**
  - Multi‑step onboarding with three steps:
    - What the app is.
    - What it is not.
    - Privacy & safety.
  - Animated transitions between steps (LTR/RTL aware).
  - Progress bar (segments) to show position.
  - Final step navigates to language selection.
- **When to touch**
  - To adjust onboarding copy or add/remove steps.

### `lib/screens/LanguageSelectionScreen.dart`
- **Responsibilities**
  - Presents language options (English / Urdu).
  - On select:
    - Calls `LanguageProvider.setLanguage`.
    - Navigates to disclaimer.
- **When to touch**
  - To add more languages or change selection UI.

### `lib/screens/DisclaimerScreen.dart`
- **Responsibilities**
  - Ethical disclaimer about the app’s scope and limitations.
  - Checkbox “I understand” gate:
    - Continue button is disabled until checked.
  - On continue:
    - Sets `jayepanah_onboarding_complete = true`.
    - Navigates to `home`.
- **When to touch**
  - To update ethical/legal text or gating logic.

---

## Home (Mode selection)

### `lib/screens/HomeScreen.dart`
- **Responsibilities**
  - Main mode selection UI:
    - **Self‑Regulation Mode** card.
    - **Helper Guidance Mode** card.
  - Modernized layout and visuals:
    - Gradient background with animated circular highlights.
    - Animated entrance for mode cards (fade + slide).
    - Rich, card‑based design with icon gradients and shadows.
  - Header:
    - App name + subtitle (localized, RTL aware).
    - Buttons for Education and Settings.
  - Persistent bottom emergency button that opens `EmergencyModal`.
- **When to touch**
  - To further refine mode cards (icons, colors, layout).
  - To add quick links or metrics (e.g. “last used”).

---

## Self‑Regulation Mode – full flow

Entry point: `lib/screens/SelfRegulationScreen.dart`

### `SelfRegulationScreen.dart`
- **Responsibilities**
  - High‑level flow controller for self‑regulation mode.
  - Uses `InterventionStateProvider.selfRegulationPhase` to decide which phase screen to show:
    - `StabilizationPhaseScreen`
    - `BreathingPhaseScreen`
    - `GroundingPhaseScreen`
    - `ReassurancePhaseScreen`
    - `RecoveryPhaseScreen`
  - `WidgetsBindingObserver` to persist state on app lifecycle changes via `InterventionStateProvider.saveState()`.
- **When to touch**
  - To insert new phases or reorder existing phases.

### `self_regulation/StabilizationPhaseScreen.dart`
- **Phase 1: Stabilization – “You are safe”**
  - Calming gradient background + subtle breathing‑like circle animation.
  - Text: “You are safe” (localized, RTL).
  - Single primary action: **Start** → moves to breathing phase.
  - No detailed instructions yet (user is just anchored to a safe place).

### `self_regulation/BreathingPhaseScreen.dart`
- **Phase 2: Breathing Regulation**
  - Full‑screen breathing visual:
    - Multi‑layer concentric circles with radial gradients.
    - Size oscillates with timing optimized for slow breathing.
    - Arrows indicating inhale (up) vs exhale (down).
  - Instruction line:
    - Fades between “Breathe In” and “Breathe Out” (`self.breathing.inhale/exhale`).
  - Optional guidance:
    - Text‑to‑speech using `flutter_tts` (respects current language).
    - Haptic pulses using `vibration` (if enabled in Settings).
  - Breath counter:
    - Displays the number of breaths completed (`self.breathing.count`).
  - Controls:
    - Circular **pause/play** button (no timer shown to avoid pressure).
    - **Continue** button → moves to Grounding phase.

### `self_regulation/GroundingPhaseScreen.dart`
- **Phase 3: Sensory Grounding (5‑4‑3‑2‑1)**
  - Each sense is a separate screen with:
    - Dominant icon (eye, touch, hearing, smell, taste).
    - Single instruction, e.g. “Name 5 things you can see”.
  - Progress indicator using top bars.
  - **Back is disabled** (`PopScope(canPop: false)`) to prevent looping.
  - “Next” / “Continue” button advances or transitions to reassurance phase.

### `self_regulation/ReassurancePhaseScreen.dart`
- **Phase 4: Cognitive Reassurance**
  - Sequence of short affirmation screens:
    - “This is uncomfortable, not dangerous.”
    - “Your body is protecting you.”
    - “This will pass.”
  - Progress indicator at top (segments).
  - “Next” / “Continue” moves through affirmations, then to recovery phase.

### `self_regulation/RecoveryPhaseScreen.dart`
- **Phase 5: Recovery & Aftercare**
  - Asks: **“How do you feel now?”**
  - Options:
    - Better
    - Same
    - Worse
  - Branching:
    - **Better**:
      - Calls `resetIntervention()`.
      - Navigates back to `home`.
    - **Same**:
      - Sends user back to Grounding phase (`phase = grounding`, step = 0).
    - **Worse**:
      - Opens `EmergencyModal` to encourage escalation.
  - Bottom persistent emergency button mirroring behavior from Home.

---

## Helper Guidance Mode – full flow

Entry point: `lib/screens/HelperGuidanceScreen.dart`

### `HelperGuidanceScreen.dart`
- **Responsibilities**
  - Flow controller for Helper Guidance mode.
  - Uses `InterventionStateProvider.helperScreen` and the `HelperGuidanceScreen` enum to decide which helper screen to render:
    - `ImmediateResponseScreen`
    - `CommunicationScreen`
    - `BreathingSyncScreen`
    - `EnvironmentalScreen`
    - `AssessmentScreen`
    - `EscalationScreen`
  - Starts at `immediateResponse` if no state is present.
  - Persists state on lifecycle changes.

### `helper_guidance/ImmediateResponseScreen.dart`
- **Helper Screen 1 – Immediate Response**
  - Simple, calm layout with:
    - “Stay calm”
    - “Stay with them”
    - “Lower stimulation”
  - Uses icon + text rows for clarity.
  - Single “Next” button advances the flow.

### `helper_guidance/CommunicationScreen.dart`
- **Helper Screen 2 – Communication Guide**
  - Three sections:
    - **What to say** – examples of validating, grounding language.
    - **What NOT to say** – phrases to avoid (“just relax”, minimizing).
    - **Tone guidance** – guidance on pace, volume, and emotional tone.
  - Layout uses cards with icons for each category.

### `helper_guidance/BreathingSyncScreen.dart`
- **Helper Screen 3 – Breathing Synchronization**
  - Visual breathing circle similar to self‑regulation but framed as:
    - “Breathe together”.
  - Encourages the helper to sync breathing with the person in panic.

### `helper_guidance/EnvironmentalScreen.dart`
- **Helper Screen 4 – Environmental Control**
  - Simple checklist‑style guidance:
    - Reduce noise.
    - Remove crowd.
    - Sit safely.
  - Each item uses icons and brief text.

### `helper_guidance/AssessmentScreen.dart`
- **Helper Screen 5 – Assessment**
  - Interactive checklist:
    - Can they speak?
    - Can they breathe?
    - Is panic reducing?
  - Each item is a toggleable card.
  - “Next” progresses to escalation decision (not blocked on selection).

### `helper_guidance/EscalationScreen.dart`
- **Helper Screen 6 – Escalation Decision**
  - Shows **medical red flags** and explains when escalation is appropriate.
  - Provides:
    - **Emergency call** CTA opening `EmergencyModal`.
    - **Finish** button that resets intervention and returns home.

---

## Education & static content

### `lib/screens/EducationScreen.dart`
- **Responsibilities**
  - Scrollable list of education cards about panic:
    - What panic attacks are.
    - What they feel like.
    - What helps / what worsens panic.
    - How to support someone.
    - When to seek professional help.
  - Each card:
    - Icon + title + localized text.
  - Header with back button and title bar.

---

## Settings & personalization

### `lib/screens/SettingsScreen.dart`
- **Responsibilities**
  - Multi‑section settings UI with collapsible sections:
    - **General** – language, text size, motion, “low stimulus” mode (dark/low contrast).
    - **Guidance preferences** – audio guidance, voice type, haptic breathing.
    - **Emergency** – emergency number, placeholders for trusted contacts and templates.
    - **Safety & ethics** – data usage, anonymous usage toggle, reset app state.
    - **About** – purpose, disclaimer, resources (helplines, etc.).
  - Uses:
    - Custom `SettingsSection` with animated expand/collapse.
    - `SettingToggle` for individual switch rows.
    - `SharedPreferences` for persistent settings.
  - **Behavior**:
    - All settings propagate into other parts of the app (e.g. breathing audio/haptics).
    - “Reset Everything” clears local state and restarts at splash.

### `SettingsSection` (in same file)
- **Responsibilities**
  - Section card UI:
    - Header row with icon, title, and chevron.
    - Animated body using `AnimatedSize`.
  - Respects RTL layout.

### `SettingToggle` (in same file)
- **Responsibilities**
  - Reusable toggle row:
    - Optional icon.
    - Label text.
    - Switch.
  - Layout is robust to long labels and RTL.

---

## Further changes & extension points

Here are recommended next steps and where to make them:

- **Fine‑tune breathing timing**
  - File: `BreathingPhaseScreen.dart`
  - Adjust `AnimationController` duration and interpolation for inhale/exhale ratio (e.g. 4‑7‑8 breathing).

- **Add more self‑regulation tools**
  - Files: `SelfRegulationScreen.dart`, `InterventionStateProvider.dart`
  - Add new `SelfRegulationPhase` values and screens (e.g. body scan, safe‑place imagery).

- **Richer helper flows**
  - Files: `helper_guidance/*.dart`, `InterventionStateProvider.dart`
  - Insert screens for “what to do after panic”, “self‑care for helper”.

- **Analytics (privacy‑preserving)**
  - File: `InterventionStateProvider.dart` or a new provider.
  - Track anonymous aggregates: which flows are used, for how long, where users drop off.

- **Accessibility**
  - Respect text size preference across the app (currently stored but not globally applied).
  - File: `AppTheme` + individual screens.

- **Theming and typography**
  - File: `app_theme.dart`
  - Introduce a consistent typographic scale and color roles tuned for low‑stimulus environments.