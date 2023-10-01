import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final locationServiceStreamPod = StreamProvider.autoDispose<ServiceStatus>(
  (ref) {
    final locationStreamController = StreamController<ServiceStatus>();
    final servicestream = Geolocator.getServiceStatusStream().distinct(
      (previous, next) => previous == next,
    );
    final locationStreamSubscription = servicestream.listen((event) {
      locationStreamController.add(event);
    });

    ref.onDispose(() {
      locationStreamSubscription.cancel();
      locationStreamController.close();
    });
    return locationStreamController.stream;
  },
  name: 'locationEnableStreamPod',
);
