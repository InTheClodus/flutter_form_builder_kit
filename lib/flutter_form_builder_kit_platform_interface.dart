import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_form_builder_kit_method_channel.dart';

abstract class FlutterFormBuilderKitPlatform extends PlatformInterface {
  /// Constructs a FlutterFormBuilderKitPlatform.
  FlutterFormBuilderKitPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterFormBuilderKitPlatform _instance = MethodChannelFlutterFormBuilderKit();

  /// The default instance of [FlutterFormBuilderKitPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterFormBuilderKit].
  static FlutterFormBuilderKitPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterFormBuilderKitPlatform] when
  /// they register themselves.
  static set instance(FlutterFormBuilderKitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
