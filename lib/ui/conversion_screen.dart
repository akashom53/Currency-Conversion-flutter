import 'package:akash_siwisoft/auth/auth_manager.dart';
import 'package:akash_siwisoft/conversion/conversion_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import 'package:intl/intl.dart';

final currencyFormat = new NumberFormat("#,##0.00", "en_US");

class ConversionScreen extends StatelessWidget {
  final _inputController = TextEditingController();

  void refreshRates(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    Provider.of<ConversionManager>(context, listen: false).fetchRates(
      appState.baseCurrency,
      appState.targetCurrencies,
    );
    String old = _inputController.text;
    if (old == null || old.isEmpty) return;
    old = old.replaceAll(RegExp(r"[A-Z]"), "");
    _inputController.text = old+appState.baseCurrency;
  }

  void onEditBaseCurrency(BuildContext context) async {
    await Navigator.of(context).pushNamed('/baseEditor');
    refreshRates(context);
  }

  void onAddTarget(BuildContext context) async {
    await Navigator.of(context).pushNamed('/targetAdder');
    refreshRates(context);
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 0), () => refreshRates(context));
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
              Container(
                height: 70,
                child: Consumer<ConversionManager>(
                  builder: (context, conversionManager, child) {
                    if (conversionManager.inProgress)
                      return Container(
                        margin: const EdgeInsets.all(20),
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      );
                    return FlatButton.icon(
                      onPressed: () => refreshRates(context),
                      icon: Icon(Icons.refresh),
                      label: Text("Refresh"),
                      colorBrightness: Brightness.dark,
                    );
                  },
                ),
              ),
              Consumer<AppState>(
                builder: (context, appState, child) => Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text("Base Value: "),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _inputController,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        inputFormatters: [
                          // FilteringTextInputFormatter.digitsOnly,
                          CurrencyInputFormatter(appState.baseCurrency),
                        ],
                        onChanged: (text) {
                          Provider.of<ConversionManager>(context, listen: false)
                              .notify();
                        },
                        keyboardType: TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "0 ${appState.baseCurrency}",
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () => onEditBaseCurrency(context),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                color: Colors.white,
                width: double.infinity,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        bottom: 20,
                        top: 10,
                      ),
                      child: Text("Today's Value: "),
                    ),
                  ),
                  FlatButton(
                    onPressed: () => onAddTarget(context),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Consumer<ConversionManager>(
                  builder: (context, conversionManager, child) {
                    final baseText = _inputController.text
                        .replaceAll(RegExp(r"[A-Z]"), "")
                        .trim();
                    double baseVal = 0;
                    try {
                      baseVal = baseText.isEmpty ? 0 : double.parse(baseText);
                    } catch (e) {
                      print(e);
                    }
                    final values = conversionManager.values(
                        baseVal is double ? baseVal : baseVal.toDouble());
                    return ListView(
                      children: values.keys
                          .map<Widget>(
                            (currency) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 2,
                              ),
                              child: Text(
                                "$currency: ${currencyFormat.format(values[currency])}",
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              ),
              MediaQuery.of(context).viewInsets.bottom == 0
                  ? Consumer<AuthState>(
                      builder: (context, authState, child) {
                        switch(authState.currentStatus) {
                          case AuthStatus.SIGNED_OUT:
                            Future.delayed(Duration(seconds: 0), () {
                              Navigator.of(context).pushReplacementNamed('/login');
                            });
                            break;
                          case AuthStatus.SIGNED_IN:

                            break;
                          case AuthStatus.IN_PROGRESS:
                            return CircularProgressIndicator();
                            break;
                        }
                        return FlatButton(
                          onPressed: () {
                            Provider.of<AuthManager>(context, listen: false).signOut();
                          },
                          child: Text("Logout"),
                          colorBrightness: Brightness.dark,
                        );
                      }
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  final String baseCurrency;

  CurrencyInputFormatter(this.baseCurrency);

  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      print(true);
      return newValue.copyWith(text: "");
    }

    String newText = "${newValue.text.replaceAll(RegExp(r"[A-Z]"), "")}".trim();

    return newValue.copyWith(text: newText + " " + baseCurrency);
  }
}
