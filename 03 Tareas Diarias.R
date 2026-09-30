install.packages("taskscheduleR")
library(taskscheduleR)

#Descarga de Precios
taskscheduler_create(
  taskname   = "precios_gasolina",
  rscript    = "C:/Users/adolf/OneDrive/Documents/Estadisticas Gasolina/01 Descarga Diaria Precios.R",
  schedule   = "DAILY",
  starttime  = "08:00",
  startdate  = format(Sys.Date(), "%d/%m/%Y")
)

#Descarga de informacion 
taskscheduler_create(
  taskname   = "info_gasolineras",
  rscript    = "C:/Users/adolf/OneDrive/Documents/Estadisticas Gasolina/02 Descarga Llave.R",
  schedule   = "DAILY",
  starttime  = "08:15",
  startdate  = format(Sys.Date(), "%d/%m/%Y")
)