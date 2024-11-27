import time
import requests
import gi
gi.require_version("GdkPixbuf","2.0")
from gi.repository import GdkPixbuf

class CocktailModel:
    def __init__(self):
        self.__cocktails = []
        self.__cocktailsInfo = {}
    
    def fetch_cocktails(self, letter):
        time.sleep(0)
        #obtengo los cocteles por la primera letra
        url = f"https://www.thecocktaildb.com/api/json/v1/1/search.php?f={letter}"
        response = requests.get(url)
        data = response.json()
        self.__cocktails = data.get('drinks', [])
    
    def fetch_cocktails_by_name(self, name):
        time.sleep(3)
        #obtengo los cocteles por el nombre
        url = f"https://www.thecocktaildb.com/api/json/v1/1/search.php?s={name}"
        response = requests.get(url)
        data = response.json()
        self.__cocktails = data.get('drinks', [])
    
    def fetch_cocktail_information(self, cocktail_name):
        time.sleep(3)
        #obtengo los cocteles por el nombre
        url = f"https://www.thecocktaildb.com/api/json/v1/1/search.php?s={cocktail_name}"
        response = requests.get(url)
        data = response.json()
        coctel = data.get('drinks', [])
        self.__cocktails = data.get('drinks', [])
        self.__cocktailsInfo = coctel[0]
    

    #Obtiene las cantidades de cada ingrediente que tenga el cóctel
    def get_ingredients(self, cocktail_name):
        paragraph = "The ingredients are the following ones:\n"
        for i in range(1, 16):
            ingredient_key = f'strIngredient{i}'
            measure_key = f'strMeasure{i}'
            ingredient = cocktail_name.get(ingredient_key)
            measure = cocktail_name.get(measure_key)
            if ingredient:
                paragraph += f"- {ingredient}"
                if measure:
                    paragraph += f" ({measure})"
                paragraph += "\n"
            else:
                    break
        return paragraph
        

    def load_and_scale_image(self, url, width, height ):
        try:
            # Cargar la imagen desde la URL o ubicación remota
            image_loader = GdkPixbuf.PixbufLoader()
            image_loader.write(requests.get(url).content)
            image_loader.close()
            image = image_loader.get_pixbuf()
            # Escalar la imagen al ancho y alto deseados
            scaled_image = image.scale_simple(width, height, GdkPixbuf.InterpType.BILINEAR)
            return scaled_image
        except Exception as e:
            print(f"Error al cargar y escalar la imagen: {e}")
            return None


    def get_cocktails(self):
        return self.__cocktails
    
    def get_cocktailsInfo(self):
        return self.__cocktailsInfo