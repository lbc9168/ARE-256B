**Question 1
gen grad = 0 
replace grad = 1 if S>11
**a
reg grad SM, robust
reg grad SF, robust
**b
probit grad SM, robust
probit grad SF, robust
**d
quietly probit grad SM
predict grad_probit_hat_SM
twoway(scatter grad SM)(lfit grad SM)(scatter grad_probit_hat_SM SM),/*
	*/title("High school graduation and mother's schooling")/*
	*/xtitle("Mother's schooling")ytitle("High school graduation")

quietly probit grad SF
predict grad_probit_hat_SF
twoway(scatter grad SM)(lfit grad SF)(scatter grad_probit_hat_SF SF),/*
	*/title("High school graduation and father's schooling")/*
	*/xtitle("Father's schooling")ytitle("High school graduation")
**e
quietly probit grad SM, robust
predict grad_predict_sm_probit
quietly reg grad SM, robust
predict grad_predict_sm_linear
quietly probit grad SF, robust
predict grad_predict_sf_probit
quietly reg grad SF, robust
predict grad_predict_sf_linear
 
list grad SM SF grad_predict_sm_probit grad_predict_sm_linear /*
	*/grad_predict_sf_probit grad_predict_sf_linear in 345/349

reg grad SM
reg grad SF
probit grad SM
probit grad SF

gen sqerror_sm_linear = (grad - grad_predict_sm_linear)^2
gen sqerror_sm_probit = (grad - grad_predict_sm_probit)^2
gen sqerror_sf_linear = (grad - grad_predict_sf_linear)^2
gen sqerror_sf_probit = (grad - grad_predict_sf_probit)^2

summarize sqerror_sm_linear sqerror_sm_probit /*
	*/sqerror_sf_linear sqerror_sf_probit
	
scalar MSE_sm_linear = sqrt(.0918903)
scalar MSE_sm_probit = sqrt(.0927554)
scalar MSE_sf_linear = sqrt(.0927651)
scalar MSE_sf_probit = sqrt(.0927771)

display MSE_sm_linear MSE_sm_probit MSE_sf_linear MSE_sf_probit

**h
quietly probit grad SF, robust
adjust SF = 13, pr
adjust SF = 17, pr
adjust SF = 21, pr
quietly reg grad SF, robust
adjust SF = 13
adjust SF = 17
adjust SF = 21

**i
**derivative of probit
quietly probit grad SF, robust
margins, dydx(SF) at(SF=12)
margins, dydx(SF) at(SF=16)
margins, dydx(SF) at(SF=20)

**Question2
**a
logit grad SF SM MALE FAITHN EARNINGS
**c
predict grad_predict_logit
gen sqerror_logit = (grad - grad_predict_logit)^2
summarize sqerror_logit
scalar rMSE_logit = sqrt(.0873875)
display rMSE_logit
**d
