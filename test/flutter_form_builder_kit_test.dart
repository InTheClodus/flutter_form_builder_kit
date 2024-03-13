import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_form_builder_kit/flutter_form_builder_kit.dart';
import 'package:flutter_form_builder_kit/flutter_form_builder_kit_platform_interface.dart';
import 'package:flutter_form_builder_kit/flutter_form_builder_kit_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterFormBuilderKitPlatform
    with MockPlatformInterfaceMixin
    implements FlutterFormBuilderKitPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterFormBuilderKitPlatform initialPlatform = FlutterFormBuilderKitPlatform.instance;

  test('$MethodChannelFlutterFormBuilderKit is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterFormBuilderKit>());
  });

  test('getPlatformVersion', () async {
    FlutterFormBuilderKit flutterFormBuilderKitPlugin = FlutterFormBuilderKit();
    MockFlutterFormBuilderKitPlatform fakePlatform = MockFlutterFormBuilderKitPlatform();
    FlutterFormBuilderKitPlatform.instance = fakePlatform;

    expect(await flutterFormBuilderKitPlugin.getPlatformVersion(), '42');
  });
}
