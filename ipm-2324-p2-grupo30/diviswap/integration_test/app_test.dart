import 'package:diviswap/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Convertir moneda', () {
    testWidgets('Conversion correcta', (tester) async {
      await tester.pumpWidget(const MyApp());

      //Pulso el boton de conversor de divisas de la barra de navegacion
      final Finder conversorButton = find.text('Conversor de divisas');
      expect(conversorButton, findsOneWidget); //Busco el boton
      await tester.tap(conversorButton); //Pulso
      await tester
          .pumpAndSettle(); //Espero a que acaben eventos asincronos(animaciones etc)

      //Reviso que el texto al comienzo sea De
      final Finder deOptionFinder = find.text('De');
      expect(deOptionFinder, findsOneWidget);

      //Busco el boton con la flecha y lo pulso
      final Finder desplegableDe = find.byKey(Key('desplegableDe'));
      expect(desplegableDe, findsOneWidget);
      await tester.tap(desplegableDe);
      await tester.pumpAndSettle();

      //Miro que haya la fila con el texto 'USD', por ejemplo
      Finder rowSelected = find.text('USD');
      expect(rowSelected, findsOneWidget);

      //Para ver si tienen los checks
      final Finder okey = find.byIcon(Icons.check);
      //Al principio ninguno tiene
      expect(okey, findsNothing);

      //Pulso una fila
      await tester.tap(rowSelected);
      await tester.pumpAndSettle();
      await tester.tap(desplegableDe);
      await tester.pumpAndSettle();

      //Ahora tiene check
      expect(okey, findsOneWidget);

      //Pruebo a cambiar el valor de De
      rowSelected = find.text('EUR');
      await tester.tap(rowSelected);
      await tester.pumpAndSettle();

      //Ahora mismo el valor de De es 'EUR'
      //Ahora busco y selecciono los valores para A
      final Finder desplegableA = find.byKey(Key('desplegableA'));
      expect(desplegableA, findsOneWidget);
      final Finder okeyA1 = find.byIcon(Icons.check);
      await tester.tap(desplegableA);
      await tester.pumpAndSettle();

      //No hay ningun valor seleccionado
      expect(okeyA1, findsNothing);

      //Selecciono valores para A (Primero uno y luego otro)
      final Finder rowA1 = find.text('USD');
      expect(rowA1, findsOneWidget);
      await tester.tap(rowA1);
      await tester.pumpAndSettle();

      //Vuelvo a abrir el desplegable
      await tester.tap(desplegableA);
      await tester.pumpAndSettle();

      //Ver que hay el check
      expect(okeyA1, findsOneWidget);

      //Fila con el valor 'DKK'
      final Finder rowA2 = find.text('DKK');
      expect(rowA2, findsOneWidget);
      await tester.tap(rowA2);
      await tester.pumpAndSettle();

      //Vuelvo a abrir para verificar que hay 2 checks
      await tester.tap(desplegableA);
      await tester.pumpAndSettle();
      expect(okeyA1, findsNWidgets(2));

      //Vuelvo a pulsar el desplegable de A e introduzco una tercera cantidad
      final Finder rowA3 = find.text('SEK');
      expect(rowA3, findsOneWidget);
      await tester.tap(rowA3);
      await tester.pumpAndSettle();

      //Busco y selecciono el boton de ingresar cantidad
      final ingresarCantidad =
          find.widgetWithText(TextFormField, 'Ingrese una cantidad');
      expect(ingresarCantidad, findsOneWidget);
      await tester.tap(ingresarCantidad);
      await tester.pumpAndSettle();

      //Introduzco la cantidad
      await tester.enterText(ingresarCantidad, '5');
      await tester.pumpAndSettle();
      //Pulso el boton de ok del teclado
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      final cantidadIngresada = find.widgetWithText(TextFormField, '5');
      expect(cantidadIngresada, findsOneWidget);

      //Buscar boton con el boton del icono del billete para realizar la conversion
      final Finder iconoConversion = find.byIcon(Icons.money);
      expect(iconoConversion, findsOneWidget);
      await tester.tap(iconoConversion);
      await tester.pumpAndSettle();

      //Resultados de conversion
      final Finder tituloResultados = find.text('Resultados de conversion');
      expect(tituloResultados, findsOneWidget);

      //Buscar el texto con las conversiones 'EUR/USD' y 'EUR/DKK' y 'EUR/SEK'
      final Finder conver1 = find.text('EUR/USD');
      expect(conver1, findsOneWidget);
      final Finder conver2 = find.text('EUR/DKK');
      expect(conver2, findsOneWidget);
      final Finder conver3 = find.text('EUR/SEK');
      expect(conver3, findsOneWidget);
    });

    testWidgets('Fallo de conversión', (tester) async {
      await tester.pumpWidget(const MyApp());

      //Pulso el boton de conversor de divisas de la barra de navegacion
      expect(
          find.byIcon(Icons.monetization_on), findsOneWidget); //Busco el boton
      final Finder conversorButton = find.byIcon(Icons.monetization_on);
      await tester.tap(conversorButton); //Pulso
      await tester
          .pumpAndSettle(); //Espero a que acaben eventos asincronos(animaciones etc)

      //ERROR 1
      //Buscar boton con el boton del icono del billete para realizar la conversion
      final Finder iconoConversion = find.byIcon(Icons.money);
      expect(iconoConversion, findsOneWidget);
      await tester.tap(iconoConversion);
      await tester.pumpAndSettle();

      //Ver que aparece el alertDialog
      expect(find.byType(AlertDialog), findsOneWidget);

      //Verificar que se muestra el informe de error con el mensaje 'Por favor introduzca una divisa para convertir'
      final Finder error1 =
          find.text('Por favor introduzca una divisa para convertir');
      expect(error1, findsOneWidget);

      // Encontrar el botón "OK" y simular el toque
      final okButton = find.widgetWithText(TextButton, 'OK');
      expect(okButton, findsOneWidget);
      await tester.tap(okButton);
      await tester.pumpAndSettle();

      // Verificar que el AlertDialog se ha cerrado
      expect(find.byType(AlertDialog), findsNothing);

      //ERROR 2
      //Reviso que el texto al comienzo sea De
      final Finder deOptionFinder = find.text('De');
      expect(deOptionFinder, findsOneWidget);

      //Busco el boton con la flecha y lo pulso
      final Finder desplegableDe = find.byKey(Key('desplegableDe'));
      expect(desplegableDe, findsOneWidget);
      await tester.tap(desplegableDe);
      await tester.pumpAndSettle();

      //Miro que haya la fila con el texto 'EUR', por ejemplo
      final Finder rowSelected = find.text('EUR');
      expect(rowSelected, findsOneWidget);

      //Para ver si tienen los checks
      final Finder okey = find.byIcon(Icons.check);
      //Al principio ninguno tiene
      expect(okey, findsNothing);

      //Pulso la fila de 'EUR'
      await tester.tap(rowSelected);
      await tester.pumpAndSettle();

      //Pulsar boton de conversion solo con la conversion desde la que convertir
      await tester.tap(iconoConversion);
      await tester.pumpAndSettle();

      //Ver que aparece el alertDialog
      expect(find.byType(AlertDialog), findsOneWidget);

      //Verificar que se muestra el informe de error con el mensaje 'Por favor introduzca una o más divisas a las que convertir la divisa actual'
      final Finder error2 = find.text(
          'Por favor introduzca una o más divisas a las que convertir la divisa actual');
      expect(error2, findsOneWidget);

      // Encontrar el botón "OK" y simular el toque
      await tester.tap(okButton);
      await tester.pumpAndSettle();

      // Verificar que el AlertDialog se ha cerrado
      expect(find.byType(AlertDialog), findsNothing);

      //ERROR 3
      //Introduzco el mismo valor para el desplegable de 'A' que el de 'De' y verifico que da error
      //Busco y selecciono el valor para A que va a ser 'EUR'
      final Finder desplegableA = find.byKey(Key('desplegableA'));
      expect(desplegableA, findsOneWidget);
      await tester.tap(desplegableA);
      await tester.pumpAndSettle();

      //No hay ningun check
      final Finder okeyA1 = find.byIcon(Icons.check);
      expect(okeyA1, findsNothing);

      //Busco la fila con el valor 'EUR' y la selecciono
      final Finder rowAequalsDe = find.text('EUR');
      expect(rowAequalsDe.at(1), findsOneWidget);
      await tester.tap(rowAequalsDe.at(1));
      await tester.pumpAndSettle();

      //Pulso el boton de conversion y verifico que sale el error con el mensaje de 'Por favor introduzca divisas diferentes para De y A'
      //Pulsar boton de conversion solo con la misma divisa que convertir y a la que convertir
      await tester.tap(iconoConversion);
      await tester.pumpAndSettle();

      //Ver que aparece el alertDialog
      expect(find.byType(AlertDialog), findsOneWidget);

      //Verificar que se muestra el informe de error con el mensaje 'Por favor introduzca divisas diferentes para De y A'
      final Finder error3 =
          find.text('Por favor introduzca divisas diferentes para De y A');
      expect(error3, findsOneWidget);

      // Encontrar el botón "OK" y simular el toque
      await tester.tap(okButton);
      await tester.pumpAndSettle();

      // Verificar que el AlertDialog se ha cerrado
      expect(find.byType(AlertDialog), findsNothing);

      //Cambiar conversion desde la que convertir
      await tester.tap(desplegableDe);
      await tester.pumpAndSettle();
      final Finder newRowDe = find.text('JPY');
      await tester.tap(newRowDe);
      await tester.pumpAndSettle();

      //ERROR 4
      //Ahora busco y selecciono los valores para A
      await tester.tap(desplegableA);
      await tester.pumpAndSettle();

      //Selecciono valores para A (Primero uno y luego otro)
      final Finder rowA1 = find.text('USD');
      expect(rowA1, findsOneWidget);
      await tester.tap(rowA1);
      await tester.pumpAndSettle();

      //Vuelvo a abrir el desplegable
      await tester.tap(desplegableA);
      await tester.pumpAndSettle();

      //Fila con el valor 'DKK'
      final Finder rowA2 = find.text('DKK');
      expect(rowA2, findsOneWidget);
      await tester.tap(rowA2);
      await tester.pumpAndSettle();

      //Pulsar el boton de conversion con las divisas pero sin haber ingresado una cantidad que convertir
      await tester.tap(iconoConversion);
      await tester.pumpAndSettle();

      //Ver que aparece el alertDialog
      expect(find.byType(AlertDialog), findsOneWidget);

      //Verificar que se muestra el informe de error con el mensaje 'Por favor introduzca una cantidad adecuada (números positivos, puede contener decimales)'
      final Finder error4 = find.text(
          'Por favor introduzca una cantidad adecuada (números positivos, puede contener decimales)');
      expect(error4, findsOneWidget);

      // Encontrar el botón "OK" y simular el toque
      await tester.tap(okButton);
      await tester.pumpAndSettle();

      // Verificar que el AlertDialog se ha cerrado
      expect(find.byType(AlertDialog), findsNothing);

      //TODOS LOS ERRORES REVISADOS
    });
  });

  group('test favoritos', () {
    testWidgets('Añadir conversion a favoritos', (tester) async {
      await tester.pumpWidget(const MyApp());

      //Pulso el boton de conversor de divisas de la barra de navegacion
      expect(
          find.byIcon(Icons.monetization_on), findsOneWidget); //Busco el boton
      final Finder conversorButton = find.byIcon(Icons.monetization_on);
      await tester.tap(conversorButton); //Pulso
      await tester
          .pumpAndSettle(); //Espero a que acaben eventos asincronos(animaciones etc)

      //Reviso que el texto al comienzo sea De
      final Finder deOptionFinder = find.text('De');
      expect(deOptionFinder, findsOneWidget);

      //Busco el boton con la flecha y lo pulso
      final Finder desplegableDe = find.byKey(Key('desplegableDe'));
      expect(desplegableDe, findsOneWidget);
      await tester.tap(desplegableDe);
      await tester.pumpAndSettle();

      //Miro que haya la fila con el texto 'USD', por ejemplo
      Finder rowSelected = find.text('EUR');
      await tester.tap(rowSelected);
      await tester.pumpAndSettle();

      //Ahora mismo el valor de De es 'EUR'
      //Ahora busco y selecciono los valores para A
      final Finder desplegableA = find.byKey(Key('desplegableA'));
      expect(desplegableA, findsOneWidget);
      final Finder okeyA1 = find.byIcon(Icons.check);
      await tester.tap(desplegableA);
      await tester.pumpAndSettle();

      //No hay ningun valor seleccionado
      expect(okeyA1, findsNothing);

      //Selecciono valores para A (Primero uno y luego otro)
      final Finder rowA1 = find.text('USD');
      expect(rowA1, findsOneWidget);
      await tester.tap(rowA1);
      await tester.pumpAndSettle();

      //Vuelvo a abrir el desplegable
      await tester.tap(desplegableA);
      await tester.pumpAndSettle();

      //Ver que hay el check
      expect(okeyA1, findsOneWidget);

      //Fila con el valor 'DKK'
      final Finder rowA2 = find.text('DKK');
      expect(rowA2, findsOneWidget);
      await tester.tap(rowA2);
      await tester.pumpAndSettle();

      //Busco y selecciono el boton de ingresar cantidad
      final ingresarCantidad =
          find.widgetWithText(TextFormField, 'Ingrese una cantidad');
      expect(ingresarCantidad, findsOneWidget);
      await tester.tap(ingresarCantidad);
      await tester.pumpAndSettle();

      //Introduzco la cantidad
      await tester.enterText(ingresarCantidad, '10');
      await tester.pumpAndSettle();

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      //FALTA VERIFICAR EL TEXTO NUEVO DE INGRESAR CANTIDAD
      final cantidadIngresada = find.widgetWithText(TextFormField, '10');
      expect(cantidadIngresada, findsOneWidget);

      //Buscar boton con el boton del icono del corazon para añadir a favoritos
      final Finder iconofavoritos = find.byIcon(Icons.favorite_border);
      expect(iconofavoritos, findsOneWidget);
      await tester.tap(iconofavoritos);
      await tester.pumpAndSettle();
      final Finder iconofavoritoschek = find.byIcon(Icons.favorite);
      expect(iconofavoritoschek, findsOneWidget);

      //compruebo que si cambio algun parametro, cambie el boton de favoritos
      await tester.tap(desplegableDe);
      await tester.pumpAndSettle();
      await tester.tap(rowSelected.first);
      await tester.pumpAndSettle();

      final Finder iconofavoritos2 = find.byIcon(Icons.favorite_border);
      expect(iconofavoritos2, findsOneWidget);

      //compruebo que si pongo una conversion que esta en favoritos, se ponga el v¡boton de favoritos
      await tester.tap(desplegableDe);
      await tester.pumpAndSettle();
      await tester.tap(rowSelected);
      await tester.pumpAndSettle();

      final Finder iconofavoritoschek2 = find.byIcon(Icons.favorite);
      expect(iconofavoritoschek2, findsOneWidget);
    });

    testWidgets('test errores de favoritos', (tester) async {
      await tester.pumpWidget(const MyApp());
      //Pulso el boton de conversor de divisas de la barra de navegacion
      expect(
          find.byIcon(Icons.monetization_on), findsOneWidget); //Busco el boton
      final Finder conversorButton = find.byIcon(Icons.monetization_on);
      await tester.tap(conversorButton); //Pulso
      await tester
          .pumpAndSettle(); //Espero a que acaben eventos asincronos(animaciones etc)

      //ERROR 1
      //Buscar boton con el boton del icono del corazon para añadir a favoritos
      final Finder iconofavoritos = find.byIcon(Icons.favorite_border);
      expect(iconofavoritos, findsOneWidget);
      await tester.tap(iconofavoritos);
      await tester.pumpAndSettle();

      //Ver que aparece el alertDialog
      expect(find.byType(AlertDialog), findsOneWidget);

      //Verificar que se muestra el informe de error con el mensaje correspondiente
      final Finder error1 = find.text(
          'Por favor introduzca una divisa desde la que convertir para guardar como favorita');
      expect(error1, findsOneWidget);

      // Encontrar el botón "OK" y simular el toque
      final okButton = find.widgetWithText(TextButton, 'OK');
      expect(okButton, findsOneWidget);
      await tester.tap(okButton);
      await tester.pumpAndSettle();

      // Verificar que el AlertDialog se ha cerrado
      expect(find.byType(AlertDialog), findsNothing);

      //ERROR 2
      //Reviso que el texto al comienzo sea De
      final Finder deOptionFinder = find.text('De');
      expect(deOptionFinder, findsOneWidget);

      //Busco el boton con la flecha y lo pulso
      final Finder desplegableDe = find.byKey(Key('desplegableDe'));
      expect(desplegableDe, findsOneWidget);
      await tester.tap(desplegableDe);
      await tester.pumpAndSettle();

      //Miro que haya la fila con el texto 'EUR', por ejemplo
      Finder rowSelected = find.text('EUR');
      expect(rowSelected.first, findsOneWidget);

      //Para ver si tienen los checks
      final Finder okey = find.byIcon(Icons.check);
      //Al principio ninguno tiene
      expect(okey, findsNothing);

      //Pulso la fila de 'EUR'
      await tester.tap(rowSelected);
      await tester.pumpAndSettle();

      //Pulsar boton de favoritos solo con la conversion desde la que convertir
      await tester.tap(iconofavoritos);
      await tester.pumpAndSettle();

      //Ver que aparece el alertDialog
      expect(find.byType(AlertDialog), findsOneWidget);

      //Verificar que se muestra el informe de error con el mensaje correspondiente
      final Finder error2 = find.text(
          'Por favor introduzca una divisa o más divisas a las que convertir para guardar como favorita');
      expect(error2, findsOneWidget);

      // Encontrar el botón "OK" y simular el toque
      await tester.tap(okButton);
      await tester.pumpAndSettle();

      // Verificar que el AlertDialog se ha cerrado
      expect(find.byType(AlertDialog), findsNothing);

      //Error de 'Por favor introduzca divisas diferentes para De y A'
      final Finder desplegableA = find.byKey(Key('desplegableA'));
      expect(desplegableA, findsOneWidget);
      await tester.tap(desplegableA);
      await tester.pumpAndSettle();

      final Finder rowEqual = find.text('EUR');
      expect(rowEqual.at(1), findsOneWidget);
      await tester.tap(rowEqual.at(1));
      await tester.pumpAndSettle();

      await tester.tap(iconofavoritos);
      await tester.pumpAndSettle();

      //Ver que aparece el alertDialog
      expect(find.byType(AlertDialog), findsOneWidget);

      //Verificar que se muestra el informe de error con el mensaje correspondiente
      final Finder error3 =
          find.text('Por favor introduzca divisas diferentes para De y A');
      expect(error3, findsOneWidget);

      // Encontrar el botón "OK" y simular el toque
      await tester.tap(okButton);
      await tester.pumpAndSettle();

      // Verificar que el AlertDialog se ha cerrado
      expect(find.byType(AlertDialog), findsNothing);
    });
  });

  group('test listado favoritos', () {
    testWidgets('Mirar el listado de favoritos y desde ahi borrar y convertir',
        (tester) async {
      await tester.pumpWidget(const MyApp());

      //Pulso el boton de conversor de divisas de la barra de navegacion
      expect(
          find.byIcon(Icons.monetization_on), findsOneWidget); //Busco el boton
      final Finder conversorButton = find.byIcon(Icons.monetization_on);
      await tester.tap(conversorButton); //Pulso
      await tester
          .pumpAndSettle(); //Espero a que acaben eventos asincronos(animaciones etc)

      //Busco el boton con la flecha y lo pulso
      final Finder desplegableDe = find.byKey(Key('desplegableDe'));
      expect(desplegableDe, findsOneWidget);
      await tester.tap(desplegableDe);
      await tester.pumpAndSettle();

      //Miro que haya la fila con el texto EUR
      Finder rowSelected = find.text('EUR');
      await tester.tap(rowSelected);
      await tester.pumpAndSettle();

      //Ahora busco y selecciono los valores para A
      final Finder desplegableA = find.byKey(Key('desplegableA'));
      expect(desplegableA, findsOneWidget);
      await tester.tap(desplegableA);
      await tester.pumpAndSettle();

      //Selecciono valores para A (Primero uno y luego otro)
      final Finder rowA1 = find.text('USD');
      expect(rowA1, findsOneWidget);
      await tester.tap(rowA1);
      await tester.pumpAndSettle();

      //Vuelvo a abrir el desplegable
      await tester.tap(desplegableA);
      await tester.pumpAndSettle();

      //Fila con el valor 'DKK'
      final Finder rowA2 = find.text('DKK');
      expect(rowA2, findsOneWidget);
      await tester.tap(rowA2);
      await tester.pumpAndSettle();

      //Buscar boton con el icono del corazon para añadir a favoritos
      final Finder iconofavoritos = find.byIcon(Icons.favorite_border);
      expect(iconofavoritos, findsOneWidget);
      await tester.tap(iconofavoritos);
      await tester.pumpAndSettle();
      final Finder iconofavoritoschek = find.byIcon(Icons.favorite);
      expect(iconofavoritoschek, findsOneWidget);

      //Pulso el boton de listado de conversiones favoritas de la barra de navegacion
      expect(
          find.byIcon(Icons.favorite_sharp), findsOneWidget); //Busco el boton
      final Finder listadoFavoritosButton = find.byIcon(Icons.favorite_sharp);
      await tester.tap(listadoFavoritosButton);
      await tester.pumpAndSettle();

      //Compruebo que me guarde la conversion en favoritos
      final Finder conversionFavoritaDe = find.text('EUR');
      expect(conversionFavoritaDe, findsOneWidget);
      final Finder conversionFavoritaA = find.text('USD, DKK');
      expect(conversionFavoritaA, findsOneWidget);

      //Pulso el boton de convertir de la barra de navegacion
      await tester.tap(conversorButton);
      await tester.pumpAndSettle();

      //Cambio de EUR A SEK en el De
      //Busco el boton con la flecha y lo pulso
      expect(desplegableDe, findsOneWidget);
      await tester.tap(desplegableDe);
      await tester.pumpAndSettle();

      //Selecciono la fila de SEK
      Finder rowSelected2 = find.text('SEK');
      await tester.tap(rowSelected2);
      await tester.pumpAndSettle();

      //Miro que el icono del corazon ahora esta vacio
      expect(iconofavoritos, findsOneWidget);

      //Guardo la conversion como favorita
      //Buscar boton con el icono del corazon para añadir a favoritos
      await tester.tap(iconofavoritos);
      await tester.pumpAndSettle();
      expect(iconofavoritoschek, findsOneWidget);

      //Cambio a la pantalla de listado de conversiones favoritas
      await tester.tap(listadoFavoritosButton);
      await tester.pumpAndSettle();

      //Miro que ahora haya dos conversiones guardadas
      final Finder conversionFavorita = find.byIcon(Icons.arrow_forward);
      expect(conversionFavorita, findsNWidgets(2));

      //Toco en la primera conversion
      final Finder conversionFavorita2 = find.text('SEK');
      await tester.tap(conversionFavorita2);
      await tester.pumpAndSettle();

      //Una vez seleccionada le doy a convertir
      final Finder convertirSeleccionada = find.byIcon(Icons.attach_money);
      expect(convertirSeleccionada, findsOneWidget);
      await tester.tap(convertirSeleccionada);
      await tester.pumpAndSettle();

      //Al cambiar a la pantalla de conversion veo que ha puesto la conversion que le mande
      expect(find.text('SEK'), findsOneWidget);
      expect(find.text('USD, DKK'), findsOneWidget);

      //Cambio a la pantalla de listado de conversiones favoritas
      await tester.tap(listadoFavoritosButton);
      await tester.pumpAndSettle();

      //Toco en la conversion que queda
      await tester.tap(conversionFavoritaA.first);
      await tester.pumpAndSettle();

      //Una vez seleccionada la borro
      final Finder borrarSeleccionada = find.byIcon(Icons.delete_outline);
      expect(borrarSeleccionada, findsOneWidget);
      await tester.tap(borrarSeleccionada);
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.arrow_forward),
          findsOneWidget); //Compruebo que solo queda una conversion
    });
  });
}
