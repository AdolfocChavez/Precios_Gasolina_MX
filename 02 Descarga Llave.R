#Abrimos las librerias que vamos a usar
library(xml2)
library(tidyverse)

#Establecemos nuestro directorio 
setwd("C:/Users/adolf/OneDrive/Documents/Estadisticas Gasolina")

#establecemos el archivo xml para los datos originales 
archivo <- paste0("datos_lugares/gasolineras_", Sys.Date(), ".xml")

#Guardamos la direccion de donde vamos a bajar los archivos 
url <- "https://publicacionexterna.azurewebsites.net/publicaciones/places"

#Bajamos la base de datos que necesitamos 
download.file(url,archivo, mode ="wb")
xml_data <- read_xml(archivo)

#Extraemos los nodos 
places <- xml_find_all(xml_data, "//place")

#Armamos la base de datos 
base_places <- tibble(
  place_id = xml_attr(places, "place_id"),
  name = xml_text(xml_find_first(places, "./name")),
  cre_id = xml_text(xml_find_first(places, "./cre_id")),
  x = xml_text(xml_find_first(places, "./location/x")),
  y = xml_text(xml_find_first(places, "./location/y"))
)

#exportamos la llave 
write.csv(base_places, paste0("datos_lugares/gasolineras_", Sys.Date(), ".csv"), row.names = FALSE)
