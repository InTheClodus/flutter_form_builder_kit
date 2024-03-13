#ifndef FLUTTER_PLUGIN_FLUTTER_FORM_BUILDER_KIT_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTER_FORM_BUILDER_KIT_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flutter_form_builder_kit {

class FlutterFormBuilderKitPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlutterFormBuilderKitPlugin();

  virtual ~FlutterFormBuilderKitPlugin();

  // Disallow copy and assign.
  FlutterFormBuilderKitPlugin(const FlutterFormBuilderKitPlugin&) = delete;
  FlutterFormBuilderKitPlugin& operator=(const FlutterFormBuilderKitPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace flutter_form_builder_kit

#endif  // FLUTTER_PLUGIN_FLUTTER_FORM_BUILDER_KIT_PLUGIN_H_
