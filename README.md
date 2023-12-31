# Dialogix

Dialogix is a mobile app that provides a platform for community-driven discussions and content sharing.

## Features

- [x] **Dynamic Links for Posts:**
  - Users can create and share dynamic links for individual posts.
  - Post links redirect users to the specific post when clicked.

- [x] **Pagination in Feed Screen:**
  - Implemented pagination for posts in the Feed screen.
  - Efficiently loads and displays a manageable number of posts at a time.

- [x] **Native Splash and Logo Support:**
  - Enhanced app launch experience with native splash screen support.
  - Integrated native logo support for brand visibility.

- [x] **Guest Sign-In Method:**
  - Added a guest sign-in method for users to explore the app quickly without creating an account.

- [x] **Karma System for Users:**
  - Implemented a karma system to reward and track user contributions.

- [x] **Community Features:**
  - Created, joined, and managed communities.
  - Added mod tools UI for community moderation.

- [x] **User Profile Enhancements:**
  - Added user profile screen and edit profile functionality.
  - Implemented light mode and dark mode functionality.

- [x] **Post Functionalities:**
  - Added post type screen.
  - Enabled users to post images, links, or text descriptions.

- [x] **Dynamic Text Input:**
  - Introduced `DetectableTextField` to detect and highlight mentions (@) and URLs in text input.

- [x] **Animation and UI Improvements:**
  - Animated bottom navigation bar on click.
  - Added animations during page switch through the bottom navigation bar.

- [x] **Bug Fixes and Optimization:**
  - Fixed post blur visibility issue during scrolling.
  - Optimized code for improved responsiveness and efficiency.


## Folder Structure

```
lib
|-- core
|   |-- common
|   |   |-- widgets
|   |   |   |-- dialogix_cached_network_image.dart
|   |   |-- error_text.dart
|   |   |-- loader.dart
|   |   |-- post_card.dart
|   |   |-- sign_in_button.dart
|   |-- constants
|   |   |-- constants.dart
|   |   |-- firebase_constants.dart
|   |   |-- font_constants.dart
|   |   |-- route_paths.dart
|   |-- controller
|   |   |-- dynamic_link_controller.dart
|   |-- enums
|   |-- providers
|   |   |-- dynamic_link
|   |   |   |-- dynamic_link_parameters_provider.dart
|   |   |   |-- firebase_dynamic_link_repository_provider.dart
|   |   |-- firebase_providers.dart
|   |   |-- storage_repository_provider.dart
|   |-- failure.dart
|   |-- type_defs.dart
|   |-- utils.dart
|-- features
|   |-- auth
|   |   |-- controller
|   |   |   |-- auth_controller.dart
|   |   |-- repository
|   |   |   |-- auth_repository.dart
|   |   |-- screens
|   |   |   |-- login_screen.dart
|   |-- community
|   |   |-- controller
|   |   |   |-- community_controller.dart
|   |   |-- repository
|   |   |   |-- community_repository.dart
|   |   |-- screens
|   |   |   |-- add_mods_screen.dart
|   |   |   |-- community_screen.dart
|   |   |   |-- create_community_screen.dart
|   |   |   |-- edit_community_screen.dart
|   |   |   |-- mod_tools_screen.dart
|   |-- error
|   |   |-- screens
|   |   |   |-- error_screen.dart
|   |-- feed
|   |   |-- screens
|   |   |   |-- feed_screen.dart
|   |   |-- widgets
|   |   |   |-- category_tabs.dart
|   |-- home
|   |   |-- delegates
|   |   |   |-- search_community_delegate.dart
|   |   |-- drawers
|   |   |   |-- community_list_drawer.dart
|   |   |   |-- profile_drawer.dart
|   |   |-- screens
|   |   |   |-- home_screen.dart
|   |-- post
|   |   |-- controller
|   |   |   |-- post_controller.dart
|   |   |-- repository
|   |   |   |-- post_repository.dart
|   |   |-- screens
|   |   |   |-- add_post_screen.dart
|   |   |   |-- add_post_type_screen.dart
|   |   |   |-- comments_screen.dart
|   |   |-- widgets
|   |   |   |-- comment_card.dart
|   |-- user_profile
|   |   |-- controller
|   |   |   |-- user_profile_controller.dart
|   |   |-- repository
|   |   |   |-- user_profile_repository.dart
|   |   |-- screens
|   |   |   |-- edit_profile_screen.dart
|   |   |   |-- user_profile_screen.dart
|-- generated
|-- models
|   |-- comment_model.dart
|   |-- community_model.dart
|   |-- dynamic_link_query_model.dart
|   |-- post_model.dart
|   |-- user_model.dart
|-- responsive
|   |-- responsive.dart
|-- theme
|   |-- palette.dart
firebase_options.dart
main.dart
router.dart
```


## Architecture: Flutter MVU (Model-View-Update)

### Description

Dialogix is structured using the Flutter MVU architecture, which stands for Model-View-Update. This architecture separates the application logic into three components:

- **Model:** Represents the application state.
- **View:** Represents the UI components.
- **Update:** Manages the logic for updating the model based on user interactions.

### Usage

- **Model (core/models):** Contains data models representing entities in the app, such as users, communities, posts, etc.
  
- **View (features):** Organized into feature-specific folders, each containing screens, controllers, and other UI-related components. This separation enables modular development and easy navigation.

- **Update (core/controllers):** Controllers manage the logic for updating the model. For example, the `AuthController` in the `auth` feature handles authentication-related updates.


## Platform Support

- [x] Android
- [x] iOS
- [x] Web
- [ ] Mac
- [ ] Windows
- [ ] Linux

## Packages
     
| Name                                                             | Usage                                               |
| ---------------------------------------------------------------- | --------------------------------------------------- |
| [**cupertino_icons**](https://pub.dev/packages/cupertino_icons)  | Cupertino style icons for Flutter                   |
| [**flutter_riverpod**](https://pub.dev/packages/flutter_riverpod) | State management library for Flutter applications using Provider |
| [**riverpod_annotation**](https://pub.dev/packages/riverpod_annotation) | Annotations for Riverpod, a simple way to manage state in Flutter |
| [**flutter_screenutil**](https://pub.dev/packages/flutter_screenutil) | A Flutter plugin for adapting screen and font size |
| [**gap**](https://pub.dev/packages/gap)                         | A package to create padding and margin with multiples of 5 pixels |
| [**google_fonts**](https://pub.dev/packages/google_fonts)         | Google Fonts for Flutter                           |
| [**cached_network_image**](https://pub.dev/packages/cached_network_image) | Download, cache and show images in a Flutter app    |
| [**flutter_svg**](https://pub.dev/packages/flutter_svg)           | SVG parsing, rendering, and widget library for Flutter |
| [**dotted_border**](https://pub.dev/packages/dotted_border)       | A Flutter package to create dotted borders         |
| [**gallery_picker**](https://pub.dev/packages/gallery_picker)     | Flutter package for displaying images and videos from gallery |
| [**detectable_text_field**](https://pub.dev/packages/detectable_text_field) | A customizable text field widget with built-in @ and URL detection |
| [**animate_do**](https://pub.dev/packages/animate_do)             | Beautiful animations inspired by Animate.css       |
| [**firebase_core**](https://pub.dev/packages/firebase_core)       | Firebase initialization for Flutter                |
| [**firebase_storage**](https://pub.dev/packages/firebase_storage) | Firebase Cloud Storage for Flutter                 |
| [**cloud_firestore**](https://pub.dev/packages/cloud_firestore)   | Flutter plugin for Cloud Firestore, a cloud-hosted, noSQL database with live synchronization |
| [**firebase_auth**](https://pub.dev/packages/firebase_auth)       | Firebase Authentication for Flutter                |
| [**google_sign_in**](https://pub.dev/packages/google_sign_in)     | Flutter plugin for Google Sign-In                   |
| [**firebase_ui_firestore**](https://pub.dev/packages/firebase_ui_firestore) | Firebase UI for Flutter Firestore, simplifies the usage of Firebase UI features with Firestore |
| [**firebase_dynamic_links**](https://pub.dev/packages/firebase_dynamic_links) | Flutter plugin for Firebase Dynamic Links          |
| [**freezed**](https://pub.dev/packages/freezed)                   | Code generation for immutable classes in Dart      |
| [**freezed_annotation**](https://pub.dev/packages/freezed_annotation) | Freezed annotations for Dart                       |
| [**riverpod_generator**](https://pub.dev/packages/riverpod_generator) | Code generator for Riverpod, a simple way to manage state in Flutter |
| [**json_annotation**](https://pub.dev/packages/json_annotation)   | JSON serialization/deserialization library for Dart |
| [**json_serializable**](https://pub.dev/packages/json_serializable) | JSON serialization/deserialization built on top of Dart's `json` package |
| [**fpdart**](https://pub.dev/packages/fpdart)                     | Functional programming constructs and utilities for Dart |
| [**routemaster**](https://pub.dev/packages/routemaster)           | Flutter package for simple and powerful routing      |
| [**uuid**](https://pub.dev/packages/uuid)                         | Generate RFC4122 UUIDs for Flutter                  |
| [**file_picker**](https://pub.dev/packages/file_picker)           | A package that allows you to use a native file explorer to pick single or multiple absolute file paths, with extensions filtering support |
| [**shared_preferences**](https://pub.dev/packages/shared_preferences) | Flutter plugin for reading and writing simple key-value pairs |
| [**any_link_preview**](https://pub.dev/packages/any_link_preview) | Flutter package to extract links and preview data from any text content |


## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/0xAdiyat/Dialogix.git
2. Install dependencies:
   ```bash
   cd dialogix-mobile-app
   flutter pub get
3. Run the app:
   ```bash
   flutter run

   
## Contribution
If you wish to contribute a change to any of the existing features or add new to this repo,
please feel free to contribute,
and send a [pull request](https://github.com/0xAdiyat/Dialogix/pulls). I welcome and encourage all pull requests. It usually takes me within 24-48 hours to respond to any issue or request.

## Author
@0xAdiyat
