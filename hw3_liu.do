**Question 2**
**replicate table 4.1**

gen Di = (agecell >= 21)
gen extoth = external - mva - suicide - homicide

**Ages 19-22 regular RD equation**
reg all Di agecell, robust 
reg mva Di agecell, robust
reg suicide Di agecell, robust
reg homicide Di agecell, robust
reg extoth Di agecell, robust
reg internal Di agecell, robust
reg alcohol Di agecell, robust

**Ages 19-22 fancy RD equation**
gen cutoff = agecell - 21
gen cutoffsq = cutoff^2
gen cutoffdi = cutoff*Di
gen cutoffsqdi = cutoffsq*Di

reg all Di cutoff cutoffsq cutoffdi cutoffsqdi, robust
reg mva Di cutoff cutoffsq cutoffdi cutoffsqdi, robust
reg suicide Di cutoff cutoffsq cutoffdi cutoffsqdi, robust
reg homicide Di cutoff cutoffsq cutoffdi cutoffsqdi, robust
reg extoth Di cutoff cutoffsq cutoffdi cutoffsqdi, robust
reg internal Di cutoff cutoffsq cutoffdi cutoffsqdi, robust
reg alcohol Di cutoff cutoffsq cutoffdi cutoffsqdi, robust

**Ages 20-21 regular RD equation**
reg all Di agecell if inrange(agecell, 20, 22), robust
reg mva Di agecell if inrange(agecell, 20, 22), robust
reg suicide Di agecell if inrange(agecell, 20, 22), robust
reg homicide Di agecell if inrange(agecell, 20, 22), robust
reg extoth Di agecell if inrange(agecell, 20, 22), robust
reg internal Di agecell if inrange(agecell, 20, 22), robust
reg alcohol Di agecell if inrange(agecell, 20, 22), robust

**Ages 20-21 fancy RD equation**
reg all Di cutoff cutoffsq cutoffdi cutoffsqdi if inrange(agecell, 20, 22), robust
reg mva Di cutoff cutoffsq cutoffdi cutoffsqdi if inrange(agecell, 20, 22), robust
reg suicide Di cutoff cutoffsq cutoffdi cutoffsqdi if inrange(agecell, 20, 22), robust
reg homicide Di cutoff cutoffsq cutoffdi cutoffsqdi if inrange(agecell, 20, 22), robust
reg extoth Di cutoff cutoffsq cutoffdi cutoffsqdi if inrange(agecell, 20, 22), robust
reg internal Di cutoff cutoffsq cutoffdi cutoffsqdi if inrange(agecell, 20, 22), robust
reg alcohol Di cutoff cutoffsq cutoffdi cutoffsqdi if inrange(agecell, 20, 22), robust


**replicate Figure 4.2**
reg all Di agecell
predict yhata
seperate yhata, by(Di)

twoway scatter all agecell ///
	|| line yhata0 yhata1 agecell, xline(21, lpattern(-)) ///
	   yt("Death rate from all causes (per 100,000)") ///
	   xt("Age") t("A sharp RD estimate of MLDA mortality effects") ///
	   legend(off)
	   
**replicate Figure 4.4**
reg all Di cutoff cutoffsq cutoffdi cutoffsqdi
predict yhatb
seperate yhatb, by(Di)

twoway scatter all agecell ///
	|| line yhata0 agecell, lpattern(_) ///
	|| line yhata1 agecell, lpattern(_) ///
	|| line yhatb0 yhatb1 agecell, xline(21, lpattern(-)) ///
	   yt("Death rate from all causes (per 100,000)") ///
	   xt("Age") t("A sharp RD estimate of MLDA mortality effects") ///
	   legend(off)

**Quetion 2a(iii)**
gen cutoffqu = cutoff^3
reg all cutoff cutoffsq cutoffqu
predict yhatc

twoway scatter all agecell ///
	|| line yhatc agecell


**Question 2b**
**replicate Figure 5.2**
levelsof state, loc(states)
forvalues s = 1(1)56{
	gen T_`s' = `s' * year
	replace T_`s' = 0 if state != `s'
	}
**Column 1**
reg mrate legal i.state i.year if inrange(year, 1970, 1983) ///
	& agegr == 2 & dtype == 1, cluster(state)
reg mrate legal i.state i.year if inrange(year, 1970, 1983) ///
	& agegr == 2 & dtype == 2, cluster(state)
reg mrate legal i.state i.year if inrange(year, 1970, 1983) ///
	& agegr == 2 & dtype == 3, cluster(state)
reg mrate legal i.state i.year if inrange(year, 1970, 1983) ///
	& agegr == 2 & dtype == 6, cluster(state)
**Column 2**
reg mrate legal i.state i.year T_* if inrange(year, 1970, 1983) ///
	& agegr == 2 & dtype == 1, cluster(state)
reg mrate legal i.state i.year T_* if inrange(year, 1970, 1983) ///
	& agegr == 2 & dtype == 2, cluster(state)
reg mrate legal i.state i.year T_* if inrange(year, 1970, 1983) ///
	& agegr == 2 & dtype == 3, cluster(state)
reg mrate legal i.state i.year T_* if inrange(year, 1970, 1983) ///
	& agegr == 2 & dtype == 6, cluster(state)
**Column 3**
reg mrate legal i.state i.year [w = pop] if inrange(year, 1970, 1983) ///
	& agegr == 2 & dtype == 1, cluster(state)
reg mrate legal i.state i.year [w = pop] if inrange(year, 1970, 1983) ///
	& agegr == 2 & dtype == 2, cluster(state)
reg mrate legal i.state i.year [w = pop] if inrange(year, 1970, 1983) ///
	& agegr == 2 & dtype == 3, cluster(state)
reg mrate legal i.state i.year [w = pop] if inrange(year, 1970, 1983) ///
	& agegr == 2 & dtype == 6, cluster(state)
**Column 4**
reg mrate legal i.state i.year T_* [w = pop] if inrange(year, 1970, 1983) ///
	& agegr == 2 & dtype == 1, cluster(state)
reg mrate legal i.state i.year T_* [w = pop] if inrange(year, 1970, 1983) ///
	& agegr == 2 & dtype == 2, cluster(state)
reg mrate legal i.state i.year T_* [w = pop] if inrange(year, 1970, 1983) ///
	& agegr == 2 & dtype == 3, cluster(state)
reg mrate legal i.state i.year T_* [w = pop] if inrange(year, 1970, 1983) ///
	& agegr == 2 & dtype == 6, cluster(state)



use "http://dss.princeton.edu/training/Panel101.dta", clear
sum y
