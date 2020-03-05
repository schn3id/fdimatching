clear all

*load data
cd "C:\Users\schne\OneDrive - The University of Nottingham\Dokumente\Studium\MSC\S2\Microectrx\"
use FDI_project.dta


*covariance matrix
corr
*fdi is pos correlated to port, negatively to tech
* positively to prior 2015empl, 2015exp(very), own (weak)
* wages empl exp post
* so likely boosts wages 

*look at categoricals
table OWN
table FDITYPE2016
table TECH



reg logwages2017 FDI2016 logwages2015 i.OWN i.TECH PORT 


logit FDI2016 i.OWN i.TECH i.PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015
predict pscore
twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
legend(order(1 "control" 2 "treated")) xtitle("prop score")


*shows bad overlap, need better X, dont use exports good results 
drop pscore
logit FDI2016 TFP2015 logemp2015 logwages2015 i.PORT i.OWN
predict pscore
twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
legend(order(1 "control" 2 "treated")) xtitle("prop score")

*fun results
/*drop pscore
logit FDI2016 TFP2015 i.PORT i.OWN
predict pscore
twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
legend(order(1 "control" 2 "treated")) xtitle("prop score")
*/


teffects psmatch (logwages2017) (FDI2016 logemp2015 logwages2015 TFP2015  i.PORT i.OWN), nneighbor(3)
tebalance summarize

teffects overlap
