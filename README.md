# IIITD ALIVE HVI submission

[![CI](https://github.com/Saransh-cpp/IIITD_ALIVE_HVI/actions/workflows/CI.yml/badge.svg)](https://github.com/Saransh-cpp/IIITD_ALIVE_HVI/actions/workflows/CI.yml)

Submission for IIITD's ALIVE lab round 2.

## Tech stack and plugins
- `Flutter`
- `Dart`
- `Open Street Map` API
- [`flutter_osm_plugin`](https://pub.dev/packages/flutter_osm_plugin)
- [`flutter_toast`](https://pub.dev/packages/fluttertoast)
- `CI` pipeline using `GitHub Actions`

## Features
- The application integrates the `Open Street Map` API with `Flutter`.
- A user can move the map to his location and coordinates by pressing a single button.
- A user can select 2 locations (which can be easily scaled to include more than 2 points) for the pickup and drop feature.
- A user can visualise and remove the path/road between 2 points for a car (which can be easily scaled to include other vehicle types).
- The repository also has a [`CI`]() pipeline built using `GitHub Action` to make the development process smoother.

## Overall pipeline and visuals

**Relevant files**
- [`main.dart`](https://github.com/Saransh-cpp/IIITD_ALIVE_HVI/blob/main/lib/main.dart)
- [`screens/home.dart`](https://github.com/Saransh-cpp/IIITD_ALIVE_HVI/blob/main/lib/screens/home.dart)
- [`screens/select_locations.dart`](https://github.com/Saransh-cpp/IIITD_ALIVE_HVI/blob/main/lib/screens/select_locations.dart)
- [`screens/search_location.dart`](https://github.com/Saransh-cpp/IIITD_ALIVE_HVI/blob/main/lib/screens/search_location.dart)
- [`screens/splash.dart`](https://github.com/Saransh-cpp/IIITD_ALIVE_HVI/blob/main/lib/screens/splash.dart)
- [`.github/workflows/CI.yml`](https://github.com/Saransh-cpp/IIITD_ALIVE_HVI/blob/main/.github/workflows/CI.yml)
- [`README.md`](https://github.com/Saransh-cpp/IIITD_ALIVE_HVI/blob/main/README.md)

**Pipeline**

**MockUps**
<p align="centre">
    <img src="./readme_assets/overall_app.png"/>
    <img src="./readme_assets/pick_up_and_drop.png"/>
</p>


**Screen Recording**

## Tasks
### Task1

**Relevant files**
- [`main.dart`](https://github.com/Saransh-cpp/IIITD_ALIVE_HVI/blob/main/lib/main.dart)
- [`home.dart`](https://github.com/Saransh-cpp/IIITD_ALIVE_HVI/blob/main/lib/screens/home.dart)

**Pipeline**
- The application opens up the integrated `Open Street Map` API on the home screen, which is launched my `main` method available in `main.dart`.

**Screenshots**


**Screen Recording**


### Task2

**Relevant files**
- [`home.dart`](https://github.com/Saransh-cpp/IIITD_ALIVE_HVI/blob/main/lib/screens/home.dart)

**Pipeline**

**Screenshots**

**Screen Recording**

### Task3

**Relevant files**
- [`select_locations.dart`](https://github.com/Saransh-cpp/IIITD_ALIVE_HVI/blob/main/lib/screens/select_locations.dart)
- [`search_location.dart`](https://github.com/Saransh-cpp/IIITD_ALIVE_HVI/blob/main/lib/screens/search_location.dart)

**Pipeline**

**Screenshots**

**Screen Recording**

### Task4

**Relevant files**
- [`home.dart`](https://github.com/Saransh-cpp/IIITD_ALIVE_HVI/blob/main/lib/screens/home.dart)
- [`select_locations.dart`](https://github.com/Saransh-cpp/IIITD_ALIVE_HVI/blob/main/lib/screens/select_locations.dart)
- [`search_location.dart`](https://github.com/Saransh-cpp/IIITD_ALIVE_HVI/blob/main/lib/screens/search_location.dart)

**Pipeline**

**Screenshots**

**Screen Recording**

### Task5

**Relevant files**
- [`README.md`](https://github.com/Saransh-cpp/IIITD_ALIVE_HVI/blob/main/README.md)
- All the files are well commented.

**Pipeline**

**Screenshots**

**Screen Recording**

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
