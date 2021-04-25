
# 12/09/2019 literature-review ScienceInsight


## <span style="color:blue">One superstar funeral at a time

### AzoulayZivin&Wang10QJE_superstar extinction

**Outline:**

unexpected death of superstars will make their co-authors publication rate drop. (knowledge spillover)

**Equation:**

\\(E[ y_{it} | X_{ijt}]= exp[\beta_{0}+\beta_{1}AFTER\_DEATH_{it}+f(AGE_{jt})+\delta_{t}+\gamma_{ij}]\\)

**Unit of obs:**

superstar i's colleague j
  
**Way to calculate standard error:**

quasi-maximum likelihood(QML) standard error 

### AzoulayRosenZivin18WP_DOES SCIENCE ADVANCE ONE FUNERAL AT A TIME?

**Outline:** 

unexpected death of superstars will make non-collaborators publication rate increase. 

**Equation:**

\\(E[ y_{it} | X_{it}]= exp[\beta_{0}+\beta_{1}AFTER\_DEATH_{it}+\beta_{2}AFTER\_DEATH_{it}*TREAT_{i}+f(AGE_{it})+\delta_{t}+\gamma_{i}]\\)

**Identification:**

solving timetrend problem

	1)specifications include age and period effects
	2)selection of a matched scientist/subfield for each treated scientist/subfield.

**Unit of obs:**

publication or funding activity in subfield i in year t

**Way to calculate standard error:**

quasi-maximum likelihood(QML) standard error 

## <span style="color:blue"> Novelty and hotspots

### MukherjeeEtAl17science advance_The nearly universal link between the age of past knowledge and tomorrow’s breakthroughs in science and technology/ The hotspot

**Outline:**

works that cite literature with a low mean age and high age variance are in a citation “hotspot” and are increasingly predictive of a work’s future citation impact.(writing a hotspot: co-author>alone)

**Equation:**

logit regression

**Unit of obs:**

reference i for each paper j

DV: impact of paper or patents (1;0)

**Way to calculate standard error:**

no information

### Evans08science_Electronic Publication and the Narrowing of Science and Scholarship

**Outline:**

although digital articles is more efficient and accessible, it lead to fewer journals and articles being cited and more recent articles being cited.

**Equation:**

regression(ols)

**Unit of obs:**

reference i for each paper j

DV: depth of citation (reference date - publish date)

IV: depth of online (# of years when the paper/daft is available online)

**Way to calculate standard error:**

no information

### Ma&Uzzi18PNAS_Scientific prize network predicts who pushes the boundaries of science

**Outline:**

a relatively constrained number of ideas and scholars push the boundaries of science; certain prizes strongly interlock disciplines and subdisciplines, creating key pathways by which knowledge spreads and is recognized across science; genealogical and coauthorship networks predict who wins multiple prizes, which helps to explain the interconnectedness among celebrated scientists and their pathbreaking ideas.

**Equation:**

no equation (method:network analysis + Ordered logistic regression )

DV: multiple prizewinning, conditional on having won at least one prize.

**Unit of obs:**

prizewinner i's career history including collaborator and advisor

**Way to calculate standard error:**

no information

## <span style="color:blue">On shoulders of giants

### Furman&Stern11AER_Climbing atop the Shoulders of Giants/ The Impact of Institutions on Cumulative Research

**Outline:**

impact of institution on knowlege accumulation

each piece of material deposited in a BRC is associated with a journal article that describes it initial characterization and application 

whether the ability to access material through a BRC amplifies the impact of the scientific research that initially described those research materials.

**Equation:**

\\( FOWARD CITATIONS_{ijt}= f(\varepsilon_{ijt};\alpha_{j}+\beta_{t}+delta_{t-pubyear}+\phi_{window}BRC-ARTICLE_{i}+\varphi_{window}BRC-ARTICLE*window period_{it}+\varphi BRC-ARTICLE*post-deposit_{it}) \\) 

\\(\alpha_{j}\\):fixed effect for each pair of a treated article and control article

identification: did

**Unit of obs:**

article i in year t
article i and its control article j in year t 

**Way to calculate standard error:**

robust se, adjusted fro clustering by article group

### Williams13JPE_Intellectual Property Rights and Innovation/ Evidence from the Human Genome

**Outline:**

Celera’s short-term IP had persistent negative effects on subsequent innovation relative to a counterfactual of Celera genes having always been in the public domain.

Celera used a contract law–based form of IP to protect genes that had been sequenced by Celera but not yet sequenced by the public effort.

public effort---genres with high medical value
celera effort---less

**Equation:**

\\((outcome)_{g}=\alpha+\beta(celera)_{g}+\lambda(covariates)_{g}+\epsilon_{g}\\)

\\((outcome)_{gy}=\alpha+\gamma_{y}+\beta(celera)_{g}+\epsilon_{gy}\\)

**Unit of obs:**

gene g

gene g's outcome in year t

**Way to calculate standard error:**
E1: heteroskedasticity-robust standard errors
E2: heteroskedasticity-robust standard errors clustered at the gene level


### FosterEtAl15ASR_Tradition and Innovation in Scientists’ Research Strategies

**Outline:**

An innovative publication is more likely to achieve high impact than a conservative one, but the additional reward does not compensate for the risk of failing to publish.

**Equation:**

map the space of chemical knowledge (Steps 1 and 2); 
identify the prevalence and stability of the various strategies (Step 3); 
construct a simple behavioral model of scientific attention that relates strategy prevalence with opportunity (Step 4); 
measure risks and rewards associated with various strategies using citations (Step 5); 
explore two potential motivational mechanisms for scientists’ choices—maximizing citations and seeking outsized recognition (Step 6).

**Unit of obs:**

artical a

**Way to calculate standard error:**

(robust se)

## <span style="color:blue">Retraction and reputation

### AzoulayEtal15RES_RETRACTIONS

**Outline:**

following retraction and relative to carefully selected controls, related articles experience a lasting five to ten percent decline in the rate of citations received. This citation penalty is more severe when the associated retracted article involves fraud or misconduct, relative to cases where the retraction occurs because of honest mistake

**Equation:**

\\(E[ CITES_{jt} | X_{ijt}]= exp[\beta_{0}+\beta_{1}RLTD_{j}*AFTER_{it}+f(AGE_{jt})+\delta_{t}+\gamma_{ij}]\\)

**Unit of obs:**

the number of citations that are received by related article j in year t to characteristics of j and of retracted article i

**Way to calculate standard error:**

QML standard errors

### AzoulayEtAl17RP_The career effects of scandal/ Evidence from scientific retractions

**Outline:**

Relative to non-retracted control authors, faculty members who experience a retraction see the citation rate to their earlier, non-retracted articles drop by 10% on average. When the retraction event had its source in “honest mistakes,” we find no evidence of differential stigma between high- and low-status faculty members.

**Equation:**

\\(E[ y_{ijt} | X_{it}]= exp[\beta_{0}+\beta_{1}RETRACTED_{i}*AFTER_{jt}+\phi(AGE_{it})+\varphi(AGE_{jt})+\delta_{t}+\gamma_{ij}]\\)

**Identification:**

DID (using pre-retraction work)

	1)Retraction events may influence a number of subsequent research inputs, including effort, flow of funding, referee beliefs, and collaborator behavior.(the quality of pre-retraction work is not affected)
	2)scientific community updates its beliefs regarding the reputation of individual scientists following a retraction.(focus on pre-retracted work by the retracted authors that does not belong to the same narrow subfield as the underlying retraction)

**Unit of obs:**

the number of citations to author i's pre-retraction article j received in year t to characteristics of both i and j


**Way to calculate standard error:**

QML standard errors

### JinEtAl18RES_The Reverse Matthew Effect/ Consequences of Retraction in Scientific Teams

**Outline:**

retractions impose little citation penalty on the prior work of eminent coauthors, but less eminent coauthors experience substantial citation declines, especially when teamed with eminent authors.

**Equation:**

\\(Pr(y_{iat}= f(\alpha_{ia}+u_{t}+\beta_{1}*Treat_{i}*Post_{kt}+\beta_{2}*Standing_{a}*Treat_{i}*Post_{kt}+\beta_{3}*Standing_{a}*Post_{kt}+\beta_{4}*Post_{kt})\\)

**Unit of obs:**

author a of article i at time t

? \\(post_{kt}\\)is a dummy variable that equals 1 if year t is after the retraction event for a given treatment and control group k

**Way to calculate standard error:**

clustered standard error(cluster the standard errors by the retraction event)

### LuEtAl13sciencereport_The Retraction Penalty/ Evidence from the Web of Science 

**Outline:**

a single retraction triggers citation losses through an author’s prior body of work. citation losses among prior work disappear when authors self-report the error.

**Equation:**

\\(Pr(y_{it}= f(\alpha_{i}+u_{t}+\beta_{post}*Post_{kt}+\beta_{dif}*Treat_{i}*Post_{kt})\\)

**Unit of obs:**

paper i published in year t

**Way to calculate standard error:**

robust standard error


## <span style="color:blue">Science across the ages

### Jones10RES_age and great invention

**Outline:**

Great achievements in knowledge are produced by older innovators today than they were a century ago. innovators are much less productive at younger ages, beginning to produce major ideas 8 years later at the end of the 20th Century than they did at the beginning. the later start to the career is not compensated for by increasing productivity beyond early middle age

**Equation:**

theoretical+analytical

**Unit of obs:**

individual i

**Way to calculate standard error:**

MLE

### Jones09RES-The Burden of Knowledge and the “Death of the Renaissance Man”/ Is Innovation Getting Harder?

**Outline:**

age at first invention, specialization, and teamwork increase over time in a large micro-data set of inventors, shows little variation across fields

**Equation:**

theoretical model

### LiuEtAl18nature_Hot streaks in artistic, cultural, and scientific careers

**Outline:**

across all three domains, hit works within a career show a high degree of temporal regularity, with each career being characterized by bursts of high-impact works occurring in sequence

**Equation:**

hot-streak model


### Simonton14book_The Wiley Handbook of Genius(422-450)

**Outline:**

relationship between age and scientic genius

**Equation:**

descriptive analysis


### AzoulayEtAl18workingpaper_Age and High Growth Entrepreneurship _ Integrated.pdf

**Outline:**

successful entrepreneurs are middle-aged, not young.

**Equation:**

descriptive analysis


## <span style="color:blue"> Randomized insights

### Boudreau&Lakhani16_Innovation Experiments/ Researching Technical Advance, Knowledge Production, and the Design of Supporting Institutions

**Outline:**

how organizational and institutional design shapes innovation outcomes and the production of knowledge

**Equation:**

case study



### BoudreauEtAl17RES_A FIELD EXPERIMENT ON SEARCH COSTS AND THE FORMATION OF SCIENTIFIC COLLABORATIONS

**Outline:**

search costs affect matching among scientific collaborators.

**Equation:**

\\(Collaboration_{ij}=\alpha+\beta Same room_{ij}+\theta Same room_{ij}*Distance_{ij}+\pi Distance_{ij}+\delta X_{ij}+\epsilon_{ij}\\)

**Unit of obs:**

scientist i and scientist j 


**Way to calculate standard error:**

grouped dyadic standard errors according to Fafchamps-Gubert


### BoudreauEtAl16MNSC_Looking Across and Looking Beyond the Knowledge Frontier/ Intellectual Distance, Novelty, and Resource Allocation in Science

**Outline:**

the “intellectual distance” between the knowledge embodied in research proposals and an evaluator’s own expertise systematically relates to the evaluations given. evaluators systematically give lower scores to research proposals that are closer to their own areas of expertise and to those that are highly novel. 

**Equation:**

\\(Evaluation\_score_{ij}=\beta*Evaluation\_distance_{ij}+\delta_{i}+\eta_{j}+\epsilon_{ij}\\)

\\(Evaluation\_score_{ij}=\beta*Evaluation\_distance_{ij}+\gamma*Proposal\_novelty_{j}+\delta_{i}+\eta_{j}+\epsilon_{ij}\\)

**Unit of obs:**

applicant j and his/her evaluator i

**Way to calculate standard error:**

robust standard error


## <span style="color:blue"> Others


### GerowEtAl17PNAS_Measuring discursive influence across scholarship 

**Outline:**

citations tend to credit authors who persist in their fields over time and discount credit for works that are influential over many topics or are “ahead of their time.” 

**Equation:**

topic model


### UzziEtAl13science_Atypical Combinations and Scientific Impact

**Outline:**

The highest-impact science is primarily grounded in exceptionally conventional combinations of prior work yet simultaneously features an intrusion of unusual combinations. 

**Equation:**

randome walk model 

