*****************************************
* Stata session
*****************************************
clear all
clear matrix

*****************
* Define paths
*****************
* Also, show the usage of the capture function

* General path: the only thing you should change!

loc root = "C:\Users\obarriga\Google Drive\University\2016\2016 - Winter\ARE 256 B\Stata session"

* Data paths
loc data_raw = "`root'/data/zip"

* Data clean
loc data_clean = "`root'/data/clean"

* This folder does not exist, so we should create it
cap mkdir "`root'/data/clean"

* Output results
loc data_output = "`root'/data/output"
cap mkdir "`root'/data/output"


*****************
* Export the data to individual folders
*****************

* We want  to organize the data on their own folder
* Things to explain: The usage of * , strings, and advanced local functions
* MENTION THAT COPY CAN BE USED TO DOWNLOAD INFO FROM WEBSITES

loc files  : dir "`data_raw'" files "*.dta"

di `files'

foreach file of loc files  {
	
	loc aux = substr("`file'",1,5)
	di "`aux'"
	
	cap mkdir "`data_clean'/`aux'"
	
	copy "`data_raw'/`file'" "`data_clean'/`aux'/`file'" , replace
	
}

*****************
* appending data
*****************

use "`data_clean'/year1/year1" , clear
append  using "`data_clean'/year2/year2"
append  using "`data_clean'/year3/year3"

save "`data_output'/appended" , replace

*****************
* Let's runa few regressions
*****************
 
* Main points: outreg2, globals and duplicates command

use "`data_output'/appended" , clear

global table = "table1"

reg ln_yield hybrid_aux HH_size
outreg2  using "`data_output'/$table.xls" , ctitle("OLS Pooled" )  dec(3) bdec(3)tdec(3) rdec(3) alpha(.01, .05, .1) replace

xtset hhid  year

xtreg ln_yield hybrid_aux HH_size , fe
outreg2  using "`data_output'/$table.xls" , ctitle("OLS Pooled" )  dec(3) bdec(3)tdec(3) rdec(3) alpha(.01, .05, .1) append

* I want to know how many are panel
duplicates tag hhid , gen(panel)
ta panel year , m

xtreg ln_yield hybrid_aux HH_size if panel == 2, fe
outreg2  using "`data_output'/$table.xls" , ctitle("OLS Pooled" )  dec(3) bdec(3)tdec(3) rdec(3) alpha(.01, .05, .1) append

*****************
* How to get statistics?
*****************

* Main points: There are 3 optios to export data. Manually (prone to mistake and a deep desire to quite your job), matrix (Not very flexible), postfiles (My personal recomendation)
* Main points: The use of the preserve and restore functions as well as temporary names and variables.
* Also, show the usage of quietly, nested loops and rename functions.


* BTW: Please, ALWAYS indent loops

* 1) Manually

table year panel, c(mean ln_yield  sd ln_yield )

*2 ) matrix: Can only store numbers. 

* Loop for years
foreach year of numlist 1997 2000 2004 {
	
	di in y "year = `year' "
	* Loop for panel values

	forvalues  panel = 0(1)2 {
	
		su ln_yield if year == `year' & panel == `panel'
		
		mat Results = nullmat(Results) \ (`year' , `panel' ,  r(mean) , r(sd) )
	
	}
	
}

* Add names to columns and rows
mat colnames Results = year panel mean sd
mat list Results

preserve
	
	drop _all
	
	svmat Results , names(col)
	
	export excel using  "`data_output'/Matrix.xls" , sheet(test) cell(B5) sheetmodify firstrow(variables)
	
restore



*3 ) postfiles: can export strings and numbers. It is pretty flexible

tempname aux
tempfile export_file

postfile `aux' str40(year panel mean sd) using `export_file'

* Loop for years
foreach year of numlist 1997 2000 2004 {
	
	di in y "year = `year' "
	* Loop for panel values

	forvalues  panel = 0(1)2 {
	
		qui: su ln_yield if year == `year' & panel == `panel'
		loc mean = r(mean)
		loc sd = r(sd)
		loc sd = r(sd)
		
		post `aux' ("`year'") ("`panel'") ("`mean'") ("`sd'") 
		
	}
	
}


postclose `aux'

use "`export_file'" , clear

destring, replace

* Change variables names
rename * , upper
rename * , lower

save   "`data_output'/using_post.dta"  	, replace

as
