global work "your directory"
cd $work

	
	*INPUT AND CLEAN DATA
	use lmb-data.dta, clear
	
	des
	sum
	
	tab lagdemocrat

	*Question 2
	reg score lagdemocrat, cluster(id)

	
	*Question 7
	
	*Question 8
	gen devlagdemvoteshare=lagdemvoteshare-.5
	
	*Question 9 
	gen devlagdemvoteshare2=devlagdemvoteshare*devlagdemvoteshare

	*Question 10 
	gen devlagdemvoteshare_D=devlagdemvoteshare*lagdemocrat

	*Question 11 
	gen within2=(lagdemvoteshare>.48 & lagdemvoteshare<.52)

	*Question 12

	*Question 15

	*Question 16
	
	*Question 17

	*Question 18

	*Question 19
	
	*Question 20	
