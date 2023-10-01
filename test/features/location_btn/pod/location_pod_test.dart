import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_helper/features/location_btn/controller/location_pod.dart';
import 'package:location_helper/features/location_btn/controller/location_service_stream_pod.dart';
import 'package:location_helper/features/location_btn/state/location_state.dart';
import 'package:riverpod_test/riverpod_test.dart';

import '../../../mock_geolocator.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(
    "Location Pod Test",
    () {
      /// Checks only  InitialState in build
      testAsyncNotifier(
        "shoud be IntialLocationState",
        setUp: () {
          GeolocatorPlatform.instance = MockGeolocatorPlatform();
        },
        overrides: [],
        provider: locationPod,
        emitBuildStates: true,
        expect: () => [
          isA<AsyncLoading<LocationState>>(),
          isA<AsyncData<LocationState>>().having(
              (s) => s.value, "is GettingLocation", isA<IntialLocationState>()),
        ],
      );

      /// Checks IntitialState in build and call check location , then state should be change accordingly
      testAsyncNotifier(
        "shoud be IntialLocationState,LoadingLocationState,LoadedLocationState",
        provider: locationPod,
        emitBuildStates: true,
        act: (notifier) => notifier.getLocation(),
        setUp: () {
          GeolocatorPlatform.instance = MockGeolocatorPlatform();
        },
        expect: () => [
          isA<AsyncLoading<LocationState>>(),
          isA<AsyncData<LocationState>>()
              .having(
                (s) => s.value,
                "is InitialLocationState",
                isA<IntialLocationState>(),
              )
              .having(
                (s) => s.value.isServiceEnabled,
                "service should be enabled",
                isTrue,
              )
              .having(
                (s) => s.value.permissionState,
                "service should be enabled",
                LocationPermission.whileInUse,
              ),
          isA<AsyncData<LocationState>>().having(
            (s) => s.value,
            "is LoadingLocationState",
            isA<LoadingLocationState>()
                .having(
                  (s) => s.isServiceEnabled,
                  "service should be enabled",
                  isTrue,
                )
                .having(
                  (s) => s.permissionState,
                  "service should be enabled",
                  LocationPermission.whileInUse,
                ),
          ),
          isA<AsyncData<LocationState>>().having(
            (s) => s.value,
            "is LoadedLocationState",
            isA<LoadedLocationState>()
                .having(
                  (s) => s.isServiceEnabled,
                  "service should be enabled",
                  isTrue,
                )
                .having(
                  (s) => s.permissionState,
                  "service should be enabled",
                  LocationPermission.whileInUse,
                )
                .having(
                  (s) => s.position,
                  "service should be enabled",
                  equals(Position(
                    latitude: 52.561270,
                    longitude: 5.639382,
                    timestamp: DateTime.fromMillisecondsSinceEpoch(
                      500,
                      isUtc: true,
                    ),
                    altitude: 3000.0,
                    accuracy: 0.0,
                    heading: 0.0,
                    speed: 0.0,
                    speedAccuracy: 0.0,
                    altitudeAccuracy: 0.0,
                    headingAccuracy: 0.0,
                  )),
                ),
          ),
        ],
      );

      /// Checks IntitialState in build and call check location , then state should be change accordingly
      /// when location permission is always
      testAsyncNotifier(
        "shoud be IntialLocationState,LoadingLocationState,LoadedLocationState when location permission is always",
        provider: locationPod,
        emitBuildStates: true,
        act: (notifier) => notifier.getLocation(),
        setUp: () {
          GeolocatorPlatform.instance = MockGeolocatorPlatform(
            checkPermissionValue: LocationPermission.always,
            requestPermissionValue: LocationPermission.always,
          );
        },
        expect: () => [
          isA<AsyncLoading<LocationState>>(),
          isA<AsyncData<LocationState>>()
              .having(
                (s) => s.value,
                "is InitialLocationState",
                isA<IntialLocationState>(),
              )
              .having(
                (s) => s.value.isServiceEnabled,
                "service should be enabled",
                isTrue,
              )
              .having(
                (s) => s.value.permissionState,
                "service should be enabled",
                LocationPermission.always,
              ),
          isA<AsyncData<LocationState>>().having(
            (s) => s.value,
            "is LoadingLocationState",
            isA<LoadingLocationState>()
                .having(
                  (s) => s.isServiceEnabled,
                  "service should be enabled",
                  isTrue,
                )
                .having(
                  (s) => s.permissionState,
                  "service should be enabled",
                  LocationPermission.always,
                ),
          ),
          isA<AsyncData<LocationState>>().having(
            (s) => s.value,
            "is LoadedLocationState",
            isA<LoadedLocationState>()
                .having(
                  (s) => s.isServiceEnabled,
                  "service should be enabled",
                  isTrue,
                )
                .having((s) => s.permissionState, "service should be enabled",
                    LocationPermission.always)
                .having(
                  (s) => s.position,
                  "service should be enabled",
                  equals(Position(
                    latitude: 52.561270,
                    longitude: 5.639382,
                    timestamp: DateTime.fromMillisecondsSinceEpoch(
                      500,
                      isUtc: true,
                    ),
                    altitude: 3000.0,
                    accuracy: 0.0,
                    heading: 0.0,
                    speed: 0.0,
                    speedAccuracy: 0.0,
                    altitudeAccuracy: 0.0,
                    headingAccuracy: 0.0,
                  )),
                ),
          ),
        ],
      );
      testAsyncNotifier(
        "should be in LocationErrorState when location service disabled ",
        provider: locationPod,
        act: (notifier) => notifier.getLocation(),
        setUp: () {
          GeolocatorPlatform.instance =
              MockGeolocatorPlatform(isLocationServiceEnabledValue: false);
        },
        expect: () => [
          isA<AsyncData<LocationState>>().having(
            (s) => s.value,
            "is LoadingLocationState",
            isA<LoadingLocationState>()
                .having(
                  (s) => s.isServiceEnabled,
                  "service should be disabled",
                  isFalse,
                )
                .having(
                  (s) => s.permissionState,
                  "permission should be enabled",
                  LocationPermission.whileInUse,
                ),
          ),
          isA<AsyncData<LocationState>>().having(
            (s) => s.value,
            "is LocationErrorState",
            isA<LocationErrorState>()
                .having(
                  (s) => s.isServiceEnabled,
                  "service should be disabled",
                  isFalse,
                )
                .having(
                  (s) => s.permissionState,
                  "permission should be enabled",
                  LocationPermission.whileInUse,
                )
                .having(
                  (s) => s.errorMessage,
                  "permission should be enabled",
                  contains("Service disabled"),
                ),
          ),
        ],
      );

      /// Checks error state on permission denied
      testAsyncNotifier(
        "should be in LocationErrorState when permission is denied",
        provider: locationPod,
        act: (notifier) => notifier.getLocation(),
        setUp: () {
          GeolocatorPlatform.instance = MockGeolocatorPlatform(
            checkPermissionValue: LocationPermission.denied,
            requestPermissionValue: LocationPermission.denied,
          );
        },
        expect: () => [
          isA<AsyncData<LocationState>>().having(
            (s) => s.value,
            "is LoadingLocationState",
            isA<LoadingLocationState>()
                .having(
                  (s) => s.isServiceEnabled,
                  "service should be disabled",
                  isTrue,
                )
                .having(
                  (s) => s.permissionState,
                  "permission should be enabled",
                  LocationPermission.denied,
                ),
          ),
          isA<AsyncData<LocationState>>().having(
            (s) => s.value,
            "is LocationErrorState",
            isA<LocationErrorState>()
                .having(
                  (s) => s.isServiceEnabled,
                  "service should be disabled",
                  isTrue,
                )
                .having(
                  (s) => s.permissionState,
                  "permission should be enabled",
                  LocationPermission.denied,
                )
                .having(
                  (s) => s.errorMessage,
                  "permission should be enabled",
                  contains("Permission not enabled"),
                ),
          ),
        ],
      );
      testAsyncNotifier(
        "should be in LocationErrorState when permission is always",
        provider: locationPod,
        act: (notifier) => notifier.getLocation(),
        setUp: () {
          GeolocatorPlatform.instance = MockGeolocatorPlatform(
            checkPermissionValue: LocationPermission.always,
            requestPermissionValue: LocationPermission.always,
          );
        },
        expect: () => [
          isA<AsyncData<LocationState>>().having(
            (s) => s.value,
            "is LoadingLocationState",
            isA<LoadingLocationState>()
                .having(
                  (s) => s.isServiceEnabled,
                  "service should be disabled",
                  isTrue,
                )
                .having(
                  (s) => s.permissionState,
                  "permission should be deniedForever",
                  LocationPermission.always,
                ),
          ),
          isA<AsyncData<LocationState>>().having(
            (s) => s.value,
            "is LoadedLocationState",
            isA<LoadedLocationState>()
                .having(
                  (s) => s.isServiceEnabled,
                  "service should be enabled",
                  isTrue,
                )
                .having(
                  (s) => s.permissionState,
                  "service should be enabled",
                  LocationPermission.always,
                )
                .having(
                  (s) => s.position,
                  "service should be enabled",
                  equals(Position(
                    latitude: 52.561270,
                    longitude: 5.639382,
                    timestamp: DateTime.fromMillisecondsSinceEpoch(
                      500,
                      isUtc: true,
                    ),
                    altitude: 3000.0,
                    accuracy: 0.0,
                    heading: 0.0,
                    speed: 0.0,
                    speedAccuracy: 0.0,
                    altitudeAccuracy: 0.0,
                    headingAccuracy: 0.0,
                  )),
                ),
          ),
        ],
      );

      /// checks intial state in build , and on change of location service ,
      /// call checkLocation function called & state should be changed
      testAsyncNotifier(
        "shoud be LoadingLocationState,LoadedLocationState",
        provider: locationPod,
        emitBuildStates: true,
        setUp: () {
          GeolocatorPlatform.instance = MockGeolocatorPlatform();
        },
        overrides: [
          locationServiceStreamPod.overrideWith((ref) async* {
            yield ServiceStatus.enabled;
          }),
        ],
        expect: () => [
          isA<AsyncLoading<LocationState>>(),
          isA<AsyncData<LocationState>>()
              .having(
                (s) => s.value,
                "is InitialLocationState",
                isA<IntialLocationState>(),
              )
              .having(
                (s) => s.value.isServiceEnabled,
                "service should be enabled",
                isTrue,
              )
              .having(
                (s) => s.value.permissionState,
                "service should be enabled",
                LocationPermission.whileInUse,
              ),
          isA<AsyncData<LocationState>>().having(
            (s) => s.value,
            "is LoadingLocationState",
            isA<LoadingLocationState>()
                .having(
                  (s) => s.isServiceEnabled,
                  "service should be enabled",
                  isTrue,
                )
                .having(
                  (s) => s.permissionState,
                  "service should be enabled",
                  LocationPermission.whileInUse,
                ),
          ),
          isA<AsyncData<LocationState>>().having(
            (s) => s.value,
            "is LoadedLocationState",
            isA<LoadedLocationState>()
                .having(
                  (s) => s.isServiceEnabled,
                  "service should be enabled",
                  isTrue,
                )
                .having(
                  (s) => s.permissionState,
                  "service should be enabled",
                  LocationPermission.whileInUse,
                )
                .having(
                  (s) => s.position,
                  "service should be enabled",
                  equals(Position(
                    latitude: 52.561270,
                    longitude: 5.639382,
                    timestamp: DateTime.fromMillisecondsSinceEpoch(
                      500,
                      isUtc: true,
                    ),
                    altitude: 3000.0,
                    accuracy: 0.0,
                    heading: 0.0,
                    speed: 0.0,
                    speedAccuracy: 0.0,
                    altitudeAccuracy: 0.0,
                    headingAccuracy: 0.0,
                  )),
                ),
          ),
        ],
      );
    },
  );
}
