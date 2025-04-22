🌿 AyurScan
AyurScan is a cross-platform Flutter application powered by a Flask backend that uses AI to identify Ayurvedic plants through images captured in real-time or selected from the gallery. It displays plant predictions along with their Ayurvedic benefits and home usage, providing users with an educational and health-oriented experience.

<br>
✨ Features
📷 Image Capture & Upload – Take a photo or select from the gallery.

🌱 Real-Time Plant Identification – Uses a trained model/API to predict the plant class.

🧘‍♀️ Ayurvedic Benefits – Shows medicinal uses and home remedies for each plant.

🗣️ Text-to-Speech Support – Voice feedback for predicted results.

🧭 Location Access – Geo-tagging support to improve prediction relevance.

🔍 Search Functionality – Easily look up any of the 40 supported Ayurvedic plants.

💾 Local Prediction History – Stores past scanned plants for reference.

📤 Share Results – Share plant info and predictions via social apps.

🌙 Theme Toggle – Switch between light and dark themes.

<br>
📱 Screenshots
(You can add screenshots of the app in action here)

<br>
🛠️ Tech Stack

Frontend	Backend	AI/ML	Others
Flutter (Dart)	Flask (Python)	MobileNetV2 / Plant.id API	Firebase Auth, Location, TTS, Image Picker
<br>
🚀 Getting Started
Prerequisites
Flutter SDK

Android Studio / VS Code

Python 3.x

Flask

Dependencies listed in pubspec.yaml and requirements.txt

Flutter App Setup
bash
Copy
Edit
git clone https://github.com/stutig123/AyurScan.git
cd AyurScan
flutter pub get
flutter run
Flask Backend Setup
bash
Copy
Edit
cd backend  # Assuming Flask API is in backend/
pip install -r requirements.txt
python app.py
Note: Ensure the backend is running before launching the app for predictions.

<br>
📂 Project Structure
bash
Copy
Edit
AyurScan/
├── lib/
│   ├── screens/              # All UI pages
│   ├── services/             # API & local storage services
│   ├── theme.dart            # Light & dark theme configuration
│   └── main.dart             # Entry point
├── backend/                  # Flask server files
├── assets/                   # Images & fonts
├── android/ios/web/...       # Platform-specific folders
<br>
🌿 Supported Ayurvedic Plants
Supports 40 common Indian Ayurvedic plants like Tulsi, Neem, Amla, Ashwagandha, Brahmi, and more. Each plant has detailed benefits and home usage listed.

<br>
🧪 Testing
Tested on Android Emulator & Real Devices

Platform compatibility: Android, iOS, Web (beta)

<br>
📦 Future Enhancements
Add Firebase Firestore for cloud-based history

Offline mode support

iOS release and deployment

Add multilingual support

<br>
🙌 Contributing
Contributions, issues, and feature requests are welcome!
Feel free to check the issues page if you'd like to help.

<br>
📄 License
This project is open source and available under the MIT License.
