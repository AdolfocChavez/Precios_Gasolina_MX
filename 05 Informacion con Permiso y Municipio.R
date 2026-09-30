#abrimos las libreria 
library(tidyverse)

#Determino la ruta en donde estan mis archivos con las descargas de precios en csv
ruta <- "C:/Users/adolf/OneDrive/Documents/Estadisticas Gasolina/csv"

#Hago la lista con los archivos que hay en la carpeta 
archivos <- list.files(path = ruta,
                       pattern = "^Precios Gasolinas \\d{4}-\\d{2}-\\d{2}\\.csv$",
                       full.names = TRUE)

#establezco las fechas de inicio y fin de mi busqueda 
#fecha_inicio <- as.Date("2026-09-14") #fecha es un ejemplo
#fecha_fin <- as.Date("2026-09-17") #la fecha es un ejemplo 

#extraigo las fechas de los nombres
#fechas <- as.Date(
#  str_extract(
#    basename(archivos),
#    "\\d{4}-\\d{2}-\\d{2}"
#  )
#)

#me quedo solamente con los archivos dentro del rango de las fechas delimitadas 
#archivos <- archivos[
#  fechas >= fecha_inicio & fechas <= fecha_fin
#]

#mapeamos los archivos de la lista y los apilamos por filas ya que todos tienen las mismas variables 
datos <- archivos |> 
  map_dfr(read_csv)

#importamos la llave con la informacion geografica de las estaciones 
llave <- read.csv("C:/Users/adolf/OneDrive/Documents/Estadisticas Gasolina/datos_lugares/gasolineras_municipios.csv")

#incorporamos a los resultados la informacion geografica 
datos <- datos |> 
  left_join(llave, by = c("Estacion" = "place_id"))

#filtramos las estaciones que reportaron precios, pero no tenemos informacion geografica 
precios_ubicacion_NA <- datos |> 
  filter(is.na(CVE_ENT))
#tenemos las listas de las estaciones de las que no hay informacion geografica, ahi podemos ver si estan las faltantes 

#nos quedamos con las que si tenemos información completa 
datos <- datos |> 
  filter(!is.na(CVE_ENT))

#DE AQUI EN ADELANTE YA ES CUESTION DEL ANALISTA COMO VA A LLEVAR A CABO SU ANALISIS. 