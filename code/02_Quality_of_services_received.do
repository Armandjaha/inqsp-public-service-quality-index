/**************************************************************************************************
 Project      : INQSP – Public Service Quality Index
 File         : 01_Quality_of_services_received.do
 Author       : Armand Djaha, M.Sc.
 Date         : August 2025

 Description
 -----------
 This script computes Dimension 2 of the INQSP index:
 "Quality of Services Received".

 It produces two sub-indices:
   - Sub-index 2.1: Assessment of public service quality by CSOs
   - Sub-index 2.2: Assessment of service quality received by users

 Main steps
 ----------
 1. Initialize environment and paths
 2. Build Sub-index 2.1 from CSO dataset
    2.1 Recode variables
    2.2 Test item consistency
    2.3 Aggregate consistent items
    2.4 Export results
 3. Build Sub-index 2.2 from users dataset
    3.1 Recode variables
    3.2 Test item consistency
    3.3 Aggregate selected items
    3.4 Export results

 Dependencies
 ------------
 - code/00_setup.do
 - $ROOT/cso.dta
 - $ROOT/users.dta

 Outputs
 -------
 - Excel workbook: $OUT/indice_global_matrice_Harmean.xlsx

**************************************************************************************************/


/**************************************************************************************************
 SECTION 1 — INITIALIZATION
**************************************************************************************************/

clear all
set more off
do "code/00_setup.do"


/**************************************************************************************************
 SECTION 2 — SUB-INDEX 2.1 : ASSESSMENT OF PUBLIC SERVICE QUALITY BY CSOs
**************************************************************************************************/

use "$ROOT\cso", clear


/**************************************************************************************************
 STEP 2.1 — VARIABLE PREPARATION
 Recode and harmonize variables before consistency testing
**************************************************************************************************/

* Q1 : Overall satisfaction with the quality of public services received in 2024
*      (Likert response recoded from 1 to 4)

foreach var in satisf_globale access_info q23 q24 q25 q26 q29 q221 q222 q224 {
    decode `var', generate(`var'_str)
    drop `var'
    rename `var'_str `var'
}

encode satisf_globale, gen(Q1)
codebook Q1, tab(100)
recode Q1 (3=1 "Très_insatisfait") ///
          (1=2 "Insatisfait") ///
          (2=3 "Satisfait") ///
          (4=4 "Très_satisfait"), gen(q1)
label var q1 "Satisfaction globale (1=Très insatisfait -> 4=Très satisfait)"


* Q2 : Satisfaction with accessibility of information regarding public services
encode access_info, gen(Q2)
codebook Q2, tab(100)
recode Q1 (3=1 "Très_insatisfait") ///
          (1=2 "Insatisfait") ///
          (2=3 "Satisfait") ///
          (4=4 "Très_satisfait"), gen(q2)
label var q2 "Accessibilité information (1=Très insatisfait -> 4=Très satisfait)"


* Q3 : Satisfaction regarding clarity of administrative procedures
encode q23, gen(Q3)
codebook Q2, tab(100)
recode Q1 (3=1 "Très_insatisfait") ///
          (1=2 "Insatisfait") ///
          (2=3 "Satisfait") ///
          (4=4 "Très_satisfait"), gen(q3)
label var q3 "Clarté des procédures (1=Très insatisfait -> 4=Très satisfait)"


* Q4 : Assessment of competence of public service agents
encode q24, gen(Q4)
codebook Q4, tab(100)
recode Q4 (4=4 "Très compétent") ///
          (1=3 "Compétent") ///
          (2=1 "Pas du tout compétent") ///
          (3=2 "Peu compétent"), gen(q4)
label var q4 "Compétence agents (1=Pas du tout compétent -> 4=Très compétent)"


* Q5 : Perception of reasonableness of service delivery delays
gen q5 = (q25 == "Oui")
label define Q5_lbl 0 "Non" 1 "Oui"
label values q5 Q5_lbl
label var q5 "Traitement dans des délais raisonnables (0=Non, 1=Oui)"


* Q6 : Effective response to specific needs
encode q26, gen(Q6)
codebook Q6, tab(100)
recode Q6 (3=1) (2=2) (1=3), gen(q6)
label define repbes 1 "Pas du tout" 2 "Oui un peu" 3 "Oui totalement"
label values q6 repbes
label var q6 "Réponse efficace aux besoins (1=Pas du tout -> 3=Oui totalement)"


* Q7 : Willingness to recommend public services to other organizations
gen q7 = (q29 == "Oui")
label define Q7_lbl 0 "Non" 1 "Oui"
label values q7 Q7_lbl
label var q7 "Prêt à recommander (0=Non, 1=Oui)"


* Q8 : Overall perception of service quality without direct interaction
gen q8 = (q221 == "Très_bonne")
label define Q8_lbl 0 "Mauvaise" 1 "Très_bonne"
label values q8 Q8_lbl
label var q8 "Perception externe positive (0=Très mauvaise, 1=Très bonne)"

drop Q1 Q2 Q3 Q4 Q6


/**************************************************************************************************
 STEP 2.2 — ITEM CONSISTENCY TEST
 Correlation, Cronbach alpha and exploratory factor analysis
**************************************************************************************************/

* Examine correlation structure across candidate items
corr q1 q2 q3 q4 q5 q6 q7 q8

* Cronbach alpha reliability test
alpha q1 q2 q3 q4 q5 q6 q7 q8, item
alpha q1 q2 q3 q4 q5 q6 q7, item

* Exploratory Factor Analysis (EFA)
factor q1 q2 q3 q4 q5 q6 q7

/*
 Interpretation notes:
 - Record here the retained items after empirical consistency checks
 - Justify whether q8 is excluded from the final aggregation
*/


/**************************************************************************************************
 STEP 2.3 — CONSISTENT ITEMS AGGREGATION
 Rule: a service is considered high quality if the respondent is "very satisfied"
**************************************************************************************************/

drop q1 q2 q3 q4 q5 q6 q7 q8


* Q1 : Overall satisfaction with the quality of public services
gen q1 = (satisf_globale == "Très_satisfait")
label var q1 "Satisfaction globale - Très satisfait"

* Q2 : Satisfaction with accessibility of information regarding public services
gen q2 = (access_info == "Très_satisfait")
label var q2 "Accessibilité à l'information - Très satisfait"

* Q3 : Satisfaction regarding clarity of administrative procedures
gen q3 = (q23 == "Très_satisfait")
label var q3 "Clarté des procédures - Très satisfait"

* Q4 : Assessment of competence of public service agents
gen q4 = (q24 == "Très_compétant")
label var q4 "Compétence des agents - Très compétent"

* Q5 : Perception of reasonableness of service delivery delays
gen q5 = (q25 == "Oui")
label var q5 "Traitement des demandes dans des délais raisonnables - Oui"

* Q6 : Effective response to specific needs
gen q6 = (q26 == "Oui_totalement")
label var q6 "Réponse efficace aux besoins spécifiques - Oui totalement"

* Q7 : Willingness to recommend public services to other organizations
gen q7 = (q29 == "Oui")
label var q7 "Prêt à recommander les services publics - Oui"


* Compute mean proportion for each retained indicator
sum q1
scalar s1_1 = r(mean)

sum q2
scalar s1_2 = r(mean)

sum q3
scalar s1_3 = r(mean)

sum q4
scalar s1_4 = r(mean)

sum q5
scalar s1_5 = r(mean)

sum q6
scalar s1_6 = r(mean)

sum q7
scalar s1_7 = r(mean)

* Aggregate sub-index 2.1
scalar indice_21 = ((s1_1 + s1_2 + s1_3 + s1_4 + s1_5 + s1_6 + s1_7) / 7)


/**************************************************************************************************
 STEP 2.4 — STORE AND EXPORT RESULTS
**************************************************************************************************/

* Store index and indicator scores in a results matrix
matrix result = (indice_21 \ s1_1 \ s1_2 \ s1_3 \ s1_4 \ s1_5 \ s1_6 \ s1_7)

* Assign row names for traceability
matrix rownames result = ///
    INDICE_21 ///
    IND_1 ///
    IND_2 ///
    IND_3 ///
    IND_4 ///
    IND_5 ///
    IND_6 ///
    IND_7

* Convert matrix to Stata dataset
clear
svmat result, names(col)

* Add labels and metadata
gen Label = ""
replace Label = "DIMENSION 2.1: CSO ASSESSMENT OF PUBLIC SERVICE QUALITY (core group q1-q7)" in 1
replace Label = "INDICATOR 1: CSOs generally very satisfied with the quality of public services received" in 2
replace Label = "INDICATOR 2: CSOs very satisfied with the accessibility of information on services" in 3
replace Label = "INDICATOR 3: CSOs very satisfied with the clarity of administrative procedures" in 4
replace Label = "INDICATOR 4: CSOs judging that service providers are very competent" in 5
replace Label = "INDICATOR 5: CSOs believing that their requests were processed within reasonable timeframes" in 6
replace Label = "INDICATOR 6: CSOs believing that public services fully met their specific needs" in 7
replace Label = "INDICATOR 7: CSOs ready to recommend public services to other organizations" in 8

* Traceability columns
gen Code_question = ""
gen Question      = ""

* Line 1 : aggregate index
replace Code_question = "AGREG" in 1
replace Question      = "AGREG : (IND_1..IND_7)/7" in 1

* Lines 2-8 : CSO indicators
replace Code_question = "Q2.1 (Satisf_Globale)" in 2
replace Question      = "Overall satisfaction with the quality of public services received in 2024 ?" in 2

replace Code_question = "Q2.2 (Access_Info)" in 3
replace Question      = "Satisfaction with accessibility of information regarding public services." in 3

replace Code_question = "Q2.3 (Q23)" in 4
replace Question      = "Satisfaction regarding clarity of administrative procedures." in 4

replace Code_question = "Q2.4 (Q24)" in 5
replace Question      = "Assessment of competence of public service agents." in 5

replace Code_question = "Q2.5 (Q25)" in 6
replace Question      = "Perception of reasonableness of service delivery delays." in 6

replace Code_question = "Q2.6 (Q25)" in 7
replace Question      = "Effective response to specific needs." in 7

replace Code_question = "Q2.9 (Q29)" in 8
replace Question      = "Willingness to recommend public services to other organizations." in 8

* Rename score column
rename c1 score

* Reorganize output table
order Label Question Code_question score
replace score = score * 100

* Display results
list, noobs clean

* Export results to Excel
export excel using "$OUT\indice_global_matrice_Harmean.xlsx", ///
    sheet("INDICE 2_1") ///
    firstrow(variables) ///
    sheetmodify


/**************************************************************************************************
 SECTION 3 — SUB-INDEX 2.2 : QUALITY OF SERVICE RECEIVED BY USERS
**************************************************************************************************/

use "$ROOT\users", clear


/**************************************************************************************************
 STEP 3.1 — VARIABLE PREPARATION
 Recode user responses into standardized indicators
**************************************************************************************************/

* Q9 : Perceived ease of access to the PPSP
encode qu23, gen(Q9_tmp)
recode Q9_tmp (3=1) (1=2) (2=3) (4=4), gen(Q9)
label define Q9_lbl 1 "Très difficile" 2 "Plutôt difficile" 3 "Plutôt facile" 4 "Très facile", replace
label values Q9 Q9_lbl
label var Q9 "Accessibilité au PPSP"
drop Q9_tmp

* Q10 : Indicates whether the service was delivered within expected deadlines
gen Q10 = .
replace Q10 = 1 if qu211 == "Oui"
replace Q10 = 0 if qu211 == "Non"
label define Q10_lbl 0 "Non" 1 "Oui"
label values Q10 Q10_lbl
label var Q10 "Prestation reçue dans les délais"

* Q11 : Evaluation of waiting time before being served
encode qu25, gen(Q11_tmp)
recode Q11_tmp (4=1) (2=2) (1=3) (3=4), gen(Q11)
label define Q11_lbl 1 "Très long" 2 "Plutôt long" 3 "Plutôt court" 4 "Très court", replace
label values Q11 Q11_lbl
label var Q11 "Temps d'attente"
drop Q11_tmp

* Q12 : Perceived availability of service agents when needed
gen Q12 = .
replace Q12 = 1 if qu24 == "Très indisponible"
replace Q12 = 2 if qu24 == "Plutôt indisponible"
replace Q12 = 3 if qu24 == "Plutôt disponible"
replace Q12 = 4 if qu24 == "Très disponible"
label define Q12_lbl 1 "Très indispo" 2 "Plutôt indispo" 3 "Plutôt dispo" 4 "Très dispo", replace
label values Q12 Q12_lbl
label var Q12 "Disponibilité des agents"

* Q13 : Perceived clarity and understanding of explanations provided
gen Q13 = .
replace Q13 = 1 if qu27 == "Très difficiles à comprendre"
replace Q13 = 2 if qu27 == "Plutôt difficiles à comprendre"
replace Q13 = 3 if qu27 == "Plutôt faciles à comprendre"
replace Q13 = 4 if qu27 == "Très faciles à comprendre"
label define Q13_lbl 1 "Très diff" 2 "Plutôt diff" 3 "Plutôt facile" 4 "Très facile", replace
label values Q13 Q13_lbl
label var Q13 "Facilité de compréhension"

* Q14 : Perceived courtesy and respect demonstrated by agents
gen Q14 = .
replace Q14 = 1 if qu26 == "Jamais"
replace Q14 = 2 if qu26 == "Parfois"
replace Q14 = 3 if qu26 == "Rarement"
replace Q14 = 4 if qu26 == "Toujours"
label define Q14_lbl 1 "Jamais" 2 "Parfois" 3 "Rarement" 4 "Toujours", replace
label values Q14 Q14_lbl
label var Q14 "Traitement respectueux"

* Q15 : Degree of comfort during the visit
gen Q15 = .
replace Q15 = 1 if qu28 == "Pas du tout à l'aise"
replace Q15 = 2 if qu28 == "Peu à l'aise"
replace Q15 = 3 if qu28 == "Plutôt à l'aise"
replace Q15 = 4 if qu28 == "Très à l'aise"
label define Q15_lbl 1 "Pas du tout à l'aise" 2 "Peu à l'aise" 3 "Plutôt à l'aise" 4 "Très à l'aise", replace
label values Q15 Q15_lbl
label var Q15 "Confort ressenti"

* Q16 : Perceived feeling of safety during the visit
gen Q16 = .
replace Q16 = 1 if qu29 == "Pas du tout en sécurité"
replace Q16 = 2 if qu29 == "Plutôt en danger"
replace Q16 = 3 if qu29 == "Plutôt en sécurité"
replace Q16 = 4 if qu29 == "Tout à fait en sécurité"
label define Q16_lbl 1 "Pas du tout en sécurité" 2 "Plutôt en danger" 3 "Plutôt en sécurité" 4 "Tout à fait en sécurité", replace
label values Q16 Q16_lbl
label var Q16 "Sécurité ressentie"

* Q17 : Indicates whether the user would recommend the PPSP to others
gen Q17 = (qu212 == "Oui")
label define Q17_lbl 0 "Non" 1 "Oui"
label values Q17 Q17_lbl
label var Q17 "Recommandation"

* Q18 : Overall satisfaction with services received over the past 6 months
gen Q18 = .
replace Q18 = 1 if qu213 == "Très insatisfait"
replace Q18 = 2 if qu213 == "Insatisfait"
replace Q18 = 3 if qu213 == "Satisfait"
replace Q18 = 4 if qu213 == "Très satisfait"
label define Q18_lbl 1 "Très insatisfait" 2 "Insatisfait" 3 "Satisfait" 4 "Très satisfait", replace
label values Q18 Q18_lbl
label var Q18 "Satisfaction (6 mois)"

* Q19 : Indicates whether the user received everything they came to request
gen Q19 = (qu210 == "Oui")
label define Q19_lbl 0 "Non" 1 "Oui"
label values Q19 Q19_lbl
label var Q19 "Toutes demandes satisfaites"


/**************************************************************************************************
 STEP 3.2 — ITEM CONSISTENCY TEST
 Test internal consistency by thematic blocks
**************************************************************************************************/

* Block A : Perceived delays (Q10, Q11)
corr Q10 Q11
alpha Q10 Q11
factor Q10 Q11

/*
 Results:
 - Add short interpretation here
*/


* Block B : Frontline workers (Q12, Q13, Q14)
corr Q12 Q13 Q14
alpha Q12 Q13 Q14
factor Q12 Q13 Q14

/*
 Results:
 - Add short interpretation here
*/


* Block C : Comfort and safety (Q15, Q16)
corr Q15 Q16
alpha Q15 Q16
factor Q15 Q16

/*
 Results:
 - Add short interpretation here
*/


* Block D : Overall satisfaction (Q17, Q18, Q19)
corr Q17 Q18 Q19
alpha Q17 Q18 Q19
factor Q17 Q18 Q19

/*
 Results:
 - Add short interpretation here
*/


/**************************************************************************************************
 STEP 3.3 — AGGREGATION
 Aggregate selected items retained after consistency review
**************************************************************************************************/

* Selected binary indicators
gen Q11_bin = (Q11 == 4)   // Very short waiting time
sum Q11_bin
scalar s2_1 = r(mean)

gen Q12_bin = (Q12 == 4)   // Very available staff
sum Q12_bin
scalar s2_2 = r(mean)

gen Q15_bin = (Q15 == 4)   // Very comfortable
sum Q15_bin
scalar s2_3 = r(mean)

gen Q16_bin = (Q16 == 4)   // Completely safe
sum Q16_bin
scalar s2_4 = r(mean)

gen Q18_bin = (Q18 == 4)   // Very satisfied
sum Q18_bin
scalar s2_5 = r(mean)

* Row-level composite index
egen indice_usagers = rowmean(Q11_bin Q12_bin Q15_bin Q16_bin Q18_bin)
sum indice_usagers
scalar s2 = r(mean)


/**************************************************************************************************
 STEP 3.4 — STORE AND EXPORT RESULTS
**************************************************************************************************/

* Results matrix
matrix result = (s2 \ s2_1 \ s2_2 \ s2_3 \ s2_4 \ s2_5)

* Row names
matrix rownames result = ///
    indice_22 ///
    IND_22_1 ///
    IND_22_2 ///
    IND_22_3 ///
    IND_22_4 ///
    IND_22_5

* Convert matrix to Stata dataset
clear
svmat result, names(col)

* Labels
gen Label = ""
replace Label = "DIMENSION 2.2: QUALITY OF SERVICES RECEIVED BY USERS/CUSTOMERS (core group)" in 1
replace Label = "INDICATOR 1: Proportion of users satisfied with waiting time (Very short, QU25)" in 2
replace Label = "INDICATOR 2: Proportion of users satisfied with staff availability (Very available, QU24)" in 3
replace Label = "INDICATOR 3: Proportion of users stating they felt comfortable during their visit (Very comfortable, QU28)" in 4
replace Label = "INDICATOR 4: Proportion of users stating they felt safe (Completely safe, QU29)" in 5
replace Label = "INDICATOR 5: Proportion of users very satisfied with services of the last 6 months (Very satisfied, QU213)" in 6

* Traceability fields
gen Code_Question = ""
gen Question      = ""

replace Code_Question = "AGREG(qu25, qu24, qu28, qu29, qu213)" in 1
replace Question      = "Overall aggregated index based on the selected core" in 1

replace Code_Question = "QU25" in 2
replace Question      = "What is your assessment of the waiting time before being seen by the officers?" in 2

replace Code_Question = "QU24" in 3
replace Question      = "Were the officers available when you needed their help?" in 3

replace Code_Question = "QU28" in 4
replace Question      = "Were you comfortable during your visit to the PPSP?" in 4

replace Code_Question = "QU29" in 5
replace Question      = "Did you feel safe during your visit?" in 5

replace Code_Question = "QU213" in 6
replace Question      = "Overall, are you satisfied with the services requested over the last 6 months?" in 6

* Rename score column
rename c1 score

* Reorganize output table
order Label Question Code_Question score
replace score = score * 100

* Display results
list, noobs clean

* Export results to Excel
export excel using "$OUT\indice_global_matrice_Harmean.xlsx", ///
    sheet("INDICE 2_2") ///
    firstrow(variables) ///
    sheetmodify