import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class TargetSelectScreen extends StatelessWidget {
  final StreamController<String> _inputError = StreamController<String>.broadcast();
  final TextEditingController _inputController = TextEditingController();

  final bool isEditingMode;

  TargetSelectScreen({Key key, this.isEditingMode = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      child: Consumer<AppState>(
                        builder: (context, appState, child) => ListView(
                          shrinkWrap: true,
                          children: buildColumnChildren(context, appState),
                        ),
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

  Container buildInput(AppState appState) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: StreamBuilder<String>(
          stream: _inputError.stream,
          builder: (context, snapshot) {
            return Row(
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: _inputController,
                      style: TextStyle(
                        fontSize: 12,
                      ),
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
                    ),
                  ),
                ),
                FlatButton(
                    onPressed: () => onAdd(appState), child: Icon(Icons.add))
              ],
            );
          }),
    );
  }

  void onNext(BuildContext context, AppState appState) async {
    if (appState.targetCurrencies.isEmpty) {
      _inputError.add("Target currencies are empty!");
      return;
    } else {
      _inputError.add(null);
      _inputError.close();
      if (isEditingMode) {
        Navigator.of(context).pop();
        return;
      }
      Navigator.of(context).pushReplacementNamed('/conversionScreen');
    }
  }

  SizedBox buildNextButton(BuildContext context, appState) {
    return SizedBox(
      width: double.infinity,
      child: FlatButton(
        onPressed: () => onNext(context, appState),
        child: Text(
          isEditingMode ? "DONE" :"NEXT",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  List<Widget> buildColumnChildren(BuildContext context, AppState appState) =>
      List<int>.generate(appState.targetCurrencies.length + 4, (index) => index)
          .map<Widget>((index) {
        if (index == 0)
          return Text(
            "Base Currency: ${appState.baseCurrency}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          );
        else if (index == 1)
          return Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Text("Currencies to Compare"),
          );
        else if (index == appState.targetCurrencies.length + 2)
          return buildInput(appState);
        else if (index == appState.targetCurrencies.length + 3)
          return buildNextButton(context, appState);
        else
          return Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.circle,
                    size: 6,
                    color: Colors.white,
                  ),
                ),
                Text(appState.targetCurrencies[index - 2]),
              ],
            ),
          );
      }).toList();

  void onAdd(AppState appState) {
    _inputError.add(
      _inputController.text.isEmpty ? "Please input a value" : null,
    );

    if (_inputController.text.isNotEmpty &&
        !appState.targetCurrencies.contains(_inputController.text)) {
      appState.addTarget(_inputController.text);
      _inputController.text = "";
    }
  }
}
