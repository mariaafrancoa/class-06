# author: Eduard F. Martínez-González
# update: 07-03-2022
# R version 4.1.1 (2021-08-10)

# initial configuration
rm(list=ls()) # limpiar entorno
Sys.setlocale("LC_CTYPE", "en_US.UTF-8") # Encoding UTF-8

# install/load packages
require(pacman)
p_load(tidyverse,rio,skimr,png,grid)

## Hoy veremos

### **1.** Combinar conjuntos de datos

### **2.** Pivotear conjuntos de datos

#=============================#
# Combinar conjuntos de datos #
#=============================#
rm(list=ls())

## Agregar observaciones
cat(" la funcion ´set.seed()´ permite consistencia en los numeros aleatorios que se escoje")
set.seed(0117) 

cat("Dos bases de datos similares, unica diferencia entre las dos es la addicion de la columna names")
df_1 = tibble(id = 100:105 , age = runif(6,18,25) %>% round() , height = rnorm(6,170,10) %>% round() )
df_2 = tibble(id = 106:107 , age = runif(2,40,50)  %>% round() , height = rnorm(2,165,8) %>% round() , name = c("Lee","Bo"))

df_1
df_2 

#### union de las bases de datos
data = bind_rows(df_1,df_2, .id = "group")
data


#------------------------------#
## Agregar columna sin un id unico

#### base de datos con age & income
set.seed(0117)
db_1 = tibble(id = 102:105 , income = runif(4,1000,2000) %>% round())
db_2 = tibble(id = 103:106 , age = runif(4,30,40)  %>% round())

db_2 
db_1

#### Union sin ID
db = bind_cols(db_1,db_2)
db

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

df_1
df_2


#------------------------------#
## Ejemplo: left_join()
dev.off()
grid.raster(readPNG("input/pics/left_join.png"))
df = left_join(x=df_1,y=df_2,by=c("hogar","visita"))
df


#------------------------------#
## Ejemplo: right_join()
dev.off()
grid.raster(readPNG("input/pics/right_join.png"))
df = right_join(x=df_1,y=df_2,by=c("hogar","visita"))
df


#------------------------------#
## Ejemplo: inner_join()
df = inner_join(x=df_1,y=df_2,by=c("hogar","visita"))
df


#------------------------------#
## Ejemplo: full_join()
df = full_join(x=df_1,y=df_2,by=c("hogar","visita"))
df


#------------------------------#
## Ejemplo: Join sin identificador único
df = full_join(x=df_1,y=df_2,by=c("hogar"))
df

cat("Los datos se duplican! Precaucion, 
    todos los id unicos deben estar presente al momento de hacer un join, 
    los datos se duplicaran de lo contrario")

#### Ejemplo de id unicos
df_1$visita %>% duplicated() %>% table()

df_1[,c("hogar","visita")] %>% duplicated() %>% table()

intersect(colnames(df_1),colnames(df_2))

#=============================#
# Pivotear conjuntos de datos #
#=============================#

# Pivotear una base de datos?
cat("Pivot es un intercambio entre el numero de filas y columnas")

# datos
cat("fish encounter & us_rent_income, son datos de el package tydverse")

fish_encounters
us_rent_income

#------------------------------#
## pivot_wide
cat("disminuimos la cantidad de filas, aumentamos la cantidad de columnas")
fish_wide = fish_encounters %>% 
            pivot_wider(names_from = station, values_from = seen)

fish_wide


rent_wide = us_rent_income %>% 
            pivot_wider(names_from = variable, values_from = c(estimate, moe))

rent_wide

#------------------------------#
## pivot_longe
cat("aumentamos la cantidad de columnas, disminuimos la cantidad de filas")
fish_long = fish_wide %>% 
            pivot_longer(cols = c(2:12), names_to = "station" , values_to = "dummy")

fish_long

#------------------------------#
# Ejercicio clase:

# GEIH
# Identificadores unicos: "directorio", "secuencia_p", "orden" y "hogar"
cat("1. Combine en un objeto los conjuntos de datos 'Enero - Cabecera - Caracteristicas generales (Personas).csv' y 'Enero - Cabecera - Ocupados.csv'")
cat("2. Combine en un objeto los conjuntos de datos 'Febrero - Cabecera - Caracteristicas generales (Personas).csv' y 'Febrero - Cabecera - Ocupados.csv'")
cat("3. Combine en un objeto los datos de la GEIH de Enero y Febrero")

#---------------------#
## Para seguir leyendo

# Wickham, Hadley and Grolemund, Garrett, 2017. R for Data Science [[Ver aquí]](https://r4ds.had.co.nz)

# + Cap. 5: Data transformation
# + Cap. 10: Tibbles
# + Cap. 12: Tidy data


