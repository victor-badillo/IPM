import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'my_app_state.dart';


class OptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'DIVISWAP',
            style: TextStyle(fontSize: 75, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 80),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                key: Key('Conversor de divisas'),
                onPressed: () {
                  appState.changeIndex(2);
                },
                style: ElevatedButton.styleFrom(
                        minimumSize: Size(325, 100),
                        backgroundColor: Theme.of(context).primaryColor)
                    .merge(
                  ButtonStyle(
                    side: MaterialStateProperty.all(
                      BorderSide(
                          color: Theme.of(context).primaryColorDark, width: 3),
                    ),
                  ),
                ),
                child: Text(
                  'Conversor de divisas',
                  style: TextStyle(
                      fontSize: 27,
                      color: Theme.of(context).dialogBackgroundColor),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  appState.changeIndex(0);
                },
                style: ElevatedButton.styleFrom(
                        minimumSize: Size(325, 100),
                        backgroundColor: Theme.of(context).primaryColor)
                    .merge(
                  ButtonStyle(
                    side: MaterialStateProperty.all(
                      BorderSide(
                          color: Theme.of(context).primaryColorDark, width: 3),
                    ),
                  ),
                ),
                child: Text(
                  'Conversiones favoritas',
                  style: TextStyle(
                      fontSize: 27,
                      color: Theme.of(context).dialogBackgroundColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildLandscapeLayout(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'DIVISWAP',
            style: TextStyle(fontSize: 75, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(width: 40),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    appState.changeIndex(2);
                  },
                  style: ElevatedButton.styleFrom(
                          minimumSize: Size(325, 100),
                          backgroundColor: Theme.of(context).primaryColor)
                      .merge(
                    ButtonStyle(
                      side: MaterialStateProperty.all(
                        BorderSide(
                            color: Theme.of(context).primaryColorDark,
                            width: 3),
                      ),
                    ),
                  ),
                  child: Text(
                    'Conversor de divisas',
                    style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).dialogBackgroundColor,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 40),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    appState.changeIndex(1);
                  },
                  style: ElevatedButton.styleFrom(
                          minimumSize: Size(325, 100),
                          backgroundColor: Theme.of(context).primaryColor)
                      .merge(
                    ButtonStyle(
                      side: MaterialStateProperty.all(
                        BorderSide(
                            color: Theme.of(context).primaryColorDark,
                            width: 3),
                      ),
                    ),
                  ),
                  child: Text(
                    'Conversiones favoritas',
                    style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).dialogBackgroundColor,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 40),
            ],
          ),
        ],
      ),
    );
  }
}