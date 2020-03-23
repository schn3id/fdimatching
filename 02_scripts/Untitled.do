use C:\Users\schne\Documents\GitHub\fdimatching\01_input\FDI_project.dta, clear


global S " OWN TECH PORT"
global P " logemp2015 DEBTS2015 EXP2015 RD2015 logwages2015"

gen emp2015 = exp(logemp2015)
gen wages2015 = exp(logwages2015)	

global P2 "emp2015 DEBTS2015 EXP2015 RD2015 wages2015"

*normal
cap drop osa1 // overlap balance
cap drop p1 // to save pscore 
*keep wages to controll for pre*
teffects psmatch (logwages2017) (FDI2016 $S $P),  osample(osa1) generate(p1)
teffects overlap, ptlevel(1)  saving(overlap_a1.gph, replace)
graph export overlap_a1.pdf, as(pdf) replace
tebalance summarize


*delogged
cap drop osa1 // overlap balance
cap drop p1 // to save pscore 
*keep wages to controll for pre*
teffects psmatch (logwages2017) (FDI2016 $S $P2),  osample(osa1) generate(p1)
teffects overlap, ptlevel(1)  saving(overlap_a1.gph, replace)
graph export overlap_a1.pdf, as(pdf) replace
tebalance summarize


*c i interaction

cap drop osa1 // overlap balance
cap drop p1 // to save pscore 
*keep wages to controll for pre*
cap teffects psmatch (logwages2017) (FDI2016 i.($S)##c.($P)),  osample(osa1) generate(p1)
teffects psmatch (logwages2017) (FDI2016 i.($S)##c.($P)) if osa1==0,  generate(p1)
teffects overlap, ptlevel(1)  saving(overlap_a1.gph, replace)
graph export overlap_a1.pdf, as(pdf) replace
tebalance summarize

cap drop osa1 // overlap balance
cap drop p1 // to save pscore 
*keep wages to controll for pre*
cap teffects psmatch (logwages2017) (FDI2016 i.($S)##c.($P2)),  osample(osa1) generate(p1)
teffects psmatch (logwages2017) (FDI2016 i.($S)##c.($P2)) if osa1==0,  generate(p1)
teffects overlap, ptlevel(1)  saving(overlap_a1.gph, replace)
graph export overlap_a1.pdf, as(pdf) replace
tebalance summarize

*use  calipher 

cap drop osa1 // overlap balance
cap drop osa2 // overlap balance
cap drop osa3 // overlap balance
cap drop osa4 // overlap balance
cap drop osa5 // overlap balance

cap drop p1 // to save pscore 
*keep wages to controll for pre*
teffects psmatch (logwages2017) (FDI2016 $S $P),  osample(osa1) generate(p1) caliper(0.03)
drop if osa1==1
teffects psmatch (logwages2017) (FDI2016 $S $P) , osample(osa2)  caliper(0.03)
drop if osa2==1
teffects psmatch (logwages2017) (FDI2016 $S $P) , osample(osa3)  caliper(0.03)
drop if osa3==1
teffects psmatch (logwages2017) (FDI2016 $S $P) , osample(osa4)  caliper(0.03)
drop if osa5==1
teffects overlap, ptlevel(1)  saving(overlap_a1.gph, replace)
graph export overlap_a1.pdf, as(pdf) replace
tebalance summarize
