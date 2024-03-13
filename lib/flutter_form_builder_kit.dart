
import 'flutter_form_builder_kit_platform_interface.dart';

class FlutterFormBuilderKit {
  Future<String?> getPlatformVersion() {
    return FlutterFormBuilderKitPlatform.instance.getPlatformVersion();
  }
}
