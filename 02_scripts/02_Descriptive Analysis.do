/*******************************************************************************
						DESCRIPTIVE ANALYSIS DO-FILE
********************************************************************************
													   Applied Microeconometrics
															   Empirical Project
																	  Do-File 02
		
		PURPOSE:	Analysis of Data Set
		
		OUTLINE:	PART 1:	Overview
					PART 2: Balance Tests
					PART 3: 
					
********************************************************************************
					PART 1: Overview
*******************************************************************************/
	
	describe
	
//	Check categoricals
	tab OWN
	tab FDITYPE2016
	tab TECH

//	Covariance matrix
	corr	
/*	--> fdi is pos correlated to PORT, negatively to TECH
	--> pos. to logemp2015, EXP2015, logwages2017, logemp2017 and EXP2017	*/
	

********************************************************************************
*					PART 2: Balance Tests
********************************************************************************

*------------------------------------------------------------------------------*
*	PART 2.1: Pre-Treatment
*------------------------------------------------------------------------------*

//			By treatment variable
iebaltab 	logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, ///
			grpvar(FDI2016) save($results\baltest_bygroup_pre.xlsx)

/*	--> Significant differnces betw. treatment and control group in all
		respects even before treatment. 	*/
		
//			By FDI type (treatment arms)
iebaltab 	logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, ///
			grpvar(FDITYPE2016) save($results\baltest_bytype_pre.xlsx)	

			
//	Density plots comparing tratment and control groups for selected varaibles
//	Export intensity			
	twoway kdensity EXP2015 if FDI2016==0 || kdensity EXP2015 if FDI2016==1, ///
	legend(order(1 "control" 2 "treated"))

//	Firm size	
	twoway kdensity logemp2015 if FDI2016==0 || kdensity logemp2015 if FDI2016==1, ///
	legend(order(1 "control" 2 "treated"))			
			
			
*------------------------------------------------------------------------------*
*	PART 2.1: Post-Treatment
*------------------------------------------------------------------------------*

//			By treatment variable
iebaltab 	logwages2017 TFP2017 logemp2017 EXP2017 RD2017, ///
			grpvar(FDI2016) save($results\baltest_bygroup_post.xlsx)

//			By FDI type (treatment arms)
iebaltab 	logwages2017 TFP2017 logemp2017 EXP2017 RD2017, ///
			grpvar(FDITYPE2016) save($results\baltest_bygroup_post.xlsx)
					
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			