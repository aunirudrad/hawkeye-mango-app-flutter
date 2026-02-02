# Hawkeye Mango 🦅🥭

An offline AI-powered mobile application designed to help farmers detect mango leaf diseases using machine learning and computer vision.

## 📋 Project Overview

Hawkeye Mango is a cross-platform Flutter application that empowers farmers with instant, on-device disease detection for mango crops. Using TensorFlow Lite's machine learning capabilities, the app analyzes images of mango leaves to identify various diseases and provides actionable prevention and treatment recommendations—all without requiring an internet connection.

This solution addresses the critical need for accessible agricultural diagnostics, especially in areas with limited internet connectivity, enabling farmers to make informed decisions quickly and protect their crops.

## 🚀 Technologies

### Framework & Language
- **Flutter** - Cross-platform UI framework
- **Dart** - Programming language (SDK >=3.2.2 <4.0.0)

### Machine Learning
- **TensorFlow Lite** (`flutter_tflite: ^1.0.1`) - On-device ML inference
- **Custom TFLite Model** (`tiny_net_fold5.tflite`) - Trained disease classification model

### Image Processing
- **image_picker** (`^0.8.9`) - Camera and gallery integration for image capture

### Additional Tools
- **flutter_launcher_icons** (`^0.10.0`) - Custom app icon configuration
- **flutter_lints** (`^2.0.0`) - Code quality and linting

## ✨ Features

### 🔍 Disease Detection
- **Real-time Image Classification**: Analyze mango leaf images using AI
- **High Accuracy Detection**: Identifies diseases with confidence percentage
- **Offline Capability**: Runs entirely on-device without internet connection
- **Multi-Disease Support**: Detects 8 different conditions:
  - Anthracnose
  - Bacterial Canker
  - Cutting Weevil
  - Die Back
  - Gall Midge
  - Powdery Mildew
  - Sooty Mould
  - Healthy leaves

### 📸 Image Capture
- **Camera Integration**: Take photos directly from the app
- **Gallery Support**: Upload existing images from device storage
- **Instant Analysis**: Get results immediately after image selection

### 💡 Agricultural Guidance
- **Prevention Recommendations**: Specific preventive measures for each disease
- **Treatment Instructions**: Detailed treatment steps and recommended interventions
- **Disease Information**: Clear explanations of each detected condition

### 🎨 User Experience
- **Intuitive Interface**: Clean, farmer-friendly design with large touch targets
- **Visual Feedback**: Display analyzed images with confidence scores
- **Color-Coded UI**: Easy-to-understand visual hierarchy
- **Multi-Platform Support**: Available for Android, iOS, Web, Windows, macOS, and Linux

## 🎯 Target Users

- Mango farmers and agricultural workers
- Agricultural extension officers
- Crop consultants and agronomists
- Agricultural students and researchers

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🛠️ Getting Started

### Prerequisites
- Flutter SDK (3.2.2 or higher)
- Dart SDK (included with Flutter)
- Android Studio / Xcode (for mobile development)
- A physical device or emulator

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd hawkeye-mango-app-flutter
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
flutter run
```

### Build for Production

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## 📂 Project Structure

```
hawkeye-mango-app-flutter/
├── assets/               # ML models, labels, and images
│   ├── tiny_net_fold5.tflite   # TensorFlow Lite model
│   ├── label.txt               # Disease class labels
│   └── logo.png                # App logo
├── lib/
│   └── main.dart        # Main application code
├── android/             # Android-specific configuration
├── ios/                 # iOS-specific configuration
├── web/                 # Web-specific configuration
├── windows/             # Windows-specific configuration
├── macos/               # macOS-specific configuration
├── linux/               # Linux-specific configuration
└── pubspec.yaml         # Project dependencies

```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- TensorFlow team for TensorFlow Lite framework
- Flutter community for excellent packages and support
- Agricultural experts who provided domain knowledge for disease information

## 📞 Support

For issues, questions, or suggestions, please open an issue in the repository.

---

**Built with ❤️ for farmers using Flutter and AI**
