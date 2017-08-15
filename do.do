***Punto 1:  "Combine los archivos de datos de forma adecuada para crear una base de datos que contenga todos los registros..."
import excel “Base1.xls", sheet("base1") firstrow
save "base1.dta"
import delimited "Base2.csv", delimiter(";") clear 
save "base2.dta", replace

append using "base1.dta"
save "completa.dta"

merge 1:1 var1 using "base3.dta"
save "basesunidas.dta"

***Punto 2: "Asigne nombres a las variables en la base de datos y rótulos a las variables en la base de datos"
rename var1 id
rename var1 id
label variable id "Identificación pacientes"
rename var2 sexo
label variable sexo "sexo"
rename var3 tipodolor
label variable tipodolor "tipo de dolor torácico"
rename var4 pas
rename var5 rescoleser
label variable rescoleser "colesterol sérico"
rename var6 resekg
label variable resekg "resultados ekg"
rename var7 fechanac
label variable fechanac "fecha de nacimiento"
rename var8 diagenfcor
label variable diagenfcor "diagnóstico enf cor"
rename var9 fechangio
label variable fechangio "fecha angio coro"

*** Punto 3: "Asigne rótulos a los valores de las variables categóricas (tenga en cuenta la tabla anterior)" 
**** antes de categorizar la presión sistóloca debo convertirla en variable numérica, está en alfanumérica
destring pas, replace force
egen float pascat= cut(pas), at(0 90 130 140 160 180 300) icodes
label variable pas "presión sistólica"
label variable pascat "presión sistólica categ"
tab pascat
label define lblpascat 0 "Hipotenso" 1 "Normal" 2 "Prehip" 3 "HTA1" 4 "HTA2" 5 "Crishta"
tab pascat
label values pascat lblpascat
tab pascat
save "basesunidas.dta", replace


***Punto 5: "Genera una variable que contenga la edad de los pacientes al momento de la angiografía coronaria"
gen fechanacim=date(fechanac,"MDY")
gen angio=date(fechangio ,"DMY")
gen edadpaciente= int((( angio - fechanacim )/365.25))
label variable fechanacim "fecha nacim pac"
label variable angio "fecha exam angio"
label variable edadpaciente "edad en años"
save “basesunidas.dta", replace
****Punto 6: "Describa los pacientes del estudio de acuerdo a la edad y sexo. Emplee al menos un gráfico y comente los resultados
tab edadpaciente
sum edadpaciente
sum edadpaciente,d
tab sexo
graph box edadpaciente, over(sexo)
tab tipodolor diagenfcor, row
graph box edadpaciente, over(sexo)
tab sexo
sum edadpaciente
clear
