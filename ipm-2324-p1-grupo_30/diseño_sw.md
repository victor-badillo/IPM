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
  class CocktailController {
    - view: CocktailView
    - model: CocktailModel
    - init(self, view, model)
    - show_Error(self, e)
    + on_treeview_row_activated(self, treeview, path, column)
    + on_botonLogoV_clicked(self, widget)
    + on_botonLogo_clicked(self, widget)
    + on_listaCocteles1_row_activated(self, treeviewE, path, column)
    + clean_treeviewE(self)
    + on_botonLogo1_clicked(self, widget)
    + on_botonListCock_clicked(self, widget)
    + on_barraBusqueda_search_changed(self, widget)
    + show_not_found_window(self)
    + update_treeviewE(self)
    + on_combo_box_changed(self, widget)
    + update_treeview(self)
    + update_textview(self, cocktailName)
    + on_botonNoEncontradoListado_clicked(self, widget)
    + on_botonLogoNoEncontrado_clicked(self, widget)
    + on_botonLogoNoError_clicked(self, widget)
    + show_error_window(self, error_message)
    + update_error_textview(self, error_message)
    + run(self)    
  }
  class CocktailView {
    + language_code: string
    + diccionario_traducciones: dict
    - builder: Gtk.Builder
    - builder2: Gtk.Builder
    - builder3: Gtk.Builder
    - builder4: Gtk.Builder
    - builder5: Gtk.Builder
    + window: Gtk.Window
    + windowInfo: Gtk.Window
    + windowSearch: Gtk.Window
    + windowNoEncontrado: Gtk.Window
    + windowError: Gtk.Window
    + botonLogoL: Gtk.Button
    + botonLogoE: Gtk.Button
    + buttonList: Gtk.Button
    + botonLogoV: Gtk.Button
    + botonNoEncontradoListado: Gtk.Button
    + botonLogoNoEncontrado: Gtk.Button
    + botonLogoError: Gtk.Button
    - cocktailImage: Gtk.Image
    - combobox: Gtk.ComboBox
    - treeview: Gtk.TreeView
    - treeviewE: Gtk.TreeView
    - labelIngredients: Gtk.Label
    - labelPreparation: Gtk.Label
    - labelNotFound: Gtk.Label
    - nameAndDescriptionText: Gtk.TextView
    - ingredientsText: Gtk.TextView
    - preparationText: Gtk.TextView
    - errorText: Gtk.TextView
    - nameAndDescriptionBuffer: Gtk.TextBuffer
    - ingredientsBuffer: Gtk.TextBuffer
    - preparationBuffer: Gtk.TextBuffer
    - errorBuffer: Gtk.TextBuffer
    + cargarInfoCoctel: Gtk.ProgressBar
    + cargarPantallaBusqueda: Gtk.ProgressBar
    + cargarPantallaListado: Gtk.ProgressBar
    + timeout_id: Glib.timeout
    + textBotonListCock: string
    + textCargarPantallaBusqueda: string
    + textCargarPantallaListado: string
    + textListaCocteles: string
    + textIngredientes: string
    + textPreparacion: string
    + textCargarPantallaInfo: string
    + textNoEncontradoLabel: string
    + textBotonNoEncontradoListado: string
    + textErrorServer: string
    + textError: string
    - init(self)
    - update_progress(self)
    + setup_treeview(self)
    + setup_treeviewE(self)
    + setup_textview(self)
    + update_treeview(self, cocktails)
    + update_treeviewE(self, cocktails)
    + update_info_cocktail_treeview(self, cocktail_info: dict, ingredients, image)
    + update_error(self, error_message: str)
    + register_handlers(self, handler)
    + register_handlers2(self, handler)
    + register_handlers3(self, handler)
    + register_handlers4(self, handler)
    + register_handlers5(self, handler)
    + run(self)
  }
  class CocktailModel {
    - cocktails: list
    - cocktailsInfo: dict
    + __init__(self)
    + fetch_cocktails(self, letter)
    + fetch_cocktails_by_name(self, name)
    + fetch_cocktail_information(self, cocktail_name)
    + get_ingredients(self, cocktail_name)
    + load_and_scale_image(self, url, width, height)
    + get_cocktails(self)
    + get_cocktailsInfo(self)
  }
  class app {
    - model: CocktailModel
    - view: CocktailView
    - controller: CocktailController
    + __init__()
    + run()
  }

app -- CocktailModel: model
app -- CocktailView: view
app -- CocktailController: controller
CocktailController -- CocktailView
CocktailController -- CocktailModel
```
## Diagramas dinámicos:
### Diagrama de secuencia para caso de uso: Buscar cócteles por nombre
```mermaid
sequenceDiagram
    participant View as CocktailView
    participant Controller as CocktailController
    participant Model as CocktailModel

    View->>Controller: on_barraBusqueda_search_changed(widget)
    Controller->>Model: fetch_cocktails_by_name(texto_busqueda)
    Model-->>Controller: cocktails

    alt No se encontraron cócteles
        Controller->>View: view.show_not_found_window()
    else Cócteles encontrados
        Controller->>View: view.update_treeviewE(cocktails)
    end

    Note over Controller, Model: Manejar errores
    alt Se produjo un error
        Model-->>Controller: error
        Controller->>View: view.show_error_message(error)
    else No hubo errores
        Controller->>View: view.hide_error_message()
    end

    View->>Controller: on_listaCocteles1_row_activated(treeviewE, path, column)
```
### Diagrama de secuencia para caso de uso: Listar cócteles por letra

```mermaid
sequenceDiagram
    participant View as CocktailView
    participant Controller as CocktailController
    participant Model as CocktailModel

    View->>Controller: register_handlers(handler)
    Controller->>View: view.register_handlers(self)
    View->>Controller: on_combo_box_changed(widget)
    Controller->>View: fetch_cocktails_by_letter(letter)
    Controller->>Model: fetch_cocktails(letter)
    Model-->>Controller: cocktails
    Controller->>View: view.update_treeview()

    Note over Controller, Model: Manejar errores
    alt Se produjo un error
        Model-->>Controller: error
        Controller->>View: view.show_error_message(error)
    else No hubo errores
        Controller->>View: view.hide_error_message()
    end

    View->>Controller: on_treeview_row_activated(treeview, path, column)
```
### Diagrama de secuencia para caso de uso: Mostrar información del cóctel

```mermaid
sequenceDiagram
    participant View as CocktailView
    participant Controller as CocktailController
    participant Model as CocktailModel

    View->>Controller: on_treeview_row_activated(treeview, path, column)
    Controller->>View: view.update_textview(cocktail_name)
    Controller->>Model: fetch_cocktail_information(cocktail_name)
    Model-->>Controller: cocktail_info
    
    Note over Controller, Model: Manejar errores
    alt Se produjo un error
        Model-->>Controller: error
        Controller->>View: view.show_error_message(error)
    else No hubo errores
        Controller->>View: view.hide_error_message()
    end

    Controller->>View: view.update_info_cocktail_treeview(cocktail_info, ingredients, image)

```