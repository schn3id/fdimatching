/*******************************************************************************
								MASTER DO-FILE
********************************************************************************
													   Applied Microeconometrics
															   Empirical Project
																	  Do-File 01
	
		PURPOSE:	Root file that manages the execution of all 
					subordinated do-files.
		
		OUTLINE:	PART 1:	Prepare Folder Paths
					PART 2: Descriptive Analysis
					PART 3: PSM
					
					
********************************************************************************
			PART 1: Prepare Folder Paths
*******************************************************************************/

	clear all

*------------------------------------------------------------------------------*
*	PART 1.1: Set globals for do-file routines
*------------------------------------------------------------------------------*

//	Adjust root file:	
	global root	"C:\Users\schne\Documents\GitHub\fdimatching"

	global temp		"$root\00_temp"
	global input	"$root\01_input"
	global scripts	"$root\02_scripts"
	global output	"$root\03_output"
	global results	"$root\04_results"
	

********************************************************************************
*			PART 2: Descriptive Analysis
********************************************************************************
/*	
	use "$input\FDI_project"
	do "$02_scripts\02_Descriptive Analysis"
	

********************************************************************************
*			PART 3: PSM 
********************************************************************************

	do "$02_scripts\03_PSM"
