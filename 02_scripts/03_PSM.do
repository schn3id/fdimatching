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

//	Check OLS regression (Test with complete model)
	reg logwages2017 FDI2016 i.OWN i.TECH PORT ///
	logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015

*------------------------------------------------------------------------------*
*	PART 1.1: Propensity Score and Kdensity Plots
*------------------------------------------------------------------------------*
	
//	Test overlap with all covariates (logit)
	logit FDI2016 i.OWN i.TECH PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, r
	// Pseudo R² of  0.5652
	predict pscore
	twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
	legend(order(1 "control" 2 "treated")) xtitle("prop. score")	
/*	--> Terrible overlap
	Note: All variables except logwages2015 have a significant influence on 
	treatment status			*/
		
//	Test overlap with all covariates (probit)
	drop pscore
	probit FDI2016 i.OWN i.TECH PORT logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015
	// slight increase in Pseudo R² (= 0.5700)
	predict pscore
	twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
	legend(order(1 "control" 2 "treated")) xtitle("prop. score")	
/*	--> Similarly terrible overlap
	Note: As in the logit model, logwages2015 is the only variable with an
	insignifcant coefficient.			*/

	
/*	Attempt to improve overlap by including square terms (logit)
	--> squaring dummies			*/
	drop pscore
	global D "OWN TECH PORT"
	global C "logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015"
	logit FDI2016 i.($D)##i.($D) $C 
	// Pseudo R² = 0.5669
	predict pscore
	twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
	legend(order(1 "control" 2 "treated")) xtitle("prop. score")	
//	--> Somewhat better overlap but far from good	

/*	Attempt to improve overlap by including square terms (probit)
	--> squaring dummies			*/
	drop pscore
	global D "OWN TECH PORT"
	global C "logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015"
	probit FDI2016 i.($D)##i.($D) $C 
	// Pseudo R² = 0.5718
	predict pscore
	twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
	legend(order(1 "control" 2 "treated")) xtitle("prop. score")	

/*	Attempt to improve overlap by including square terms (logit)
	--> squaring continuous variables			*/
	drop pscore
	global D "OWN TECH PORT"
	global C "logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015"
	logit FDI2016 c.($C)##c.($C) $D
	// Decrease in Pseudo R² (=0.5337)
	predict pscore
	twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
	legend(order(1 "control" 2 "treated")) xtitle("prop. score")	

/*	Attempt to improve overlap by including square terms (probit)
	--> squaring continuous variables			*/
	drop pscore
	global D "OWN TECH PORT"
	global C "logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015"
	probit FDI2016 c.($C)##c.($C) $D
	// Pseudo R² =0.5378
	predict pscore
	twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
	legend(order(1 "control" 2 "treated")) xtitle("prop. score")
	
/*	Attempt to improve overlap by including square terms (logit)
	--> squaring dummies with continuous variables			*/
	drop pscore
	global D "OWN TECH PORT"
	global C "logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015"
	logit FDI2016 $D $C i.($D)#c.($C)
	// Pseudo R² =  0.5814 --> highest so far
	predict pscore
	twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
	legend(order(1 "control" 2 "treated")) xtitle("prop. score")	

/*	Attempt to improve overlap by including square terms (probit)
	--> squaring dummies with continuous variables			*/
	drop pscore
	global D "OWN TECH PORT"
	global C "logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015"
	probit FDI2016 $D $C i.($D)#c.($C)
	// Pseudo R² = 0.5859 
	predict pscore
	twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
	legend(order(1 "control" 2 "treated")) xtitle("prop. score")
	
/*	Attempt to improve overlap by including square terms (logit)
	(squaring all variables)			*/
	drop pscore
	global D "OWN TECH PORT"
	global C "logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015"
	logit FDI2016 i.($D)##i.($D) c.($C)##c.($C) i.($D)#c.($C)
	// Pseudo R² = 0.5942 
	predict pscore
	twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
	legend(order(1 "control" 2 "treated")) xtitle("prop. score")	

/*	Attempt to improve overlap by including square terms (probit)
	(squaring all variables)			*/
	drop pscore
	global D "OWN TECH PORT"
	global C "logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015"
	probit FDI2016 i.($D)##i.($D) c.($C)##c.($C) i.($D)#c.($C)
	// Pseudo R²  0.5986 --> highest so far
	predict pscore
	twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
	legend(order(1 "control" 2 "treated")) xtitle("prop. score")
	
/*	Note: 
	1) probit models consistently yield higher R² than logit models for our data
	--> Preference for probit models?
	2) logwages2015 remains insignificant throughout all specifications. 
	When including higher order terms, TFP2015, DEBTS2015 and RD2015 also become
	insignificant. 
	--> Exlude these in PSM for sure?			*/
	
********************************************************************************
*					PART 2: Matching
********************************************************************************

*------------------------------------------------------------------------------*
*	PART 2.1: Estimation using ... estimator
*------------------------------------------------------------------------------*

global S " i.OWN i.TECH PORT"
global P " logemp2015 DEBTS2015 EXP2015 RD2015 logwages2015"


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
			
		
