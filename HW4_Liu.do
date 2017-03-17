clear all
clear matrix

loc root = "C:\Users\Bingcai\Google Drive\2017 Winter\ARE 256B\HW4\outputs"

***Problem 1***
use "C:\Users\Bingcai\Google Drive\2017 Winter\ARE 256B\HW4\Guns.dta", clear
**Question a**
qui reg vio shall incarc_rate avginc pb1064, vce(robust)
outreg2  using "Q1_PooledOLS.doc" , ctitle("Vio" ) ///
		 dec(3) bdec(3) tdec(3) rdec(3) alpha(.01, .05, .1) replace

qui reg rob shall incarc_rate avginc pb1064, vce(robust)
outreg2  using "Q1_PooledOLS.doc" , ctitle("Rob" ) ///
		 dec(3) bdec(3) tdec(3) rdec(3) alpha(.01, .05, .1) append

qui reg mur shall incarc_rate avginc pb1064, vce(robust)
outreg2  using "Q1_PooledOLS.doc" , ctitle("Mur" ) ///
		 dec(3) bdec(3) tdec(3) rdec(3) alpha(.01, .05, .1) append
		 
**Question b**
xtset year

qui xtreg vio shall incarc_rate avginc pb1064, re vce(robust)
outreg2  using "Q1_RE.doc" , ctitle("Vio" ) ///
		 dec(3) bdec(3) tdec(3) rdec(3) alpha(.01, .05, .1) replace

qui xtreg rob shall incarc_rate avginc pb1064, re vce(robust)
outreg2  using "Q1_RE.doc" , ctitle("Rob" ) ///
		 dec(3) bdec(3) tdec(3) rdec(3) alpha(.01, .05, .1) append

qui xtreg mur shall incarc_rate avginc pb1064, re vce(robust)
outreg2  using "Q1_RE.doc" , ctitle("Mur" ) ///
		 dec(3) bdec(3) tdec(3) rdec(3) alpha(.01, .05, .1) append

**Question c**
qui xtreg vio shall incarc_rate avginc pb1064, fe vce(robust)
outreg2  using "Q1_FE.doc" , ctitle("Vio" ) ///
		 dec(3) bdec(3) tdec(3) rdec(3) alpha(.01, .05, .1) replace

qui xtreg rob shall incarc_rate avginc pb1064, fe vce(robust)
outreg2  using "Q1_FE.doc" , ctitle("Rob" ) ///
		 dec(3) bdec(3) tdec(3) rdec(3) alpha(.01, .05, .1) append

qui xtreg mur shall incarc_rate avginc pb1064, fe vce(robust)
outreg2  using "Q1_FE.doc" , ctitle("Mur" ) ///
		 dec(3) bdec(3) tdec(3) rdec(3) alpha(.01, .05, .1) append
		 

**Question e**
*violent*
qui xtreg vio shall incarc_rate avginc pb1064, re
est sto bre
qui xtreg vio shall incarc_rate avginc pb1064, fe
est sto bfe
hausman bfe bre

*robbery*
qui xtreg rob shall incarc_rate avginc pb1064, re
est sto bre
qui xtreg rob shall incarc_rate avginc pb1064, fe
est sto bfe
hausman bfe bre

*Murder*
qui xtreg mur shall incarc_rate avginc pb1064, re
est sto bre
qui xtreg mur shall incarc_rate avginc pb1064, fe
est sto bfe
hausman bfe bre


***Problem 2***
use "C:\Users\Bingcai\Google Drive\2017 Winter\ARE 256B\HW4\SeatBelts.dta", clear
**Question a**
xtset fips year

qui xtreg fatalityrate sb_useage, fe vce(robust)
outreg2  using "Q2_a2.doc" , ctitle("FE" ) ///
		 dec(3) bdec(3) tdec(3) rdec(3) alpha(.01, .05, .1) replace
qui xtreg fatalityrate sb_useage i.year, fe vce(robust)
outreg2  using "Q2_a2.doc" , ctitle("FE_Tfix" ) ///
		 dec(3) bdec(3) tdec(3) rdec(3) alpha(.01, .05, .1) append 
qui xtreg fatalityrate sb_useage i.year c.year#i.fips, fe vce(robust)
outreg2  using "Q2_a2.doc" , ctitle("FE_Tfix_Ttrend" ) ///
		 dec(3) bdec(3) tdec(3) rdec(3) alpha(.01, .05, .1) append

**Question b**
xtset fips year

qui regress D.(fatalityrate sb_useage), nocons vce(cluster fips)
outreg2  using "Q2_b.doc" , ctitle("FE" ) replace
qui regress D.(fatalityrate sb_useage) i.year, nocons vce(cluster fips)
outreg2  using "Q2_b.doc" , ctitle("FE_Tfix" ) append
qui regress D.(fatalityrate sb_useage) i.year c.year#i.fips, ///
		nocons vce(cluster fips)
outreg2  using "Q2_b.doc" , ctitle("FE_Tfix_Ttrend" ) append


***Problem 4***
use "C:\Users\Bingcai\Google Drive\2017 Winter\ARE 256B\HW4\cement.dta", clear

**Question a**
gen date = ym(year, month)
tsset date
dfuller gcem, regress

**Question b**
*easy way*
regress gcem grres
estat bgodfrey, lags(1)
estat bgodfrey, lags(3)
estat bgodfrey, lags(5)

*complex way*
reg gcem grres
predict resid, residuals
gen resid_lag1 = L1.resid
gen resid_lag2 = L2.resid
gen resid_lag3 = L3.resid
gen resid_lag4 = L4.resid
gen resid_lag5 = L5.resid

reg resid grres resid_lag1
outreg2  using "Q4_a2.doc" , ctitle("Lag1" ) replace
reg resid grres resid_lag1 resid_lag2 resid_lag3
outreg2  using "Q4_a2.doc" , ctitle("Lag3" )  append
reg resid grres resid_lag1 resid_lag2 resid_lag3 resid_lag4 resid_lag5
outreg2  using "Q4_a2.doc" , ctitle("Lag5" )  append

**Question C**
regress gcem grres, robust
outreg2  using "Q4_a3.doc" , ctitle("Robust" ) sdec(4) replace
newey gcem grres, lag(5)
outreg2  using "Q4_a3.doc" , ctitle("Newey_lag5" ) sdec(4) append

