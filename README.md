# BookHub – Flutter + Firebase + Crossref API App

BookHub is a modern Flutter-based mobile application that lets users explore, search, and manage books or scholarly works in one place.
It integrates Firebase Authentication for secure user login/signup and the Crossref REST API for fetching real-time book and research data.

🚀 Features

✅ User Authentication (Firebase)

Sign up, log in, and logout functionality

Secure session management with FirebaseAuth

✅ Crossref API Integration

Fetches live book and research metadata

Displays title, author, publisher, and DOI links

✅ Search Functionality

Dynamic search by book title or author

Real-time filtering of results

✅ Clean & Modern UI

Beautiful Material Design interface

Consistent purple theme and background component

Intuitive bottom navigation bar

✅ Profile Management

View user details

Logout and app information options

🧠 Tech Stack
Component	Technology
Frontend	Flutter (Dart)
Backend	Firebase Authentication
API	Crossref REST API
HTTP Requests	http package
External Links	url_launcher package
State Management	Flutter Stateful Widgets
🧱 App Structure
lib/
 ├── main.dart
 ├── screens/
 │    ├── onboarding_screen.dart
 │    ├── login_screen.dart
 │    ├── signup_screen.dart
 │    ├── home_screen.dart
 │    ├── currently_reading_screen.dart
 │    ├── library_screen.dart
 │    └── profile_screen.dart
 │
 ├── services/
 │    └── crossref_service.dart
 │
 ├── widgets/
 │    └── app_background.dart
 │
 └── firebase_options.dart

🔐 Firebase Setup

Create a new project in Firebase Console

Enable Email/Password Authentication

Add your Android/iOS app

Download and place google-services.json in /android/app/

Initialize Firebase in main.dart using:

await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

🌍 Crossref API Setup

No API key is required.
Use this endpoint in your service:

https://api.crossref.org/works?filter=has-full-text:true&mailto=GroovyBib@example.org

📱 Screens Overview

🏁 Onboarding Screen – Introduction to the app

🔑 Login/Signup Screens – Firebase Authentication

🏠 Home Screen – Bottom navigation bar with three tabs:

Currently Reading – Fetches Crossref recommendations

Library – Search and explore publications

Profile – User info and logout

📈 Future Enhancements

🔹 Add Firestore for storing user favorites

🔹 Integrate Google Sign-In

🔹 Offline caching of books

🔹 Push notifications for new releases

🔹 Implement dark mode

🧾 Learning Outcomes

Integrating Firebase Authentication into Flutter apps

Handling REST API data using http

Building dynamic UIs with FutureBuilder

Structuring multi-screen navigation

Combining cloud, API, and UI layers seamlessly

💡 How to Run

Clone the repository

git clone https://github.com/your-username/bookhub.git
cd bookhub


Install dependencies

flutter pub get


Run the app

flutter run

📜 License

This project is licensed under the MIT License
.
Feel free to use, modify, and distribute it for educational or personal use.
