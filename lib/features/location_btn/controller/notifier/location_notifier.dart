import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_helper/features/location_btn/controller/location_service_stream_pod.dart';
import 'package:location_helper/features/location_btn/state/location_state.dart';

class LocationNotifier extends AutoDisposeAsyncNotifier<LocationState> {
  @override
  FutureOr<LocationState> build() async {
    ///listen to changes in location service, so we can react by getting location
    ref.listen(locationServiceStreamPod, (previous, next) {
      if (next is AsyncData) {
        getLocation();
      }
    });

    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    final permissionState = await Geolocator.checkPermission();

    return IntialLocationState(
      isServiceEnabled: isServiceEnabled,
      permissionState: permissionState,
    );
  }

  Future<void> getLocation() async {
    state = await AsyncValue.guard(() async {
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      final permissionState = await Geolocator.checkPermission();

      if (permissionState != LocationPermission.always ||
          permissionState != LocationPermission.whileInUse) {
        final newPermissionState = await Geolocator.requestPermission();
        state = AsyncData(
          LoadingLocationState(
            isServiceEnabled: isServiceEnabled,
            permissionState: newPermissionState,
          ),
        );
      } else {
        state = AsyncData(
          LoadingLocationState(
            isServiceEnabled: isServiceEnabled,
            permissionState: permissionState,
          ),
        );
      }

      /// When service enabled , check permission
      if (isServiceEnabled == true) {
        /// When permission enabled, get Location Position
        if (permissionState == LocationPermission.always ||
            permissionState == LocationPermission.whileInUse) {
          final position = await Geolocator.getCurrentPosition();
          return LoadedLocationState(
            isServiceEnabled: isServiceEnabled,
            permissionState: permissionState,
            position: position,
          );
        }

        /// When permission is not not enabled
        else {
          return LocationErrorState(
            isServiceEnabled: isServiceEnabled,
            permissionState: permissionState,
            errorMessage: "Permission not enabled",
          );
        }
      }

      /// If service is disabled change state to LocationErrorState
      else {
        return LocationErrorState(
          isServiceEnabled: isServiceEnabled,
          permissionState: permissionState,
          errorMessage: "Service disabled",
        );
      }
    });
  }
}
