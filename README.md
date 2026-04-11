📌 Pinterest Clone (Flutter)

A Pinterest-inspired mobile and web application built using Flutter, following modern best practices like Riverpod state management, GoRouter navigation, and clean feature-based architecture.

This project demonstrates how to build a scalable Flutter app that works on Android and Web, with a production-ready UI similar to the Pinterest app.

🚀 Features

🧱 Masonry / Staggered Grid Layout (Pinterest-style feed)

🌐 Real API Integration using Unsplash

⚡ Fast image loading & caching

🧭 Declarative navigation with deep linking

🧠 State management with Riverpod

🎨 Shimmer loading effects

📱 Bottom navigation (Home, Search, Create, Inbox, Saved)

🖼️ Pin detail screen

🌍 Deployed on Netlify (Web MVP)

🛠️ Tech Stack (Required & Used)
Category	Package
State Management	flutter_riverpod
Navigation	go_router
Networking	dio
Image Caching	cached_network_image
Loading Effects	shimmer
Grid Layout	flutter_staggered_grid_view
Backend API	Unsplash API
Web Hosting	Netlify
📂 Project Structure
lib/
├── core/
│   ├── config/
│   ├── network/
│   └── widgets/
├── features/
│   ├── auth/
│   ├── home/
│   ├── pin_detail/
│   └── profile/
├── routes/
├── main.dart


Architecture follows feature-first + clean separation of concerns.

🖥️ Platforms Supported

✅ Android

✅ Web (Chrome / Edge / Safari)

⏳ iOS (physical device requires macOS or cloud CI)

🌐 Web Deployment

The app is built using:

flutter build web

and deployed manually via Netlify using the build/web directory.

▶️ Getting Started Locally
1️⃣ Clone the repository
git clone https://github.com/ArunKumar73177/pinterest_clone.git
cd pinterest_clone

2️⃣ Install dependencies
flutter pub get

3️⃣ Run on Android
flutter run

4️⃣ Run on Web
flutter run -d chrome

📸 Screens (Highlights)

Pinterest-style home feed

Pin detail page

Auth flow (UI-ready)

Bottom navigation

Responsive layout for web

🔮 Planned Improvements

🔐 Authentication using clerk_flutter

❤️ Save / Like pins

💬 Comments

👤 User profiles

📱 iOS build via cloud CI

🔎 Advanced search

👤 Author

Arun Kumar

Flutter Developer
📧 arunsharma73177@gmail.com

📄 License

This project is for educational and demonstration purposes only.
Not affiliated with Pinterest.
