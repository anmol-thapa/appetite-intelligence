# Appetite Intelligence

**Appetite Intelligence** is a Flutter-based calorie tracking app that helps users cut down on junk food using personalized food logging, AI-powered insights, and smart cheat meal allowances.

---

## Features

- **Log Meals**: Add food with calorie & macro info (Fat, Carbs, Protein)
- **Label Food**: Categorize as **Healthy**, **Neutral**, or **Junk**
- **Visual Insights**:
  - Pie charts for junk vs. healthy breakdown
  - Macro source breakdown by health rating
- **Firebase Authentication**:
  - Secure sign-in and real-time syncing of user data
- **AI Analysis - In Progress**:
  - Detect when and how junk food is usually consumed (e.g., late-night snacks, weekend trends)
  - Personalized predictions based on eating history

---

## Packages Used

**Core**
- [`cloud_firestore`](https://pub.dev/packages/cloud_firestore)
- [`firebase_auth`](https://pub.dev/packages/firebase_auth)
- [`firebase_core`](https://pub.dev/packages/firebase_core)
- [`flutter_riverpod`](https://pub.dev/packages/flutter_riverpod)
- [`go_router`](https://pub.dev/packages/go_router)
- [`google_fonts`](https://pub.dev/packages/google_fonts)
- [`http`](https://pub.dev/packages/http)
- [`intl`](https://pub.dev/packages/intl)
- [`ntp`](https://pub.dev/packages/ntp)

**Extras**
- [`barcode_scan2`](https://pub.dev/packages/barcode_scan2)
- [`arc_progress_bar_new`](https://pub.dev/packages/arc_progress_bar_new)
- [`custom_sliding_segmented_control`](https://pub.dev/packages/custom_sliding_segmented_control)
- [`fl_chart`](https://pub.dev/packages/fl_chart)
- [`validators`](https://pub.dev/packages/validators)
- [`lottie`](https://pub.dev/packages/lottie)

---

## AI Roadmap

- Use on-device ML to detect eating trends
- Predict junk food consumption windows
- Suggest habit change interventions

---