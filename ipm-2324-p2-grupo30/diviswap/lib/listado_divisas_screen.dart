import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'my_app_state.dart';


class ListadoFavoritosScreen extends StatefulWidget {
  @override
  _ListadoFavoritosScreenState createState() => _ListadoFavoritosScreenState();
}

class _ListadoFavoritosScreenState extends State<ListadoFavoritosScreen> {
  var selectedRow; // Variable para almacenar la fila seleccionada

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 177, 221, 179),
                    border: Border.all(
                        width: 3, color: Theme.of(context).primaryColorDark),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: IconButton(
                    //Boton de borrar favorito
                    icon: Icon(Icons.delete_outline),
                    color: Colors.black,
                    onPressed: () {
                      if (selectedRow != null) {
                        appState.removeFavorite(
                            selectedRow); // Elimina la conversion seleccionada de la lista de favoritas
                        setState(() {
                          selectedRow = null;
                        });
                      }
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(21),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    border: Border.all(
                        width: 3, color: Theme.of(context).primaryColorDark),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    "FAVORITOS",
                    style: TextStyle(
                        color: Theme.of(context).dialogBackgroundColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 151, 216, 154),
                    border: Border.all(
                        width: 3, color: Theme.of(context).primaryColorDark),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: IconButton(
                    //Boton de realizar conversion
                    icon: Icon(Icons.attach_money),
                    color: Colors.black,
                    onPressed: () {
                      if (selectedRow != null) {
                        //Formateamos los favoritos para meterlos en los valores seleccionados de la pantalla de conversion
                        appState.selectedDeValue = selectedRow.split('>')[0];
                        String valorA = selectedRow.split('>')[1];
                        appState.selectedAValue.clear();
                        appState.selectedAValue = valorA.split(", ");
                        appState.changeIndex(2);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              // ListView para mostrar las divisas
              children: [
                for (var str in appState.favorites)
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: selectedRow == str
                          ? Theme.of(context).primaryColorDark
                          : Color.fromARGB(255, 147, 209, 149),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          selectedRow = str;
                        });
                      },
                      title: Row(
                        children: [
                          Expanded(
                            //Formateamos las conversiones guardadas para poner De -> A
                            child: Row(
                              children: [
                                SizedBox(width: 12),
                                Text(
                                  str.split('>')[
                                      0], //Str es la conversion entera que pasamos
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                                SizedBox(width: 12),
                                // Icono de la flecha
                                Icon(Icons.arrow_forward,
                                    color: Colors.black, size: 24),
                                SizedBox(width: 12),
                                Flexible(
                                  child: Text(
                                    str.split('>')[1],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}