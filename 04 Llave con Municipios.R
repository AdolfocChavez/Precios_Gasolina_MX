#Abrimos la libreria 
library(sf)
library(ggplot2)
library(tidyverse)

#ponemos la ruta de en donde estan los archivos 
carpeta <- "C:/Users/adolf/OneDrive/Documents/Estadisticas Gasolina/datos_lugares"

#hacemos la lista de llaves 
archivos <- list.files(
  path = carpeta,
  pattern = "^gasolineras_\\d{4}-\\d{2}-\\d{2}\\.csv$",
  full.names = TRUE
)

#jalamos la base con todas las llaves 
datos <- read_csv(archivos, id = "archivo")

#hacemos la llave unica de gasolineras 
gasolineras <- datos |> 
  distinct(place_id, name, cre_id, x, y,)

#filtramos las que no tienen coordenadas 
gasolineras_sin_coordenadas <- gasolineras |> 
  filter(x == 0.00000)

#Dejamos las que si tienen coordenadas 
gasolineras <- gasolineras |> 
  filter(!x == 0)

rm(datos, archivos, carpeta)

#Hay que descargar y decomprimir el marco geoestadistico de INEGI 
#"https://www.inegi.org.mx/contenidos/productos/prod_serv/contenidos/espanol/bvinegi/productos/geografia/marcogeo/794551196649_s.zip"

#Sacamos el mapa con división municipal 
municipios  <- st_read("C:/Users/adolf/Documents/Marco Geoestadistico/MG_Integrado_Encuesta_Intercensal_2025/conjunto_de_datos/00mun.shp")

#convertimos los datos de las gasolineras en objetos geoespaciales 
gasolineras_sf <- st_as_sf(gasolineras, coords = c("x", "y"), crs = 4326)

#ponemos todo en el mismo sistema de coordenadas 
gasolineras_sf <- st_transform(gasolineras_sf, st_crs(municipios))

#Le ponemos los datos de municipios y estado a las gasolineras 
llave_mun <- st_join(gasolineras_sf, municipios, join = st_within)

#sacamos las gasolineras que no estan en algun municipio 
llave_mun_NA <- llave_mun |> 
  filter(if_any(everything(), is.na))

#hay algunas con problemas por errores de captura en los datos asi que vamos a filtrarlos 
duplicados_llave_mun <- llave_mun |>
  add_count(place_id) |>
  filter(n > 1) |>
  arrange(place_id)

#nos quedamos con una fila por place_id 
llave_mun <- llave_mun |> 
  distinct(place_id, .keep_all = TRUE)

#eliminamos las columnas de la llave que no son necesarias 
llave_mun <- llave_mun |> 
  select(-geometry, -CVEGEO) |> 
  st_drop_geometry()

#ponemos como wd de en donde vamos a guardar la llave 
setwd("C:/Users/adolf/OneDrive/Documents/Estadisticas Gasolina/datos_lugares")

#guardamos la llave como un csv
write.csv(llave_mun, "gasolineras_municipios.csv", row.names = FALSE)

#guardamos los datos de las gasolineras sin coordenadas y con coordenadas erroneas y con errores de captura  
write.csv(llave_mun_NA, "gasolineras_cordenadas_erroneas.csv", row.names = FALSE)
write.csv(gasolineras_sin_coordenadas, "gasolineras_sin_coordenadas.csv", row.names = FALSE)
write.csv(duplicados_llave_mun, "gasolineras_errores_captura.csv", row.names = FALSE)


