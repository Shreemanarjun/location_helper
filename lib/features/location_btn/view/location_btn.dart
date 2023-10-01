import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_helper/features/location_btn/controller/location_pod.dart';
import 'package:location_helper/features/location_btn/state/location_state.dart';

class LocationButton extends ConsumerWidget {
  const LocationButton({super.key});

  /// Listen to different state , to show messages and actions according to statea
  void listener({
    required AsyncValue<LocationState> next,
    required BuildContext context,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();

    /// If any unknown error , (like android permsssion permission not andded in manifest or in info.plist in ios)
    if (next is AsyncError) {
      final error = next.error;
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
      final locationstate = next.value!;

      /// if location state is location error state
      if (locationstate is LocationErrorState) {
        final errorState = locationstate;

        /// If service not enabled
        if (!errorState.isServiceEnabled) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: ElevatedButton(
                  onPressed: () {
                    Geolocator.openLocationSettings();
                  },
                  child: const Text(
                    "Please enable location service. Click to enable",
                  )),
              duration: const Duration(seconds: 10),
            ),
          );
        }

        /// If permission is denied
        else if (errorState.permissionState == LocationPermission.denied ||
            errorState.permissionState == LocationPermission.deniedForever ||
            errorState.permissionState ==
                LocationPermission.unableToDetermine) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: ElevatedButton(
                  onPressed: () {
                    Geolocator.openAppSettings();
                  },
                  child: const Text(
                    "Please accept location permission",
                  )),
              duration: const Duration(seconds: 10),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(locationPod,
        (previous, next) => listener(next: next, context: context));

    final locationStateAsync = ref.watch(locationPod);

    return locationStateAsync.when(
      data: (locationstate) {
        return switch (locationstate) {
          IntialLocationState() => ElevatedButton(
              onPressed: () {
                ref.read(locationPod.notifier).getLocation();
              },
              child: const Text("Get Current Location"),
            ),
          LoadingLocationState() => ElevatedButton.icon(
              onPressed: () {},
              icon: const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
              label: const Text("Getting Current Location"),
            ),
          LoadedLocationState(:final position) => ElevatedButton(
              onPressed: () {
                ref.read(locationPod.notifier).getLocation();
              },
              child: Text("Got Location $position"),
            ),
          LocationErrorState(
            :final errorMessage,
          ) =>
            ElevatedButton(
              onPressed: () {
                ref.read(locationPod.notifier).getLocation();
              },
              child: Text(
                "Unable to determine current Location $errorMessage",
              ),
            ),
        };
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Center(
        child: ElevatedButton(
          onPressed: () {
            ref.read(locationPod.notifier).getLocation();
          },
          child: const Text(
            "Unable to determine location ",
          ),
        ),
      ),
    );
  }
}
