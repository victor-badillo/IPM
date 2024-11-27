import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'my_app_state.dart';


class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados de conversion'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Esta función se ejecuta cuando se presiona el botón de retroceso
            appState.comeBack();
            appState.changeIndex(2);
          },
        ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          //Seleccionar pantalla vertical u horizontal
          return (orientation == Orientation.portrait)
              ? buildPortraitLayout(context) //Vertical
              : buildLandscapeLayout(context); //Horizontal
        },
      ),
    );
  }

  Widget buildPortraitLayout(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return ListView.builder(
      itemCount: appState.data.length,
      itemBuilder: (context, index) {
        var item = appState.data[index];
        double resultado = double.parse(
                item['c'].toString()) * //c es la tasa de conversión del stub
            double.parse(appState.cantidadController
                .text); //Calculamos el resultado con lo que nos devuelve el stub
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 120,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    item[
                        's'], //Cogemos la abreviatura de la conversión que hace el stub
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              //SizedBox(width: 20),
              Icon(Icons.arrow_circle_right_outlined, size: 50),
              //SizedBox(width: 20),
              Container(
                width: 120,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    resultado.toStringAsFixed(4),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildLandscapeLayout(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return ListView.builder(
      itemCount: appState.data.length,
      itemBuilder: (context, index) {
        var item = appState.data[index];
        double resultado = double.parse(
                item['c'].toString()) * //c es la tasa de conversión del stub
            double.parse(appState.cantidadController
                .text); //Calculamos el resultado con lo que nos devuelve el stub
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //Expanded(
                Container(
                  width: 240,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      item[
                          's'], //Cogemos la abreviatura de la conversión que hace el stub
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              //),
              //SizedBox(width: 20),
              Icon(Icons.arrow_circle_right_outlined, size: 70),
              //SizedBox(width: 20),
              //Expanded(
                Container(
                  width: 240,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      resultado.toStringAsFixed(4),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              //),
            ],
          ),
        );
      },
    );
  }
}