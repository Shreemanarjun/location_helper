import 'package:geolocator/geolocator.dart';

sealed class LocationState {
  final bool isServiceEnabled;
  final LocationPermission permissionState;

  const LocationState(
      {required this.isServiceEnabled, required this.permissionState});
}

class IntialLocationState extends LocationState {
  IntialLocationState({
    required super.isServiceEnabled,
    required super.permissionState,
  });

  @override
  String toString() =>
      'IntialLocationState(isServiceEnabled: $isServiceEnabled, permissionState: $permissionState)';
}

class LoadingLocationState extends LocationState {
  @override
  String toString() =>
      'LoadingLocationState(isServiceEnabled: $isServiceEnabled, permissionState: $permissionState)';
  LoadingLocationState({
    required super.isServiceEnabled,
    required super.permissionState,
  });
}

class LoadedLocationState extends LocationState {
  final Position position;
  LoadedLocationState({
    required super.isServiceEnabled,
    required super.permissionState,
    required this.position,
  });

  @override
  String toString() => 'LoadedLocationState(position: $position)';
}

class LocationErrorState extends LocationState {
  final String errorMessage;

  LocationErrorState({
    required super.isServiceEnabled,
    required super.permissionState,
    required this.errorMessage,
  });

  @override
  String toString() => 'LocationErrorState(errorMessage: $errorMessage)';
}
