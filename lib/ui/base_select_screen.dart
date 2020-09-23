import 'dart:async';

import 'package:akash_siwisoft/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseSelectScreen extends StatelessWidget {
  final StreamController<String> _inputError = StreamController<String>();
  final TextEditingController _inputController = TextEditingController();

  final bool isEditingMode;

  BaseSelectScreen({Key key, this.isEditingMode = false}) : super(key: key);

  void onNext(BuildContext context, AppState appState) async {
    _inputError.add(
      _inputController.text.isEmpty ? "Please input a value" : null,
    );

    if (_inputController.text.isNotEmpty) {
      appState.baseCurrency = _inputController.text;
      await _inputError.close();
      if (isEditingMode) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pushReplacementNamed('/targetSelector');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 0), () {
      final oldBase =
          Provider.of<AppState>(context, listen: false).baseCurrency;
      if (oldBase != null && oldBase.isEmpty) _inputController.text = oldBase;
    });
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Text(
                  "SIVISOFT",
                  style: TextStyle(fontSize: 40),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  "Currency Converter",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Select Your Base"),
                          buildInput(),
                          buildNextButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox buildNextButton() {
    return SizedBox(
      width: double.infinity,
      child: Consumer<AppState>(
        builder: (context, appState, widget) => FlatButton(
          onPressed: () => onNext(context, appState),
          child: Text(
            isEditingMode ? "DONE" : "NEXT",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Container buildInput() {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: StreamBuilder<String>(
            stream: _inputError.stream,
            builder: (context, snapshot) {
              return TextField(
                controller: _inputController,
                decoration: InputDecoration(
                  hintText: "Currency code (INR, USD, EUR...)",
                  errorText: snapshot.data,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
