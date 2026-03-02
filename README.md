# 🛒 Flutter E-Commerce App 

A modern, robust, and scalable E-Commerce application built with **Flutter** and **Dart**, following the principles of **Clean Architecture** and **Domain-Driven Design (DDD)**.

## 🌟 Overview
This project focuses on providing a seamless shopping experience with high performance, secure authentication, and a reactive UI. The application heavily utilizes **BLoC/Cubit** for state management and **GetIt** for Dependency Injection, ensuring a decoupled, testable, and maintainable codebase.

---

## ✨ Key Features & Recent Updates

### 🔐 Authentication (المصادقة وتسجيل الدخول)
* **Multi-method Login:** Support for both Email/Password and Phone Number (OTP) authentication.
* **Strict Validation:** * Regex-based email validation.
  * International phone number validation using `intl_phone_field` (Strictly configured for Saudi Arabia `+966` with 9-digit length and `5` prefix constraints).
  * `inputFormatters` to prevent non-numeric inputs.
* **Secure Session Management:** Persistent auto-login capabilities with secure bug-free local caching avoiding "ghost data" overwrites.

### 🛒 Smart Cart System (نظام سلة المشتريات الذكي)
* **Local Persistence:** Cart items are securely saved locally using `SharedPreferences`, ensuring data survives app restarts.
* **Reactive UI Sync:** Real-time synchronization across the app. Adding an item from the `HomeScreen` instantly updates the `ProductDetailsScreen` button state (turns green with a checkmark) and the `CartScreen`.
* **Advanced Cart Logic:** * Add to cart (auto-increments if exists).
  * Decrement quantity (auto-removes if quantity reaches 0).
  * Remove entire item.
  * Dynamic, real-time total price calculation.

### 👤 Profile Management (إدارة الملف الشخصي)
* **Clean Architecture Implementation:** Fully refactored to separate Domain (Entities, UseCases), Data (Repositories, LocalDataSources), and Presentation (UI, Cubit).
* **Dynamic Data Rendering:** Intelligently detects the login method (Email vs. Phone) to display the correct icons, typography spacing, and identifiers.
* **Fail-Safe Logout:** Completely clears user sessions, resets the Cart BLoC state, and wipes local storage to ensure zero data leakage between accounts.
* **Error Handling:** Graceful error UI with "Retry" mechanisms for failed data loads.

### ⚙️ Core & Architecture (البنية التحتية)
* **Clean Architecture:** Strict separation of concerns (Presentation, Domain, Data).
* **Dependency Injection:** Centralized and organized DI container using `GetIt`, structured logically by feature.
* **State Management:** Reactive and predictable state handling using `flutter_bloc`.

---

## 🛠️ Tech Stack & Packages

* **Framework:** [Flutter](https://flutter.dev/)
* **State Management:** `flutter_bloc`, `dartz` (for functional error handling)
* **Dependency Injection:** `get_it`
* **Local Storage:** `shared_preferences`
* **Network/API:** `dio` *(Configured for future remote integrations)*
* **UI/UX:** `intl_phone_field`, Custom Animations, Modern Material 3 Design.

---

## 🏗️ Folder Structure (Clean Architecture)
```text
lib/
 ┣ core/                 # Core utilities, constants, DI, network config
 ┣ features/
 ┃ ┣ auth/               # Authentication feature
 ┃ ┃ ┣ data/             # Repositories Impl & Data Sources
 ┃ ┃ ┣ domain/           # Entities, Repositories Interfaces, UseCases
 ┃ ┃ ┗ presentation/     # UI, Blocs, Cubits
 ┃ ┣ cart/               # Cart Management feature
 ┃ ┣ product/            # Product Browsing feature
 ┃ ┗ profile/            # User Profile feature
 ┗ main.dart
