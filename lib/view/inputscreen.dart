import 'package:cleverconvert/bloc/bloc.dart';
import 'package:cleverconvert/model/converter.dart';
import 'package:cleverconvert/res/strings.dart';
import 'package:cleverconvert/view/resultsscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  /// bloc for the input screen
  final InputScreenBloc bloc = InputScreenBloc();

  @override
  void initState() {
    super.initState();
  }

  /// dispose controller and bloc
  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  double _calculateFontSize(int textLength) {
    double _minSize = 48;
    double tempSize = MediaQuery.of(context).size.width;

    if (textLength == 0) {
      return _minSize;
    }

    tempSize /= (1 + textLength * 0.7);

    if (tempSize < _minSize) {
      return _minSize;
    }

    return tempSize;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (context) => InputScreenBloc(),
      child: BlocBuilder(
        bloc: bloc,
        builder: (BuildContext context, InputScreenState state) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.info_outline,
                  ),
                  onPressed: () => showLicensePage(
                    context: context,
                    applicationLegalese: Strings.licenseText,
                  ),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Theme.of(context).accentColor,
              onTap: bloc.onCategoryChanged,
              currentIndex: state.categoryIndex,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    FontAwesomeIcons.weightHanging,
                  ),
                  title: Text(
                    state.categories.elementAt(0),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    FontAwesomeIcons.thermometerHalf,
                  ),
                  title: Text(
                    state.categories.elementAt(1),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    FontAwesomeIcons.ruler,
                  ),
                  title: Text(
                    state.categories.elementAt(2),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    FontAwesomeIcons.tachometerAlt,
                  ),
                  title: Text(
                    state.categories.elementAt(3),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    FontAwesomeIcons.cube,
                  ),
                  title: Text(
                    state.categories.elementAt(4),
                  ),
                ),
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextField(
                      onChanged: bloc.onValueChanged,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: _calculateFontSize(state.value.length),
                      ),
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration.collapsed(
                        hintText: "Enter a value",
                      ),
                    ),
                  ),
                ),
                DropdownButton(
                  underline: Container(),
                  value: state.unit,
                  onChanged: bloc.onUnitChanged,
                  items: state.units
                      .map((unit) => DropdownMenuItem<String>(
                            value: unit,
                            child: Text(unit),
                          ))
                      .toList(),
                )
              ],
            ),
            floatingActionButton: state.convertPossible
                ? FloatingActionButton.extended(
                    label: Text(
                      "CONVERT",
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        // TODO: remove logic from view
                        builder: (context) => ResultsScreen(
                          value: Converter.value,
                          unit: Converter.selectedUnit.name,
                          results: Converter.convert(),
                        ),
                      ),
                    ),
                    icon: Icon(
                      Icons.arrow_forward,
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }
}
