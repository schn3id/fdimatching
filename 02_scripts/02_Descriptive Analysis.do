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
*	PART 2.1: Overlap of pre-treatement variables
*------------------------------------------------------------------------------*
//	Density plots comparing tratment and control groups for selected varaibles
		
//	OWN 
	tab2 OWN FDI2016, col
	twoway kdensity OWN if FDI2016==0 || kdensity OWN if FDI2016==1, ///
	legend(order(1 "control" 2 "treated"))
	// Good overlap, except for listed companies, which have received less FDI
	
//	TECH 
	tab2 TECH FDI2016, col
	twoway kdensity TECH if FDI2016==0 || kdensity TECH if FDI2016==1, ///
	legend(order(1 "control" 2 "treated"))	
	/* Low-tech firms seem to be more likely to get FDI than high-tech firms
	 --> Significant imbalance, might cause trouble if prediciton is "too good"		*/
	
//	PORT 
	tab2 PORT FDI2016, col
	twoway kdensity PORT if FDI2016==0 || kdensity PORT if FDI2016==1, ///
	legend(order(1 "control" 2 "treated"))	
	// Firms without port seem to be less likely to receive FDI

//	logwages2015 
	twoway kdensity logwages2015 if FDI2016==0 || kdensity logwages2015 if FDI2016==1, ///
	legend(order(1 "control" 2 "treated"))	
	// Almost perfect overlap

//	TFP2015 
	twoway kdensity TFP2015 if FDI2016==0 || kdensity TFP2015 if FDI2016==1, ///
	legend(order(1 "control" 2 "treated"))	
	// Almost perfect overlap

//	logemp2015 
	twoway kdensity logemp2015 if FDI2016==0 || kdensity logemp2015 if FDI2016==1, ///
	legend(order(1 "control" 2 "treated"))	
	// Decent overlap, only few control obs at left-hand tail without overlap
	
//	DEBTS2015 
	twoway kdensity DEBTS2015 if FDI2016==0 || kdensity DEBTS2015 if FDI2016==1, ///
	legend(order(1 "control" 2 "treated"))	
	// Almost perfect overlap
	
//	EXP2015 
	xtile EXP2015_index5=EXP2015, n(5)
	tab2 EXP2015_index5 FDI2016, col
	twoway kdensity EXP2015 if FDI2016==0 || kdensity EXP2015 if FDI2016==1, ///
	legend(order(1 "control" 2 "treated"))
	// Not the best overlap --> no overlap at right hand tail 
	
//	RD2015
	twoway kdensity RD2015 if FDI2016==0 || kdensity RD2015 if FDI2016==1, ///
	legend(order(1 "control" 2 "treated"))	
	// Decent overlap
	
	
*------------------------------------------------------------------------------*
*	PART 2.2: Balance test of pre-treatment variables
*------------------------------------------------------------------------------*	
//			By treatment variable
iebaltab 	TECH PORT ///
			logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, ///
			grpvar(FDI2016) save($results\baltest_byfdi_pre.xlsx) replace

/*	--> Significant differnces betw. treatment and control group in all
		respects even before treatment. 	*/
		
//			By FDI type (treatment arms)
iebaltab 	TECH PORT ///
			logwages2015 TFP2015 logemp2015 DEBTS2015 EXP2015 RD2015, ///
			grpvar(FDITYPE2016) save($results\baltest_byfditype_pre.xlsx) replace

			
	
	
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			