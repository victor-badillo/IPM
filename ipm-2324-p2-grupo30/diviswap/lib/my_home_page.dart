import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'conversor_divisas_screen.dart';
import 'listado_divisas_screen.dart';
import 'my_app_state.dart';
import 'options_page.dart';
import 'result_screen.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var appState = context.watch<MyAppState>();

    Widget page;
    switch (appState.selectedIndex) {
      case 0:
        page = ListadoFavoritosScreen();
        break;
      case 1:
        page = OptionsPage();
        break;
      case 2:
        page = ConversorDivisasScreen();
        break;
      case 3:
        page = ResultScreen();
        break;
      default:
        throw UnimplementedError(
            'no widget for ${appState.selectedIndex}'); //Para futuras implementaciones
    }

    var mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        //Animación al seleccionar index
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      body: Column(
        children: [
          Expanded(child: mainArea),
          SafeArea(
            child: BottomNavigationBar(
              backgroundColor: Color.fromARGB(255, 150, 226, 162),
              selectedItemColor: Color.fromARGB(255, 10, 41, 12),
              unselectedItemColor: const Color.fromARGB(255, 48, 114, 51),
              items: [
                BottomNavigationBarItem(
                  tooltip: 'icono_favoritos',
                  icon: Icon(Icons.favorite_sharp),
                  label: 'Favoritos',
                ),
                BottomNavigationBarItem(
                  tooltip: 'icono_home',
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  tooltip: 'icono_monetization',
                  icon: Icon(Icons.monetization_on),
                  label: 'Conversor',
                ),
                BottomNavigationBarItem(
                    tooltip: 'icono_resultados',
                    icon: Icon(Icons.summarize),
                    label: 'Resultados')
              ],
              currentIndex: appState.selectedIndex,
              onTap: (value) {
                if(value == 2){
                  appState.comeBack();
                }
                setState(() {
                  appState.selectedIndex = value;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
