import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final locationServiceStreamPod = StreamProvider.autoDispose<ServiceStatus>(
  (ref) {
    final stream = Geolocator.getServiceStatusStream()..listen((event) {});
    return stream;
  },
  name: 'locationEnableStreamPod',
);
