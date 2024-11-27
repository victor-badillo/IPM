import threading
import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk

class CocktailController():

    def __init__(self, view, model):
        self.__view = view
        self.__model = model
        self.__view.register_handlers(self)
        self.__view.register_handlers2(self)
        self.__view.register_handlers3(self)
        self.__view.register_handlers4(self)
        self.__view.register_handlers5(self)

    def __show_Error__(self, e):
        ad=e.split('connection')
        if len(ad)>1:
            self.show_error_window(self.__view.textErrorServer)
        else:
            self.show_error_window(self.__view.textError)


    def on_treeview_row_activated(self, treeview, path, column):
        try:
            model = treeview.get_model()
            iter = model.get_iter(path) # Obtener la iteración seleccionada
            cocktail_name = model.get_value(iter, 0)  # 0 es la primera columna
            # Llamar a la función que muestre la info del cóctel
            self.__view.window.hide()
            self.__view.cargarInfoCoctel.show()
            self.update_textview(cocktail_name)
            self.__view.windowInfo.show_all()
        except Exception as e:
            self.__show_Error__(str(e))
           


    def on_botonLogoV_clicked(self, widget):
        self.__view.windowInfo.hide()
        self.__view.windowSearch.show_all()

    def on_botonLogo_clicked(self, widget):
        self.__view.window.hide()
        self.__view.windowSearch.show_all()
    
    
    def on_listaCocteles1_row_activated(self, treeviewE, path, column):
        #guardo el nombre del coctel y obtengo la iteracion seleccionada
        try:
            model = treeviewE.get_model()
            iter = model.get_iter(path)
            cocktail_name = model.get_value(iter, 0)
            #muestro info del coctel
            self.__view.windowSearch.hide()
            self.clean_treeviewE()
            self.__view.cargarInfoCoctel.show()
            self.update_textview(cocktail_name)
            self.__view.windowInfo.show_all()
        except Exception as e:
            self.__show_Error__(str(e))


    def clean_treeviewE(self):
        emptyList = []
        self.__view.update_treeviewE(emptyList)

    def on_botonLogo1_clicked(self, widget):
        self.clean_treeviewE()

    def on_botonListCock_clicked(self, widget):
        self.__view.windowSearch.hide()
        self.clean_treeviewE()
        self.__view.window.show_all()
    

    def on_barraBusqueda_search_changed(self, widget):
        def th():
            texto_busqueda = widget.get_text()
            try:
                self.__view.cargarPantallaBusqueda.show()
                self.__model.fetch_cocktails_by_name(texto_busqueda)
                cocktails = self.__model.get_cocktails()

                if not cocktails:
                    self.show_not_found_window()
                else:
                    self.update_treeviewE()
            except Exception as e:
                self.__show_Error__(str(e))
            finally:
               self.__view.cargarPantallaBusqueda.hide()

        thread = threading.Thread(target=th)
        thread.start()
        

    def show_not_found_window(self):
        self.__view.windowSearch.hide()
        self.__view.windowNoEncontrado.show_all()

        
    def update_treeviewE(self):
        cocktails = self.__model.get_cocktails()
        self.__view.update_treeviewE(cocktails)

    def on_combo_box_changed(self, widget): #Funcion que coge los cocteles con la letra del combobox
        def th():
            try:
                self.__view.cargarPantallaListado.show()
                letter = widget.get_active_text()
                if letter:
                    self.__model.fetch_cocktails(letter)
                    cocktails = self.__model.get_cocktails()
                    if not cocktails:
                        self.__view.window.hide()
                        self.show_not_found_window()
                    else:
                        self.update_treeview()
            except Exception as e:
                self.__show_Error__(str(e))
            finally:
                self.__view.cargarPantallaListado.hide()
        thread = threading.Thread(target=th)
        thread.start()

    def update_treeview(self):
        cocktails = self.__model.get_cocktails()
        self.__view.update_treeview(cocktails)


    def update_textview(self,cocktailName):
        def th():
            self.__model.fetch_cocktail_information(cocktailName)
            #obtengo la info y los ingredientes del coctel y actualizo
            cocktailInfo = self.__model.get_cocktailsInfo()
            ingredients = self.__model.get_ingredients(cocktailInfo)
            image = self.__model.load_and_scale_image(cocktailInfo.get("strDrinkThumb",""),250,250 )
            self.__view.update_info_cocktail_treeview(cocktailInfo, ingredients, image)
            self.__view.cargarInfoCoctel.hide()
        thread = threading.Thread(target=th)
        thread.start()

    def on_botonNoEncontradoListado_clicked(self, widget):
        self.__view.windowNoEncontrado.hide()
        self.__view.window.show_all()

    def on_botonLogoNoEncontrado_clicked(self, widget):
        self.__view.windowNoEncontrado.hide()
        self.clean_treeviewE()
        self.__view.windowSearch.show_all()

    def on_botonLogoError_clicked(self, widget):
        self.__view.windowError.hide()
        self.clean_treeviewE()
        self.__view.windowSearch.show_all()
    
    def show_error_window(self, error_message):
        if self.__view.window.is_visible():           
            self.__view.window.hide()
        if self.__view.windowSearch.is_visible():
            self.__view.windowSearch.hide()
        self.__view.windowError.show_all()
        self.update_error_textview(error_message)

    def update_error_textview(self, error_message:str):
        self.__view.update_error(error_message)


    def run(self):
        self.__view.run()  