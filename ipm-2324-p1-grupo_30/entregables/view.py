import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, GLib
import locale

class CocktailView():
    def __init__(self):

        # Detecta el idioma del sistema
        user_locale, _ = locale.getdefaultlocale()
        self.language_code = user_locale.split('_')[0]
        # Carga las traducciones en un diccionario
        self.diccionario_traducciones = {}
        if self.language_code == "es":
            with open("spanishText.txt", "r") as file:
                self.diccionario_traducciones = eval(file.read())
        elif self.language_code == "en":
            with open("englishText.txt", "r") as file:
                self.diccionario_traducciones = eval(file.read())

        #Builders
        self.__builder = Gtk.Builder()
        self.__builder2 = Gtk.Builder()
        self.__builder3 = Gtk.Builder()
        self.__builder4 = Gtk.Builder()
        self.__builder5 = Gtk.Builder()
        self.__builder.add_from_file("pantallaListado.glade")
        self.__builder2.add_from_file("infoCoctel.glade")
        self.__builder3.add_from_file("pantallaBusqueda.glade")
        self.__builder4.add_from_file("pantallaNoEncontrado.glade")
        self.__builder5.add_from_file("pantallaError.glade")

        #Ventanas
        self.window = self.__builder.get_object("ventanaListado")
        self.windowInfo = self.__builder2.get_object("ventanaDetalleCocktail")
        self.windowSearch = self.__builder3.get_object("ventanaBusqueda")
        self.windowNoEncontrado = self.__builder4.get_object("ventanaNoEncontrado")
        self.windowError = self.__builder5.get_object("ventanaError")

        self.window.connect("destroy", Gtk.main_quit)
        self.windowInfo.connect("destroy", Gtk.main_quit)       
        self.windowSearch.connect("destroy", Gtk.main_quit)
        self.windowNoEncontrado.connect("destroy", Gtk.main_quit)
        self.windowError.connect("destroy", Gtk.main_quit)
        #Botones
        self.botonLogoL = self.__builder.get_object("botonLogo")
        self.botonLogoE = self.__builder3.get_object("botonLogo1")
        self.buttonList = self.__builder3.get_object("botonListCock")
        self.botonLogoV = self.__builder2.get_object("botonLogoV")
        self.botonNoEncontradoListado = self.__builder4.get_object("botonVentanaListado")
        self.botonLogoNoEncontrado = self.__builder4.get_object("botonLogoNoEncontrado")
        self.botonLogoError = self.__builder5.get_object("botonLogoError")

        #Image
        self.__cocktailImage = self.__builder2.get_object("cocktailImage")
        #WidgetLetra
        self.combobox = self.__builder.get_object("comboBoxLetter")
        #Treeviews
        self.__treeview = self.__builder.get_object("listaCocteles")
        self.__treeviewE = self.__builder3.get_object("listaCocteles1")
        #Label
        self.__labelIngredients = self.__builder2.get_object("infoCoctelIngredientes")
        self.__labelPreparation = self.__builder2.get_object("infoCoctelModoPreparacion")
        self.__labelNotFound = self.__builder4.get_object("noEncontradoLabel")

        #Textviews y Buffers
        self.__nameAndDescriptionText = self.__builder2.get_object("nameAndDescriptionText")
        self.__ingredientsText = self.__builder2.get_object("ingredientsText")
        self.__preparationText= self.__builder2.get_object("preparationText")
        self.__errorText = self.__builder5.get_object("errorText")
        self.__nameAndDescriptionBuffer = Gtk.TextBuffer()
        self.__ingredientsBuffer = Gtk.TextBuffer()
        self.__preparationBuffer = Gtk.TextBuffer()
        self.__errorBuffer = Gtk.TextBuffer()
        # Configurar TreeView y TreeStore
        self.setup_treeview()
        self.setup_textview()
        self.setup_treeviewE()
        #Barras de progreso
        self.cargarInfoCoctel = self.__builder2.get_object("cargarInfoCoctel")
        self.cargarPantallaBusqueda = self.__builder3.get_object("cargarPantallaBusqueda")
        self.cargarPantallaListado = self.__builder.get_object("cargarPantallaListado")
        self.timeout_id = GLib.timeout_add(100, self.__update_progress__)
        #Activar barra de progreso
        self.__update_progress__()

        #I18n
        #Pantalla Busqueda:
        self.textBotonListCock = self.diccionario_traducciones.get("textBotonListCock", "")
        self.buttonList.set_label(self.textBotonListCock)
        self.textCargarPantallaBusqueda= self.diccionario_traducciones.get("textCargarPantallaBusqueda", "")
        self.cargarPantallaBusqueda.set_text(self.textCargarPantallaBusqueda)

        #Pantalla Listado
        self.textCargarPantallaListado = self.diccionario_traducciones.get("textCargarPantallaListado", "")
        self.cargarPantallaListado.set_text(self.textCargarPantallaListado)
        self.textListaCocteles = self.diccionario_traducciones.get("textListaCocteles", "")

        #Pantalla detalle Coctel
        self.textIngredientes = self.diccionario_traducciones.get("textIngredientes", "")
        self.__labelIngredients.set_text(self.textIngredientes)
        self.textPreparacion = self.diccionario_traducciones.get("textPreparacion", "")
        self.__labelPreparation.set_text(self.textPreparacion)
        self.textCargarPantallaInfo = self.diccionario_traducciones.get("textCargarPantallaInfo", "")
        self.cargarInfoCoctel.set_text(self.textCargarPantallaInfo)

        #Pantalla no encontrado
        self.textNoEncontradoLabel = self.diccionario_traducciones.get("textNoEncontradoLabel", "")
        self.__labelNotFound.set_text(self.textNoEncontradoLabel)
        self.textBotonNoEncontradoListado = self.diccionario_traducciones.get("textBotonNoEncontradoListado", "")
        self.botonNoEncontradoListado.set_label(self.textBotonNoEncontradoListado)

        #Pantalla error
        self.textErrorServer = self.diccionario_traducciones.get("textErrorServer", "")
        self.textError = self.diccionario_traducciones.get("textError", "")


        
    def __update_progress__(self):
            self.cargarInfoCoctel.pulse()  # Usar el modo de pulso
            self.cargarPantallaListado.pulse()
            self.cargarPantallaBusqueda.pulse()
            return True
    
    def setup_treeview(self):
        self.__tree_store = Gtk.ListStore(str) # Crear un TreeStore con las columnas necesarias
        self.__treeview.set_model(self.__tree_store) # Asociar el TreeStore al TreeView
        # Crear y agregar columnas al TreeView
        renderer = Gtk.CellRendererText()
        column = Gtk.TreeViewColumn(self.diccionario_traducciones.get("textListaCocteles", ""), renderer, text=0)
        self.__treeview.append_column(column)

    def setup_treeviewE(self):
        self.__tree_storeE = Gtk.ListStore(str)
        self.__treeviewE.set_model(self.__tree_storeE)
        renderer = Gtk.CellRendererText()
        column = Gtk.TreeViewColumn(self.diccionario_traducciones.get("textListaCocteles", ""), renderer, text=0)
        self.__treeviewE.append_column(column)
    
    #Asignar los buffers a los textviews
    def setup_textview(self):
        self.__nameAndDescriptionText.set_buffer(self.__nameAndDescriptionBuffer)
        self.__ingredientsText.set_buffer(self.__ingredientsBuffer)
        self.__preparationText.set_buffer(self.__preparationBuffer)
        self.__errorText.set_buffer(self.__errorBuffer)

    def update_treeview(self, cocktails):
        self.__tree_store.clear() # Limpiar los datos existentes
        for cocktail in cocktails:
            self.__tree_store.append([cocktail["strDrink"]])

    def update_treeviewE(self, cocktails):
        self.__tree_storeE.clear()
        for cocktail in cocktails:
            self.__tree_storeE.append([cocktail["strDrink"]])

    #Vaciar buffers, obtener datos 
    def update_info_cocktail_treeview(self, cocktail_info : dict, ingredients, image):
        self.__nameAndDescriptionBuffer.set_text("")
        self.__ingredientsBuffer.set_text("")
        self.__preparationBuffer.set_text("")
        self.__cocktailImage.clear()
        
        #Nombre del coctel y descripcion
        name = cocktail_info.get("strDrink", "No name for this cocktail")
        tags = cocktail_info.get("strTags", "No tags")
        category = cocktail_info.get("strCategory", "No category assigned for this cocktail")
        iba = cocktail_info.get("strIBA", "No IBA")
        alcoholic = cocktail_info.get("strAlcoholic", "Non alcoholic")
        glass = cocktail_info.get("strGlass", " ")
        if tags is None: tags = "No tags"
        if iba is None : iba = "No IBA"
        if name is None : name = "No name for this cocktail"
        if category is None : category = "No category assigned for this cocktail"
        if alcoholic is None : alcoholic = "Not indicated if alcoholic or not"
        if glass is None: glass = "Not indicated glass"

        nameAndDescription = name + ", " + tags + ", " + category + ", " + iba + ", " + alcoholic + ", " + glass + "."

        self.__nameAndDescriptionBuffer.set_text(nameAndDescription)

        #Lista de ingredientes con sus medidas
        self.__ingredientsBuffer.set_text(ingredients)
        #Preparacion del cóctel nuevo
        preparation = cocktail_info.get("strInstructions", "Non available instructions for this cocktail")
        self.__preparationBuffer.set_text(preparation)
        #Asignar imagen si tiene
        if image:
            self.__cocktailImage.set_from_pixbuf(image)

    def update_error(self, error_message : str):
        self.__errorBuffer.set_text(error_message)

    #Conectar los widgets a sus señales
    def register_handlers(self,handler): 
        self.__builder.connect_signals(handler)

    def register_handlers2(self,handler):
        self.__builder2.connect_signals(handler)

    def register_handlers3(self,handler):
        self.__builder3.connect_signals(handler)

    def register_handlers4(self,handler):
        self.__builder4.connect_signals(handler)

    def register_handlers5(self,handler):
        self.__builder5.connect_signals(handler)

    def run(self):
        self.windowSearch.show_all()