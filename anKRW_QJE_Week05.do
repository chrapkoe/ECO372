*AA1 Elissa Chrapko
capture log close

clear
cd "/Users/elissa/Downloads/"

log using "AA1_chrapkolog.log", replace
use "daKRW_QJE_2022", clear

	*CLEAN AND CREATE VARIABLES
	***************************
	des
	sum
	
	*First create nice labels
	* Indicators for waves and regions - this follows the replcation file
	foreach k of numlist 1/4 {
		gen region4_`k' = region4 == `k'
	}
	foreach k of numlist 1/5 {
		gen wave`k' = wave == `k'
	}

	label variable region4_1 "Northeast"
	label variable region4_2 "Midwest"
	label variable region4_3 "South"
	label variable region4_4 "West"
	
	label variable wave1 "Wave 1"
	label variable wave2 "Wave 2"
	label variable wave3 "Wave 3"
	label variable wave4 "Wave 4"
	label variable wave5 "Wave 5"


	label variable cb "Call Back"
	label variable white "White Sounding"
	label variable male "Male Sounding"
	label variable female "Female Sounding"
	
	label define white 1 "White sounding" 0 "Black sounding"
	label values white white
	label define male 0 "Female sounding" 1 "Male sounding"
	label values male male
	label define female 0 "Male sounding" 1 "Female sounding"
	label values female female


**************************************
*Summary Statistics
**************************************	
	
	*We can use some commands to print this to a table
	***************************************************

	global var "female over40 lgbtq_club academic_club political_club gender_neutral_pronouns same_gender_pronouns associates region4_1 region4_2 region4_3 region4_4 wave1 wave2 wave3 wave4 wave5 cb" //We want to get means by race fro these varaibles so we name them to a list called "var"; now everytime we put $var in our code Stata will read it as this list

*Table1_KRW
	
	eststo white: estpost summarize $var if white == 1
	eststo black: estpost summarize $var if white == 0
	eststo diff: estpost ttest $var, by(black) unequal
	
	esttab white black diff, mtitles("White sounding" "Black sounding" "Difference") cells("mean(pattern(1 1 0) fmt(2)) sd(pattern(1 1 0) par([ ])) b(star pattern( 0 0 1) fmt(3)) se(pattern(0 0 1) fmt(3) par(( )))")  title("Table 1: Summary Statistics for Characteristics in Resumes, All Firms, KRW data 2022") addnotes("Notes:This table reports descriptive statistics for resume characteristics using data from the KRW in 2022. Column (1) shows the means for resumes with white sounding names and Column (2) shows the the means for those with black sounding names. Columns (3) reports the differences in means across black and white. Standard errors are reported in parentheses; standard deviations are reported in brackets. Significance stars are as follows: * p<.05; ** p<.01; *** p<.001") label replace //this reports all the result collected above
	esttab white black diff using Table1_KRW.html, mtitles("White sounding" "Black sounding" "Difference") cells("mean(pattern(1 1 0) fmt(2)) sd(pattern(1 1 0) par([ ])) b(star pattern( 0 0 1) fmt(3)) se(pattern(0 0 1) fmt(3) par(( )))")  title("Table 1: Summary Statistics for Characterictics in Resumes, All Firms, KRW data 2022") addnotes("Notes: This table reports descriptive statistics for resume characteristics using data from the KRW in 2022. Column (1) shows the means for resumes with white sounding names and Column (2) shows the the means for those with black sounding names. Columns (3) reports the differences in means across black and white. Standard errors are reported in parentheses; standard deviations are reported in brackets. Significance stars are as follows: * p<.05; ** p<.01; *** p<.001") label replace
	
**************************************
*Differential effect by female
**************************************	

	*Create interaction
	****************************************************************
	*use this name for interaction:
	gen white_female=white*female	
	label variable white_female "White X Female name"
	
		
	*Table of Regression results on SDO of call back rate on white and differnce in the SDO by female
	**************************************************************

*Table2_KRW

	eststo spec1: regress cb white, vce(cluster job_id)
	eststo spec2: regress cb white female over40 lgbtq_club academic_club political_club gender_neutral_pronouns same_gender_pronouns associates region4_1 region4_2 region4_3 region4_4 wave1 wave2 wave3 wave4 wave5, vce(cluster job_id)
	eststo spec3: regress cb white female white_female over40 lgbtq_club academic_club political_club gender_neutral_pronouns same_gender_pronouns associates region4_1 region4_2 region4_3 region4_4 wave1 wave2 wave3 wave4 wave5, vce(cluster job_id)
	

	esttab spec1 spec2 spec3 using Table2_KRW.html, cells(b(star fmt(3)) se(fmt(3) par(( )))) order(white female white_female over40 lgbtq_club academic_club political_club gender_neutral_pronouns same_gender_pronouns associates region4_1 region4_2 region4_3 region4_4 wave1 wave2 wave3 wave4 wave5) title("Table 2: Regression Results for Callback Rates from KRW data 2022") addnotes("Notes: This table reports regression results for resume callback characteristics using data from the KRW in 2022. Column (1) shows the means for resumes with white sounding names, Column (2) shows the the means with controls, and Column (3) reports the same controls with the addition of the interaction term for those with white female names. Standard errors are reported in parentheses. Significance stars are as follows: * p<.05; ** p<.01; *** p<.001") label replace
	
	
log close
