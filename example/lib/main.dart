import 'package:flutter/material.dart';
import 'package:flutter_form_builder_kit/flutter_form_builder_kit.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormBuilderKitState> _formGlobalKey = GlobalKey<FormBuilderKitState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: FormBuilderKit(
          key: _formGlobalKey,
          child: Column(
            children: [
              FormBuilderKitTextField(
                name: 'name',
                validator: FormBuilderValidators.required(),

              ),
              ElevatedButton(
                onPressed: () {
                  _formGlobalKey.currentState?.saveAndValidate();
                  print(_formGlobalKey.currentState?.saveAndValidate());
                  print(_formGlobalKey.currentState?.value);
                },
                child: const Text('Validate'),
              ),
            ],
          ),
        )
      ),
    );
  }
}
