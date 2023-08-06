# News app

![Flutter version](https://img.shields.io/badge/Flutter-v3.10.4-blue.svg)
![Dart version](https://img.shields.io/badge/Dart-v3.0.3-blue.svg)

## Introduction
This Flutter project aims to provide users with a seamless experience to read articles from various domains of your choice. You can add their preferred domains and view articles specifically from those sources. Additionally, the application showcases top headlines by countries and categories, allowing users to stay up-to-date with the latest news globally. The app also offers a powerful search functionality, enabling users to search for any article and sort them by date, relevancy, or popularity.

## Features
- View articles from user-added domains
- Explore top headlines by countries and categories
- Powerful search feature to find specific articles
- Sort articles by date, relevancy, or popularity
- Dark theme support for comfortable reading in low-light conditions
- Material You support, bringing Android 12 design language and customization options

## Installation
To run this News Application on your device, follow these steps:

1. Clone the repository to your local machine.
2. Ensure you have Flutter installed. If not, follow the official installation guide: [Flutter Install](https://flutter.dev/docs/get-started/install)
3. Connect your device or use an emulator.
4. Open the terminal in the project directory and run:

```shell
flutter pub get
dart run build_runner watch -d
flutter run
```

5. The application should now be running on your device.

## Usage
Upon launching the application, you will be presented with the feed screen, you will have to add some sources first to view articles. Clicking on any article will open it in your default web browser.

### Adding Domains
To add domains of your interest, follow these steps:
1. Open the settings page from the app's menu.
2. Navigate to the "Manage Sources" section.
3. Add your preferred domains one by one.

### Searching Articles
To search for articles, use the search bar on the top of the home screen. Enter your search query and press enter to see relevant articles. You can also sort the search results by date, relevancy, or popularity.

## Supported Platforms
Our News Application supports the following platforms:
- Android
- iOS

## Dark Theme
To enable the Dark Theme, follow these steps:
1. Open the settings page from the app's menu.
2. Toggle the switch to enable Dark Theme.

## Material You Support
Our News Application embraces the Material You design language introduced in Android 12. It allows the app's appearance to be customized based on system-wide themes and color schemes, providing a more personalized user experience.

## Contributing
We welcome contributions to enhance the News Application. If you find any bugs, have suggestions for new features, or would like to improve the code, please feel free to open an issue or submit a pull request.
