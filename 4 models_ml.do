gen grad = (S>11) 
clear programs

use "C:\Users\Bingcai\Google Drive\2017 Winter\ARE 256B\HW1\256B_PS1_Dataset.dta", clear
**Linear Model**
capture program drop mylinear
program mylinear
    args lnf theta1 sigma
	quietly replace `lnf' = ln(normalden($ML_y1 , `theta1', `sigma')
end 

ml model lf lfols (grad = SF) /sigma
ml maximize
ml model lf lfols (grad = SM) /sigma
ml maximize

**Probit Model**
capture program drop myprobit
program myprobit
	args lnf theta1
	quietly replace `lnf' = ln(normal(`theta1')) if $ML_y1==1
	quietly replace `lnf' = ln(1-normal(`theta1')) if $ML_y1==0
end

ml model lf myprobit (grad = SM)
ml maximize
ml model lf myprobit (grad = SF)
ml maximize

**Logit Model**
capture program drop mylogit
program mylogit
	args lnf theta1
	quietly replace `lnf' = -ln(1+exp(-`theta1')) if $ML_y1==1
	quietly replace `lnf' = -`theta1' - ln(1+exp(-`theta1')) if $ML_y1==0
end

ml model lf mylogit (grad = SF SM MALE FAITHN EARNINGS)
ml maximize

**Tobit Model**
tobit grad SM, ll

capture program drop mytobit1
program mytobit1
	args lnf theta1 sigma
	quietly replace `lnf'= ln(1-normal(`theta1'/`sigma')) if $ML_y1==0
	quietly replace `lnf'= ///
	ln((1/`sigma')*normalden($ML_y1 , `theta1', `sigma') if $ML_y1>0
end

ml model lf mytobit1 (grad = SF) /sigma
ml check
ml maximize, nolog
