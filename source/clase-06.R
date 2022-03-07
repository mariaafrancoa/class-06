# author: Eduard F. Martínez-González
# update: 07-03-2022
# R version 4.1.1 (2021-08-10)

# initial configuration
rm(list=ls()) # limpiar entorno
Sys.setlocale("LC_CTYPE", "en_US.UTF-8") # Encoding UTF-8

# install/load packages
require(pacman)
p_load(tidyverse,rio,skimr,png,grid)

# view working directory 
getwd()
list.files(recursive = T)

## Hoy veremos

### **1.** Combinar conjuntos de datos

### **2.** Pivotear conjuntos de datos

#=============================#
# Combinar conjuntos de datos #
#=============================#

## Agregar observaciones
cat(" la funcion ´set.seed()´ permite consistencia en los numeros aleatorios que se escoje")
set.seed(0117) #esto hace que sean iguales

cat("Dos bases de datos similares, unica diferencia entre las dos es la addicion de la columna names")
df_1 = tibble(id = 100:105 , age = runif(6,18,25) %>% round() , height = rnorm(6,170,10) %>% round() )
df_2 = tibble(id = 106:107 , age = runif(2,40,50)  %>% round() , height = rnorm(2,165,8) %>% round() , name = c("Lee","Bo"))

df_1
df_2 

#### union de las bases de datos
data = bind_rows(df_1,df_2, .id = "group") #df1 y df2 son dos bases; agrega las filas; si quiero agregar columnas sería con _columns
data


#------------------------------#
## Agregar columna sin un id unico

#### base de datos con age & income
set.seed(0117)
db_1 = tibble(id = 102:105 , income = runif(4,1000,2000) %>% round())
db_2 = tibble(id = 103:106 , age = runif(4,30,40)  %>% round())

db_2 #id age
db_1 #id income

#### Union sin ID
db = bind_cols(db_1,db_2)
db #estan mal pegadas, int 103 con int 104 entonces...

cat("Algo salió mal!. la función `bind_cols()` no tiene en cuenta el identificador de cada observación.")


#================#
# Joint function #
#================#
rm(list=ls())

## Agregar variables: join()
dev.off()
grid.raster(readPNG("input/pics/types_join.png"))

# importamos bases de datos ejemplo
df_1 = import("input/ejemplo_1.xlsx")
df_2 = import("input/ejemplo_2.xlsx")

df_1 # sexo
df_2 # edad e ingrerso y quiero pegarle la variable sexo


#------------------------------#
## Ejemplo: left_join()
dev.off() #borra el grafico anterior
grid.raster(readPNG("input/pics/left_join.png"))
df = left_join(x=df_1,y=df_2,by=c("hogar","visita")) # el tercer argumento son las variables llave, que estan en ambas (hogar y visita) y borra el hogar que no estaba en y (hogar 101 visita 1)
df


#------------------------------#
## Ejemplo: right_join()
dev.off()
grid.raster(readPNG("input/pics/right_join.png"))
df = right_join(x=df_1,y=df_2,by=c("hogar","visita")) #aqui en vez de eliminar el 101 visita 1; dejo lo que esta en y y los de x que peguen en y. el 301 no estaba en y
df


#------------------------------#
## Ejemplo: inner_join()
dev.off()
grid.raster(readPNG("input/pics/inner_join.png"))
df = inner_join(x=df_1,y=df_2,by=c("hogar","visita")) #solo deja las observaciones que estaban en x y en y
df


#------------------------------#
## Ejemplo: full_join()
dev.off()
grid.raster(readPNG("input/pics/full_join.png"))
df = full_join(x=df_1,y=df_2,by=c("hogar","visita"))
df


#------------------------------#
## Ejemplo: Join sin identificador único
dev.off()
grid.raster(readPNG("input/pics/bad_join.png"))
df = full_join(x=df_1,y=df_2,by=c("hogar"))
df

cat("Las observaciones se duplican! 
     Precaucion al momento de hacer un join asegurese de usar todos los id unicos,  
     de lo contrario las observaciones se duplicaran.")
c(1,2,3,4,5,1,2,3)
duplicated(c(1:5,1,2,3)) 
duplicated(c(1:5,1,2,3)) %>% table()

#### Ejemplo de id unicos
df_1$visita %>% duplicated() %>% table()

df_1[,c("hogar","visita")] %>% duplicated() %>% table()

intersect(colnames(df_1),colnames(df_2))

distinct_all(df) #df paso de 9 a t obs, porque duplicaba unas' solo dejo los valores que no se repiten

#=============================#
# Pivotear conjuntos de datos #
#=============================#

# Pivotear una base de datos? cambiar el numero de filas por el numero de columnas
cat("Pivot es un intercambio entre el numero de filas y columnas") # pinte cosas sobre la consola

# datos
cat("fish encounter & us_rent_income, son datos de el package tydverse")
?fish_encounters

fish_encounters
us_rent_income

#------------------------------#
## pivot_wide
cat("disminuimos la cantidad de filas, aumentamos la cantidad de columnas")
fish_wide = fish_encounters %>% 
            pivot_wider(names_from = station, values_from = seen)

fish_wide # Hay muchos N/A es porque hay seasons donde no se ve el pez.


rent_wide = us_rent_income %>% 
            pivot_wider(names_from = variable, values_from = c(estimate, moe))

rent_wide #convierte variable de categorias en columnas

#------------------------------#
## pivot_longe
cat("aumentamos la cantidad de columnas, disminuimos la cantidad de filas")
fish_long = fish_wide %>% 
            pivot_longer(cols = c(2:12), names_to = "station" , values_to = "dummy")
# cuantas columnas 
fish_long

#------------------------------#
# Ejercicio clase:

# GEIH GRAN ENCUESTA INTEGRADA DE HOGARES
# Identificadores unicos: "directorio", "secuencia_p", "orden" y "hogar"
cat("1. Combine en un objeto los conjuntos de datos 'Enero - Cabecera - Caracteristicas generales (Personas).csv' y 'Enero - Cabecera - Ocupados.csv'")
cat("2. Combine en un objeto los conjuntos de datos 'Febrero - Cabecera - Caracteristicas generales (Personas).csv' y 'Febrero - Cabecera - Ocupados.csv'")
cat("3. Combine en un objeto los datos de la GEIH de Enero y Febrero")

cg_enero = import("input/Enero - Cabecera - Caracteristicas generales (Personas).csv")
ocu_enero = import("input/Enero - Cabecera - Ocupados.csv")

total = left_join(x=cg_enero , y=ocu_enero , by=c("DIRECTORIO","SECUENCIA_P","ORDEN","HOGAR"))
#---------------------#
## Para seguir leyendo

# Wickham, Hadley and Grolemund, Garrett, 2017. R for Data Science [[Ver aquí]](https://r4ds.had.co.nz)

# + Cap. 5: Data transformation
# + Cap. 10: Tibbles
# + Cap. 12: Tidy data


