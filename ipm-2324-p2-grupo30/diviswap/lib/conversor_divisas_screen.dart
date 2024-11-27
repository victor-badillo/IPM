import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'my_app_state.dart';

class ConversorDivisasScreen extends StatefulWidget {
  @override
  _ConversorDivisasScreenState createState() => _ConversorDivisasScreenState();
}

class _ConversorDivisasScreenState extends State<ConversorDivisasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          //Seleccionar pantalla vertical u horizontal
          return (orientation == Orientation.portrait)
              ? buildVerticalLayout(context) //Vertical
              : buildHorizontalLayout(context); //Horizontal
        },
      ),
    );
  }

  Widget buildVerticalLayout(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      body: SingleChildScrollView(

      
      
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 60),
            Row(
              children: [
                Container(
                  width: 50,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    border: Border.all(
                        width: 3, color: Theme.of(context).primaryColorDark),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: PopupMenuButton<String>(
                      key: Key('desplegableDe'),
                      onSelected: (String value) {
                        setState(() {
                          if (appState.selectedDeValue == value) {
                            appState.selectedDeValue =
                                'De'; //Inicialmente la barra pone De
                          } else {
                            appState.selectedDeValue = value;
                          }
                        });
                      },
                      itemBuilder: (BuildContext context) {
                        return appState.opcionesDe.map((String option) {
                          return PopupMenuItem<String>(
                            value: option,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  option,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                                if (appState.selectedDeValue ==
                                    option) //Al marcar la opcion ponemos el check
                                  Icon(Icons.check,
                                      color:
                                          Theme.of(context).primaryColorDark),
                              ],
                            ),
                          );
                        }).toList();
                      },
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Icon(Icons.arrow_forward_ios,
                            color: Theme.of(context).dialogBackgroundColor),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      border: Border.all(
                          width: 3, color: Theme.of(context).primaryColorDark),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      appState.selectedDeValue,
                      style: TextStyle(
                          color: Theme.of(context).dialogBackgroundColor),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Container(
                  width: 50,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    border: Border.all(
                        width: 3, color: Theme.of(context).primaryColorDark),
                    // Borde negro
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: PopupMenuButton<String>(
                      key: Key('desplegableA'),
                      onSelected: (String value) {
                        setState(() {
                          if (appState.selectedAValue.contains(value)) {
                            appState.selectedAValue.remove(value);
                          } else {
                            appState.selectedAValue.add(value);
                          }
                        });
                      },
                      itemBuilder: (BuildContext context) {
                        return appState.opcionesA.map((String option) {
                          return PopupMenuItem<String>(
                            value: option,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  option,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                                if (appState.selectedAValue.contains(option))
                                  Icon(Icons.check,
                                      color:
                                          Theme.of(context).primaryColorDark),
                              ],
                            ),
                          );
                        }).toList();
                      },
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Icon(Icons.arrow_forward_ios,
                            color: Theme.of(context).dialogBackgroundColor),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      border: Border.all(
                          width: 3, color: Theme.of(context).primaryColorDark),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      appState.selectedAValue.isNotEmpty
                          ? appState.selectedAValue.join(", ")
                          : 'A', //Si no hay nada seleccionado pone A
                      style: TextStyle(
                          color: Theme.of(context).dialogBackgroundColor),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                border: Border.all(
                    width: 3, color: Theme.of(context).primaryColorDark),
                // Borde negro
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: appState.cantidadController,
                readOnly: false,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Ingrese una cantidad',
                  hintStyle:
                      TextStyle(color: Theme.of(context).dialogBackgroundColor),
                ),
                style:
                    TextStyle(color: Theme.of(context).dialogBackgroundColor),
              ),
            ),
            SizedBox(height: 120),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  key: Key('botonConversion'),
                  onPressed: () async {
                    if (appState.checkParametersConvert()) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            //Pantalla de carga mientras los resultados no cargan
                            title: Text('Cargando...'),
                            content: FractionallySizedBox(
                              widthFactor: 0.25,
                              heightFactor: 0.1,
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      );
                      String symbols = appState.selectedDeValue +
                          "/" +
                          appState.selectedAValue
                              .join(",${appState.selectedDeValue}/");
                      await appState.peticionAPI(
                          symbols,
                          double.parse(appState.cantidadController.text),
                          context);
                      Navigator.pop(context);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            //Ventana de error
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            backgroundColor: Colors.orange,
                            title: Text(
                              'ERROR',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    20.0, // Puedes ajustar el tamaño según tu preferencia
                              ),
                            ),
                            content: Text(appState.errorMessage),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); //Cerrar el error
                                },
                                child: Text(
                                  'OK',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        15.0, // Puedes ajustar el tamaño según tu preferencia
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(150, 100),
                    backgroundColor: const Color.fromARGB(255, 29, 70, 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.money,
                          size: 70,
                          color: Theme.of(context).dialogBackgroundColor),
                      SizedBox(height: 4),
                      Text('Convert',
                          style: TextStyle(
                              color: Theme.of(context).dialogBackgroundColor)),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    if (appState.checkParametersLike()) {
                      String likedElement =
                          '${appState.selectedDeValue}>${appState.selectedAValue.join(', ')}'; //Guardamos la conversión como favoritos
                      appState.toggleFavorite(likedElement);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            //Ventana de error
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            backgroundColor: Colors.orange,
                            title: Text(
                              'ERROR',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            content: Text(appState.errorMessage),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); //Cerrar el error
                                },
                                child: Text(
                                  'OK',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(150, 100),
                    backgroundColor: Colors.pink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            determineLikeIcon(
                                appState), //Comprueba si ya ha sido guardada la conversión como fav
                            size: 70,
                            color: Theme.of(context).dialogBackgroundColor,
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Like',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).dialogBackgroundColor)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget buildHorizontalLayout(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(height: 40),
            Row(
              children: [
                Container(
                  width: 50,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    border: Border.all(
                        width: 3, color: Theme.of(context).primaryColorDark),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: PopupMenuButton<String>(
                      onSelected: (String value) {
                        setState(() {
                          if (appState.selectedDeValue == value) {
                            appState.selectedDeValue =
                                'De'; //Cuando no hay nada seleccionado se pone De
                          } else {
                            appState.selectedDeValue = value;
                          }
                        });
                      },
                      itemBuilder: (BuildContext context) {
                        return appState.opcionesDe.map((String option) {
                          return PopupMenuItem<String>(
                            value: option,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  option,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                                if (appState.selectedDeValue ==
                                    option) //Al marcar la opcion ponemos el check
                                  Icon(Icons.check,
                                      color:
                                          Theme.of(context).primaryColorDark),
                              ],
                            ),
                          );
                        }).toList();
                      },
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Icon(Icons.arrow_forward_ios,
                            color: Theme.of(context).dialogBackgroundColor),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      border: Border.all(
                          width: 3, color: Theme.of(context).primaryColorDark),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      appState.selectedDeValue,
                      style: TextStyle(
                          color: Theme.of(context).dialogBackgroundColor),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  width: 50,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    border: Border.all(
                        width: 3, color: Theme.of(context).primaryColorDark),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: PopupMenuButton<String>(
                      onSelected: (String value) {
                        setState(() {
                          if (appState.selectedAValue.contains(value)) {
                            appState.selectedAValue.remove(value);
                          } else {
                            appState.selectedAValue.add(value);
                          }
                        });
                      },
                      itemBuilder: (BuildContext context) {
                        return appState.opcionesA.map((String option) {
                          return PopupMenuItem<String>(
                            value: option,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  option,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                                if (appState.selectedAValue.contains(option))
                                  Icon(Icons.check,
                                      color:
                                          Theme.of(context).primaryColorDark),
                              ],
                            ),
                          );
                        }).toList();
                      },
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Icon(Icons.arrow_forward_ios,
                            color: Theme.of(context).dialogBackgroundColor),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      border: Border.all(
                          width: 3, color: Theme.of(context).primaryColorDark),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      appState.selectedAValue.isNotEmpty
                          ? appState.selectedAValue.join(", ")
                          : 'A', //Cuando no hay opciones marcadas se pone un A
                      style: TextStyle(
                          color: Theme.of(context).dialogBackgroundColor),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: 350,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      border: Border.all(
                          width: 3, color: Theme.of(context).primaryColorDark),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: TextFormField(
                        controller: appState.cantidadController,
                        readOnly: false,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Ingrese una cantidad',
                          hintStyle: TextStyle(
                              color: Theme.of(context).dialogBackgroundColor),
                        ),
                        style: TextStyle(
                            color: Theme.of(context).dialogBackgroundColor),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 45),
                Container(
                  width: 150,
                  height: 70,
                  color: Theme.of(context).dialogBackgroundColor,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (appState.checkParametersConvert()) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              //Aparece la pantalla de carga mientras no hay resultado de conversion
                              title: Text('Cargando...'),
                              content: FractionallySizedBox(
                                widthFactor: 0.25,
                                heightFactor: 0.1,
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                        );
                        String symbols = appState.selectedDeValue +
                            "/" +
                            appState.selectedAValue
                                .join(",${appState.selectedDeValue}/");
                        await appState.peticionAPI(
                            symbols,
                            double.parse(appState.cantidadController.text),
                            context);
                        Navigator.pop(context);
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              //Se muestra el error
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              backgroundColor: Colors.orange,
                              title: Text(
                                'ERROR',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                              content: Text(appState.errorMessage),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); //Cerrar el error
                                  },
                                  child: Text(
                                    'OK',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(150, 100),
                      backgroundColor: const Color.fromARGB(255, 29, 70, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Icon(
                      Icons.money,
                      size: 40,
                      color: Theme.of(context).dialogBackgroundColor,
                    ),
                  ),
                ),
                SizedBox(width: 40),
                Container(
                  width: 150,
                  height: 70,
                  color: Theme.of(context).dialogBackgroundColor,
                  child: ElevatedButton(
                    onPressed: () {
                      if (appState.checkParametersLike()) {
                        String likedElement =
                            '${appState.selectedDeValue}>${appState.selectedAValue.join(', ')}'; //Guardamos la conversión como favorita en el formato que nos interesa
                        appState.toggleFavorite(likedElement);
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              //Se muestra el error
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              backgroundColor: Colors.orange,
                              title: Text(
                                'ERROR',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      20.0, // Puedes ajustar el tamaño según tu preferencia
                                ),
                              ),
                              content: Text(appState.errorMessage),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Cerrar el error
                                  },
                                  child: Text(
                                    'OK',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          15.0, // Puedes ajustar el tamaño según tu preferencia
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(150, 100),
                      backgroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Icon(
                      determineLikeIcon(
                          appState), //Comprueba si ya ha sido guardada la conversión como fav
                      size: 40,
                      color: Theme.of(context).dialogBackgroundColor,
                    ),
                  ),
                ),
                SizedBox(width: 15),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData determineLikeIcon(MyAppState appState) {
    //Función para comprobar si ya se ha guardado el elemento como favorito y el corazón tiene que salir rellenado
    if (appState.favorites.contains(
        '${appState.selectedDeValue}>${appState.selectedAValue.join(', ')}')) {
      return Icons.favorite;
    } else {
      return Icons.favorite_border;
    }
  }
}
