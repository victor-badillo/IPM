from model import CocktailModel
from controller import CocktailController
from view import CocktailView

import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk

class app():
    def __init__(self):
        self.__model = CocktailModel()
        self.__view= CocktailView()
        self.__controller = CocktailController(self.__view,self.__model)
    def run(self):
        self.__controller.run()
        Gtk.main()

app = app()
app.run()