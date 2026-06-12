# 🐱 StudyNeko

> A Flutter-based study tracking application with Pomodoro timer, gamification, and lo-fi music — built as a CEN306 Final Project.

---

## 📱 About

StudyNeko is a mobile productivity app designed to help students build consistent study habits. It combines a Pomodoro timer, daily task management, study statistics, and a gamification system (XP, levels, streaks, badges) into a single, visually polished application.

---

## ✨ Features

- 🍅 **Pomodoro Timer** — Customizable focus and break durations with subject and notes input
- ✅ **Daily Task Manager** — Add, complete, and delete daily tasks with XP rewards
- 📊 **Statistics Dashboard** — Weekly study charts, subject breakdown, and study intensity map
- 🏆 **Achievement Badges** — Unlock 10 badges based on sessions, streaks, XP, and tasks
- ⭐ **XP & Level System** — Earn XP and level up your Neko character (Level 1–5)
- 🔥 **Study Streak** — Track consecutive study days to build habits
- 🎵 **Lo-fi Music Player** — 16 built-in lo-fi tracks to help you focus
- ⚙️ **Settings** — Customize Pomodoro duration, break duration, and daily goal

---

## 🛠️ Tech Stack

| Category | Technology |
|----------|-----------|
| Framework | Flutter & Dart |
| Database | SQLite (sqflite) |
| State Management | Provider |
| Architecture | Layered Architecture (DAO + Repository) |
| Audio | just_audio |
| Fonts | Google Fonts (Plus Jakarta Sans, Quicksand) |

---

## 🏗️ Architecture

StudyNeko follows a four-layered architecture:

```
Presentation Layer  →  UI screens and widgets
        ↓
Business Logic Layer  →  Providers (ChangeNotifier)
        ↓
Repository Layer  →  Abstracts data access
        ↓
Data Layer  →  SQLite, DAO classes, Model objects
```

---

## 📁 Project Structure

```
lib/
  main.dart
  business/
    providers/
      pomodoro_provider.dart
      session_provider.dart
      settings_provider.dart
      todo_provider.dart
  core/
    constants/
      app_constants.dart
    theme/
      app_theme.dart
  data/
    dao/
      setting_dao.dart
      study_session_dao.dart
      todo_dao.dart
    database/
      database_helper.dart
    models/
      setting.dart
      study_session.dart
      todo.dart
    repositories/
      setting_repository.dart
      study_session_repository.dart
      todo_repository.dart
  ui/
    screens/
      badges_screen.dart
      home_screen.dart
      music_screen.dart
      pomodoro_screen.dart
      session_list_screen.dart
      settings_screen.dart
      statistics_screen.dart
      todo_screen.dart
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK >= 3.0.0
- Android Studio or VS Code
- Android emulator or physical device

### Installation

```bash
# Clone the repository
git clone https://github.com/kubracelik0/studyneko.git

# Navigate to project directory
cd studyneko

# Install dependencies
flutter pub get

# Run the app
flutter run
```

---

## 📦 Dependencies

```yaml
sqflite: ^2.3.0
provider: ^6.1.2
just_audio: ^0.9.36
google_fonts: ^6.2.1
path: ^1.9.0
intl: ^0.19.0
url_launcher: ^6.3.0
```

---

## 🎓 Course Information

| Item | Detail |
|------|--------|
| Course | CEN306 - Mobile Application Design and Development |
| Instructor | Dr. Yıldız Karadayı |
| Project | Final Exam Project |
| Version | 1.0.0 |

---

## 👩‍💻 Developer

**Kübra Çelik**
CEN306 Final Project — 2026

---

*Made with 🐱 and lots of lo-fi music*
