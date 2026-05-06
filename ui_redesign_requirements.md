# UI Redesign Requirements — Panic Attack Help App (Pakistan Context)

## Overview & Design Intent

This document specifies exact UI changes to transform the current app into a calming, trustworthy, and beautiful experience. The aesthetic is **soft naturalism** — think a quiet garden at dawn. Pastel sage greens and lavenders, warm whites, real glassmorphism done right, and gentle motion. Everything should feel safe, unhurried, and human.

The app serves people in Pakistan who may be experiencing a panic attack themselves or trying to help someone else. The UI must not feel clinical, cold, or overwhelming. It should feel like a trusted friend's hand on your shoulder.

---

## 1. Color Palette

Use these exact values as your Flutter `ThemeData` color scheme. The palette is built around **sage green**, **soft lavender**, and **warm white**, with one warm accent.

```dart
// Core palette
const Color backgroundBase     = Color(0xFFF7F6F2); // warm off-white, never pure white
const Color backgroundSurface  = Color(0xFFEFEDE8); // slightly deeper warm surface

// Glassmorphism tint colors (use with opacity)
const Color glassSage          = Color(0xFFA8C5A0); // sage green
const Color glassLavender      = Color(0xFFB8B0D4); // soft lavender
const Color glassPeach         = Color(0xFFE8C4B0); // warm peach accent
const Color glassMist          = Color(0xFFD4E0DC); // cool mist/teal-white

// Text colors
const Color textPrimary        = Color(0xFF2E2E2E); // near-black, warm toned
const Color textSecondary      = Color(0xFF7A7A72); // muted warm grey
const Color textOnGlass        = Color(0xFF3A3A38); // for text on glass cards

// Accent / CTA
const Color accentSage         = Color(0xFF6B9B6B); // deeper sage for buttons
const Color accentLavender     = Color(0xFF7E74B8); // deeper lavender for secondary actions
```

**Rules:**
- Never use pure `#FFFFFF` or `#000000` anywhere in the UI.
- Background gradient should go from `backgroundBase` at top to `backgroundSurface` at bottom on every screen. Angle: 160°.
- Avoid blues and reds entirely (they read as clinical or alarming).

---

## 2. Glassmorphism — Done Right

The current glass looks ugly because it probably lacks proper layering. Here is the exact specification:

### Glass Card Properties
```dart
// Every glass card/panel should use:
Container(
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.45),       // base fill
    borderRadius: BorderRadius.circular(24),
    border: Border.all(
      color: Colors.white.withOpacity(0.70),     // bright white border
      width: 1.2,
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0xFF8FA89A).withOpacity(0.15), // sage-tinted shadow
        blurRadius: 24,
        spreadRadius: 0,
        offset: Offset(0, 8),
      ),
      BoxShadow(
        color: Colors.white.withOpacity(0.80),   // inner highlight
        blurRadius: 1,
        spreadRadius: -1,
        offset: Offset(0, 1),
      ),
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(24),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: /* your content */,
    ),
  ),
)
```

### What was wrong before (avoid this):
- `BackdropFilter` applied with nothing interesting behind it → blur on plain white = invisible effect.
- Fix: **Always place glass cards over a gradient or a soft illustrated/blurred background blob**. Place 2–3 large soft gradient blobs (circles with `blur: 80–120`) behind all glass surfaces so the blur effect is visible and beautiful.

### Background Blob Example
Place these in a `Stack` behind all content on each screen:
```dart
// Blob 1 — sage green, top-left
Positioned(
  top: -60, left: -80,
  child: Container(
    width: 280, height: 280,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Color(0xFFA8C5A0).withOpacity(0.35),
    ),
    child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80)),
  ),
)

// Blob 2 — lavender, bottom-right
Positioned(
  bottom: 80, right: -60,
  child: Container(
    width: 240, height: 240,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Color(0xFFB8B0D4).withOpacity(0.30),
    ),
  ),
)

// Blob 3 — peach, center
Positioned(
  top: MediaQuery.of(context).size.height * 0.4, left: 80,
  child: Container(
    width: 160, height: 160,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Color(0xFFE8C4B0).withOpacity(0.20),
    ),
  ),
)
```

---

## 3. Typography

Use **DM Serif Display** for headings and **Nunito** for body/UI text. Both are on Google Fonts.

```yaml
# pubspec.yaml
google_fonts: ^6.1.0
```

```dart
// Heading (calming, soft-serif feel)
TextStyle headingLarge = GoogleFonts.dmSerifDisplay(
  fontSize: 28,
  fontWeight: FontWeight.w400,  // serifs look best at regular weight
  color: textPrimary,
  height: 1.3,
);

TextStyle headingMedium = GoogleFonts.dmSerifDisplay(
  fontSize: 22,
  fontWeight: FontWeight.w400,
  color: textPrimary,
);

// Body / UI text
TextStyle bodyLarge = GoogleFonts.nunito(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: textPrimary,
  height: 1.6,
);

TextStyle bodyMedium = GoogleFonts.nunito(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: textSecondary,
);

TextStyle labelButton = GoogleFonts.nunito(
  fontSize: 16,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.3,
  color: Colors.white,
);

// Urdu/mixed text — keep system font but increase size for readability
TextStyle urduBody = TextStyle(
  fontFamily: 'Jameel Noori Nastaleeq', // or system default
  fontSize: 18,
  height: 2.0,  // Nastaliq needs extra line height
  color: textPrimary,
);
```

---

## 4. Buttons

### Primary CTA Button (e.g., "شروع کریں", "Start Breathing")
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: accentSage,
    foregroundColor: Colors.white,
    minimumSize: Size(double.infinity, 56),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
    elevation: 0,
    shadowColor: Colors.transparent,
  ).copyWith(
    overlayColor: MaterialStateProperty.all(
      Colors.white.withOpacity(0.15),
    ),
  ),
)
```

### Secondary / Ghost Button
```dart
OutlinedButton(
  style: OutlinedButton.styleFrom(
    foregroundColor: accentSage,
    minimumSize: Size(double.infinity, 52),
    side: BorderSide(color: accentSage.withOpacity(0.5), width: 1.5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
  ),
)
```

### Floating Soft Pill Button (for quick actions like "I'm okay now")
```dart
// Glass pill — used for secondary choices mid-screen
Container(
  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.55),
    borderRadius: BorderRadius.circular(100),
    border: Border.all(color: Colors.white.withOpacity(0.8), width: 1),
    boxShadow: [
      BoxShadow(
        color: Color(0xFF8FA89A).withOpacity(0.12),
        blurRadius: 16, offset: Offset(0, 4),
      )
    ],
  ),
)
```

---

## 5. Cards — Journey / Exercise Cards

Inspired by Image 1 (Wysa-style) but elevated with the glass treatment:

```dart
// Card structure
Container(
  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  decoration: BoxDecoration(
    // Use tinted glass: sage for calming exercises, lavender for breathing
    color: Color(0xFFA8C5A0).withOpacity(0.22),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(
      color: Colors.white.withOpacity(0.65),
      width: 1.2,
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0xFF8FA89A).withOpacity(0.12),
        blurRadius: 20, offset: Offset(0, 6),
      ),
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(24),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: /* card content */,
      ),
    ),
  ),
)
```

**Card color tinting by type:**
| Exercise Type | Glass Tint Color | Opacity |
|---|---|---|
| Breathing | `glassSage` | 0.22 |
| Grounding (5-4-3-2-1) | `glassLavender` | 0.20 |
| For helpers / others | `glassMist` | 0.25 |
| Urgent / "I'm panicking now" | `glassPeach` | 0.18 |

---

## 6. Breathing Animation (Key Screen)

Inspired by Image 2 (the glowing orb). This is the most critical screen.

```dart
// Animated breathing orb
// Use AnimationController with duration matching the breathing phase

// Visual: a soft blurred circle that scales from 0.6 to 1.0
// Inner: solid pastel fill (sage or lavender)
// Outer: same color at ~0.2 opacity, larger, blurred — creates glow

AnimatedContainer(
  duration: Duration(seconds: 4),
  curve: Curves.easeInOut,
  width: isInhale ? 200 : 120,
  height: isInhale ? 200 : 120,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    gradient: RadialGradient(
      colors: [
        Color(0xFFA8C5A0).withOpacity(0.9),  // sage center
        Color(0xFFB8B0D4).withOpacity(0.4),  // lavender mid
        Colors.transparent,
      ],
      stops: [0.0, 0.6, 1.0],
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0xFFA8C5A0).withOpacity(0.4),
        blurRadius: isInhale ? 60 : 20,
        spreadRadius: isInhale ? 20 : 5,
      ),
    ],
  ),
)

// Text below the orb: DM Serif Display, 24px
// "سانس لیں" (Inhale) / "روکیں" (Hold) / "چھوڑیں" (Exhale)
// Fade in/out with the animation phases
```

**Breathing screen background:** Pure `backgroundBase` (#F7F6F2) with the three blobs. No other distractions. Just the orb, the instruction text, and a subtle phase counter.

---

## 7. Navigation Bar

```dart
// Bottom nav — glass style
Container(
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.70),
    border: Border(
      top: BorderSide(color: Colors.white.withOpacity(0.9), width: 1),
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0xFF8FA89A).withOpacity(0.10),
        blurRadius: 20, offset: Offset(0, -4),
      ),
    ],
  ),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
    child: BottomNavigationBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      selectedItemColor: accentSage,
      unselectedItemColor: textSecondary,
      // Icons: use outlined icons; selected = filled
    ),
  ),
)
```

---

## 8. Home Screen Layout

Inspired by Image 2 (left panel). Structure:

```
┌─────────────────────────────────────────┐
│  [Greeting]  "آپ کیسا محسوس کر رہے ہیں؟"│  ← DM Serif, 26px
│                                         │
│  ┌─ Mood Pills ──────────────────────┐  │
│  │  [گھبراہٹ]  [پریشانی]  [ٹھیک]    │  │  ← Nunito, soft glass pills
│  └───────────────────────────────────┘  │
│                                         │
│  ┌─ Feature Card (glass, sage) ──────┐  │
│  │  "ابھی مدد چاہیے؟"               │  │
│  │  → سانس لینے کی مشق  [شروع کریں] │  │
│  └───────────────────────────────────┘  │
│                                         │
│  "کسی اور کی مدد کریں"                  │  ← section label
│  ┌─ Card ─┐  ┌─ Card ─┐               │
│  │ Helper │  │ Ground │               │
│  │ Guide  │  │  ing   │               │
│  └────────┘  └────────┘               │
└─────────────────────────────────────────┘
```

---

## 9. Spacing & Border Radius System

```dart
// Spacing scale (multiples of 4)
const double spaceXS  = 4.0;
const double spaceSM  = 8.0;
const double spaceMD  = 16.0;
const double spaceLG  = 24.0;
const double spaceXL  = 32.0;
const double spaceXXL = 48.0;

// Border radius scale
const double radiusSM  = 12.0;  // chips, tags
const double radiusMD  = 18.0;  // buttons
const double radiusLG  = 24.0;  // cards
const double radiusXL  = 32.0;  // full-screen modal sheets
const double radiusPill = 100.0; // pill buttons

// Content padding (screen edges)
const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 16);
```

---

## 10. Micro-interactions & Motion

Keep all animations **slow and calming** — nothing snappy or bouncy.

```dart
// Standard transition duration
const Duration durationFast   = Duration(milliseconds: 200);
const Duration durationNormal = Duration(milliseconds: 400);
const Duration durationSlow   = Duration(milliseconds: 700);

// Always use Curves.easeInOut or Curves.easeOut
// Never use Curves.bounceIn/bounceOut (too energetic for panic context)

// Card appear animation: fade + slide up 16px
// Button press: scale to 0.97, duration 150ms
// Screen transitions: fade, not slide (less disorienting for anxious users)
```

---

## 11. Icon Style

- Use **outlined icons only** (e.g., `Icons.favorite_border`, not `Icons.favorite`)
- Selected/active state: filled + `accentSage` color
- Size: 24px standard, 28px for primary actions
- Never use flat emoji as icons — use proper icon widgets

---

## 12. What NOT to Do (Anti-Patterns)

| ❌ Avoid | ✅ Instead |
|---|---|
| Pure white `#FFFFFF` backgrounds | Warm off-white `#F7F6F2` |
| Glass blur with nothing behind it | Always have colored blobs under glass |
| High-contrast red for urgency | Warm peach `#E8C4B0` tints |
| Bouncy/spring animations | `Curves.easeInOut`, slow durations |
| Dense text blocks in Urdu | Large font size (18px+), generous line-height (2.0) |
| Generic `BoxDecoration` with one shadow | Layered shadows: one deep, one white inner highlight |
| `Inter` or `Roboto` fonts | `DM Serif Display` + `Nunito` |
| Flat colored buttons with hard edges | Subtle shadow, rounded `18px`, no harsh elevation |
| Dark mode as default | Light mode primary; warm, soft, natural |

---

## 13. Required Flutter Packages

```yaml
dependencies:
  google_fonts: ^6.1.0           # DM Serif Display + Nunito
  flutter_animate: ^4.5.0        # declarative animations
  glassmorphism: ^3.0.0          # optional helper, or build manually
  lottie: ^3.1.0                 # for breathing animation (optional)
```

---

## Summary

The single most important thing: **every screen should feel like you're looking through frosted glass at a soft garden**. Warm whites, sage greens, and lavenders. Serene typography. The blur effect must have something colorful behind it to work. Animations must breathe, not bounce. This is a calm space, not an app.
