global work "your directory"
cd $work

	
*INPUT AND CLEAN DATA
	use TaskData22_23_24, clear //this is the taskswitching data pooled from 2022,2023 and 2024 in ECO372
		

*REMONDER CORRELATIONS
	correlate totalmins correct speed english alphabet Dtaskswitch if random==0 & totalmin~=0
	matrix Selected = r(C)
	heatplot Selected, values(format(%9.2f)) color(hcl diverging, intensity(.9))  cuts(-1 -0.5 -0.3 -0.10 0.10 0.3 0.5 1) keylabels(all,  format(%9.2f)) aspectratio(1) lower nodiagonal
	graph save Week08_Selected_Correlation, replace

	correlate totalmins correct speed english alphabet Dtaskswitch if random==1 & totalmin~=0
	matrix Random = r(C)
	heatplot Random, values(format(%9.2f)) color(hcl diverging, intensity(.9)) cuts(-1 -0.5 -0.3 -0.10 0.10 0.3 0.5 1) keylabels(all,  format(%9.2f)) aspectratio(1) lower nodiagonal
	graph save Week08_Randomized_Correlation, replace
	*COMBINE BOTH SAVED GRAPHS TO ONE BIG GRAPH
	graph combine "Week08_Selected_Correlation" "Week08_Randomized_Correlation",  iscale(.8) ycommon xcommon ysize(5) xsize(11)
	graph save Week08_Correlation, replace
	erase Week08_Selected_Correlation.gph
	erase Week08_Randomized_Correlation.gph

*WEEK 08 - Questions

	*Question 1
	eststo spec1: reg totalmins Dtaskswitch if random==1, robust
	eststo spec2: reg totalmins Dtaskswitch speed if random==1, robust
	eststo spec3: reg totalmins Dtaskswitch speed alphabet english if random==1, robust
	eststo spec4: reg totalmins Dtaskswitch if random==0, robust
	eststo spec5: reg totalmins Dtaskswitch speed if random==0, robust
	eststo spec6: reg totalmins Dtaskswitch speed alphabet english if random==0, robust

	*Helpful resources for esttab syntax:
	*http://repec.org/bocode/e/estout/hlp_esttab.html
	*http://repec.org/bocode/e/estout/advanced.html

	local notes " This table reports regression estimates for the indicated variables where the outcome is total minutes spent on completing survey tasks. Each column is a separate regression. Robust Standard errors of the estimates are reported in parentheses. Accuracy speed is the the number of correct prereq quiz questions completed every 10 minutes. In the selected sample those with accuracy-speed above 2.3 were assigned to the taskswitching survey while those below 2.3 were assigned to the focused-survey."
	esttab spec1 spec2 spec3 spec4 spec5 spec6 using taTaskData01.html, mgroups("Randomized Group" "Selected Group", pattern(1 0 0 1 0 0)) nomtitles  cells(b( fmt(2)) se(fmt(3) par(( )))) stats(r2 N, fmt(3 0) labels("R-squared" "Observations")) title("Table 1: Regression estimates for the time to complete survey in the task-switching experiment") addnotes("Notes:`notes'") label replace //this reports all the result collected above

*Question 2
	twoway (scatter totalmins speed), by(group) xline(2.3, lstyle(foreground))

*Question 3
	gen devspeed=round(speed-2.3, 0.01)
	reg totalmins Dtaskswitch speed if random==1, robust
	reg totalmins Dtaskswitch devspeed if random==1, robust
	reg totalmins Dtaskswitch speed if random==0, robust
	reg totalmins Dtaskswitch devspeed if random==0, robust

	eststo spec1: reg totalmins Dtaskswitch speed if random==1, robust
	eststo spec2: reg totalmins Dtaskswitch devspeed if random==1, robust
	eststo spec3: reg totalmins Dtaskswitch speed if random==0, robust
	eststo spec4: reg totalmins Dtaskswitch devspeed if random==0, robust
	local notes " This table reports regression estimates for the indicated variables where the outcome is total minutes spent on completing survey tasks. Each column is a separate regression. Robust Standard errors of the estimates are reported in parentheses. Accuracy speed is the the number of correct prereq quiz questions completed every 10 minutes. In the selected sample those with accuracy-speed above 2.3 were assigned to the taskswitching survey while those below 2.3 were assigned to the focused-survey."
	esttab spec1 spec2 spec3 spec4  using taTaskData02.html, mgroups("Randomized Group" "Selected Group", pattern(1 0  1 0 )) nomtitles  cells(b( fmt(2)) se(fmt(3) par(( )))) stats(r2 N, fmt(3 0) labels("R-squared" "Observations")) title("Table 2: Regression estimates for the time to complete survey in the task-switching experiment") addnotes("Notes:`notes'") label replace //this reports all the result collected above

	*Question 5
	reg totalmins Dtaskswitch speed if random==1, robust
	predict yhat_random 

	scatter totalmins speed if Dtaskswitch==0 & random==1, color(blue) msize(vsmall) || ///
	scatter totalmins speed if Dtaskswitch==1  & random==1, color(red) msize(vsmall) legend(off) xline(2.3, lstyle(foreground))|| ///
	line yhat_random speed if Dtaskswitch==0  & random==1, color(blue) sort || ///
	line yhat_random speed if Dtaskswitch==1  & random==1, sort color(red) title("Randomized Group") ytitle("Total time to complete tasks")

	*Question 6
	reg totalmins Dtaskswitch devspeed if random==1, robust
	predict yhat_randomdev 

	scatter totalmins devspeed if Dtaskswitch==0 & random==1, color(blue) msize(vsmall) || ///
	scatter totalmins devspeed if Dtaskswitch==1  & random==1, color(red) msize(vsmall) legend(off) xline(0, lstyle(foreground))|| ///
	line yhat_randomdev devspeed if Dtaskswitch==0  & random==1, color(blue) sort || ///
	line yhat_randomdev devspeed if Dtaskswitch==1  & random==1, sort color(red) title("Randomized Group") ytitle("Total time to complete tasks")

	*Question 7
	reg totalmins Dtaskswitch speed if random==0, robust
	predict yhat_select

	scatter totalmins speed if Dtaskswitch==0 & random==0, color(blue) msize(vsmall) || ///
	scatter totalmins speed if Dtaskswitch==1  & random==0, color(red) msize(vsmall) legend(off) xline(2.3, lstyle(foreground))|| ///
	line yhat_select speed if Dtaskswitch==0  & random==0, color(blue) sort || ///
	line yhat_select speed if Dtaskswitch==1  & random==0, sort color(red) title("Selected Group") ytitle("Total time to complete tasks")

	*Question 8
	reg totalmins Dtaskswitch devspeed if random==0, robust
	predict yhat_selectdev

	scatter totalmins devspeed if Dtaskswitch==0 & random==0, color(blue) msize(vsmall) || ///
	scatter totalmins devspeed if Dtaskswitch==1  & random==0, color(red) msize(vsmall) legend(off) xline(0, lstyle(foreground))|| ///
	line yhat_selectdev devspeed if Dtaskswitch==0  & random==0, color(blue) sort || ///
	line yhat_selectdev devspeed if Dtaskswitch==1  & random==0, sort color(red) title("Selected Group") ytitle("Total time to complete tasks")

	*Question 9 
	gen devspeed2=devspeed*devspeed
	reg totalmins Dtaskswitch devspeed devspeed2 if random==0, robust
	predict yhat_selectdevquad 

	scatter totalmins devspeed if Dtaskswitch==0 & random==0, color(blue) msize(vsmall) || ///
	scatter totalmins devspeed if Dtaskswitch==1  & random==0, color(red) msize(vsmall) legend(off) xline(0, lstyle(foreground))|| ///
	line yhat_selectdevquad devspeed if Dtaskswitch==0  & random==0, color(blue) sort || ///
	line yhat_selectdevquad devspeed if Dtaskswitch==1  & random==0, sort color(red) title("Selected Group") ytitle("Total time to complete tasks")
	
	*Question 10 
	gen devspeed_D=devspeed*Dtaskswitch
	reg totalmins Dtaskswitch devspeed devspeed_D if random==0, robust
	predict yhat_selectdevint 

	scatter totalmins devspeed if Dtaskswitch==0 & random==0, color(blue) msize(vsmall) || ///
	scatter totalmins devspeed if Dtaskswitch==1  & random==0, color(red) msize(vsmall) legend(off) xline(0, lstyle(foreground))|| ///
	line yhat_selectdevint devspeed if Dtaskswitch==0  & random==0, color(blue) sort || ///
	line yhat_selectdevint devspeed if Dtaskswitch==1  & random==0, sort color(red) title("Selected Group") ytitle("Total time to complete tasks") 

	*Question 11 
	reg totalmins Dtaskswitch devspeed devspeed_D if random==0 & devspeed>=-1 & devspeed<=1, robust
	predict yhat_selectdevintb1 

	scatter totalmins devspeed if Dtaskswitch==0 & random==0 & devspeed>=-1 & devspeed<=1, color(blue) msize(vsmall) || ///
	scatter totalmins devspeed if Dtaskswitch==1  & random==0 & devspeed>=-1 & devspeed<=1, color(red) msize(vsmall) legend(off) xline(0, lstyle(foreground))|| ///
	line yhat_selectdevintb1 devspeed if Dtaskswitch==0  & random==0 & devspeed>=-1 & devspeed<=1, color(blue) sort || ///
	line yhat_selectdevintb1 devspeed if Dtaskswitch==1  & random==0 & devspeed>=-1 & devspeed<=1, sort color(red) title("Selected Group") ytitle("Total time to complete tasks") 

	*Question 12
	eststo spec1: 	reg totalmins Dtaskswitch if random==1, robust
	eststo Q5: 		reg totalmins Dtaskswitch speed if random==1, robust
	eststo Q6:		reg totalmins Dtaskswitch devspeed if random==1, robust
	eststo spec4: 	reg totalmins Dtaskswitch if random==0, robust
	eststo Q7:		reg totalmins Dtaskswitch speed if random==0, robust
	eststo Q8:		reg totalmins Dtaskswitch devspeed if random==0, robust
	eststo Q9:		reg totalmins Dtaskswitch devspeed devspeed2 if random==0, robust
	eststo Q10:		reg totalmins Dtaskswitch devspeed devspeed_D if random==0, robust
	eststo Q11: 	reg totalmins Dtaskswitch devspeed devspeed_D if random==0 & devspeed>=-1 & devspeed<=1, robust

	local notes " This table reports regression estimates for the indicated variables where the outcome is total minutes spent on completing survey tasks. Each column is a separate regression. Robust Standard errors of the estimates are reported in parentheses. Accuracy speed is the the number of correct prereq quiz questions completed every 10 minutes. In the selected sample those with accuracy-speed above 2.3 were assigned to the taskswitching survey while those below 2.3 were assigned to the focused-survey. Columns 1 2 and 3 use the Randomized sample while remaining columns use the Selected sample. The specification in column 9 restricts the sample to those within 1 speed points of the threshold."
	esttab spec1 Q5 Q6 spec4 Q7 Q8 Q9 Q10 Q11 using taTaskData03.html, mgroups("Randomized Group" "Selected Group", pattern(1 0 0 1 0 0 0)) nomtitles  cells(b( fmt(2)) se(fmt(3) par(( )))) stats(r2 N, fmt(3 0) labels("R-squared" "Observations")) title("Table 3: Regression estimates for the time to complete survey in the task-switching experiment") addnotes("Notes:`notes'") label replace //this reports all the result collected above

	*Question 15
	ssc install cmogram
	cmogram totalmins speed, cut(2.3) scatter line(2.3) qfitci
	cmogram totalmins speed, cut(2.3) scatter line(2.3) lowess

	*Question 16
	capture drop aspeed* R1 R0
	lpoly totalmins speed if Dtaskswitch == 0 & random==0, nograph kernel(triangle) gen(R0 aspeed0) bwidth(1)}
	lpoly totalmins speed if Dtaskswitch == 1 & random==0, nograph kernel(triangle) gen(R1 aspeed1)  bwidth(1)}
	scatter aspeed1 R1, color(red) msize(small) || scatter aspeed0 R0, msize(small) color(red) xline(2.3,lstyle(dot)) legend(off) xtitle("Accuracy-speed") ytitle("Time to complete tasks")

	*Question 17
	ssc install rdrobust, replace
	rdrobust totalmins speed, c(2.3)
	
	*Question 18
	net install rddensity, from(https://sites.google.com/site/rdpackages/rddensity/stata) replace
	net install lpdensity, from(https://sites.google.com/site/nppackages/lpdensity/stata) replace
	rddensity speed, c(2.3) plot
