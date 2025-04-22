# 🌿 AyurScan

**AyurScan** is a cross-platform Flutter application powered by a Flask backend that uses AI to identify Ayurvedic plants through images captured in real-time or selected from the gallery. It displays plant predictions along with their Ayurvedic benefits and home usage, providing users with an educational and health-oriented experience.

---

## ✨ Features

- 📷 **Image Capture & Upload** – Take a photo or select from the gallery.
- 🌱 **Real-Time Plant Identification** – Uses a trained model/API to predict the plant class.
- 🧘‍♀️ **Ayurvedic Benefits** – Shows medicinal uses and home remedies for each plant.
- 🗣️ **Text-to-Speech Support** – Voice feedback for predicted results.
- 🧭 **Location Access** – Geo-tagging support to improve prediction relevance.
- 🔍 **Search Functionality** – Easily look up any of the 40 supported Ayurvedic plants.
- 💾 **Local Prediction History** – Stores past scanned plants for reference.
- 📤 **Share Results** – Share plant info and predictions via social apps.
- 🌙 **Theme Toggle** – Switch between light and dark themes.

---

## 📱 Screenshots

*(Add screenshots of your app here)*

---

## 🛠️ Tech Stack

| Frontend         | Backend         | AI/ML                   | Others                                 |
|------------------|------------------|--------------------------|----------------------------------------|
| Flutter (Dart)   | Flask (Python)   | MobileNetV2 / Plant.id API | Firebase Auth, Location, TTS, Image Picker |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK
- Android Studio / VS Code
- Python 3.x
- Flask
- Dependencies listed in `pubspec.yaml` and `requirements.txt`

### Flutter App Setup

```bash
git clone https://github.com/stutig123/AyurScan.git
cd AyurScan
flutter pub get
flutter run
