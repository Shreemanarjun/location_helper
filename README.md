# Location Helper 🌍

Location Helper is a Flutter package that simplifies location service management and error handling using the Geolocator package and Riverpod for state management.

## Features 🚀

- **Auto Location Service Management:** The package automatically manages the device's location service status and reacts to changes.
- **Error Handling:** Location Helper provides easy-to-use error handling mechanisms for various scenarios, ensuring a smooth user experience even in case of errors.
- **Riverpod Integration:** Utilizes Riverpod, a state management library for Flutter, to handle location service states and provide a reactive programming approach.

## Getting Started 🛠️

To get started with Location Helper, add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_riverpod: ^latest_version
  geolocator: ^latest_version
```

Then, run `flutter pub get` to install the packages.

## Setup Permissions

Follow the Geolocator package's [usage guide](https://pub.dev/packages/geolocator#usage) to set up location permissions in your application.

## Usage 🎉

### 1. Consume Location State

Use the `Consumer` widget from Riverpod to consume the location service state in your widgets:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref)  {
      final locationStateAsync = ref.watch(locationPod);

    // Build your UI based on locationState (LoadedLocationState, LoadingLocationState, LocationErrorState, etc.)
    // Handle different states and display appropriate UI components.
  }
}
```

### 2. React to Location Service Changes

Location Helper automatically reacts to location state changes. When the location service status changes, the `LocationNotifier` will handle it and update the state accordingly. You can listen to the location service stream using `ref.listen` method in your notifier.

```dart
   ref.listen(locationPod,
        (AsyncValue<LocationState>? previous previous,AsyncValue<LocationState> previous next){

  /// If any unknown error, like Android permission not added in manifest or in info.plist in iOS        
     if (next is AsyncError) {
      final error = next.error;

      /// You can use dialogs or snackbars here to show useful info to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString(),
          ),
        ),
      );
    }

    /// All the defined state can be listened to react here
    else if (next is AsyncData && next.value != null) {
           /// If service not enabled
        if (!errorState.isServiceEnabled) {
             /// You can use dialogs or snackbars here to show useful info to the user
        }
           /// If permission is denied
        else if (errorState.permissionState == LocationPermission.denied ||
            errorState.permissionState == LocationPermission.deniedForever ||
            errorState.permissionState ==
                LocationPermission.unableToDetermine) {

      /// You can use dialogs or snackbars here to show useful info to the user

         }
    }
});

```

## Testing ✅

Location Helper has been thoroughly tested to ensure reliability and stability. Unit tests and widget tests have been implemented to validate different aspects of the package, including location state changes, error handling, and integration with Riverpod.

To run the tests, use the following command in your terminal or command prompt:

```
flutter test
```

Feel free to explore the `test` directory to view the test cases and expand the test coverage if needed.

## Contributing 🤝

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License 📄
 This project is licensed under the [MIT License](LICENSE).


 MIT License

Copyright (c) 2023 Shreeman Arjun Sahu

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---

