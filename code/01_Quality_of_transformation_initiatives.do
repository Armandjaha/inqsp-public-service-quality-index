/**************************************************************************************************
 Project      : INQSP – Public Service Quality Index
 File         : 01_Quality_of_transformation_initiatives.do
 Author       : Armand Djaha, M.Sc.
 Date         : August 2025

 Description
 -----------
 This script computes Dimension 1 of the INQSP index:
 "Quality of Public Service Transformation Initiatives".

 It produces two sub-indices:
   - Sub-index 1.1: Existence of operational mechanisms
   - Sub-index 1.2: Perception of initiative leads on the appropriation of the
                    "Fonctionnaire Nouveau" concept

 Main steps
 ----------
 1. Initialize environment and paths
 2. Build Sub-index 1.1 from initiative leads dataset
    2.1 Recode variables
    2.2 Test item consistency
    2.3 Aggregate consistent items
 3. Build Sub-index 1.2 from initiative leads dataset
    3.1 Recode variables
    3.2 Test item consistency
    3.3 Aggregate consistent items
 4. Aggregate sub-indices into Dimension 1
 5. Export results

 Dependencies
 ------------
 - code/00_setup.do
 - $ROOT/initiatives_lead.dta

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
 SECTION 2 — DIMENSION 1 : QUALITY OF PUBLIC SERVICE TRANSFORMATION INITIATIVES
**************************************************************************************************/

use "$ROOT\initiatives_lead", clear


/************************************************************************************
 SUB-INDEX 1.1 — EXISTENCE OF OPERATIONAL MECHANISMS
************************************************************************************/


/**************************************************************************************************
 STEP 2.1 — VARIABLE PREPARATION
 Recode and harmonize variables before consistency testing
**************************************************************************************************/

foreach var in q2 q3 q4 q5 q6 q7 q8 q10 q11 q12 q13 q14 {
    decode `var', generate(`var'_str)
    drop `var'
    rename `var'_str `var'
}

* Q1 : Impact assessment mechanism (satisfaction)
encode q8, gen(Q1)

* Q2 : Existence of a beneficiary awareness mechanism
encode q3, gen(Q2)

* Q2_1 : Limited version (only relevant initiatives)
encode q3, gen(Q2_1)
replace Q2_1 = . if q2 != "Oui"

* Q3 : Existence of an operational mechanism to evaluate initiative usage
encode q2, gen(Q3)

* Q4 : Whether a structural change has been observed since implementation
encode q4, gen(Q4)


/**************************************************************************************************
 STEP 2.2 — ITEM CONSISTENCY TEST
 Correlation, Cronbach alpha and exploratory factor analysis
**************************************************************************************************/

* Examine correlation structure across candidate items
corr Q1 Q2 Q3

* Cronbach alpha reliability test
alpha Q1 Q2 Q3, item

* Exploratory Factor Analysis (EFA)
factor Q1 Q2 Q3

/*
 Interpretation notes:
 - Record here the retained items after empirical consistency checks
 - Justify exclusion of non-retained variables if needed
*/


/**************************************************************************************************
 STEP 2.3 — CONSISTENT ITEMS AGGREGATION
 Keep only the most policy-relevant and positive operational mechanisms
**************************************************************************************************/

* Clean up to retain only consistent and relevant items
drop Q2 Q3

* Regenerate binary indicators
gen Q2 = (q3 == "Oui")
sum Q2
scalar s1_1 = r(mean)

gen Q3 = (q2 == "Oui")
sum Q3
scalar s1_2 = r(mean)

* Sub-index 1.1 : operational mechanisms (simple average)
gen meca_operationel = (Q2 + Q3) / 2
sum meca_operationel
scalar s1 = r(mean)


/************************************************************************************
 SUB-INDEX 1.2 — APPROPRIATION OF THE "FONCTIONNAIRE NOUVEAU" CONCEPT
************************************************************************************/


/**************************************************************************************************
 STEP 3.1 — VARIABLE PREPARATION
 Recode perception and awareness variables before consistency testing
**************************************************************************************************/

* Q5 : Personal appropriation of the "Fonctionnaire Nouveau" concept (if aware)
encode q13, gen(Q5)
recode Q5 (1=1) (3=2) (2=3)
label define Q5_lbl 1 "Non" 2 "Partiellement" 3 "Oui, complètement", replace
label values Q5 Q5_lbl
label var Q5 "Adoption du concept (1=Non -> 3=Oui, complètement)"

* Q6 : Awareness of the concept of "Fonctionnaire Nouveau"
encode q12, gen(Q6)
recode Q6 (1=0) (2=1)
label define Q6_lbl 0 "Non" 1 "Oui", replace
label values Q6 Q6_lbl
label var Q6 "Connaissance du concept (0=Non, 1=Oui)"

* Q7 : Perceived appropriation of the concept among colleagues
encode q14, gen(Q7)
recode Q7 (3=1) (1=2) (4=3) (2=4)
label define Q7_lbl 1 "Pas du tout" 2 "Non, très peu" 3 "Quelques-uns" 4 "Oui, la majorité", replace
label values Q7 Q7_lbl
label var Q7 "Appropriation du concept (1=Pas du tout -> 4=Oui, la majorité)"


/**************************************************************************************************
 STEP 3.2 — ITEM CONSISTENCY TEST
 Correlation, Cronbach alpha and exploratory factor analysis
**************************************************************************************************/

* Examine correlation structure across candidate items
corr Q5 Q6 Q7

* Cronbach alpha reliability test
alpha Q5 Q6 Q7, item

* Exploratory Factor Analysis (EFA)
factor Q5 Q6 Q7

/*
 Interpretation notes:
 - Record here the retained items after empirical consistency checks
*/


/**************************************************************************************************
 STEP 3.3 — CONSISTENT ITEMS AGGREGATION
 Convert retained items into binary indicators and compute the sub-index
**************************************************************************************************/

drop Q5 Q6 Q7

gen Q5 = (q13 == "Oui")
sum Q5
scalar s2_1 = r(mean)

gen Q6 = (q12 == "Oui")
sum Q6
scalar s2_2 = r(mean)

gen Q7 = (q14 == "Oui, la majorité")
sum Q7
scalar s2_3 = r(mean)

* Sub-index 1.2 : "Fonctionnaire Nouveau"
gen fonctionnaire_nv = (Q5 + Q6 + Q7) / 3
sum fonctionnaire_nv
scalar s2 = r(mean)


/**************************************************************************************************
 SECTION 4 — FINAL AGGREGATION OF DIMENSION 1
**************************************************************************************************/

* Final aggregation of validated sub-indices
scalar indice_1 = (s1 + s2) / 2


/**************************************************************************************************
 SECTION 5 — STORE AND EXPORT RESULTS
**************************************************************************************************/

* Store dimension score, sub-dimensions and indicators in a results matrix
matrix result = (indice_1 \ s1 \ s1_1 \ s1_2 \ s2 \ s2_1 \ s2_2 \ s2_3)

* Assign row names for traceability
matrix rownames result = ///
    INDICE_1 ///
    SOUS_IND_EXI_MEC ///
    IND_1_2_MEC_OP_UT ///
    IND_1_3_MEC_SENS ///
    SOUS_IND_FC_NV ///
    IND_2_1_ADOP_CONCEP ///
    IND_2_2_CON_CONCEP ///
    IND_2_3_APP_CONCEP

* Convert matrix to Stata dataset
clear
svmat result, names(col)

* Add labels and metadata
gen Label = ""
replace Label = "DIMENSION 1: QUALITY OF PUBLIC SERVICE TRANSFORMATION INITIATIVES" in 1
replace Label = "SUB-DIMENSION 1: EXISTENCE OF OPERATIONAL MECHANISM" in 2
replace Label = "INDICATOR 1.1: Evaluation of use by beneficiaries" in 3
replace Label = "INDICATOR 1.2: Awareness of beneficiaries" in 4
replace Label = "SUB-DIMENSION 2: APPROPRIATION OF THE FONCTIONNAIRE NOUVEAU CONCEPT" in 5
replace Label = "INDICATOR 2.1: Declared adoption" in 6
replace Label = "INDICATOR 2.2: Knowledge of the concept" in 7
replace Label = "INDICATOR 2.3: Appropriation by colleagues" in 8

* Traceability columns
gen Code_question = ""
gen Question      = ""

* Fill traceability information
replace Code_question = "AGREG" in 1
replace Question      = "AGREGATION: (SI1 + SI2) / 2" in 1

replace Code_question = "AGREG" in 2
replace Question      = "AGREGATION: (Q3 + Q2) / 2" in 2

replace Code_question = "Q3" in 3
replace Question      = "Do you have an operational mechanism for evaluating utilization?" in 3

replace Code_question = "Q2" in 4
replace Question      = "Is there a mechanism for raising awareness among beneficiaries?" in 4

replace Code_question = "AGREG" in 5
replace Question      = "AGREGATION: (Q5 + Q6 + Q7) / 3" in 5

replace Code_question = "Q13" in 6
replace Question      = "Have you adopted the ""nouveau fonctionnaire"" concept?" in 6

replace Code_question = "Q12" in 7
replace Question      = "Are you familiar with the concept of a ""nouveau fonctionnaire""?" in 7

replace Code_question = "Q14" in 8
replace Question      = "Have your colleagues adopted the concept of a ""nouveau fonctionnaire""?" in 8

* Rename score column
rename c1 score

* Reorganize output table
order Label Question Code_question score
replace score = score * 100

* Display results
list, noobs clean

* Export results to Excel
export excel using "$OUT\indice_global_matrice_Harmean.xlsx", ///
    sheet("INDICE 1") ///
    firstrow(variables) ///
    replace