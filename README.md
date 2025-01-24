# Hoode

A modern cross-platform real estate application built with Flutter and PocketBase.

## 🌟 Features

- Cross-platform support (iOS, Android, Windows, Linux)
- Real estate property management
- Agent relationship system
- Modern and responsive UI
- Secure data handling with PocketBase

## 🛠 Setup & Development

### Prerequisites

- Flutter SDK (latest stable version)
- PocketBase server
- Platform-specific development tools:
  - Android Studio for Android
  - Xcode for iOS/macOS
  - Visual Studio for Windows
  - GTK development libraries for Linux

### Getting Started

1. Clone the repository:

```bash
git clone https://github.com/yourusername/hoode.git
```

2. Install dependencies:

```bash
flutter pub get
```

3. Configure PocketBase:

- Set up PocketBase server
- Run migrations
- Configure environment variables

4. Run the application:

```bash
flutter run
```

## 🏗  Project Structure

hoode/
├── lib/               # Main application code
├── android/           # Android-specific code
├── ios/              # iOS-specific code
├── windows/          # Windows-specific code
├── linux/            # Linux-specific code
├── pb_migrations/    # PocketBase migrations
└── assets/          # Application assets

## 🔧 Configuration

### PocketBase Setup

- Install PocketBase server
- Apply migrations from the pb_migrations folder
- Configure your database collections and relationships

### Environment Variables

Create a .env file in the project root with:

```env
POCKETBASE_URL=your_pocketbase_url
```

## 🚀 Deployment

### Mobile (Android/iOS)

- Configure signing keys
- Update version numbers
- Build release version:

```bash
flutter build apk --release
```

or

```bash
flutter build ios --release
```

### Desktop (Windows/Linux)

```bash
flutter build windows
```

or

```bash
flutter build linux
```

## 📱 Supported Platforms

- Android
- iOS
- Windows
- Linux

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details

## 📞 Support

For support, email <your-email@example.com> or open an issue in the repository.
