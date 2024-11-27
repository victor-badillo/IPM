# Diseño software

<!-- ## Notas para el desarrollo de este documento
En este fichero debeis documentar el diseño software de la práctica.

> :warning: El diseño en un elemento "vivo". No olvideis actualizarlo
> a medida que cambia durante la realización de la práctica.

> :warning: Recordad que el diseño debe separar _vista_ y
> _estado/modelo_.
	 

El lenguaje de modelado es UML y debeis usar Mermaid para incluir los
diagramas dentro de este documento. Por ejemplo:

```mermaid
classDiagram
    class Model {
	}
	class View {
	}
	View ..> Gtk : << uses >>
	class Gtk
	<<package>> Gtk
```
-->
## Diagrama estático: diagrama de clases  
```mermaid
classDiagram
    class MyAppState {
        - int selectedIndex 
        - String selectedDeValue 
        - List<String> selectedAValue 
        - TextEditingController cantidadController
        - List<String> opcionesDe
        - List<String> opcionesA
        - bool isResultScreenOpen 
        - List<String> favorites
        - String currentConversion
        - List<Map<String, dynamic>> data
        - String errorMessage

        + Future peticionAPI(String symbols, double cantidadControllerValue, BuildContext context)
        + void comeBack()
        + void toggleFavorite([String? str])
        + void removeFavorite(String str)
        + void changeIndex(int i)
        + bool _esNumeroRealPositivo(TextEditingController controller)
        + bool checkParametersConvert()
        + bool checkParametersLike()
    }

    class MyApp {
        - Key
        + class MyApp(key)
        + ChangeNotifierProvider build(BuildContext context)
    }

    class MyHomePage {
        +Scaffold build(BuildContext context)
    }

    class OptionsPage {
        +Scaffold build(BuildContext context)
    }

    class ConversorDivisasScreen {
        +Scaffold build(BuildContext context)
        -Scaffold buildVerticalLayout(BuildContext context)
        -Scaffold buildHorizontalLayout(BuildContext context)
        -IconData determineLikeIcon(MyAppState appState)
    }

    class ResultScreen{
        +Scaffold build(BuildContext context)
        -ListView buildPortraitLayout(BuildContext context)
        -ListView buildLandscapeLayout(BuildContext context)
    }

    class ListadoFavoritosScreen{
        -var selectedRow;
        -Scaffold build(BuildContext context)
    }

    MyApp <|-- MyHomePage
    MyApp <|-- OptionsPage
    MyApp <|-- ConversorDivisasScreen
    MyApp <|-- ResultScreen
    MyApp <|-- ListadoFavoritosScreen
    MyApp <--* MyAppState
```
## Diagramas dinámicos:  
### Diagrama de secuencia para caso de uso: Convertir moneda  
```mermaid
sequenceDiagram
    Usuario ->> OptionsPage: Selecciona 'Convertir Divisa'
    OptionsPage ->> MyAppState: Cambiar índice de pantalla
    MyAppState ->> MyHomePage: Notifylisteners()
    MyHomePage->> ConversorDivisasScreen: Cambia a la pantalla de conversión
    ConversorDivisasScreen ->> ConversorDivisasScreen: Seleccciona de que divisa a que divisas cambia
    ConversorDivisasScreen ->> ConversorDivisasScreen: Selecciona la cantidad a convertir
    ConversorDivisasScreen ->> MyAppState: Actualiza el estado de la app con los nuevos valores
    Usuario ->> ConversorDivisasScreen: Selecciona el botón de conversión
    ConversorDivisasScreen ->> MyAppState: Llamada a la conversión de la divisa
    alt se produjo un error
        MyAppState-->>ConversorDivisasScreen: mostrar error
    else
        MyAppState ->> MyAppState: Calculo de la conversión
        MyAppState ->> MyAppState: Cambiar índice de pantalla
        MyAppState ->> MyHomePage: Notifylisteners()
        MyHomePage ->> Result: Cambiar a la pantalla de resultados
    end
```
### Diagrama de secuencia para caso de uso: Guardar conversion como favorita  
```mermaid
sequenceDiagram
    Usuario ->> OptionsPage: Selecciona 'Convertir Divisa'
    OptionsPage ->> MyAppState: Cambiar índice de pantalla
    MyAppState ->> MyHomePage: Notifylisteners()
    MyHomePage->> ConversorDivisasScreen: Cambia a la pantalla de conversión
    ConversorDivisasScreen ->> ConversorDivisasScreen: Seleccciona de que divisa a que divisas cambia
    ConversorDivisasScreen ->> ConversorDivisasScreen: Selecciona la cantidad a convertir
    ConversorDivisasScreen ->> MyAppState: Actualiza el estado de la app con los nuevos valores
    Usuario ->> ConversorDivisasScreen: Selecciona el botón de favoritos
    alt se produjo un error
        MyAppState-->>ConversorDivisasScreen: mostrar error
    else no se produce un error
	ConversorDivisasScreen ->> MyAppState: guardar la conversion en favoritos
    end
```
### Diagrama de secuencia para caso de uso: Ver listado de Favoritos
```mermaid
sequenceDiagram
    Usuario ->> OptionsPage: Selecciona 'Listado Faboritos'
    OptionsPage ->> MyAppState: Cambiar índice de pantalla
    MyAppState ->> MyHomePage: Notifylisteners()
    MyHomePage->> ListadoFavoritosScreen: Cambia a la pantalla de favoritos
    ListadoFavoritosScreen->> ListadoFavoritosScreen: seleccionar conversion
    alt
        ListadoFavoritosScreen->> MyAppState: cargar conversion
        MyAppState->>MyHomePage:Notifylisteners()
        MyHomePage->>ConversorDivisasScreen:Cambia a la pantalla de conversion
    else
        ListadoFavoritosScreen->> MyAppState: eliminada conversion
        MyAppState->>ListadoFavoritosScreen:Notifylisteners()
    end
```
