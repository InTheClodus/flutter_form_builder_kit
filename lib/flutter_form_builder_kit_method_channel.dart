import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_form_builder_kit_platform_interface.dart';

/// An implementation of [FlutterFormBuilderKitPlatform] that uses method channels.
class MethodChannelFlutterFormBuilderKit extends FlutterFormBuilderKitPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_form_builder_kit');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
