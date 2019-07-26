/*==============================================================================

			Estimating the Tax Burden on TN 
						Using ACS
					
						 by Megha Patel
									
================================================================================*/
import delimited "T:\Tax Burden\Data Collection\PUMS\PUMS RAW DATA 2017.csv"
log using "ACS.4.3.19.txt", replace
save "T:\Tax Burden\Data Collection\PUMS\ACS 4.3.19.dta"


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

*Sullivan county - 1000 and 1100
*Counties that need Manipulation
*Knox County - Puma Codes 1601, 1602, 1603, 1604
*****For Knox, create a duplicate set for data for 1601 because it counts for 
*Andersen and Union 
*Go into the data editor and copy paste observations for 1601. Then assign new Puma code for duplicate observations
*New County Code = 1611 for Knox County
*___________________________________________________________

recode puma (1001 1100 = 1010)(1611 1602 1603 1604 = 1610) (2001 2002 2003 = 2010)(2401 2402 = 2410) (2501 2502 2503 2504 2505 = 2510) (3201 3202 3203 3204 3205 3206 3207 3208 = 3210)
*Note that you should have duplicated the data for Knox already
*Puma County Codes to Aggregate 
*Sullivan - 1001, 1100
*Sullivan county overlaps with another county. Seclect 1000 and copy and reassign puma
*Knox - 1611, 1602, 1603, 1604
*Rutherford - 2401 and 2042
*Davidson - 2501, 2502, 2503, 2504, 2505
*Shelby - 3201, 3202, 3203, 3204, 3205, 3206, 3207, 3208
*Hamilton - 2001, 2002, 2003
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

replace bracket= 1 if family_inc <= 24999.99
replace bracket = 2 if family_inc>=25000 
replace bracket =3 if family_inc>=50000 
replace bracket =4 if family_inc>=75000 
replace bracket =5 if family_inc>=100000 
replace bracket =6 if family_inc>=200000

*Check results
tab puma bracket



*End Data Management
*========================================================
order puma family_inc bracket prop_value veh rntp mrgp 

*==================================================================
*Command for finding median for family income for each county and bracket
*See if there is a foreach or loop that can do this for all counties

svy: epctile family_inc if bracket==1, percentiles(50) over (puma)
svy: epctile family_inc if bracket==2, percentiles(50) over (puma)
svy: epctile family_inc if bracket==3, percentiles(50) over (puma)
svy: epctile family_inc if bracket==4, percentiles(50) over (puma)
svy: epctile family_inc if bracket==5, percentiles(50) over (puma)
svy: epctile family_inc if bracket==6, percentiles(50) over (puma)


svy: epctile family_inc if puma==100 & bracket==1, percentiles(50) 
*Outcomes
*1-24,999 -  16,179.02
*25,000-49,999 - 36,503.92
*50,000-74,999 - 61,591.52
*75,000-99,999 - 83,928.69
*100,000-199,999 -  121,342.7
*200,000 plus -  271,302

*===================================================================
*For property values

svy: epctile prop_value if bracket==1, percentiles(50) over (puma)
svy: epctile prop_value if bracket==2, percentiles(50) over (puma)
svy: epctile prop_value if bracket==3, percentiles(50) over (puma)
svy: epctile prop_value if bracket==4, percentiles(50) over (puma)
svy: epctile prop_value if bracket==5, percentiles(50) over (puma)
svy: epctile prop_value if bracket==6, percentiles(50) over (puma)

*Outcomes
*1-24,999 - 60,000 
*25,000-49,999 - 80,000
*50,000-74,999 - 100,000
*75,000-99,999 -  120,000
*100,000-199,999 -   180,000
*200,000 plus -  260,000

*===========================================================
*For Renters - Remember to Multiply by Appraisial Ratios

svy: epctile rntp if bracket==1, percentiles(50) over (puma)


*And so on........
*===========================================================
*For Mortgages -Remember to Multiply by Appraisial Ratios


svy: epctile mrgp if bracket==2, percentiles(50) over (puma)
svy: epctile mrgp if bracket==3, percentiles(50) over (puma)
svy: epctile mrgp if bracket==4, percentiles(50) over (puma)
svy: epctile mrgp if bracket==5, percentiles(50) over (puma)
svy: epctile mrgp if bracket==6, percentiles(50) over (puma)

*===============================================================================

*===============================================================================
*Average number of vehicles per county by income bracket

svy: mean veh if bracket==1, over(puma)
svy: mean veh if bracket==2, over(puma)
svy: mean veh if bracket==3, over(puma)
svy: mean veh if bracket==4, over(puma)
svy: mean veh if bracket==5, over(puma)
svy: mean veh if bracket==6, over(puma)

*Export Results to Excel

putexcel set "Results - STATA.xlsx"
*===============================================================================

*Manipulate IRS Data
import excel "T:\Tax Burden\Data Collection\IRS\IRS 2016 Manipulated.xlsx", sheet("Sheet1")

 drop in 1
 
 rename A County
 rename B Bracket_Qual
 rename C n_returns
 rename D r_amounts
 rename E s_tax
 rename F Bracket
 
 drop G H I
 
 save "T:\Tax Burden\IRS Data Manipulated 4.8.19.dta"
 
 *clear
 
 *Import Appraisial Ratios
 

 import excel "T:\Tax Burden\Data Collection\Excel - Appraisial Ratios.xlsx", sheet("Sheet1")

*save file

 drop in 1

 rename A County
 rename B A_Ratio
 rename C Pop_Count

 save "T:\Tax Burden\Data Collection\Appraisial Ratios.dta"
 
clear

use "T:\Tax Burden\IRS Data Manipulated 4.8.19.dta"

merge m:1 County using "T:\Tax Burden\Data Collection\Appraisial Ratios.dta"

*drop variables that are not needed. Only should have 570 
drop in 573
drop in 573
*replace values for DeKalb and MicMinn. THey did not come in correctly for A_ratio
*and pop count
drop in 571
drop in 571
drop in 571
drop in 571

drop _merge

*Label Variables
label variable Bracket_Qual " income for brackets"
label variable n_returns "number of returns"
label variable r_amounts "amount in returns"
label variable s_tax "sales tax"
label variable Bracket "Income bracket 1, 2, 3, 4, 5, 6"
label variable A_Ratio "Appraisal ratio for the county"
label variable Pop_Count "population count for the county"
label variable _merge "merge. keep for record"

save "T:\Tax Burden\IRS Data And A Ratios Merge 4.8.19.dta"

*===============================================================================

*Second Merge

import delimited "T:\Tax Burden\Data Collection\PUMS\PUMS Data Interpretations\geocorr2018.csv"


clear
 import excel "T:\Tax Burden\Data Collection\GEO Corr Cleaned.xlsx", sheet("Sheet1")
rename A puma
rename B county
rename C Pop_Count

drop in 1

 save "T:\Tax Burden\Data Collection\GeoCorr2018 STATA.dta", replace
 
use "T:\Tax Burden\IRS Data And A Ratios Merge 4.8.19.dta"
merge m:1 Pop_Count using "T:\Tax Burden\Data Collection\GeoCorr2018 STATA.dta"
*cleaned data set using orignal geocorr file. Data came in for counties that were not recoded previously
keep County Bracket_Qual n_returns r_amounts s_tax Bracket A_Ratio Pop_Count puma county 

 
drop _merge

save "T:\Tax Burden\IRS Data And A Ratios Merge 4.8.19.dta", replace
*This is the file that you can use to merge with the results from the ACS file. 


*================================================================================

*Third Merge
import excel "T:\Tax Burden\ACS Results Cleaned.xlsx", sheet("Sheet1")
rename A bracket
rename B puma
rename C family_inc
rename D prop_value
rename E prop_tax
rename F vehicle

label variable bracket " income bracket"
label variable puma "puma"
label variable family_inc "family income"
label variable prop_value "property value"
label variable prop_tax "property tax"
label variable vehicle "number of vehicles"

drop in 1

save "T:\Tax Burden\ACS Results.dta", replace

use "T:\Tax Burden\IRS Data And A Ratios Merge 4.8.19.dta"
 
merge m:1 bracket puma using "T:\Tax Burden\ACS Results.dta"

drop _merge
save "T:\Tax Burden\MERGED ACS Appraisial IRS.dta"

*you now have the merged IRS, ACS, population, and ACS Data. 
*Variables in the set
/*
County
puma
bracket_qual
n_returns
r_amounts
sales tax
bracket (1 2 3 4 5 6)
a_ratio
pop_count
county
family_inc
prop_value
vehicle

*/
*let's create the final property tax variable
*Note that you have to create the final property tax variable
*===============================================================================

*let's create a data set for the CES Survey
*We want to have numbers for the grocery tax and the motor oil tax that 
*will be combined with wheel tax
*You must scrap wheel tax from the website later. 2018 is still not available when
*this do file was created

*The Numbers for the CES Survey are dependent on the urban consumer unit for the county
*most counties are below 100,000, but some are higher
*have to segment out counties based on their population


use "T:\Tax Burden\MERGED ACS Appraisial IRS.dta"

*destring all variables that should be numeric. 


destring family_inc, replace
destring n_returns, replace
destring r_amounts, replace
destring s_tax, replace
destring bracket, replace
destring A_Ratio, replace
destring Pop_Count, replace
destring puma, replace
destring prop_value, replace
destring prop_tax, replace
destring vehicle, replace

label variable County "county variable name"
label variable Bracket_Qual "income brackets qualitative"
label variable n_returns "number of returns"
label variable r_amounts "amount in returns"
label variable s_tax "sales tax"
label variable bracket "bracket numeric"
label variable A_Ratio "appraisial ratio"
label variable Pop_Count "population count"
label variable puma "puma code"
label variable county "county variable used in merge"
label variable urban_unit "urban consumer unit 1 2 3"


*Now generate a variable to segement out counties by urban consumer unit
generate urban_unit = Pop_Count
replace urban_unit = 1 if Pop_Count <= 99999
replace urban_unit = 2 if Pop_Count>=100000
replace urban_unit =3 if Pop_Count>=250000
replace urban_unit =4 if Pop_Count>= 1000000
replace urban_unit =5 if Pop_Count>=2500000
replace urban_unit =6 if Pop_Count>=5000000

*Note that you will only use 1, 2 and 3 in the analysis
tab urban_unit
*check to see if it is correct

save "T:\Tax Burden\MERGED ACS Appraisial IRS.dta", replace

*We need a new variables for food costs and a sparate variable for gasoline cost
*These will be used to assign gasoline costs to the counties
*Numbers for  urban consumer unit

/* 1 - Less than 100,000
2 - 100,000 to 249,999
3 - 250,000 to 999,999
*/

*For variation in grocery tax
 *((Total Spent on Food at home-Total Spent on Food at Home and Away))/(Difference between highest and lowest Income Bracket Per PUMA)
 
*Cleaned a dataset in Excel and import for Grocery Tax and Gasoline Tax
import excel "T:\Tax Burden\Grocery and Automobile Tax.xlsx", sheet("Sheet1") clear
save "T:\Tax Burden\Grocery and Automobile Tax.dta"
rename A bracket
rename B urban_unit
rename C g_tax
rename D gas_tax

label variable bracket " income bracket"
label variable urban_unit " urban consumer unit"
label variable g_tax "grocery tax"
label variable gas_tax "gas tax"
drop in 1

destring bracket, replace
destring urban_unit, replace
destring g_tax, replace
destring gas_tax, replace
save "T:\Tax Burden\Grocery and Automobile Tax.dta", replace

use "T:\Tax Burden\MERGED ACS Appraisial IRS.dta"

merge m:1 bracket urban_unit using "T:\Tax Burden\Grocery and Automobile Tax.dta"

drop _merge

*create final sales tax variable
egen sales_tax = rowtotal(g_tax s_tax)
*final property tax variable
gen property_tax = A_Ratio*prop_tax

*final automobile variable
order County puma family_inc prop_value property_tax sales_tax
save "T:\Tax Burden\MERGED ACS Appraisial IRS Grocery Gas.dta"

*================================================================================
*Is wheel tax data ready? - Yes
*note that some of the numbers for wheel taxes are coming from the county's financial reports

*Shelby
*Hamilton
*Davidson
*Knox
*McMinn
*Moore

*import scrap file
import excel "T:\Tax Burden\Data Collection\Sales Tax Data\Wheel Tax Final Scrap.xlsx", sheet("Sheet1")

rename A County
rename B wheel_tax_total
drop C D E
drop in 1

label variable county "county"
label variable wheel_tax_total "total wheel tax in the county"

save "T:\Tax Burden\Wheel Tax Scrap.dta", replace

clear

use "T:\Tax Burden\MERGED ACS Appraisial IRS Grocery Gas.dta"


merge m:1 County using "T:\Tax Burden\Wheel Tax Scrap.dta"
*MicMinn did not come in properly

drop in 571
drop _merge

destring wheel_tax_total, replace 
generate wheel_tax_ind = wheel_tax_total/Pop_Count

*generate new variable to sum wheel tax and gasoline
*first multiply wheel tax by number of cars
gen wheel_veh = wheel_tax_ind*vehicle
egen auto_tax = rowtotal(wheel_veh gas_tax)
egen total_tax_burden = rowtotal(auto_tax property_tax sales_tax)

save "T:\Tax Burden\MERGED ACS Appraisial IRS Grocery Gas.dta", replace
*convert total tax amount to percent 
gen tax_percent = (total_tax_burden/family_inc)*100

gen after_tax_inc = family_inc-total_tax_burden

*create progressivty values
*install progres

log using "Progres.txt"

progres family_inc after_tax_inc if counties==1
progres family_inc after_tax_inc if counties==2
progres family_inc after_tax_inc if counties==3
progres family_inc after_tax_inc if counties==4
progres family_inc after_tax_inc if counties==5
progres family_inc after_tax_inc if counties==6
progres family_inc after_tax_inc if counties==7
progres family_inc after_tax_inc if counties==8
progres family_inc after_tax_inc if counties==9
progres family_inc after_tax_inc if counties==10
progres family_inc after_tax_inc if counties==11
progres family_inc after_tax_inc if counties==12
progres family_inc after_tax_inc if counties==13
progres family_inc after_tax_inc if counties==14
progres family_inc after_tax_inc if counties==15
progres family_inc after_tax_inc if counties==16
progres family_inc after_tax_inc if counties==17
progres family_inc after_tax_inc if counties==18
progres family_inc after_tax_inc if counties==19
progres family_inc after_tax_inc if counties==20
progres family_inc after_tax_inc if counties==21
progres family_inc after_tax_inc if counties==22
progres family_inc after_tax_inc if counties==23
progres family_inc after_tax_inc if counties==24
progres family_inc after_tax_inc if counties==25
progres family_inc after_tax_inc if counties==26
progres family_inc after_tax_inc if counties==27
progres family_inc after_tax_inc if counties==28
progres family_inc after_tax_inc if counties==29
progres family_inc after_tax_inc if counties==30
progres family_inc after_tax_inc if counties==31
progres family_inc after_tax_inc if counties==32
progres family_inc after_tax_inc if counties==33
progres family_inc after_tax_inc if counties==34
progres family_inc after_tax_inc if counties==35
progres family_inc after_tax_inc if counties==36
progres family_inc after_tax_inc if counties==37
progres family_inc after_tax_inc if counties==38
progres family_inc after_tax_inc if counties==39
progres family_inc after_tax_inc if counties==40
progres family_inc after_tax_inc if counties==41
progres family_inc after_tax_inc if counties==42
progres family_inc after_tax_inc if counties==43
progres family_inc after_tax_inc if counties==44
progres family_inc after_tax_inc if counties==45
progres family_inc after_tax_inc if counties==46
progres family_inc after_tax_inc if counties==47
progres family_inc after_tax_inc if counties==48
progres family_inc after_tax_inc if counties==49
progres family_inc after_tax_inc if counties==50
progres family_inc after_tax_inc if counties==51
progres family_inc after_tax_inc if counties==52
progres family_inc after_tax_inc if counties==53
progres family_inc after_tax_inc if counties==54
progres family_inc after_tax_inc if counties==55
progres family_inc after_tax_inc if counties==56
progres family_inc after_tax_inc if counties==57
progres family_inc after_tax_inc if counties==58
progres family_inc after_tax_inc if counties==59
progres family_inc after_tax_inc if counties==60
progres family_inc after_tax_inc if counties==61
progres family_inc after_tax_inc if counties==62
progres family_inc after_tax_inc if counties==63
progres family_inc after_tax_inc if counties==64
progres family_inc after_tax_inc if counties==65
progres family_inc after_tax_inc if counties==66
progres family_inc after_tax_inc if counties==67
progres family_inc after_tax_inc if counties==68
progres family_inc after_tax_inc if counties==69
progres family_inc after_tax_inc if counties==70
progres family_inc after_tax_inc if counties==71
progres family_inc after_tax_inc if counties==72
progres family_inc after_tax_inc if counties==73
progres family_inc after_tax_inc if counties==74
progres family_inc after_tax_inc if counties==75
progres family_inc after_tax_inc if counties==76
progres family_inc after_tax_inc if counties==77
progres family_inc after_tax_inc if counties==78
progres family_inc after_tax_inc if counties==79
progres family_inc after_tax_inc if counties==80
progres family_inc after_tax_inc if counties==81
progres family_inc after_tax_inc if counties==82
progres family_inc after_tax_inc if counties==83
progres family_inc after_tax_inc if counties==84
progres family_inc after_tax_inc if counties==85
progres family_inc after_tax_inc if counties==86
progres family_inc after_tax_inc if counties==87
progres family_inc after_tax_inc if counties==88
progres family_inc after_tax_inc if counties==89
progres family_inc after_tax_inc if counties==90
progres family_inc after_tax_inc if counties==91
progres family_inc after_tax_inc if counties==92
progres family_inc after_tax_inc if counties==93
progres family_inc after_tax_inc if counties==94
progres family_inc after_tax_inc if counties==95

save "T:\Tax Burden\MERGED ACS Appraisial IRS Grocery Gas.dta", replace

*create progressivity index values
*copy and paste into excel for next merge

import excel "T:\Tax Burden\Suites Index and rankings.xlsx", sheet("Sheet1") clear

rename A County
rename B suits
rename C ranking
drop in 1 

*progressivity - 1 is most progressivty and 95 is less progressive

label variable County "county"
label variable suits "suits index"
label variable ranking "progressivity rankings"
save "T:\Tax Burden\Suites and Rankings.dta", replace

clear
use "T:\Tax Burden\MERGED ACS Appraisial IRS Grocery Gas.dta"

merge m:1 County using "T:\Tax Burden\Suites and Rankings.dta"
drop in 571

destring suits, replace
destring ranking, replace
drop _merge
*copy and paste data for MicMinn again. Did not come in correctly

*================================================================================
*completion of the data management and merges. Can create visuals now
save "T:\Tax Burden\MERGED ACS Appraisial IRS Grocery Gas.dta", replace
