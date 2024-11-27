import 'dart:convert';
import 'package:flutter/material.dart';
import 'server_stub.dart' as stub;


class MyAppState extends ChangeNotifier {
  int selectedIndex = 1; //Variable para seleccionar la pantalla inicial
  //Variables seleccionadas para conversion
  String selectedDeValue = 'De';
  List<String> selectedAValue = [];
  TextEditingController cantidadController = TextEditingController();
  List<String> opcionesDe = [
    'EUR',
    'USD',
    'JPY',
    'DKK',
    'GBP',
    'SEK',
    'CHF',
    'NOK',
    'RUB',
    'TRY',
    'AUD',
    'BRL',
    'CAD',
    'CNY',
    'INR',
    'MXN',
    'ZAR'
  ];
  List<String> opcionesA = [
    'EUR',
    'USD',
    'JPY',
    'DKK',
    'GBP',
    'SEK',
    'CHF',
    'NOK',
    'RUB',
    'TRY',
    'AUD',
    'BRL',
    'CAD',
    'CNY',
    'INR',
    'MXN',
    'ZAR'
  ];
  bool isResultScreenOpen = false; // Variable para controlar threading
  List<String> favorites = []; //Lista para guardar favoritos
  String?
      currentConversion; //Variable para guardar el favorito actual y comparar
  List<Map<String, dynamic>> data = []; //Variable para resultsScreen
  String errorMessage = ''; //Mensaje de error

  Future peticionAPI(String symbols, double cantidadControllerValue,
      BuildContext context) async {
    if (!isResultScreenOpen) {
      isResultScreenOpen = true;
      notifyListeners();

      var uri = Uri(
        scheme: 'https',
        host: 'fcsapi.com',
        path: "/api-v3/forex/latest",
        queryParameters: {
          'symbol': symbols,
          'access_key': 'MY_API_KEY',
        },
      );
      var response = await stub.get(uri);
      print(symbols);
      print(response.statusCode);
      print(response.body);
      var dataAsDartMap = jsonDecode(response.body);
      print(dataAsDartMap);
      data = List<Map<String, dynamic>>.from(dataAsDartMap['response']);
      changeIndex(3); //Cambiar a pantalla resultados
    }
    return true;
  }

  void comeBack() {
    //funcion para volver atras desde resultScreen
    isResultScreenOpen = false;
    notifyListeners();
  }

  void toggleFavorite([String? str]) {
    //Comparar favoritos con los que ya estan en la lista
    currentConversion = str;
    str = str ?? currentConversion;
    if (favorites.contains(str)) {
      favorites.remove(str);
    } else {
      favorites.add(str!);
    }
    notifyListeners();
  }

  void removeFavorite(String str) {
    favorites.remove(str);
    notifyListeners();
  }

  void changeIndex(int i) {
    selectedIndex = i;
    notifyListeners();
  }

  bool _esNumeroRealPositivo(TextEditingController controller) {
    String valor = controller.text;
    double? resultado = double.tryParse(valor);
    return resultado != null && resultado > 0;
  }

  bool checkParametersConvert() {
    //Error conversión
    if (selectedDeValue == 'De') {
      errorMessage = 'Por favor introduzca una divisa para convertir';
      return false;
    } else if (selectedAValue.isEmpty) {
      errorMessage =
          'Por favor introduzca una o más divisas a las que convertir la divisa actual';
      return false;
    } else if (  selectedAValue.contains(selectedDeValue)) {
      errorMessage = 'Por favor introduzca divisas diferentes para De y A';
      return false;
    } else if(!_esNumeroRealPositivo(cantidadController)){
      errorMessage = 'Por favor introduzca una cantidad adecuada (números positivos, puede contener decimales)';
      return false;
    }else {
      return true;
    }
  }

  bool checkParametersLike() {
    //Error favoritos
    if (selectedDeValue == 'De') {
      errorMessage =
          'Por favor introduzca una divisa desde la que convertir para guardar como favorita';
      return false;
    } else if (selectedAValue.isEmpty) {
      errorMessage =
          'Por favor introduzca una divisa o más divisas a las que convertir para guardar como favorita';
      return false;
    } else if(selectedAValue.contains(selectedDeValue)){
      errorMessage = 'Por favor introduzca divisas diferentes para De y A';
      return false;
    }else {
      return true;
    }
  }
}