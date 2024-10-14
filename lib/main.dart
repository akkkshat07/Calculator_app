import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      home: CalculatorHome(
        toggleTheme: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
      ),
    );
  }

  ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue[300],
      scaffoldBackgroundColor: Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[100],
        ),
      ),
      textTheme: TextTheme(bodyLarge: TextStyle(color: Colors.black)),
    );
  }

  ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.blue[800],
      scaffoldBackgroundColor: Colors.black,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[900],
        ),
      ),
      textTheme: TextTheme(bodyLarge: TextStyle(color: Colors.white)),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  final VoidCallback toggleTheme;
  CalculatorHome({required this.toggleTheme});

  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String _input = '0';
  String _output = '';
  bool _decimalAdded = false;

  void _buttonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _input = '0';
        _output = '';
        _decimalAdded = false;
      } else if (value == '⌫') {
        if (_input.length > 1) {
          if (_input.endsWith('.')) {
            _decimalAdded = false;
          }
          _input = _input.substring(0, _input.length - 1);
        } else {
          _input = '0';
          _output = '';
          _decimalAdded = false;
        }
      } else if (value == '=') {
        try {
          _output = _calculateResult(_input);
          _decimalAdded = _output.contains('.');
        } catch (e) {
          _output = 'Error';
        }
      } else if (value == '.') {
        if (!_decimalAdded) {
          _input += value;
          _decimalAdded = true;
        }
      } else if (value == '%') {
        try {
          double currentValue = double.parse(_input);
          _input = (currentValue / 100).toString();
        } catch (e) {
          _output = 'Error';
        }
      } else if (value == '√') {
        try {
          double currentValue = double.parse(_input);
          _output = (currentValue >= 0 ? sqrt(currentValue).toString() : 'Error');
        } catch (e) {
          _output = 'Error';
        }
      } else {
        if (_input == '0') {
          _input = value;
        } else {
          _input += value;
        }
      }
    });
  }

  String _calculateResult(String expression) {
    try {
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      return eval.toString();
    } catch (e) {
      return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _input,
                    style: TextStyle(fontSize: 36, color: Colors.grey),
                  ),
                  Text(
                    _output,
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GridView.builder(
              itemCount: buttons.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemBuilder: (context, index) {
                return CalculatorButton(
                  text: buttons[index],
                  onPressed: () => _buttonPressed(buttons[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  CalculatorButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(20),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

const List<String> buttons = [
  '7', '8', '9', '/',
  '4', '5', '6', '*',
  '1', '2', '3', '-',
  '0', '.', '%', '+',
  '⌫', 'C', '=', '√',
];
