*** Replication files for for "Preference Externality Estimators" ***

*** Data input: 
***		dt0_ad_vote.dta: party-county-year, for voting, advertising, and other demographical controls
***		dt0_bordercounties.dta: county-dmaborder, cross-border counties


quietly{

*** Housekeeping and declare globals for variable lists ****

global convar "sen govincumb dist rain rain_y2004 snow snow_y2004 age25 age45 age65 unemploy empsal"
global cvconvar "sen govincumb dist rain snow age25 age45 age65 unemploy empsal"
program drop _all
set more off


*** Prepare dataset for analysis ***

program P01_PrepData
	**** prepare all-county data ****

	use dt0_ad_vote.dta,clear
	gisid fips year party

	*** generate dependent variables: ln(share) - ln(share0) ***

	bysort fips year: assert _N == 2
	bysort fips year: egen totvotes2party = sum(votes2party)
	generate diflnqk = log(votes2party / VAP_TOT) - log(1 - totvotes2party / VAP_TOT)

	*** generate ad variable: ln(ads) ***

	generate lnal = ln(1 + points / 1000)

	*** generate other variables variables ***

	generate lnpop = log(VAP_TOT)
	bysort party dma year: egen dmapop = sum(VAP_TOT)

	*** generate cross-market IV -- weighted average ***

	generate popShare = VAP_TOT / dmapop
	bysort party dma year: generate nCountyInDma = _N
	tempvar tmpv
	foreach var of varlist $cvconvar{
		generate `tmpv' = `var' * popShare
		by party dma year: egen cmiv_`var' = sum(`tmpv')
		drop `tmpv'
	}

	*** generate interactive IV -- lagged CPM, and cross-market IV **

	cap drop py
	egen py = group(party year)
	forvalues ival = 1(1)8{
		disp "`ival'"
		xi, prefix(ivp`ival') i.py*lagCPM`ival'
	}

	local ival = 1
	foreach var of varlist cmiv_*{
		disp "`ival'"
		xi, prefix(ic`ival') i.py*`var'
		local ival = `ival' + 1
	}

	save dt1_allcounty.dta, replace
	
	*** generate border county data ***

	use dt0_bordercounties.dta,clear
	gisid fips border

	** expand to 4 **

	expand 2
	bysort fips border: generate party = _n
	expand 2
	bysort fips border party: generate year = 1996 + 4 * _n


	** merge in variables ***

	merge m:1 fips party year using "dt1_allcounty.dta", assert(match using) keep(match) keepusing($convar dma lnal lnpop cmiv_* diflnqk lagCPM* ivp* ic* dmapop VAP_TOT) nogenerate

	save dt1_countyInBorder.dta,replace
end


*** Tables 2 -- 5 ***

program T2_BorderOffborderSizes
	tempfile tmp
	use dt0_bordercounties.dta,clear
	gcontract fips
	drop _freq
	generate border = 1
	save `tmp', replace

	use "dt1_allcounty.dta",clear
	gcontract fips dma year VAP_TOT
	drop _freq
	gcollapse VAP_TOT, by(fips dma)
	bysort dma: egen popdma = sum(VAP)
	generate pop_ratio = VAP / popdma
	merge m:1 fips using `tmp', assert(master match) keepusing(border) nogenerate
	replace border = 0 if border == .

	generate ratio_cat = 1 if pop_ratio <= 0.1
	label define ratio_cat 1 "0 - 0.1", replace
	forvalues i = 2/9{
		replace ratio_cat = `i' if pop_ratio <= 0.1 * `i' & ratio_cat == .
		local j = `i' - 1
		local lb = "`=strofreal(0.1*`j', "%3.1f")'"
		local ub = "`=strofreal(0.1*`i', "%3.1f")'"
		label define ratio_cat `i' "`lb'-`ub'", add
	}
	replace ratio_cat = 9 if ratio_cat == .
	label values ratio_cat ratio_cat
	tab ratio_cat border, column
end
program AddYnT3
	args nlist
	forvalues i = 1/3{
		qui estadd local nt`i' "Yes"
	}
	forvalues i = 4/7{
		qui estadd local nt`i' "No"
	}
	foreach num of numlist `nlist'{
		qui estadd local nt`num' "Yes", replace
	}
	cap confirm matrix e(first)
	if (!_rc) {
		qui mat first = e(first)
		qui estadd scalar pr_first = first[3,1]
		qui estadd scalar F_first = first[4,1]
	}
end
program GenHausmanT3, rclass
	syntax varlist(fv ts)
	tempvar tmpresid
	qui reghdfe lnal $convar `varlist',  absorb($fes) vce(cluster i.party#i.dma) residuals(`tmpresid')
	qui reghdfe diflnqk lnal `tmpresid' $convar, absorb($fes) vce(cluster i.party#i.dma)
	qui test `tmpresid'
	return scalar hauspval = `r(p)'
end
program T3_CompareSpec
	*** columns 1 -- 4, OLS and IV ***

	use "dt1_allcounty",clear

	egen gp_party_dma = group(party dma)

	global prciv "i.party#i.year#c.lagCPM*"
	global crsmktiv "i.party#i.year#c.cmiv_*"
	global fes "i.party#i.year i.party#i.dma"

	eststo clear
	eststo: qui reghdfe diflnqk lnal $convar, absorb($fes) vce(cluster i.party#i.dma)
	AddYnT3 "1 2 3"

	GenHausmanT3 $prciv
	local hauspval = `r(hauspval)'
	eststo: qui ivreghdfe diflnqk $convar (lnal = $prciv), absorb($fes) cluster(gp_party_dma) ffirst 
	qui estadd scalar hauspval = `hauspval'
	AddYnT3 "6"

	GenHausmanT3 $crsmktiv
	local hauspval = `r(hauspval)'
	eststo: qui ivreghdfe diflnqk $convar (lnal = $crsmktiv), absorb($fes) cluster(gp_party_dma) ffirst 
	AddYnT3 "7"
	qui estadd scalar hauspval = `hauspval'

	GenHausmanT3 $prciv $crsmktiv
	local hauspval = `r(hauspval)'
	eststo: qui ivreghdfe diflnqk $convar (lnal = $prciv $crsmktiv), absorb($fes) cluster(gp_party_dma) ffirst 
	AddYnT3 "6 7"
	qui estadd scalar hauspval = `hauspval'

	*** columns 5 --6: border approach ***

	use dt1_countyInBorder.dta,clear

	*** flag small borders ***

	bysort dma border year party: egen borderpop = sum(VAP_TOT)
	generate pctPopBorder = borderpop / dmapop
	sort border dma year pctPopBorder
	by border dma year: assert pctPopBorder[1] == pctPopBorder[_N]
	sort border pctPopBorder
	by border: generate smallborder = (pctPopBorder[_N] <= 0.1)

	global fes "i.party#i.dma#i.border i.party#i.border#i.year"

	eststo: qui reghdfe diflnqk lnal $convar, absorb($fes) vce(cluster i.party#i.border i.party#i.dma)
	AddYnT3 "4 5"

	eststo: qui reghdfe diflnqk lnal $convar if smallborder, absorb($fes) vce(cluster i.party#i.border i.party#i.dma)

	AddYnT3 "4 5"

	*** output ***

	local scalarstr `" "nt1 Controls" "nt2 Party-year FE" "nt3 Party-dma FE" "nt4 Party-dma-border FE" "nt5 Party-border-year FE" "nt6 Lagged ads price IV" "nt7 Preference Externality IVs" "N Observation" "r2_a Adjusted R-squared" "F_first First-stage excluded F" "pr_first First-stage partial R2" "hauspval p-val for Hausman test" "'
	local sfmtstr `" %s %s %s %s %s %s %s %5.0f %4.3f %4.3f %4.3f %4.3f "'
	local eststr `"b(3) se(3) scalar(`scalarstr') sfmt(`sfmtstr') starlevels(* 0.10 ** 0.05 *** 0.01) keep(lnal) varwidth(22) modelwidth(7) label mtitle(OLS IV IV IV BD SBD) nogaps nonotes noobs title("DV: log(share) - log(share0)") addnote("Clustered SE at Party-dma, unit of obs: party-county-year")"'
	esttab est*, `eststr'
end
program GenHausmanOLSBD, rclass
	syntax [if]
	marksample touse
	tempvar tmpresid
	qui reghdfe lnal $convar if `touse',  absorb($fes2) residuals(`tmpresid')
	qui reghdfe diflnqk lnal `tmpresid' $convar if `touse', absorb($fes1) vce(cluster i.party#i.border i.party#i.dma)
	qui test `tmpresid'
	return scalar hauspval = `r(p)'
end
program GenHausmanOLSIV, rclass
	syntax varlist(fv ts) [if]
	marksample touse
	tempvar tmpresid
	qui reghdfe lnal $convar `varlist' if `touse',  absorb($fes1) residuals(`tmpresid')
	qui reghdfe diflnqk lnal `tmpresid' $convar if `touse', absorb($fes1) vce(cluster i.party#i.border i.party#i.dma)
	qui test `tmpresid'
	return scalar hauspval = `r(p)'
end
program GenHausmanBDIV, rclass
	syntax varlist(fv ts) [if]
	marksample touse
	tempvar tmpresid
	qui reghdfe lnal $convar `varlist' if `touse',  absorb($fes2) residuals(`tmpresid')
	qui reghdfe diflnqk lnal `tmpresid' $convar if `touse', absorb($fes2) vce(cluster i.party#i.border i.party#i.dma)
	qui test `tmpresid'
	return scalar hauspval = `r(p)'
end
program AddYnT4
	args nlist
	forvalues i = 1/7{
		qui estadd local nt`i' "No"
	}
	forvalues i = 1/3{
		qui estadd local nt`i' "Yes", replace
	}
	foreach num of numlist `nlist'{
		qui estadd local nt`num' "Yes", replace
	}
	cap confirm matrix e(first)
	if (!_rc) {
		qui mat first = e(first)
		qui estadd scalar pr_first = first[3,1]
		qui estadd scalar F_first = first[4,1]
	}
end
program T4_BorderAnalysis
	use dt1_countyInBorder.dta,clear

	bysort dma border year party: egen borderpop = sum(VAP_TOT)
	generate pctPopBorder = borderpop / dmapop
	sort border dma year pctPopBorder
	by border dma year: assert pctPopBorder[1] == pctPopBorder[_N]
	sort border pctPopBorder
	by border: generate smallborder = (pctPopBorder[_N] <= 0.1)

	egen gp_party_dma = group(party dma)
	egen gp_party_border = group(party border)

	global prciv "i.party#i.year#c.lagCPM*"
	global crsmktiv "i.party#i.year#c.cmiv_*"
	global fes1 "i.party#i.dma#i.border i.party#i.year"
	global fes2 "i.party#i.dma#i.border i.party#i.border#i.year"

	eststo clear
	eststo: qui reghdfe diflnqk lnal $convar, absorb($fes1)  vce(cluster i.party#i.border i.party#i.dma)
	AddYnT4 "3"

	eststo: qui reghdfe diflnqk lnal $convar if smallborder, absorb($fes1)  vce(cluster i.party#i.border i.party#i.dma)
	AddYnT4 "3"

	GenHausmanOLSBD if smallborder
	local hausols = `r(hauspval)'
	eststo: qui reghdfe diflnqk lnal $convar if smallborder, absorb($fes2) vce(cluster i.party#i.border i.party#i.dma)
	qui estadd scalar pvols = `hausols'
	AddYnT4 "4"

	GenHausmanOLSIV $crsmktiv if smallborder
	local hausols = `r(hauspval)'
	GenHausmanBDIV $crsmktiv if smallborder
	local hausbd = `r(hauspval)'
	eststo: qui ivreghdfe diflnqk $convar (lnal = $crsmktiv $prciv) if smallborder, absorb($fes1) cluster(gp_party_dma gp_party_border)
	qui estadd scalar pvols = `hausols'
	qui estadd scalar pvbd = `hausbd'
	AddYnT4 "3 5"

	local scalarstr `" "nt1 Control" "nt2 Party-dma-border FE" "nt3 Party-year FE" "nt4 Party-border-year FE" "nt5 PE IV" "N Observation" "pvols Hausman OLS (p-val)" "pvbd Hausman BA (p-val)" "'
	local eststr `"b(3) se(3) r2(3) scalar(`scalarstr') starlevels(* 0.10 ** 0.05 *** 0.01) keep(lnal) order(lnal) varwidth(25) modelwidth(7) label mtitle(OLS OLS BA IV) nogaps nonotes title("Table 4, border counties, DV: log(share) - log(share0)") mgroups(`" borders "' `" `:disp _dup(6) " "' small borders "', pattern(1 1 0 0) span) addnote("Clustered SE at party-border and party-dma, unit of obs: party-county-border-year")"'
	esttab *, `eststr'
end
program PostRegT5
	qui estadd local nt1 "Yes", replace
	qui estadd local nt2 "Yes", replace
	qui mat first = e(first)
	qui estadd scalar pr_first = first[3,1]
	qui estadd scalar F_first = first[4,1]
end
program GenHausmanT5, rclass
	syntax varlist(fv ts)
	tempvar tmpresid
	qui reghdfe lnal `varlist' $ivs,  absorb($fes) vce(cluster i.party#i.dma) residuals(`tmpresid')
	qui reghdfe diflnqk lnal `tmpresid' `varlist', absorb($fes) vce(cluster i.party#i.dma)
	qui test `tmpresid'
	return scalar hauspval = `r(p)'
end
program T5_Spillover
	use dt1_allcounty.dta,clear

	egen gp_party_dma = group(party dma)

	global prciv "i.party#i.year#c.lagCPM*"
	global crsmktiv "i.party#i.year#c.cmiv_*"
	global fes "i.party#i.year i.party#i.dma"

	*** construct unemployment in the largest county in the DMA ***

	isid fips year party
	sort dma year VAP_TOT
	by dma year: generate largest_unemploy = unemploy[_N]
	by dma year: generate largest_empsal = empsal[_N]

	*** For Waldfogel instruments ***

	label var lnal "Ln(Ads)"
	label var unemploy "Unemploy"
	label var contig_unemploy "Unemp-contiguous"
	label var largest_unemploy "Unemp-largest"
	label var empsal "Income"
	label var contig_empsal "Inc-contiguous"
	label var largest_empsal "Inc-largest"

	*** with price and Waldfogel IV ***

	eststo clear

	global ivs "$crsmktiv"
	GenHausmanT5 $convar
	local hauspval = `r(hauspval)'
	eststo: qui ivreghdfe diflnqk $convar (lnal = $ivs), absorb($fes) cluster(gp_party_dma) ffirst
	qui estadd scalar hauspval = `hauspval'
	PostRegT5

	GenHausmanT5 contig_unemploy contig_empsal $convar
	local hauspval = `r(hauspval)'
	eststo: qui ivreghdfe diflnqk contig_unemploy contig_empsal $convar (lnal = $ivs), absorb($fes) cluster(gp_party_dma) ffirst
	qui estadd scalar hauspval = `hauspval'
	PostRegT5

	GenHausmanT5 largest_unemploy largest_empsal $convar
	local hauspval = `r(hauspval)'
	eststo: qui ivreghdfe diflnqk largest_unemploy largest_empsal $convar (lnal = $ivs), absorb($fes) cluster(gp_party_dma) ffirst
	qui estadd scalar hauspval = `hauspval'
	PostRegT5

	GenHausmanT5 contig_unemploy contig_empsal largest_unemploy largest_empsal $convar
	local hauspval = `r(hauspval)'
	eststo: qui ivreghdfe diflnqk contig_unemploy contig_empsal largest_unemploy largest_empsal $convar (lnal = $ivs), absorb($fes) cluster(gp_party_dma) ffirst
	qui estadd scalar hauspval = `hauspval'
	PostRegT5

	local varstoshow "lnal unemploy empsal contig_unemploy contig_empsal largest_unemploy largest_empsal" 
	local eststr `"b(3) se(3) r2(3) scalar("nt1 Controls" "nt2 PE IV" "F_first First-stage excluded F" "pr_first First-stage partial R2" "hauspval Hausman, p-val") starlevels(* 0.10 ** 0.05 *** 0.01) keep(`varstoshow') order(`varstoshow')  varwidth(22) modelwidth(7) label nomtitles nogaps nonotes title("DV: log(share) - log(share0)") addnote("Clustered SE at Party-dma, unit of obs: party-county-year" "Other controls, party-year FE, party-DMA FE are included.")"'
	esttab est*, `eststr' 
end
}


**** main part ****

P01_PrepData
T2_BorderOffborderSizes
T3_CompareSpec
T4_BorderAnalysis
T5_Spillover




