import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location_helper/features/location_btn/controller/notifier/location_notifier.dart';
import 'package:location_helper/features/location_btn/state/location_state.dart';

final locationPod =
    AsyncNotifierProvider.autoDispose<LocationNotifier, LocationState>(
  LocationNotifier.new,
  name: 'locationPod',
);
