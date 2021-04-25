# Dif-in-dif with Repeated Cross-section

Falsification tests to do

- gender-specific linear trend (maybe add quadratic)
- composition bias: 

## Application 

**Acemoglue and Angrist (2001 JPE)**

- policy: Americans with Disabilities Act (ADA), affect all men, and women under 40; provide better accomodation, and increase wages
- DV: employment and wage of disabled and non-disabled workders, using CPS data
- Finding: decline in employment, but no-decline in wages
	- that employment of the disabled declined more in medium-size firms, possibly because small firms are exempt from the ADA and large firms can more easily absorb ADA-related costs.
	- larger in states in which there have been more ADA-related discrimination charges
	- there is little evidence of a reduction in separation rates of the disabled
	- Effects of the ADA may have been due more to the costs of accommodation than to the threat of lawsuits for wrongful termination
- Empirical strategies
	- individual-level data
	- The [[control variables]] in these regressions are dummies for individual disability status, year, two 10-year age groups, three schooling groups, three race groups, and nine census region main effects, plus interaction terms for age#year, schooling#year, race#year, and region#year
	- No treated-by-other-demo controls 
	- add treated X linear time trend: This allows for the possibility that changes in outcomes by disability status can be explained by extrapolating different trends for the disabled and nondisabled.
	- examine the role of control, but removing controls, including year-specific control dummies (a separate main effect for each cell), non-parametrics (estimate treatment effect cell-by-cell, and do the average)
	- Composition bias: If the unemployed or nonparticipants were disproportionately more likely to identify themselves as disabled after the ADA; 
		- use 1993 and 1994 data, to compare guys reported disability in both surveys, and guys reported disabilities in neither surveys

**Arteaga (18 JPubE)**

- Policy: the credits requirement for econ and business major in one university is reduced by 20%
  - DV: wage, using individual-level data;
- Implementation
  - To examine no decrease in enrollment, use RDT plots
  - Dif-in-dif, controlling for years since graduation; although panel data, don't control for individual FE. 
  - SE: individual
  - [[Auxillary-tests|Common group errors]]; some placebo test to rule out this.
  - Reform may change the pool of enrollments in other non-measured ways: include only guys already enrolled at the time of reform
  - Mechanism: lower curriculum decrease students' performance in recruiting process, mainly by survey


**Chin (05 JLaborE)**

- Policy: Evacuation of Japanese in the Westcost after WWII, DV: earning
- Data: individual-level census data: Japanese descent, male, US-borned
- Empirical strategy:
	- unit of observation: individual
	- treatment: born in West Coast; control: born in other states (mostly in Hawaii)
	- "post": older cohorts, birth cohorts between 1908 and 1924, aging 18 -- 34 in 1942; "pre": young cohorts, birth between 1925 and 1941, aging 1 -- 17 in 1942. Younger cohorts in school, so career path is not affected
- Specifications
	- Main with the [[control variables]]: treat, post, treatpost, (years of school)#(treat, post), year of birth dummy, state of birth dummy
	- Threat of main specification, differential trend, because of 
		- millitary service 
		- different occupation structure for Japanese: Japanese in control states (mostly Hawaii) have more access to high-tiered job, thus wage increases steeper as it becomes older, and post cohortsa are older guys
		- reduction in Anti-Asian discrimination
	- Falsification test for the threat: use Chinese sample

**Droes and Koster (2016JUrbanE)**

- Policy: the opening up of wind Turbine; DV: house price; Treated: at least one Turbine opened within 2 miles; sequential treatment event;
- Main specification: treatpost, treated dummy, year dummy
- [[control variables]]: a set of housing characteristics including the size of the house, the number of rooms, ......
- SE clustered at the PC4 level (zip-code level)
- Location FE (absorb treated dummy) to further control for non-randomness of turbine
- To control for local trend, use grographic RD: select control houses to be 2km -- 3km away from the Turbine.
- Distance-specific, and time-specific effects

**Finkelstein (02JPubE)**

- Policy: tax subsidy only in Quebec; DV: insurance coverage; Data: dummy for insurance takeup
- Compositional changes in the treatment group relative to the control group in characteristics that are correlated with coverage by employer-provided supple- mentary health insurance could drive differences in trends in coverage between the treatment and control group over the sample period. 
	- For example, if union membership decreases in Quebec relative to the control provinces, and union members are more likely to be covered by employer-provided supplementary health insurance than non-union members
	- Include many controls
	- Show robustness: no control, with subset of exogeneous control, with full control, estimates are similar
- Falsification test: pre-trend, with no control, exogeneous control, full controls

**Gathmann and Sass (18JLE)**

- Policy: the price of public day care is raised in one specific state after 2006 in Germany
- Data: household level, DV: day care adoption
- Main specification: treatpost
- [[control variables]]: demographic, state FE, year FE, state unemployment, state GDP, state-specific time trend; 
- SE clustered at the state level

**Pischke(2007EJ)**

- policy: German short school years in 1966--67, which expose some students to a total of 2/3 year yess of schooling.
	- Treated unit is defined by state-cohort-year.
	- DV: ln(wage)
	- [[control variables]]: state FE, year FE, cohort FE, age, gender. Not interacted with treated dummy
	- SE clustered at the year-of-birth by state.
- Both individual-level analysis, as well as state-year-grade level analysis, for differerent DV.


## For identification

**Athey and Imbens (2006 ECMA)**

**Abadie (2005 RES)**





