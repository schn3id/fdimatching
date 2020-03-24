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
// NOT SURE WE NEED THIS	
	
//	Test overlap with all covariates (logit)
	logit 	FDI2016 i.OWN i.TECH PORT 		///
			logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015
			// Pseudo R² of  0.5652
	predict pscore
	twoway kdensity pscore if FDI2016==0 || kdensity pscore if FDI2016==1, ///
	legend(order(1 "control" 2 "treated")) xtitle("prop. score")	
/*	--> Terrible overlap
	Note: All variables except logwages2015 have a significant influence on 
	treatment status			*/
		
//	Test overlap with all covariates (probit)
	drop pscore
	probit 	FDI2016 i.OWN i.TECH PORT ///
			logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015
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
	1) Non of the models yields satifying overlap. Check if there are varibales
	which perfectly predict treatment status
	2) probit models consistently yield higher R² than logit models for our data
	--> Preference for probit models?
	3) logwages2015 remains insignificant throughout all specifications. 
	When including higher order terms, TFP2015, DEBTS2015 and RD2015 also become
	insignificant. 						*/

* --> Continue narrowing down the model based on descriptive analysis? 

	
********************************************************************************
*					PART 2: Matching
********************************************************************************

*------------------------------------------------------------------------------*
*	PART 2.1: Estimation using psmatching with logit model
*------------------------------------------------------------------------------*

*_________________________________________________________________Complete model
	
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN i.TECH PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015),	///
					  osample(osa1) generate(p1)
					  
	teffects overlap, ptlevel(1) saving($results\overl_log_comp1.gph, replace)
	graph export $results\overl_log_comp1.pdf, as(pdf) replace
	// Catastrophic overlap
	
	tebalance summarize
	// SD catastrophy. VR fine.
	
*____________________________________________Deleting problematic variable: TECH
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015),	///
					  osample(osa1) generate(p1)
					  
	teffects overlap, ptlevel(1) saving($results\overl_log_noTECH.gph, replace)
	graph export $results\overl_log_noTECH.pdf, as(pdf) replace
	// Much better overlap
	
	tebalance summarize
	// SD way below 10% for all variables. VR fine.

*_________________________________________Deleting problematic variable: EXP2015
	cap drop osa1 
	cap drop p1 
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN i.TECH PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 /*EXP2015*/ RD2015),	///
					  osample(osa1) generate(p1)
					  
	teffects overlap, ptlevel(1) saving($results\overl_log_noEXP.gph, replace)
	graph export $results\overl_log_noEXP.pdf, as(pdf) replace
	// Ok overlap except left-hand tail.
	
	tebalance summarize
	// SD still above 20% for TECH. VR fine.

*_______________________________Deleting problematic variables: TECH and EXP2015
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 /*EXP2015*/ RD2015),	///
					  osample(osa1) generate(p1)
					  
	teffects overlap, ptlevel(1) saving($results\overl_log_noTECHEXP.gph, replace)
	graph export $results\overl_log_noTECHEXP.pdf, as(pdf) replace
	// Ok overlap except left-hand tail.
	
	tebalance summarize
	// SD and VR fine.
	
*____________________________Deleting problematic variables: TECH and logemp2015
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 /*logemp2015*/ DEBTS2015 EXP2015 RD2015),	///
					  osample(osa1) generate(p1)
					  
	teffects overlap, ptlevel(1) saving($results\overl_log_noTECHemp.gph, replace)
	graph export $results\overl_log_noTECHemp.pdf, as(pdf) replace
	// Ok overlap, but tails still not so good.
	
	tebalance summarize
	// SD way below 10% for all variables. VR fine.
	
*___________________Deleting problematic variables: TECH, EXP2015 and logemp2015
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 /*logemp2015*/ DEBTS2015 /*EXP2015*/ RD2015),	///
					  osample(osa1) generate(p1)
					  
	teffects overlap, ptlevel(1) saving($results\overl_log_noTECHEXPemp.gph, replace)
	graph export $results\overl_log_noTECHEXPemp.pdf, as(pdf) replace
	// Very good overlap.
	
	tebalance summarize
	// SD very good, VR also fine.	

*------------------------------------------------------------------------------*
*	PART 2.2: Estimation using psmatching with probit model
*------------------------------------------------------------------------------*

*_________________________________________________________________Complete model
	
	cap drop osa1 
	cap drop p1 	
	cap teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN i.TECH PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit),	///
					  osample(osa1) generate(p1)
				   // violation of overlap assumption for 389 obs 	

	// Reestimate			   
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN i.TECH PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit)	///
					  if osa1 == 0
					  
	tebalance summarize
	// SD catastrophy. VR fine.
					  
	teffects overlap, ptlevel(1) saving($results\overl_prob_comp1.gph, replace)
	graph export $results\overl_prob_comp1.pdf, as(pdf) replace
	// Catastrophic overlap
	
	
*____________________________________________Deleting problematic variable: TECH
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, probit),	///
					  osample(osa1) generate(p1)
					  
	teffects overlap, ptlevel(1) saving($results\overl_prob_noTECH.gph, replace)
	graph export $results\overl_prob_noTECH.pdf, as(pdf) replace
	// Much better overlap
	
	tebalance summarize
	// SD way below 10% for all variables. VR fine.

*_________________________________________Deleting problematic variable: EXP2015

	cap drop osa1 
	cap drop p1 
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN i.TECH PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 /*EXP2015*/ RD2015, probit),	///
					  osample(osa1) generate(p1)
					  
	teffects overlap, ptlevel(1) saving($results\overl_prob_noEXP.gph, replace)
	graph export $results\overl_prob_noEXP.pdf, as(pdf) replace
	// Ok overlap except left-hand tail.
	
	tebalance summarize
	// SD not great, some above 10% but none above 20%. VR fine.

*_______________________________Deleting problematic variables: TECH and EXP2015
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 logemp2015 DEBTS2015 /*EXP2015*/ RD2015, probit),	///
					  osample(osa1) generate(p1)
					  
	teffects overlap, ptlevel(1) saving($results\overl_prob_noTECHEXP.gph, replace)
	graph export $results\overl_prob_noTECHEXP.pdf, as(pdf) replace
	// Ok overlap except left-hand tail.
	
	tebalance summarize
	// SD and VR fine.
	
*____________________________Deleting problematic variables: TECH and logemp2015
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 /*logemp2015*/ DEBTS2015 EXP2015 RD2015, probit),	///
					  osample(osa1) generate(p1)
					  
	teffects overlap, ptlevel(1) saving($results\overl_prob_noTECHemp.gph, replace)
	graph export $results\overl_prob_noTECHemp.pdf, as(pdf) replace
	// Ok overlap, but tails still not so good.
	
	tebalance summarize
	// SD way below 10% for all variables. VR fine.
	
*___________________Deleting problematic variables: TECH, EXP2015 and logemp2015
	
	cap drop osa1 
	cap drop p1 
	teffects psmatch (logwages2017) ///
					 (FDI2016 i.OWN /*i.TECH*/ PORT ///
					  logwages2015 TFP2015 /*logemp2015*/ DEBTS2015 /*EXP2015*/ RD2015, probit),	///
					  osample(osa1) generate(p1)
					  
	teffects overlap, ptlevel(1) saving($results\overl_prob_noTECHEXPemp.gph, replace)
	graph export $results\overl_prob_noTECHEXPemp.pdf, as(pdf) replace
	// Very good overlap, left-hand tail still not perfect but acceptable.
	
	tebalance summarize
	// SD very good, VR also fine.			
