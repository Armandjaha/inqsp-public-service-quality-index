/**************************************************************************************************
 Project      : INQSP – Public Service Quality Index
 File         : 04_Decision_makers_perception.do
 Author       : Djaha Armand Kouakou, M.Sc.
 Date         : August 2025

 Description
 -----------
 This script computes Dimension 4 of the INQSP index:
 "Overall Perception of Public Service Quality by Decision-Makers".

 The index is constructed using four indicators:

   Q1 : Overall satisfaction with public service quality
   Q2 : Observed changes in public service delivery
   Q5 : Absence of challenges affecting service quality (inverted)
   Q8 : Existence of monitoring or evaluation mechanisms

 The final index is computed as a simple average of the four components.

 Dependencies
 ------------
 - code/00_setup.do
 - $ROOT/decision_makers.dta

 Output
 ------
 Excel file :
 $OUT/indice_global_matrice_Harmean.xlsx

**************************************************************************************************/


/**************************************************************************************************
 SECTION 1 — INITIALIZATION
**************************************************************************************************/

clear all
set more off
do "code/00_setup.do"


/**************************************************************************************************
 SECTION 2 — DATA PREPARATION
**************************************************************************************************/

use "$ROOT\decision_makers", clear


/**************************************************************************************************
 STEP 2.1 — VARIABLE RECODING
 Convert categorical responses to binary indicators
**************************************************************************************************/

foreach var in q1 q2 q3 q4 q5 q6 q7 q8 q81 q82 q9 {
    decode `var', generate(`var'_str)
    drop `var'
    rename `var'_str `var'
}


* Q1 : Overall satisfaction with public service quality
gen Q1 = (q1 == "Très_satisfait")
sum Q1
scalar s1 = r(mean)


* Q2 : Observed changes in the service
gen Q2 = (q2 == "Oui")
sum Q2
scalar s2 = r(mean)
label var Q2 "Observed change (0=No,1=Yes)"


* Q3 : Absence of challenges affecting service quality
gen Q3 = .
replace Q3 = 1 if q5 == "Non"   // absence of challenges
replace Q3 = 0 if q5 == "Oui"   // challenges present
sum Q3
scalar s3 = r(mean)
label var Q3 "Absence of quality constraints (0=No,1=Yes)"


* Q4 : Existence of monitoring mechanism
gen Q4 = (q8 == "Oui")
sum Q4
scalar s4 = r(mean)
label var Q4 "Monitoring system present (0=No,1=Yes)"


/**************************************************************************************************
 STEP 2.2 — CONSISTENCY TEST
 Evaluate coherence across indicators
**************************************************************************************************/

corr Q1 Q2 Q3 Q4
alpha Q1 Q2 Q3 Q4, item
factor Q1 Q2 Q3 Q4

/*
Interpretation note:

The index is composed of conceptually independent indicators.
Low internal consistency is therefore expected and acceptable.

Each indicator captures a distinct dimension of decision-makers'
perception regarding public service quality.
*/


/**************************************************************************************************
 SECTION 3 — INDEX CONSTRUCTION
**************************************************************************************************/

egen indice_decideurs = rowmean(Q1 Q2 Q3 Q4)
label var indice_decideurs "Composite index – Decision makers perception (0–1)"

sum indice_decideurs
scalar indice_dec = r(mean)


/**************************************************************************************************
 SECTION 4 — RESULT MATRIX
**************************************************************************************************/

matrix result_decid = (indice_dec \ s1 \ s2 \ s3 \ s4)

matrix rownames result_decid = ///
INDICE_DECIDEURS ///
SOUS_IND_1_PERCEPTION ///
SOUS_IND_2_CHANGEMENTS ///
SOUS_IND_3_DEFIS ///
SOUS_IND_4_DISPOSITIF

mat list result_decid


/**************************************************************************************************
 SECTION 5 — TABULATION AND EXPORT
**************************************************************************************************/

clear
svmat result_decid, names(col)


* Dimension labels (English)
gen Label = ""
replace Label = "DIMENSION 4: Overall Perception of Decision-Makers" in 1
replace Label = "SUB-DIMENSION 1: Perception of Overall Quality (Q1)" in 2
replace Label = "SUB-DIMENSION 2: Changes Observed in the Service (Q2)" in 3
replace Label = "SUB-DIMENSION 3: Absence of Challenges Hindering Quality (Inverted Q5)" in 4
replace Label = "SUB-DIMENSION 4: Existence of a Monitoring System (Q8)" in 5


* Labels
replace Label = "DIMENSION 4: Overall Perception of Decision-Makers" in 1
replace Label = "SUB-DIMENSION 1: Perception of Overall Quality (Q1)" in 2
replace Label = "SUB-DIMENSION 2: Changes Observed in the Service (Q2)" in 3
replace Label = "SUB-DIMENSION 3: Absence of Challenges Hindering Quality (Inverted Q5)" in 4
replace Label = "SUB-DIMENSION 4: Existence of a Monitoring System (Q8)" in 5



* Traceability columns
gen Code_question = ""
gen Question      = ""

replace Code_question = "AGREG(Q1,Q2,Q5,Q8)" in 1
replace Question = "Aggregate perception index across four indicators" in 1

replace Code_question = "Q1" in 2
replace Question = "Overall satisfaction with public service quality" in 2

replace Code_question = "Q2" in 3
replace Question = "Observed improvements in the service" in 3

replace Code_question = "Q5 (inverted)" in 4
replace Question = "Absence of challenges affecting service quality" in 4

replace Code_question = "Q8" in 5
replace Question = "Presence of monitoring or evaluation mechanisms" in 5


* Rename score column
rename c1 score

* Reorganize output table
order Label Code_question Question score

* Convert scores to percentage
replace score = score * 100


* Export Excel
export excel using "$OUT\indice_global_matrice_Harmean.xlsx", ///
    sheet("INDICE 4") ///
    firstrow(variables) ///
    sheetmodify


/**************************************************************************************************
 METHODOLOGICAL NOTE
**************************************************************************************************

Indicator interpretation:

Q1 = subjective perception of service quality (satisfaction)

Q2 = perceived transformation or improvement in service delivery

Q5 = absence of structural challenges affecting service quality
     (variable inverted to ensure positive interpretation)

Q8 = existence of monitoring or evaluation systems

The index ranges between 0 and 1.

Values closer to 1 indicate that decision-makers perceive
public service quality as high and supported by institutional mechanisms.

Variables Q81 and Q82 are retained as contextual indicators
but are not included in the composite score.

**************************************************************************************************/