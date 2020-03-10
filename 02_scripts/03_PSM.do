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

global S " i.OWN i.TECH PORT"
global P " logemp2015 DEBTS2015 EXP2015 RD2015 logwages2015"


*smol model
 cap drop osa1 // overlap balance
cap drop p1 // to save pscore 
teffects psmatch (logwages2017) (FDI2016 logemp2015 logwages2015 TFP2015  i.PORT i.OWN),  osample(osa1) generate(p1)
teffects overlap, ptlevel(1)  saving(overlap_a1.gph, replace)
graph export overlap_a1.pdf, as(pdf) replace
tebalance summarize

*big model


 cap drop osa1 // overlap balance
cap drop p1 // to save pscore 
teffects psmatch (logwages2017) (FDI2016 $S $P ),  osample(osa1) generate(p1)
teffects overlap, ptlevel(1)  saving(overlap_a1.gph, replace)
graph export overlap_a1.pdf, as(pdf) replace
tebalance summarize
	*this is a change 
	*this is another change
	
*------------------------------------------------------------------------------*
*	PART 2.2: Estimation using ... estimator
*------------------------------------------------------------------------------*

			
			
			
			
			
			
			
			
			
			
			
			
