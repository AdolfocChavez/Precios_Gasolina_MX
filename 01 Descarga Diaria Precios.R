#Abrimos las librerias que vamos a usar
library(xml2)
library(tidyverse)

#Establecemos nuestro directorio 
setwd("C:/Users/adolf/OneDrive/Documents/Estadisticas Gasolina")

#establecemos el archivo xml para los datos originales 
archivo <- paste0("xml/precios_", Sys.Date(), ".xml")

#Guardamos la direccion de donde vamos a bajar los archivos 
url <- "https://publicacionexterna.azurewebsites.net/publicaciones/prices"

#Bajamos la base de datos que necesitamos 
download.file(url,archivo, mode ="wb")
xml_data <- read_xml(archivo)

#Hay que ver la estructura de los nodos 
#xml_structure(xml_data)

#Hay que obtener los nodos de estación 
estaciones <- xml_find_all(xml_data, ".//place")

#hacemos la tabla con la informacion 
tabla_gasolineras <- map_dfr(estaciones, function(est) {
  place_id  <- xml_attr(est, "place_id")
  productos <- xml_find_all(est, ".//gas_price")
  
  precios <- setNames(
    as.numeric(xml_text(productos)),
    xml_attr(productos, "type")
  )
  
  tibble(
    Estacion = place_id,
    Magna  = unname(precios["regular"]),
    Premium  = unname(precios["premium"]),
    Diesel   = unname(precios["diesel"])
  )
})

#Obtenemos la lista de estaciones repetidas en la tabla
estaciones_repetidas <- tabla_gasolineras |>
  count(Estacion, sort = TRUE) |>
  filter(n > 1)

#Vemos cuantas veces aparecen, cuantas veces aparece el registro de algun combustible y cuantos de esos registros son distintos. 
revision_repetidas <- tabla_gasolineras |>
  semi_join(estaciones_repetidas, by = "Estacion") |>
  group_by(Estacion) |>
  summarise(
    registros = n(),
    diesel_registros = sum(!is.na(Diesel)),
    premium_registros = sum(!is.na(Premium)),
    magna_registros = sum(!is.na(Magna)),
    diesel_valores = n_distinct(Diesel, na.rm = TRUE),
    premium_valores = n_distinct(Premium, na.rm = TRUE),
    magna_valores = n_distinct(Magna, na.rm = TRUE),
    .groups = "drop"
  )

#Hacemos la lista con las estaciones con valores distintos de diesel, magna o premium
precios_distintos <- revision_repetidas |>
  filter(diesel_valores > 1 | 
         premium_valores > 1 |
         magna_valores > 1)

#conservamos en una tabla aparte los valores originales de estas que aparecen con precios distintos 
tabla_gasolineras_precios_distintos <- tabla_gasolineras |>
  semi_join(precios_distintos, by = "Estacion")

#Ahora arreglamos tabla_gasolinera omitiendo las que tienen mas de un valor
tabla_gasolineras_ajustada <- tabla_gasolineras |>
  anti_join(precios_distintos, by = "Estacion") |>
  group_by(Estacion) |>
  summarise(
    Diesel = if (all(is.na(Diesel))) NA_real_ else max(Diesel, na.rm = TRUE),
    Premium = if (all(is.na(Premium))) NA_real_ else max(Premium, na.rm = TRUE),
    Magna = if (all(is.na(Magna))) NA_real_ else max(Magna, na.rm = TRUE),
    .groups = "drop"
  )

#combinamos las tablas
tabla_gasolineras_final <- bind_rows(tabla_gasolineras_ajustada, tabla_gasolineras_precios_distintos)

#Le agregamos la etiqueta de fecha a los datos 
tabla_gasolineras_final <- tabla_gasolineras_final |> 
  mutate(fecha = Sys.Date())

#Exportamos la informacion como una tabla al wd 
write.csv(tabla_gasolineras_final, paste0("csv/Precios Gasolinas ", Sys.Date(), ".csv"), row.names = FALSE)