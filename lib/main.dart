import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location_helper/features/location_btn/view/location_btn.dart';
import 'package:location_helper/shared/riverpod_observer.dart';
import 'package:talker_flutter/talker_flutter.dart';

// coverage:ignore-file

/// This `talker` global variable used for logging and accessible
///  to other classed or function
// coverage:ignore-file

final talker = TalkerFlutter.init(
  settings: TalkerSettings(
    maxHistoryItems: null,
    useConsoleLogs: !kReleaseMode,
    enabled: !kReleaseMode,
  ),
  logger: TalkerLogger(
    output: debugPrint,
    settings: const TalkerLoggerSettings(),
  ),
);

void main() {
  runApp(ProviderScope(
    observers: [
      MyObserverLogger(talker: talker),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(child: LocationButton()),
      ),
    );
  }
}
