<div align="center">

# 🛍️ Modish Store

**A modern, full-featured e-commerce mobile app built with Flutter**

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=flat&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.10-0175C2?style=flat&logo=dart&logoColor=white)
![Bloc](https://img.shields.io/badge/State%20Management-Bloc%2FCubit-5C2D91?style=flat)
![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-orange?style=flat)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-3DDC84?style=flat)

</div>

---

## 📱 Overview

**Modish Store** is a complete e-commerce mobile application developed as a graduation project by a team of developers. The app lets users browse a product catalog, search and filter items, manage a cart, complete checkout, and receive automatic order confirmation emails — all backed by a clean, scalable Flutter architecture.

> **My role:** I was responsible for the end-to-end design and development of the Flutter application — architecture, UI/UX implementation, state management, and API integration — while collaborating with teammates on the overall product.

## 📸 Screenshots
<table>
<tr>
<td><img src="screenshots\onBoarding(1).png" width="180"/></td>
<td><img src="screenshots\onBoarding(2).png" width="180"/></td>
<td><img src="screenshots\Login.png" width="180"/></td>
<td><img src="screenshots\Signup.png" width="180"/></td>
<td><img src="screenshots\HomePage.png" width="180"/></td>
<td><img src="screenshots\Drawer.png" width="180"/></td>
<td><img src="screenshots\Product_Details.png" width="180"/></td>
<td><img src="screenshots\Profile.png" width="180"/></td>
<td><img src="screenshots\Search.png" width="180"/></td>
<td><img src="screenshots\cart.png" width="180"/></td>
<td><img src="screenshots\checkout.png" width="180"/></td>
</tr>
</table>

## 🎬 Demo

*A short walkthrough video/GIF of the app will be linked here.*

## ✨ Features

- 🔐 **Authentication** — secure login & sign-up flow with session persistence (`flutter_secure_storage`)
- 🛒 **Shopping Cart** — add, update, and remove items with real-time cart state
- 🔍 **Search & Filtering** — search the catalog and filter products by category
- ❤️ **Favorites** — save products to a personal wishlist
- 💳 **Checkout Flow** — complete order placement from cart to confirmation
- 📧 **Automated Order Emails** — order confirmation with full order details sent directly to the user's email
- 🎧 **Customer Support** — in-app technical/customer support access
- 👤 **Profile Management** — view and update user profile information
- 🖼️ **Optimized Images** — cached network images for smooth scrolling performance

## 🛠️ Tech Stack

| Category | Tools |
|---|---|
| **Framework** | Flutter (Dart) |
| **Architecture** | Clean Architecture, feature-first folder structure |
| **State Management** | `flutter_bloc` (Bloc / Cubit) |
| **Dependency Injection** | `get_it` (service locator) |
| **Networking** | `dio`, `http` |
| **Local Storage** | `shared_preferences`, `flutter_secure_storage` |
| **Email Service** | `emailjs` (order confirmation emails) |
| **Media** | `cached_network_image`, `image_picker`, `flutter_svg` |
| **Other** | `url_launcher`, `get_it`, `gap` |

## 🏗️ Architecture

The app follows **Clean Architecture** principles with a **feature-first** structure. Each feature (Cart, HomePage, Login/Signup, Profile, Search, Onboarding, Splash) is self-contained and split into three layers:

```
feature/
├── data/          # Models & repositories — talks to the API via Dio
├── logic/         # Bloc/Cubit — business logic & state management
└── presentation/  # Views & widgets — UI only, no business logic
```

Dependencies are wired up through a central **service locator** (`get_it`), which registers a singleton `Dio` client and lazily-instantiated repositories for each feature — keeping the UI layer decoupled from data sources and making the codebase easy to test and extend.

## 📂 Project Structure

```
lib/
├── core/                  # Shared utilities, theming, DI setup
│   ├── di/                # GetIt service locator
│   ├── theme/
│   ├── colors.dart
│   └── fontstyle.dart
├── features/
│   ├── splash/
│   ├── on_board/
│   ├── login_signup/
│   ├── HomePage/
│   ├── search/
│   ├── Cart/
│   └── profile/
└── main.dart
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (^3.10.3)
- Android Studio / Xcode (for emulators) or a physical device

### Installation

```bash
# Clone the repository
git clone https://github.com/mahmoudnasef178/Modish-Store.git
cd Modish-Store

# Install dependencies
flutter pub get

# Run the app
flutter run
```
## 📬 Contact

**Mahmoud Nasef**
[GitHub](https://github.com/mahmoudnasef178) ·[linkedin](https://www.linkedin.com/in/mahmoud-nasef1/?skipRedirect=true)

---

<div align="center">
Made with 💜 and Flutter
</div>