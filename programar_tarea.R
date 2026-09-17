install.packages("taskscheduleR")
library(taskscheduleR)

taskscheduler_create(
  taskname   = "precios_gasolina",
  rscript    = "C:/Users/adolf/OneDrive/Documents/Estadisticas Gasolina/Descarga Diaria Precios.R",
  schedule   = "DAILY",
  starttime  = "08:00",
  startdate  = format(Sys.Date(), "%d/%m/%Y")
)