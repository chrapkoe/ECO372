global work "/Users/elissa/Downloads/Week04_LectureMaterials"
cd $work


	*INSTALL SOME GRAPHING TOOLS
	ssc install heatplot, replace
	ssc install palettes, replace
	ssc install colrspace, replace
	
	*INPUT AND CLEAN DATA
	use taskdata, clear
	*Answered multi-tasking survey
		label var answered "Resp. answered survey"
		label define answered 0 "Did Not Answer Survey" 1 "Answered Survey"
		label value answered answered 
	*How_completed
		label var how_completed  "How Resp. completed sequence"
	*Sequence
		label variable sequence "Sequence submitted"
	*Correct
		label variable correct "Sequence correct"
		label define correct 0 "Incorrect sequence" 1 "Correct sequence"
		label values correct correct
	*Charlength
		label variable charlength "Length of sequence"
	*Instructions
		label var instructions  "Resp. followed instructions"
	*Language variables
		label var english "Resp. first language english"
		label var alphabet "Resp. first writing system alphabet"
		label var language "Language type"
		label define language 1 "English-Alpha" 2 "Non-english-alpha" 3 "Non-english-non-alpha"
		label values language language
	*Keyboard
		label var keyboard "Keyboard type"
		label define keyboard 1 "Keyboard on a laptop or desktop" 2 "External keyboard paired with a tablet" 3 "Touch-based with smart phone" 4 "Touch-based with other"
		label values keyboard keyboard
	*Outcome variables
		label var totalmins "Total time to complete tasks"
		label var num_task "Number of survey tasks: answered + correct + followed"
		label var taskspermin "Number of survey tasks per min spent"
	*Predetermined (i.e., X variables)
		label var group "Resp. survey group"
		label var Dtaskswitch "Resp. assigned task-switching task (vs focused)"
		label var random "Resp. was randomized to Dtaskswitch (vs selected for speed)"
		label var selected "Resp. was selected to Dtaskswitch (vs randomized)"
		label var speed "Selection variable: accuracy-speed to answer prereq qs (corr num/10 min)"		
	
	*assign yes no lable to yes-no variables
		label define yesno 0 "No" 1 "Yes"
		label values english alphabet instruction yesno

	des
	sum
	
	tab answered, miss
	tab correct, miss
	tab group, miss
	tab group answered, miss
	
	*Make an indicator variable (dummy) for using touch screen:
	recode keyboard 1=0 2=0 3=1 4=1, gen(touchscreen)
	label values touchscreen yesno

	*CORRELATIONS
	correlate totalmins correct speed english alphabet touchscreen Dtaskswitch if random==0 & totalmin~=0
	return list
	matrix Selected = r(C)
	heatplot Selected, values(format(%9.2f)) title(Selected) lower nodiagonal
	*or
	heatplot Selected, values(format(%9.2f)) color(, diverging intensity(.9))  cuts(-1(.4)1) title(Selected) keylabels(all,  format(%9.2f)) aspectratio(1) lower nodiagonal

	correlate totalmins correct speed english alphabet touchscreen Dtaskswitch if random==1 & totalmin~=0
	matrix Random = r(C)
	heatplot Random, values(format(%9.2f)) title(Randomized) lower nodiagonal
	*or
	heatplot Random, values(format(%9.2f)) color(, diverging intensity(.9))  cuts(-1(.4)1) title(Randomized)  keylabels(all,  format(%9.2f)) aspectratio(1) lower nodiagonal

	*REGRESSIONS
	*3
	reg totalmins Dtaskswitch if random == 1, robust

	*4

	*5

	*6
	
	*8
	
