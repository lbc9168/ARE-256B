***Question 1***
gen EXPSQ = EXP^2
gen LOGEARNINGS = log(EARNINGS)

**a**
tobit LOGEARNINGS S EXP EXPSQ, ll

**b**
summarize LOGEARNINGS S EXP EXPSQ

**c**
reg LOGEARNINGS S EXP EXPSQ
