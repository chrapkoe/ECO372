
cd "/Users/elissa/Downloads"

*log using "anLMBextend_Week09", replace text

	*BRING IN DATA
	use NEWlmb-data.dta, clear

	***************
	*Table 1: (see Table I and II in LMB)
	***************
	*covariates: realincome lnincome pcthighschl pctblack pcteligible
	
	*log income
	eststo clear
	eststo spec_all: reg lnincome lagdemocrat if lagdemvoteshare>=0 & lagdemvoteshare<=1 & LMBsample==1, cluster(id) 
	eststo spec_25: reg lnincome lagdemocrat if lagdemvoteshare>.25 & lagdemvoteshare<.75 & LMBsample==1, cluster(id) 
	eststo spec_10: reg lnincome lagdemocrat if lagdemvoteshare>.40 & lagdemvoteshare<.60 & LMBsample==1, cluster(id) 
	eststo spec_2: reg lnincome lagdemocrat if lagdemvoteshare>.48 & lagdemvoteshare<.52 & LMBsample==1, cluster(id) 
	eststo spec_opt: rdrobust lnincome lagdemvoteshare & LMBsample==1, c(0.5) 
	
	esttab spec_all  spec_25 spec_10 spec_2 spec_opt using taLMBTable01.rtf, ///
		rename(lagdemocrat "Log Income" RD_Estimate "Log Income" ) ///
		cells(b( fmt(3) star) se(fmt(3) par(( )))) ///
		title("Table 1: Difference in Covariates and Election Outcomes for Democrat vs Republican Districts (i.e., slope effect for lagdemocrat)") ///
		mtitles ("All" "+/-25" "+/-10" "+/-2" "Optimal BW") collabels(none)  ///
		refcat("Log Income" "Panel A - Covariates", nolabel) label ///
		noobs nocons se nonotes replace
		
	*pcthighschl
	eststo clear
	eststo spec_all: reg pcthighschl lagdemocrat if lagdemvoteshare>=0 & lagdemvoteshare<=1 & LMBsample==1, cluster(id) 
	eststo spec_25: reg pcthighschl lagdemocrat if lagdemvoteshare>.25 & lagdemvoteshare<.75 & LMBsample==1, cluster(id) 
	eststo spec_10: reg pcthighschl lagdemocrat if lagdemvoteshare>.40 & lagdemvoteshare<.60 & LMBsample==1, cluster(id) 
	eststo spec_2: reg pcthighschl lagdemocrat if lagdemvoteshare>.48 & lagdemvoteshare<.52 & LMBsample==1, cluster(id) 
	eststo spec_opt: rdrobust pcthighschl lagdemvoteshare & LMBsample==1, c(0.5) 
	
	esttab spec_all  spec_25 spec_10 spec_2 spec_opt using taLMBTable01.rtf, ///
		rename(lagdemocrat "Percent High-school Grad." RD_Estimate "Percent High-school Grad." ) ///
		cells(b( fmt(3) star) se(fmt(3) par(( )))) ///
		nomtitles nonumbers nogaps nolines collabels(none) ///
		noobs nocons se nonotes append

	*pctblack	
	eststo clear
	eststo spec_all: reg pctblack lagdemocrat if lagdemvoteshare>=0 & lagdemvoteshare<=1 & LMBsample==1, cluster(id) 
	eststo spec_25: reg pctblack lagdemocrat if lagdemvoteshare>.25 & lagdemvoteshare<.75 & LMBsample==1, cluster(id) 
	eststo spec_10: reg pctblack lagdemocrat if lagdemvoteshare>.40 & lagdemvoteshare<.60 & LMBsample==1, cluster(id) 
	eststo spec_2: reg pctblack lagdemocrat if lagdemvoteshare>.48 & lagdemvoteshare<.52 & LMBsample==1, cluster(id) 
	eststo spec_opt: rdrobust pctblack lagdemvoteshare & LMBsample==1, c(0.5) 
	
	esttab spec_all  spec_25 spec_10 spec_2 spec_opt using taLMBTable01.rtf, ///
		rename(lagdemocrat "Percent Black" RD_Estimate "Percent Black" ) ///
		cells(b( fmt(3) star) se(fmt(3) par(( )))) ///
		nomtitles nonumbers nogaps nolines collabels(none) ///
		noobs nocons se nonotes append

	*pcteligible
	eststo clear
	eststo spec_all: reg pcteligible lagdemocrat if lagdemvoteshare>=0 & lagdemvoteshare<=1 & LMBsample==1, cluster(id) 
	eststo spec_25: reg pcteligible lagdemocrat if lagdemvoteshare>.25 & lagdemvoteshare<.75 & LMBsample==1, cluster(id) 
	eststo spec_10: reg pcteligible lagdemocrat if lagdemvoteshare>.40 & lagdemvoteshare<.60 & LMBsample==1, cluster(id) 
	eststo spec_2: reg pcteligible lagdemocrat if lagdemvoteshare>.48 & lagdemvoteshare<.52 & LMBsample==1, cluster(id) 
	eststo spec_opt: rdrobust pcteligible lagdemvoteshare, c(0.5) 
	
	esttab spec_all  spec_25 spec_10 spec_2 spec_opt using taLMBTable01.rtf, ///
		rename(lagdemocrat "Percent Eligible to Vote" RD_Estimate "Percent Eligible to Vote") ///
		cells(b( fmt(3)) se(fmt(3) par(( )))) ///
		nomtitles nonumbers nogaps nolines collabels(none) ///
		noobs nocons se nonotes append

	*Incumbency Advantage see Page 831 LMBsample==1 
	global sample "LMBsample==1 & year>=1981"
	eststo clear
	eststo spec_all: reg democrat lagdemocrat if lagdemvoteshare>=0 & lagdemvoteshare<=1 & $sample, cluster(id) 
	eststo spec_25: reg democrat lagdemocrat if lagdemvoteshare>.25 & lagdemvoteshare<.75 & $sample, cluster(id) 
	eststo spec_10: reg democrat lagdemocrat if lagdemvoteshare>.40 & lagdemvoteshare<.60 & $sample, cluster(id) 
	eststo spec_2: reg democrat lagdemocrat if lagdemvoteshare>.48 & lagdemvoteshare<.52 & $sample, cluster(id) 
	eststo spec_opt: rdrobust democrat lagdemvoteshare if $sample, c(0.5) 
	
	esttab spec_all  spec_25 spec_10 spec_2 spec_opt using taLMBTable01.rtf, ///
		rename(lagdemocrat "Years - 1981-1990" RD_Estimate "Years - 1981-1990") ///
		cells(b( fmt(3) star) se(fmt(3) par(( )))) ///
		nomtitles nonumbers nogaps nolines collabels(none) ///
		title("Panel B - Incumbency Advantage by Period") ///
		noobs nocons se nonotes append
		
	*Incumbency Advantage LMBsample==0
	global sample "LMBsample==0"
	eststo clear
	eststo spec_all: reg democrat lagdemocrat if lagdemvoteshare>=0 & lagdemvoteshare<=1 & $sample, cluster(id) 
	eststo spec_25: reg democrat lagdemocrat if lagdemvoteshare>.25 & lagdemvoteshare<.75 & $sample, cluster(id) 
	eststo spec_10: reg democrat lagdemocrat if lagdemvoteshare>.40 & lagdemvoteshare<.60 & $sample, cluster(id) 
	eststo spec_2: reg democrat lagdemocrat if lagdemvoteshare>.48 & lagdemvoteshare<.52 & $sample, cluster(id) 
	eststo spec_opt: rdrobust democrat lagdemvoteshare if $sample, c(0.5) 
	
	esttab spec_all  spec_25 spec_10 spec_2 spec_opt using taLMBTable01.rtf, ///
		rename(lagdemocrat "Years - 1992-2006" RD_Estimate "Years - 1992-2006") ///
		cells(b( fmt(3) star) se(fmt(3) par(( )))) ///
		nomtitles nonumbers nogaps nolines collabels(none) ///
		noobs nocons se legend append ///
		addnotes("Standard errors appear in parentheses. The unit of observation is a district-congressional session. Columns (1) to (4) report the difference in average district characteristics between Democrat and Republican districts. Column (1) includes the entire sample. Columns (2) to (4) include only districts with Democrat vote share between 25 and 75 percent, 40 and 60 percent, and 48 and 52 percent, respectively. The model in column (5) includes only districts within the optimal bandwidth, as estimated using the Calonico et. al optimizing method (local polynomial regression). Panel A estimates the impact of relevant socioeconomic covariates on election outcomes. Panel B measures Incumbency Advantage in two time periods: 1946 to 1990 (LMB data period), and 1992 to 2006 (ECO372 updated data period).")


	***************
	*Figure 1: Covariates (see Figure III in LMB)
	***************
	*RDD plot like LMB EXCEPT this will be with optimal bandwidths instead of a 4th degree polynomial
	*covariates: realincome lnincome pcthighschl pctblack pcteligible
	
	global sample "LMBsample==1"
	rdplot realincome lagdemvoteshare if lagdemvoteshare>.25 & lagdemvoteshare<.75 & $sample, ///
		c(0.5) ci(95) graph_options(legend(off) title("Income") xtitle("Democrat Vote Share at time t") ytitle("Income"))
		graph save temp1, replace
	rdplot pcthighschl lagdemvoteshare if lagdemvoteshare>.25 & lagdemvoteshare<.75 & $sample, ///
		c(0.5) ci(95) graph_options(legend(off) title("High-school") xtitle("Democrat Vote Share at time t") ytitle("High-school"))
		graph save temp2, replace
	rdplot pctblack lagdemvoteshare if lagdemvoteshare>.25 & lagdemvoteshare<.75 & $sample, ///
		c(0.5) ci(95) graph_options(legend(off) title("Black") xtitle("Democrat Vote Share at time t") ytitle("Black"))
		graph save temp3, replace
	rdplot pcteligible  lagdemvoteshare if lagdemvoteshare>.25 & lagdemvoteshare<.75 & $sample, ///
		c(0.5) ci(95) graph_options(legend(off) title("Eligible") xtitle("Democrat Vote Share at time t") ytitle("Eligible"))
		graph save temp4, replace
	
	graph combine "temp1" "temp2" "temp3" "temp4",  iscale(.5) xcommon ysize(6.5) xsize(6.5) title("Figure 1: Similarity of Constituents' Characteristics" "in Bare Democrat and Republican Districts", size(small)) caption("Panels refer to (from top left to bottom right) the following district characteristics: real income, percentage with high-school degree, percentage black," "percentage eligible to vote. Points represent the average characteristic within each x value. The continuous line represents the predicted values from" "optimal bandwidths in vote share above and below the 50% threshhold. The whiskers represent the 95% confidence interval for each point.", size(tiny)) 


	***************
	*Figure 2: Covariates (see Figure IIb in LMB)
	***************
	*RDD plot like LMB EXCEPT this will be with optimal bandwidths instead of a 4th degree polynomial
	
	global sample "LMBsample==1"
	rdplot democrat lagdemvoteshare if $sample, ///
	c(0.5) cibands graph_options(legend(off) title("Incumbency Advantage") subtitle("Effect of Initial Win on Winning Next Election") xtitle("Democrat Vote Share at time t") ytitle("Probability of a Democrat Win at time t+1") yscale(range(-.0 1)) ylabel(-0(.20)1) caption("This panel plots probability of Democrat victory at t + 1 against Democrat vote share, time t, using data from the ECO372 updated data period (1992-2006). The continuous line represents the predicted values from optimal bandwidths in vote share above and below the 50% threshhold."))
	
*Note: the caption of this graph does not work. I've tried literally everything and it just cuts off or messes up the rest of the graph. I tried the same method as above, I tried line breaks, I tried redoing the way it's coded in general, and it just won't cooperate.
	

*log close


	