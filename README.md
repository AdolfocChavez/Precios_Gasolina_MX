Es un conjunto de códigos para descargar los precios de las gasolinas en México de manera diaria y organizar los resultados en un solo data frame con información de a que municipio pertenece cada gasolinera y el día que se realizo la consulta para poder trabajar. 

Son Scripts en R, asi que por lo menos necesitan R Instalado. 

Antes de correr los scripts necesitan hacer un par ajustes: 

Ajuste #1 
Tener un directorio de trabajo y en este crear dos carpetas designadas para trabajar. Un carpeta en donde van los datos de los precios, tanto archivos tipo XML como archivos tipo CSV.  Otra carpeta en donde va la información de las estaciones igualmente tanto archivos tipo XML como archivos CSV. 

Ajuste #2 
Descargar y descomprimir el marco geoestadistico de INEGI para poder tener el mapa que se usa en el script "04 Llave con Municipios.R" de "https://www.inegi.org.mx/contenidos/productos/prod_serv/contenidos/espanol/bvinegi/productos/geografia/marcogeo/794551196649_s.zip"

Ajuste #3
Deben de ajustar las rutas en TODOS los scripts para que coincidan con las carpetas que creación en el primer ajuste y la ubicación del mapa para el script "04 Llave con Municipios.R".

Ahora si ya hiciste todos los ajustes, que no es nada de otro mundo ya puedes correr los scripts. 

Paso 1 
Correr el script "01 Descarga Diaria Precios.R". Esto debería de darte 2 archivos distintos: un XML con los datos en crudo como se descargaron de la página y un archivo CSV con la información ya limpia. 

Paso 2
Correr el script "02 Descarga Llave.R" Esto debería de dar también 2 archivos: un XML con la información cruda como se descargo y un archivo CSV con la información del permiso, el nombre de la empresa que opera el permiso y las coordenadas de la ubicación de la gasolinera. 

Paso 3 
Correr el script "03 Tareas Diarias.R" Esto debería de programar en la computadora que se corran los scripts 01 y 02 todos los días. Verificar en Programador de Tareas (Si usas WINDOWS) que existan las tareas del Script. 

Paso 4 
Correr el script "04 Llave con Municipios.R". Esto debería de dar 4 archivos CSV. Uno con las gasolineras con estado y municipio, uno con las gasolineras que tuvieron errores de captura al momento de subir su información, otra con gasolineras que tenían coordenadas 0 y otra con gasolineras que subieron coordenadas que se ubican fuera del país. 

Paso 5 
El script "05 Información con Permiso y Municipio.R" crea un dataframe con toda la información recopilada: todos los precios de los combustibles de todas las gasolineras y su ubicación en función del municipio y estado. Este script no crea un archivo porque la información crece rápido ya que son mas de 15,000 entradas diarias. 
