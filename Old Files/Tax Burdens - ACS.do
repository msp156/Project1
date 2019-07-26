/*==============================================================================

			Estimating the Tax Burden on TN 
						Using ACS
					
						 by Megha Patel
									
================================================================================*/
import delimited "T:\Tax Burden\Data Collection\PUMS\PUMS RAW DATA 2017.csv"
log using "ACS.3.27.19.txt", replace

*Tell STATA survey type
svyset [pw=wgtp], sdr(wgtp1 - wgtp80) vce(sdr) mse
*Use svy command to check population size 
svy: mean np 
*population size should be 2,903,199

*DATA MANAGEMENT - CREATING VARIABLES
order puma adjhsg adjinc fincp veh valp rntp mrgp
sort puma

*Create New county variable to manipulate larger counties
gen county = puma

order county puma
*___________________________________________________________
*Use the geocorr2018 file to separate the pumas into counties
*EX 100 - Gibson, Dyer, etc
*****For Knox, create a duplicate set for data for 1601 because it counts for 
*Andersen and Union 
*Go into the data editor and copy paste observations for 1601. Then assign new Puma code for duplicate observations
*New County Code = 1611 for Knox County
*Puma County Codes to Aggregate = 1611, 1602, 1603, 1604

*Counties that need Manipulation
*Knox County - Puma Codes 1601, 1602, 1603, 1604
*****For Knox, create a duplicate set for data for 1601 because it counts for 
*Andersen and Union 
*Go into the data editor and copy paste observations for 1601. Then assign new Puma code for duplicate observations
*New County Code = 1611 for Knox County
*___________________________________________________________

recode puma (1611 1602 1603 1604 = 1610) (2401 2402 = 2410) (2501 2502 2503 2504 2505 = 2510) (3201 3202 3203 3204 3205 3206 3207 3208 = 3210)
*Note that you should have duplicated the data for Knox already
*Puma County Codes to Aggregate 
*Knox - 1611, 1602, 1603, 1604
*Rutherford - 2401 and 2042

*Davidson - 2501, 2502, 2503, 2504, 2505
*Shelby - 3201, 3202, 3203, 3204, 3205, 3206, 3207, 3208

*Create variables for Family Income and Prop Value - Check Distribution
gen family_inc = 1.011189*fincp
hist family_inc
*use median

gen prop_value = 1*valp
*replace property values that are missing. These are renters
replace prop_value =.  if prop_value ==0 
hist prop_value
*use median

*drop observations that have no family income to remove anyone with income lower than $1
keep if family_inc >0
keep if family_inc ~=.
*drop obs that have no people in the household. They also have no income to report
keep if np>0
*total 89,854 useable households
*average family size is now 3

*create variables for income brackets
order puma family_inc prop_value veh rntp mrgp

/*INCOME BRACKETS
1-24,999
25,000-49,999
50,000-74,999
75,000-99,999
100,000-199,999
200,000 plus
*/

generate bracket = family_inc
replace bracket= 1 if family_inc<=24999.99 
replace bracket = 2 if family_inc>=25000 
replace bracket =3 if family_inc>=50000 
replace bracket =4 if family_inc>=75000 
replace bracket =5 if family_inc>=100000 
replace bracket =6 if family_inc>=200000

*End Data Management
*========================================================
order puma family_inc bracket prop_value veh rntp mrgp 

*==================================================================
*Command for finding median for family income for each county and bracket
*See if there is a foreach or loop that can do this for all counties

svy: epctile family_inc if puma==100 & bracket==1, percentiles(50)
svy: epctile family_inc if puma==100 & bracket==2, percentiles(50)
svy: epctile family_inc if puma==100 & bracket==3, percentiles(50)
svy: epctile family_inc if puma==100 & bracket==4, percentiles(50)
svy: epctile family_inc if puma==100 & bracket==5, percentiles(50)
svy: epctile family_inc if puma==100 & bracket==6, percentiles(50)

*Outcomes
*1-24,999 -  16,179.02
*25,000-49,999 - 36,503.92
*50,000-74,999 - 61,591.52
*75,000-99,999 - 83,928.69
*100,000-199,999 -  121,342.7
*200,000 plus -  271,302

*===================================================================
*For property values
svy: epctile prop_value if puma==100 & bracket==1, percentiles(50)
svy: epctile prop_value if puma==100 & bracket==2, percentiles(50)
svy: epctile prop_value if puma==100 & bracket==3, percentiles(50)
svy: epctile prop_value if puma==100 & bracket==4, percentiles(50)
svy: epctile prop_value if puma==100 & bracket==5, percentiles(50)
svy: epctile prop_value if puma==100 & bracket==6, percentiles(50)

*Outcomes
*1-24,999 - 60,000 
*25,000-49,999 - 80,000
*50,000-74,999 - 100,000
*75,000-99,999 -  120,000
*100,000-199,999 -   180,000
*200,000 plus -  260,000

*===========================================================
*For Renters - Remember to Multiply by Appraisial Ratios
svy: epctile rntp if puma==100 & bracket==1, percentiles(50)
svy: epctile rntp if puma==200 & bracket==1, percentiles(50)
svy: epctile rntp if puma==300 & bracket==1, percentiles(50)

*And so on........
*===========================================================
*For Mortgages -Remember to Multiply by Appraisial Ratios

svy: epctile mrgp if puma==100 & bracket==2, percentiles(50)
svy: epctile mrgp if puma==100 & bracket==3, percentiles(50)
svy: epctile mrgp if puma==100 & bracket==4, percentiles(50)
svy: epctile mrgp if puma==100 & bracket==5, percentiles(50)
svy: epctile mrgp if puma==100 & bracket==6, percentiles(50)
*===========================================================

*number of SNAP Recipients per county


*Clear


