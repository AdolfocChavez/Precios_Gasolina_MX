Es un código pequeño y sencillo para que puedan bajar los precios diarios de las gasolinas en México. 

Son Scripts en R, asi que por lo menos necesitan R Instalado. 

PASO #1 
Crear dos carpetas designadas para bajar archivos. Un carpeta en donde van los datos en crudo que son archivos 
tipo XML. Y una segunda carpeta en donde van archivos tipo CSV, que tienen la información procesada. 

PASO #2
Deben de ajustar las rutas en el script "Descarga Diaria Precios.R" para que se guarden los datos en las carpetas 
creadas en el PASO #1. 

Paso #3 
Ajustar la ruta en el script "programar_tarea.R" para que coincida con la ubicación del script 
"Descarga Diaria Precios.R" en tu máquina.

Paso #4
Ejecutar script "programar_tarea.R" para que se ejecute de manera automatica todos los días el script 
"Descarga Diaria Precios.R" en tu máquina.

Paso #5 
Verificar en Programador de Tareas (Si usas WINDOWS) que exista una tarea que se llama precios_gasolina. 
