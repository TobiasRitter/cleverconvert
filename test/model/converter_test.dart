import 'package:anyunit/model/category.dart';
import 'package:anyunit/model/converter.dart';
import 'package:anyunit/model/unit.dart';
import 'package:test_api/test_api.dart';

void main() {
  test("conversion from celcius to fahrenheit is working", () {
    Unit celcius = Unit(
        name: "celcius",
        getConvertedValue: (val) => val - 273.15,
        getStandardizedValue: (val) => val + 273.15);
    Unit fahrenheit = Unit(
        name: "fahrenheit",
        getConvertedValue: (val) => (val - 273.15) * 9 / 5 + 32,
        getStandardizedValue: (val) => (val - 32) * 5 / 9 + 273.15);

    Category temperatures = Category(
      name: "temperatures",
      units: {
        celcius,
        fahrenheit,
      },
    );

    Converter tempConverter = Converter(
      categories: {temperatures},
    );

    Map conversionResults = tempConverter.convert(
        originalUnit: celcius, originalValue: 20, category: temperatures);
    expect(conversionResults.length, 1);
    expect(conversionResults.containsValue(68.0), true);
  });

  test("equal unit is not shown as a result", () {
    Unit celcius = Unit(
        name: "celcius",
        getConvertedValue: (val) => val - 273.15,
        getStandardizedValue: (val) => val + 273.15);
    Unit celciusCopy = Unit(
        name: "celcius",
        getConvertedValue: (val) => val - 273.15,
        getStandardizedValue: (val) => val + 273.15);

    Category temperatures = Category(
      name: "temperatures",
      units: {
        celcius,
        celciusCopy,
      },
    );

    Converter tempConverter = Converter(
      categories: {temperatures},
    );

    Map conversionResults = tempConverter.convert(
        originalUnit: celcius, originalValue: 20, category: temperatures);
    expect(conversionResults.length, 0);
  });

  test("unit has to be in the selected category", () {
    Unit celcius = Unit(
        name: "celcius",
        getConvertedValue: (val) => val - 273.15,
        getStandardizedValue: (val) => val + 273.15);
    Unit kg = Unit(
      name: "kg",
      getConvertedValue: (val) => val / 1000,
      getStandardizedValue: (val) => val * 1000,
    );

    Category temperature = Category(
      name: "temperature",
      units: {
        celcius,
      },
    );

    Category weight = Category(
      name: "weight",
      units: {
        kg,
      },
    );

    Converter converter = Converter(
      categories: {
        temperature,
        weight,
      },
    );

    expect(
        () => converter.convert(
              originalUnit: celcius,
              originalValue: 20,
              category: weight,
            ),
        throwsA(predicate((e) =>
            e is ArgumentError &&
            e.message == "unit is not in the selected category")));
  });
}
