#include "include/flutter_form_builder_kit/flutter_form_builder_kit_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_form_builder_kit_plugin.h"

void FlutterFormBuilderKitPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_form_builder_kit::FlutterFormBuilderKitPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
