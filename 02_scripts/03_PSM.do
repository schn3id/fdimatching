/*******************************************************************************
								PSM DO-FILE
********************************************************************************
Applied Microeconometrics
															   Empirical Project
																	  Do-File 03
		
		PURPOSE:	Perform Propensity Score Matching
		
		OUTLINE:	PART 1:	Test for Overlap
					PART 2: Matching
					PART 3: Tests
										
********************************************************************************
					PART 1: Test for Overlap
*******************************************************************************/

//	Check OLS regression (Test)
	reg logwages2017 FDI2016 logwages2015 i.OWN i.TECH PORT 


*------------------------------------------------------------------------------*
*	PART 1.1: Propensity score and Kdensity plot
*------------------------------------------------------------------------------*	
	
//	Test overlap with all covariates
	logit FDI2016 i.OWN i.TECH PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015
	predict pscore
	twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
	legend(order(1 "control" 2 "treated")) xtitle("prop. score")	
//	--> Terrible overlap
	

//	Test overlap dropping EXP2015 
	drop pscore
	
	logit FDI2016 i.OWN i.TECH PORT logwages2015 TFP2015 logemp2015 DEBTS2015 RD2015
	predict pscore
	twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
	legend(order(1 "control" 2 "treated")) xtitle("prop. score")
//	--> Better but not great

	
//	Test overlap dropping EXP2015 and TECH
	drop pscore
	
	logit FDI2016 i.OWN PORT logwages2015 TFP2015 logemp2015 DEBTS2015 RD2015
	predict pscore
	twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
	legend(order(1 "control" 2 "treated")) xtitle("prop. score")

//	--> Best overlap with most complete model


//	Test overlap dropping EXP2015, TECH, TFP2015, DEBTS2015 and RD2015
	drop pscore
	
	logit FDI2016 i.OWN PORT logwages2015 logemp2015 
	predict pscore
	twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
	legend(order(1 "control" 2 "treated")) xtitle("prop. score")
//	--> Best Overlap overall (though not that different from the one before)	


//	Test overlap dropping EXP2015, TECH, logwages2015, logemp2015, DEBTS2015 and RD2015
	drop pscore
	
	logit FDI2016 i.OWN PORT  TFP2015  
	predict pscore
	twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
	legend(order(1 "control" 2 "treated")) xtitle("prop. score")
//	--> Fun result (bc of dropping logemp2015)



*------------------------------------------------------------------------------*
*	PART 1.2: Covariate Balancing Tests
*------------------------------------------------------------------------------*

// Frequency distribution of treated and control units across the strata

// Divide into quintiles
// Has to be after actual logit estimation determining pscore 
xtile strata=pscore, n(5)
save FDI_project_working, replace

// Replicating table on slide 23 
summarize pscore FDI2016 if strata==1
summarize pscore FDI2016 if strata==1 & FDI2016==0
summarize pscore FDI2016 if strata==1 & FDI2016==1
summarize pscore FDI2016 if strata==2
summarize pscore FDI2016 if strata==2 & FDI2016==0
summarize pscore FDI2016 if strata==2 & FDI2016==1
summarize pscore FDI2016 if strata==3
summarize pscore FDI2016 if strata==3 & FDI2016==0
summarize pscore FDI2016 if strata==3 & FDI2016==1
summarize pscore FDI2016 if strata==4
summarize pscore FDI2016 if strata==4 & FDI2016==0
summarize pscore FDI2016 if strata==4 & FDI2016==1
summarize pscore FDI2016 if strata==5
summarize pscore FDI2016 if strata==5 & FDI2016==0
summarize pscore FDI2016 if strata==5 & FDI2016==1


********************************************************************************
*					PART 2: Matching
********************************************************************************

*------------------------------------------------------------------------------*
*	PART 2.1: Estimation using ... estimator
*------------------------------------------------------------------------------*

	global CAT " OWN  PORT"
	global CON " logemp2015 DEBTS2015 RD2015 logwages2015"
	global DIF "TECH EXP2015"


*smol model
 cap drop osa1 // overlap balance
cap drop p1 // to save pscore 
*keep wages to controll for pre*
teffects psmatch (logwages2017) (FDI2016 logemp2015 logwages2015  TFP2015  i.PORT i.OWN),  osample(osa1) generate(p1)
teffects overlap, ptlevel(1)  saving(overlap_a1.gph, replace)
graph export overlap_a1.pdf, as(pdf) replace
tebalance summarize

*big model


 cap drop osa1 // overlap balance
cap drop p1 // to save pscore 
teffects psmatch (logwages2017) (FDI2016  i.TECH i.PORT logemp2015 DEBTS2015 EXP2015 RD2015 logwages2015),  osample(osa1) generate(p1)
teffects overlap, ptlevel(1)  saving(overlap_a1.gph, replace)
graph export overlap_a1.pdf, as(pdf) replace
tebalance summarize

	
*------------------------------------------------------------------------------*
*	PART 2.2: Estimation using psmatching with probit estimator
*------------------------------------------------------------------------------*

cap drop osa1 // overlap balance
cap drop p1 // to save pscore 
teffects psmatch (logwages2017) (FDI2016 logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN, probit), osample(osa1) generate(p1)
teffects overlap, ptlevel(1)  saving(overlap_a1.gph, replace)
graph export overlap_a1.pdf, as(pdf) replace
tebalance summarize	
			
cap drop osa1 // overlap balance
cap drop p1 // to save pscore 
teffects psmatch (logwages2017) (FDI2016 logemp2015 logwages2015  TFP2015 c.EXP2015##c.EXP2015 i.PORT i.OWN, probit), osample(osa2) generate(p2)
teffects overlap, ptlevel(1)  saving(overlap_a1.gph, replace)
graph export overlap_a1.pdf, as(pdf) replace
tebalance summarize			
			
generate logexp2015 = log(EXP2015)

cap drop osa1 // overlap balance
cap drop p1 // to save pscore 
cap teffects psmatch (logwages2017) (FDI2016 logemp2015 logwages2015  TFP2015 logexp2015 i.PORT i.OWN, probit), osample(osa3) generate(p3)
teffects psmatch (logwages2017) (FDI2016 logemp2015 logwages2015  TFP2015 logexp2015 i.PORT i.OWN, probit) if osa3==0, generate (p3) 
teffects overlap, ptlevel(1)  saving(overlap_a1.gph, replace)
graph export overlap_a1.pdf, as(pdf) replace
tebalance summarize				
			
*Interactions for better pscores*			
			
cap drop osa1 // overlap balance
cap drop p1 // to save pscore 
teffects psmatch (logwages2017) (FDI2016   c.($P)#i.($S) ) if osa1=0 ,  osample(osa1) generate(p1)
teffects overlap, ptlevel(1)  saving(overlap_a1.gph, replace)
graph export overlap_a1.pdf, as(pdf) replace
tebalance summarize
			
cap teffects psmatch (logwages2017) (FDI2016 logemp2015 logwages2015  TFP2015 logexp2015 i.PORT i.OWN, probit), osample(osa3) generate(p3)
teffects psmatch (logwages2017) (FDI2016 logemp2015 logwages2015  TFP2015 logexp2015 i.PORT i.OWN, probit) if osa3==0, generate (p3) 
teffects overlap, ptlevel(1)  saving(overlap_a1.gph, replace)
graph export overlap_a1.pdf, as(pdf) replace
tebalance summarize				
			
*Interactions for better pscores*			


		
cap drop osa1 // overlap balance
cap drop p1 // to save pscore 
teffects psmatch (logwages2017) (FDI2016   c.($P)#i.($S)#i.($S) ) if OWN!=4,  osample(osa1) generate(p1)
teffects overlap, ptlevel(1)  saving(overlap_a1.gph, replace)
graph export overlap_a1.pdf, as(pdf) replace
tebalance summarize
				

*constructing pscores
cap drop pscore
logit FDI2016  i.($S)##c.($P) c.($P)##c.($P)
predict pscore			
twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
legend(order(1 "control" 2 "treated")) xtitle("prop. score")			





cap drop pscore
logit FDI2016  i.OWN##i.TECH i.PORT i.TECH c.EXP2015 c.logemp2015  DEBTS2015	RD2015
predict pscore			
twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
legend(order(1 "control" 2 "treated")) xtitle("prop. score")			


cap drop pscore
logit FDI2016  i.OWN i.TECH i.PORT i.TECH c.EXP2015 c.logemp2015##c.logemp2015  c.DEBTS2015##c.DEBTS2015	RD2015
predict pscore			
twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
legend(order(1 "control" 2 "treated")) xtitle("prop. score")			




*lets use AIPW* 
cap drop osa1
cap teffects aipw (logwages2017 c.($P) i.($S))(FDI2016 c.($P) i.($S)  ) , ///
osample(osa1) 
teffects aipw (logwages2017 c.($P) i.($S))(FDI2016 c.($P) i.($S)  ) if osa1==0
teffects overlap
tebalance summarize

cap drop osa1
teffects aipw (logwages2017  logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH) ///
(FDI2016 logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH) if TECH!=4 , osample(osa1) 
*teffects aipw (logwages2017  logemp2015 logwages2015  TFP2015 logexp2015 i.PORT i.OWN i.TECH)///
*(FDI2016 logemp2015 logwages2015  TFP2015 logexp2015 i.PORT i.OWN i.TECH) if osa1==0
teffects overlap 
tebalance summarize


*------------------------------------------------------------------------------*
*	PART 2.3: Estimation using psmatching with probit estimator: WAGES
 ATT, ATE, ATN in FDITYPES model without interactions
*------------------------------------------------------------------------------*

cap drop osa1
teffects aipw (logwages2017  logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH) ///
(FDITYPE2016 logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH) if TECH!=4 , osample(osa1)
 
teffects aipw (logwages2017  logemp2015 logwages2015  TFP2015 logexp2015 i.PORT i.OWN i.TECH)///
(FDITYPE2016 logemp2015 logwages2015  TFP2015 logexp2015 i.PORT i.OWN i.TECH) if osa1==0
teffects overlap 
tebalance summarize

*ATET is not possible for AIWP
****----------------------------------IPW--------------------------------------*
cap drop 
osa1 teffects ipw (logwages2017  logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH)(FDITYPE2016 logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH) if FDITYPE!=0  , osample(osa1) 
**
 cap drop osa1 
 teffects ipw (logwages2017)(FDI2016 logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH), osample(osa1)
**by FDITYPE2016: ATE
 cap drop osa1
 teffects ipw (logwages2017)(FDITYPE2016 logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH) if osa1==0
**by FDITYPE2016: ATET: negative results 
 cap drop osa1
 teffects ipw (logwages2017)(FDITYPE2016 logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH),atet osample(osa1)
****----------------------------------RA--------------------------------------*
**by FDITYPE2016: ATE
cap drop osa1 
teffects ra (logwages2017  logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH)(FDITYPE2016)
**by FDITYPE2016: ATET: positive results 
teffects ra (logwages2017  logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH)(FDITYPE2016),atet


*------------------------------------------------------------------------------*
*	PART 2.3: Estimation using psmatching with probit estimator: TFP2017
 ATT, ATE, ATN in FDITYPES model without interactions
*------------------------------------------------------------------------------*

cap drop osa1
teffects aipw (TFP2017  logemp2015 logwages2015 TFP2015 EXP2015 i.PORT i.OWN i.TECH)(FDITYPE2016 logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH) if TECH!=4 , osample(osa1)
 
teffects aipw (TFP2017  logemp2015 logwages2015  TFP2015 logexp2015 i.PORT i.OWN i.TECH)///
(FDITYPE2016 logemp2015 logwages2015  TFP2015 logexp2015 i.PORT i.OWN i.TECH) if osa1==0
teffects overlap 
tebalance summarize

*ATET is not possible for AIWP
****----------------------------------IPW--------------------------------------*
cap drop 
osa1 teffects ipw (TFP2017  logemp2015 logwages2015 TFP2015 EXP2015 i.PORT i.OWN i.TECH)(FDITYPE2016 logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH) if FDITYPE!=0  , osample(osa1) 
**
 cap drop osa1 
 teffects ipw (TFP2017)(FDI2016 logemp2015 logwages2015 TFP2015 EXP2015 i.PORT i.OWN i.TECH), osample(osa1)
**by FDITYPE2016: ATE
 cap drop osa1
 teffects ipw (TFP2017)(FDITYPE2016 logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH) if osa1==0
**by FDITYPE2016: ATET: negative results 
 cap drop osa1
 teffects ipw (TFP2017)(FDITYPE2016 logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH),atet osample(osa1)
****----------------------------------RA--------------------------------------*
**by FDITYPE2016: ATE
cap drop osa1 
teffects ra (TFP2017  logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH)(FDITYPE2016)
**by FDITYPE2016: ATET: positive results 
teffects ra (TFP2017  logemp2015 logwages2015  TFP2015 EXP2015 i.PORT i.OWN i.TECH)(FDITYPE2016),atet


								
