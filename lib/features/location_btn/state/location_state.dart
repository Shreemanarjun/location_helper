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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IntialLocationState &&
        other.isServiceEnabled == isServiceEnabled &&
        other.permissionState == permissionState;
  }

  @override
  int get hashCode => isServiceEnabled.hashCode ^ permissionState.hashCode;

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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoadingLocationState &&
        other.isServiceEnabled == isServiceEnabled &&
        other.permissionState == permissionState;
  }

  @override
  int get hashCode => isServiceEnabled.hashCode ^ permissionState.hashCode;
}

class LoadedLocationState extends LocationState {
  final Position position;
  LoadedLocationState({
    required super.isServiceEnabled,
    required super.permissionState,
    required this.position,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoadedLocationState && other.position == position;
  }

  @override
  int get hashCode => position.hashCode;

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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LocationErrorState && other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => errorMessage.hashCode;

  @override
  String toString() => 'LocationErrorState(errorMessage: $errorMessage)';
}
