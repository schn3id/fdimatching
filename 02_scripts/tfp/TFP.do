*start log
cap log close
    log using 02_Descriptive_Analysis_tfp, replace

*load data
use C:\Users\schne\Documents\GitHub\fdimatching\01_input\FDI_project.dta, clear

*define globals
global S " OWN PORT"
global P "logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015"



*run ps model without tech 
teffects psmatch (TFP2017) (FDI2016 i.($S) $P),  osample(osa1) generate(p1)
teffects overlap, ptlevel(1)  saving(overlap_normal.gph, replace)
*graph export overlap_a1.pdf, as(pdf) replace
tebalance summarize
cap drop p11
cap drop osa1 // overlap balance

*ps model without tech, with interactions for better ps balance
*keep wages to controll for pre*
teffects psmatch (TFP2017) (FDI2016 i.($S)##c.($P)),  osample(osa1) generate(p1)
teffects overlap, ptlevel(1)  saving(overlap_norm_inter.gph, replace)
*graph export overlap_a1.pdf, as(pdf) replace
tebalance summarize
cap drop osa1 
cap drop p11

* ps matching with 3 neighbours
teffects psmatch (TFP2017) (FDI2016 i.($S) $P), nneighbor(3) osample(osa1) generate(p1) 
teffects overlap, ptlevel(1)  saving(overlap_nn3_norm.gph, replace)
**graph export overlap_a1.pdf, as(pdf) replace
tebalance summarize
cap drop osa1 
cap drop p11-p13 

*ps matching with 3 neighbors with interactions
teffects psmatch (TFP2017) (FDI2016 i.($S)##c.($P)), nneighbor(3) osample(osa1) generate(p1) 
teffects overlap, ptlevel(1)  saving(overlap_nn3_int.gph, replace)
**graph export overlap_a1.pdf, as(pdf) replace
tebalance summarize
cap drop osa1 
cap drop p11-p13 


*caliper 0.05 + NN 5
cap teffects psmatch (TFP2017) (FDI2016 i.($S) $P), osample(osa1) generate(p1) nneighbor(5) caliper(0.05)
drop if osa1==1 /*drop 6 observations*/
drop osa1
teffects psmatch (TFP2017) (FDI2016 i.($S) $P), osample(osa1) generate(p1) nneighbor(5) caliper(0.05)
**graph export overlap_cal_norm.pdf, as(pdf) replace
tebalance summarize
cap drop osa1 // overlap balance
cap drop p11-p15 // to save pscore 



*caliper, NN 5, interactions
teffects psmatch (TFP2017) (FDI2016 i.($S)##c.($P)), osample(osa1) generate(p1) nneighbor(5) caliper(0.05)
drop if osa1==1 /*drop 6 observations*/
drop osa1
drop p11-p15
teffects psmatch (TFP2017) (FDI2016 i.($S)##c.($P)), osample(osa1) generate(p1) nneighbor(5) caliper(0.05)
**graph export overlap_cal_int.pdf, as(pdf) replace
tebalance summarize
drop osa1
drop p11-p15


*AIPW estimator
teffects aipw (TFP2017 i.($S) $P )(FDI2016 i.($S) $P ), osample(osa1) 
**graph export overlap_APIW_norm.pdf, as(pdf) replace
tebalance summarize
drop osa1

*AIPW with interactions
teffects aipw (TFP2017 i.($S)##c.($P) )(FDI2016 i.($S)##c.($P)), osample(osa1) 
*graph export overlap_APIW_int.pdf, as(pdf) replace
tebalance summarize
drop osa1


*AIPW bt type
teffects aipw (TFP2017  i.($S) c.($P) )(FDITYPE2016  i.($S) c.($P) ) , osample(osa1)
tebalance summarize
*teffects overlap, ptlevel(1) saving(overlap_type_m1.gph, replace)
*teffects overlap, ptlevel(2) saving(overlap_type_m2.gph, replace)
*teffects overlap, ptlevel(3) saving(overlap_type_m3.gph, replace)
drop osa1


*AIPW by type, with interactions
teffects aipw (TFP2017  i.($S)##c.($P) )(FDITYPE2016  i.($S)##c.($P) ) , osample(osa1)
tebalance summarize
teffects overlap, ptlevel(1) saving(overlap_type_m1.gph, replace)
teffects overlap, ptlevel(2) saving(overlap_type_m2.gph, replace)
teffects overlap, ptlevel(3) saving(overlap_type_m3.gph, replace)
drop osa1

log close

mlogit FDITYPE2016  i.($S) c.($P) i.TECH

