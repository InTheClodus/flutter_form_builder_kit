import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder_kit/flutter_form_builder_kit.dart';

/// 表单字段的容器。
class FormBuilderKit extends StatefulWidget {
  /// 当表单字段中的一个发生变化时调用。
  ///
  /// 除了调用此回调函数之外，所有的表单字段本身也将重新构建。
  ///
  final VoidCallback? onChanged;

  /// {@macro flutter.widgets.navigator.onPopInvoked}
  ///
  /// {@tool dartpad}
  /// 这个示例演示了如何使用这个参数，在导航返回操作会导致表单数据丢失时显示确认对话框。
  /// ** 请查看 examples/api/lib/widgets/form/form.1.dart 中的代码 **
  ///
  /// {@end-tool}
  /// 另请参阅:
  ///
  ///  * [canPop]，它也来自于 [PopScope]，通常与这个参数一起使用。
  ///
  ///  * [PopScope.onPopInvoked]，这是 [Form] 在内部委托给的。
  final void Function(bool)? onPopInvoked;

  /// {@macro flutter.widgets.PopScope.canPop}
  ///
  /// {@tool dartpad}
  /// 这个示例演示了如何使用这个参数，在导航返回操作会导致表单数据丢失时显示确认对话框。
  ///
  /// ** 请查看 examples/api/lib/widgets/form/form.1.dart 中的代码 **
  /// {@end-tool}
  ///
  /// 另请参阅:
  ///
  ///  * [onPopInvoked]，它也来自于 [PopScope]，通常与这个参数一起使用。
  ///  * [PopScope.canPop]，这是 [Form] 在内部委托给的。
  final bool? canPop;

  /// 此小部件在树中位于该小部件下面。
  ///
  /// 这是包含此表单的小部件层次结构的根。
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  /// 用于启用/禁用表单字段的自动验证并更新它们的错误文本。
  ///
  /// {@macro flutter.widgets.form.autovalidateMode}
  final AutovalidateMode? autovalidateMode;

  /// 一个可选的字段初始值的 Map。键对应于字段的名称，值对应于字段的初始值。
  ///
  /// 如果字段有本地初始值设置，这里设置的初始值将被忽略。
  final Map<String, dynamic> initialValue;

  /// 表单是否应忽略从 `enabled` 为 `false` 的字段提交的值。
  ///
  /// 这种行为在 HTML 表单中很常见，其中当表单提交时，_只读_ 值不会被提交。
  ///
  /// `true` = 禁用 / `false` = 只读
  ///
  /// 当为 `true` 时，最终的表单值将不包含已禁用的字段。
  /// 默认值为 `false`。
  final bool skipDisabled;

  /// 表单是否能够接收用户输入。
  ///
  /// 默认为 true。
  ///
  /// 当为 `false` 时，所有表单字段将被禁用 - 不接受输入 - 并且它们的启用状态将被忽略。
  final bool enabled;

  /// 当字段注销时是否清除字段的内部值。
  ///
  /// 默认为 `false`。
  ///
  /// 当设置为 `true` 时，表单构建器将不会保留已处理的 [FormBuilderField] 的内部值。这对于动态表单很有用，其中由于状态更改而注册和注销字段。
  ///
  /// 当注册与已注销字段相同名称的字段时，此设置将不起作用。
  final bool clearValueOnUnregister;

  /// 创建一个表单字段的容器。
  ///
  /// [child] 参数不能为空。
  const FormBuilderKit({
    super.key,
    required this.child,
    this.onChanged,
    this.autovalidateMode,
    this.onPopInvoked,
    this.initialValue = const <String, dynamic>{},
    this.skipDisabled = false,
    this.enabled = true,
    this.clearValueOnUnregister = false,
    this.canPop,
  });

  static FormBuilderKitState? of(BuildContext context) =>
      context.findAncestorStateOfType<FormBuilderKitState>();

  @override
  FormBuilderKitState createState() => FormBuilderKitState();
}

/// 表单字段映射的类型别名。
typedef FormBuilderFields
    = Map<String, FormBuilderFieldKitState<FormBuilderFieldKit<dynamic>, dynamic>>;

class FormBuilderKitState extends State<FormBuilderKit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FormBuilderFields _fields = {};
  final Map<String, dynamic> _instantValue = {};
  final Map<String, dynamic> _savedValue = {};

// 因为 Dart 类型系统不会接受 ValueTransformer<dynamic>。
  final Map<String, Function> _transformers = {};
  bool _focusOnInvalid = true;

  /// 当验证时将会聚焦在无效字段上时将为 true。
  ///
  /// 仅用于内部逻辑。
  bool get focusOnInvalid => _focusOnInvalid;

  bool get enabled => widget.enabled;

  /// 验证表单上的所有字段是否有效。
  bool get isValid => fields.values.every((field) => field.isValid);

  /// 如果表单上的某些字段是脏的，则为 true。
  ///
  /// 脏的：字段的值被用户或逻辑代码更改。
  bool get isDirty => fields.values.any((field) => field.isDirty);

  /// 如果表单上的某些字段被触摸过，则为 true。
  ///
  /// 触摸过：字段被用户或逻辑代码聚焦。
  bool get isTouched => fields.values.any((field) => field.isTouched);

  /// 获取错误的映射。
  Map<String, String> get errors => {
        for (var element
            in fields.entries.where((element) => element.value.hasError))
          element.key.toString(): element.value.errorText ?? ''
      };

  /// 获取初始值。
  Map<String, dynamic> get initialValue => widget.initialValue;

  /// 获取表单的所有字段。
  FormBuilderFields get fields => _fields;

  Map<String, dynamic> get instantValue =>
      Map<String, dynamic>.unmodifiable(_instantValue.map((key, value) =>
          MapEntry(key, _transformers[key]?.call(value) ?? value)));

  /// 仅返回保存的值。
  Map<String, dynamic> get value =>
      Map<String, dynamic>.unmodifiable(_savedValue.map((key, value) =>
          MapEntry(key, _transformers[key]?.call(value) ?? value)));

  dynamic transformValue<T>(String name, T? v) {
    final t = _transformers[name];
    return t != null ? t.call(v) : v;
  }

  dynamic getTransformedValue<T>(String name, {bool fromSaved = false}) {
    return transformValue<T>(name, getRawValue(name));
  }

  T? getRawValue<T>(String name, {bool fromSaved = false}) {
    return (fromSaved ? _savedValue[name] : _instantValue[name]) ??
        initialValue[name];
  }

  void setInternalFieldValue<T>(String name, T? value) {
    _instantValue[name] = value;
    widget.onChanged?.call();
  }

  void removeInternalFieldValue(String name) {
    _instantValue.remove(name);
  }

  void registerField(String name, FormBuilderFieldKitState field) {
    // 每个字段必须具有唯一的名称。理想情况下，我们可以简单地这样做：
    //   assert(!_fields.containsKey(name));
    // 但是，Flutter 会延迟处置已停用的字段，因此如果字段正在被替换，则新实例在旧实例被注销之前就已注册。
    // 为了适应这种情况，但也为了提供对意外重复名称的帮助，我们进行检查并发出警告。
    final oldField = _fields[name];
    assert(() {
      if (oldField != null) {
        debugPrint('Warning! Replacing duplicate Field for $name'
            ' -- this is OK to ignore as long as the field was intentionally replaced');
      }
      return true;
    }());

    _fields[name] = field;
    field.registerTransformer(_transformers);

    field.setValue(
      oldField?.value ?? (_instantValue[name] ??= field.initialValue),
      populateForm: false,
    );
  }

  void unregisterField(String name, FormBuilderFieldKitState field) {
    assert(
      _fields.containsKey(name),
      'Failed to unregister a field. Make sure that all field names in a form are unique.',
    );

    // 仅在注册时移除字段。
    // 有可能在为给定名称调用 unregisterField 之前替换字段（为给定名称调用 registerField 两次），
    // 所以只发出警告，因为这可能是有意的。
    if (field == _fields[name]) {
      _fields.remove(name);
      _transformers.remove(name);
      if (widget.clearValueOnUnregister) {
        _instantValue.remove(name);
        _savedValue.remove(name);
      }
    } else {
      assert(() {
        // 当您有意使用相同名称替换另一个字段时，可以忽略这个警告。
        debugPrint('Warning! Ignoring Field unregistration for $name'
            ' -- this is OK to ignore as long as the field was intentionally replaced');
        return true;
      }());
    }
  }

  void save() {
    _formKey.currentState!.save();
    // Copy values from instant to saved
    _savedValue.clear();
    _savedValue.addAll(_instantValue);
  }

  @Deprecated(
      'Will be remove to avoid redundancy. Use fields[name]?.invalidate(errorText) instead')
  void invalidateField({required String name, String? errorText}) =>
      fields[name]?.invalidate(errorText ?? '');

  @Deprecated(
      'Will be remove to avoid redundancy. Use fields.first.invalidate(errorText) instead')
  void invalidateFirstField({required String errorText}) =>
      fields.values.first.invalidate(errorText);

  /// 验证表单的所有字段。
  ///
  /// 如果有字段无效，并且 [focusOnInvalid] 为 `true`，则将焦点设置到第一个无效字段。
  /// 默认为 `true`。
  ///
  /// 如果 [autoScrollWhenFocusOnInvalid] 为 `true`，则自动滚动到第一个焦点为无效字段。
  /// 默认为 `false`。
  ///
  /// 注意：如果一个无效字段是 **TextField** 类型并且将被聚焦，表单将自动滚动以显示此无效字段。
  /// 在这种情况下，自动滚动是因为这是框架内部的行为，而不是因为 [autoScrollWhenFocusOnInvalid] 为 `true`。
  bool validate({
    bool focusOnInvalid = true,
    bool autoScrollWhenFocusOnInvalid = false,
  }) {
    _focusOnInvalid = focusOnInvalid;
    final hasError = !_formKey.currentState!.validate();
    if (hasError) {
      final wrongFields =
          fields.values.where((element) => element.hasError).toList();
      if (wrongFields.isNotEmpty) {
        if (focusOnInvalid) {
          wrongFields.first.focus();
        }
        if (autoScrollWhenFocusOnInvalid) {
          wrongFields.first.ensureScrollableVisibility();
        }
      }
    }
    return !hasError;
  }

  /// 保存表单值并验证表单的所有字段。
  ///
  /// 如果有字段无效，并且 [focusOnInvalid] 为 `true`，则将焦点设置到第一个无效字段。
  /// 默认为 `true`。
  ///
  /// 如果 [autoScrollWhenFocusOnInvalid] 为 `true`，则自动滚动到第一个焦点为无效字段。
  /// 默认为 `false`。
  ///
  /// 注意：如果一个无效字段是 **TextField** 类型并且将被聚焦，表单将自动滚动以显示此无效字段。
  /// 在这种情况下，自动滚动是因为这是框架内部的行为，而不是因为 [autoScrollWhenFocusOnInvalid] 为 `true`。
  bool saveAndValidate({
    bool focusOnInvalid = true,
    bool autoScrollWhenFocusOnInvalid = false,
  }) {
    save();
    return validate(
      focusOnInvalid: focusOnInvalid,
      autoScrollWhenFocusOnInvalid: autoScrollWhenFocusOnInvalid,
    );
  }

  /// Reset form to `initialValue`
  void reset() {
    _formKey.currentState?.reset();
  }

  /// 更新表单的字段值。
  /// 在需要一次性更新所有值之后，初始化后使用此功能。
  ///
  /// 要在初始化时一次性加载所有值，请使用 `initialValue` 属性。
  void patchValue(Map<String, dynamic> val) {
    val.forEach((key, dynamic value) {
      _fields[key]?.didChange(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: widget.autovalidateMode,
      onPopInvoked: widget.onPopInvoked,
      canPop: widget.canPop,
    // `onChanged` 在 `setInternalFieldValue` 期间调用，否则会提前调用。
      child: _FormBuilderScope(
        formState: this,
        child: FocusTraversalGroup(
          policy: WidgetOrderTraversalPolicy(),
          child: widget.child,
        ),
      ),
    );
  }
}

class _FormBuilderScope extends InheritedWidget {
  const _FormBuilderScope({
    required super.child,
    required FormBuilderKitState formState,
  }) : _formState = formState;

  final FormBuilderKitState _formState;

  /// 与此小部件关联的 [Form]。
  FormBuilderKit get form => _formState.widget;

  @override
  bool updateShouldNotify(_FormBuilderScope oldWidget) =>
      oldWidget._formState != _formState;
}
