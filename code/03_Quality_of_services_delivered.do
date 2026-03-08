/**************************************************************************************************
 Project      : INQSP – Public Service Quality Index
 File         : 03_Quality_of_services_provided_by_PPSP.do
 Author       : Armand Djaha Kouakou, M.Sc.
 Date         : August 2025

 Description
 -----------
 This script computes Dimension 3 of the INQSP index:
 "Quality of Services Provided by PPSP".

 The dimension is composed of five sub-indices:

   1. Working conditions of frontline staff
   2. Physical environment and operational resources
   3. Information provided to users
   4. Service continuity mechanisms
   5. Staff–user interactions

 The final dimension score is the equal-weighted average of the five sub-indices.

 Dependencies
 ------------
 - code/00_setup.do
 - $ROOT/AGENTS_PRESTATAIRES/frontline_workers.dta
 - $ROOT/ppsp.dta
 - $ROOT/INTERACTIONS/interaction.dta

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
 SUB-INDEX 1 — WORKING CONDITIONS OF FRONTLINE STAFF
**************************************************************************************************/

use "$ROOT\AGENTS_PRESTATAIRES\frontline_workers", clear


/**************************************************************************************************
 STEP 1.1 — VARIABLE PREPARATION
**************************************************************************************************/

foreach var in qa21 qa22 qa33 qa34 qa23 qa31 qa32 qa41 qa42 qa35 {
    decode `var', generate(`var'_str)
    drop `var'
    rename `var'_str `var'
}

* Q1 : Supervision
gen q1 = (qa21 == "Oui")
label var q1 "Supervised at least once"

* Q2 : Satisfaction with equipment
gen q2=.
replace q2 = 1 if qa32 == "Très insatisfait"
replace q2 = 2 if qa32 == "Insatisfait"
replace q2 = 3 if qa32 == "Satisfait"
replace q2 = 4 if qa32 == "Très satisfait"

* Q3 : Workplace comfort
gen q3=.
replace q3 = 1 if qa33 == "Très insatisfait"
replace q3 = 2 if qa33 == "Insatisfait"
replace q3 = 3 if qa33 == "Satisfait"
replace q3 = 4 if qa33 == "Très satisfait"

* Q4 : Management satisfaction
gen q4=.
replace q4 = 1 if qa34 == "Très insatisfait"
replace q4 = 2 if qa34 == "Insatisfait"
replace q4 = 3 if qa34 == "Satisfait"
replace q4 = 4 if qa34 == "Très satisfait"

* Q5 : Training usefulness
gen q5 = (qa23 == "Oui")

* Q6 : Opinion taken into account
gen q6=.
replace q6 = 1 if qa31 == "Très insatisfait"
replace q6 = 2 if qa31 == "Insatisfait"
replace q6 = 3 if qa31 == "Satisfait"
replace q6 = 4 if qa31 == "Très satisfait"

* Q7 : Training needs fulfilled
gen q7 = (qa22 == "Oui")

* Q8 : Respect of job description
gen q8 = (qa41 == "Oui")

* Q9 : Motivation
gen q9=.
replace q9 = 1 if qa35 == "Pas du tout motivé"
replace q9 = 2 if qa35 == "Un peu motivé"
replace q9 = 3 if qa35 == "Motivé"

* Q10 : Follow procedures
gen q10 = (qa42 == "Oui")


/**************************************************************************************************
 STEP 1.2 — ITEM CONSISTENCY TEST
**************************************************************************************************/

corr q1-q10
alpha q1-q10, item
factor q1-q10

alpha q1-q6 q8-q10, item
factor q1-q4 q6-q10


/**************************************************************************************************
 STEP 1.3 — AGGREGATION : FRONTLINE STAFF
**************************************************************************************************/

* Sub-index 1 : perceived work environment
gen q2_bin = (q2==4)
sum q2_bin
scalar s1_1 = r(mean)

gen q3_bin = (q3==4)
sum q3_bin
scalar s1_2 = r(mean)

gen q4_bin = (q4==4)
sum q4_bin
scalar s1_3 = r(mean)

gen q6_bin = (q6==4)
sum q6_bin
scalar s1_4 = r(mean)

gen s_agent1 = (q2_bin + q3_bin + q4_bin + q6_bin)/4
sum s_agent1
scalar agent1 = r(mean)

* Sub-index 2 : discipline and compliance
gen q8_bin = (q8==1)
sum q8_bin
scalar s2_1 = r(mean)

gen q10_bin = (q10==1)
sum q10_bin
scalar s2_2 = r(mean)

egen s_agent2 = rowmean(q8_bin q10_bin)
sum s_agent2
scalar agent2 = r(mean)

* Global staff index
egen indice_agents = rowmean(s_agent1 s_agent2)
sum indice_agents
scalar s_agents = r(mean)


/**************************************************************************************************
 SUB-INDEX 2 — PHYSICAL WORK ENVIRONMENT AND RESOURCES
**************************************************************************************************/

use "$ROOT\ppsp", clear


/**************************************************************************************************
 STEP 2.1 — VARIABLE PREPARATION
**************************************************************************************************/

foreach var in qp46__1 qp46__2 qp41 qp42 qp12 qp31__1 qp31__2 qp31__3 qp31__4 qp15 qp45 qp14 qp51__1 qp51__2 qp51__3 qp51__4 qp52 qp61 qp62 qp63 qp64 qp65 {
    decode `var', generate(`var'_str)
    drop `var'
    rename `var'_str `var'
}

gen acces_eau = (qp46__1 == "Oui")
sum acces_eau
scalar eau = r(mean)

gen mat_bon = (qp15 == "Oui")
sum mat_bon
scalar mb = r(mean)

gen mat_complet = (qp14 == "Oui")
sum mat_complet
scalar mc = r(mean)

gen toilette = (qp45 == "Oui")
sum toilette
scalar toi = r(mean)

gen waiting_area = (qp42 == "Oui")
sum waiting_area
scalar war = r(mean)


/**************************************************************************************************
 STEP 2.2 — CONSISTENCY TEST
**************************************************************************************************/

corr acces_eau mat_bon mat_complet toilette waiting_area
alpha acces_eau mat_bon mat_complet toilette waiting_area, item
factor acces_eau mat_bon mat_complet toilette waiting_area


/**************************************************************************************************
 STEP 2.3 — AGGREGATION
**************************************************************************************************/

egen indice_env = rowmean(acces_eau mat_bon mat_complet toilette waiting_area)
sum indice_env
scalar s_env = r(mean)


/**************************************************************************************************
 SUB-INDEX 3 — INFORMATION PROVIDED
**************************************************************************************************/

foreach v in 1 2 3 4 {
    gen info_disp_`v' = (qp51__`v' == "Oui")
}

egen info_disp_sum = rowtotal(info_disp_1-info_disp_4)
gen info_disp = (info_disp_sum == 4)

sum info_disp
scalar id = r(mean)

gen info_sign = (qp52 == "Oui")
sum info_sign
scalar is = r(mean)

gen info_fournie = (info_disp + info_sign)/2
sum info_fournie
scalar s3 = r(mean)

corr info_disp info_fournie


/**************************************************************************************************
 SUB-INDEX 4 — SERVICE CONTINUITY MECHANISM
**************************************************************************************************/

gen open_on_time = (qp61 == "Oui")
sum open_on_time
scalar ot = r(mean)

gen agents_on_time = (qp62 == "Oui")
sum agents_on_time
scalar at = r(mean)

gen archive = (qp65 == "Oui")

corr open_on_time agents_on_time archive
alpha open_on_time agents_on_time archive, item
factor open_on_time agents_on_time archive

egen punctuality = rowmean(open_on_time agents_on_time)
sum punctuality
scalar s_punctuality = r(mean)


/**************************************************************************************************
 SUB-INDEX 5 — STAFF–USER RELATIONSHIP
**************************************************************************************************/

use "$ROOT\INTERACTIONS\interaction", clear

foreach var in qu1 qu2 qu3 qu4 qu5 qu6 qu7 qu8 qu9 qu10 {
    decode `var', generate(`var'_str)
    drop `var'
    rename `var'_str `var'
}

gen besoins_combles = (qu10 == "Oui")
sum besoins_combles
scalar bc = r(mean)

gen procedure = (qu4 == "Oui")
sum procedure
scalar pro = r(mean)

gen salue = (qu1 == "Oui")
sum salue
scalar sal = r(mean)

gen sourit = (qu2 == "Oui")
sum sourit
scalar sou = r(mean)

corr besoins_combles procedure salue sourit
alpha besoins_combles procedure salue sourit, item
factor besoins_combles procedure salue sourit

egen indice_relation = rowmean(besoins_combles procedure salue sourit)
sum indice_relation
scalar s5 = r(mean)


/**************************************************************************************************
 GLOBAL DIMENSION INDEX
**************************************************************************************************/

gen indice_3 = (s_agents + s_env + s3 + s_punctuality + s5)/5
sum indice_3
scalar ind3 = r(mean)


/**************************************************************************************************
 RESULT MATRIX
**************************************************************************************************/

matrix result = (ind3 \ s_agents \ agent1 \ s1_1 \ s1_2 \ s1_3 \ s1_4 \ agent2 \ s2_1 \ s2_2 \ ///
                 s_env \ eau \ mb \ mc \ toi \ war \ ///
                 s3 \ id \ is \ ///
                 s_punctuality \ ot \ at \ ///
                 s5 \ bc \ pro \ sal \ sou)

matrix rownames result = ///
INDICE_3_GLOBAL ///
SOUS_IND_1_COND_TRAVAIL ///
IND_1_1_sat_materiel ///
IND_1_2_confort_lieu ///
IND_1_3_sat_management ///
IND_1_4_prise_en_compte ///
SOUS_IND_1_DISCIPLINE ///
IND_1_5_respect_fiche ///
IND_1_6_suit_proced ///
SOUS_IND_2_ENV_PHYSIQ ///
IND_2_1_eau ///
IND_2_2_mat_bon ///
IND_2_3_mat_complet ///
IND_2_4_toilette ///
IND_2_5_salle_attente ///
SOUS_IND_3_INFO ///
IND_3_1_info_aff4 ///
IND_3_2_signaletique ///
SOUS_IND_4_CONTINUITE ///
IND_4_1_ouv_heure ///
IND_4_2_agents_heure ///
SOUS_IND_5_RELATION ///
IND_5_1_besoins ///
IND_5_2_procedure ///
IND_5_3_salue ///
IND_5_4_sourit


/**************************************************************************************************
 TABULARIZATION AND EXPORT
**************************************************************************************************/

clear
svmat result, names(col)

gen Label = ""
replace Label = "DIMENSION 3: QUALITY OF SERVICES PROVIDED BY PPSP" in 1
* ---- SUB-DIMENSION 1 ----
replace Label = " SUB-DIMENSION 1: Working Conditions of Staff" in 2
replace Label = "Component 1: Perceived Work Environment" in 3
replace Label = "Indicator 1: Material Satisfaction" in 4
replace Label = "Indicator 2: Comfort of the Workplace" in 5
replace Label = "Indicator 3: Management Satisfaction" in 6
replace Label = "Indicator 4: Consideration of Feedback" in 7

replace Label = "Component 2: Discipline & Compliance" in 8
replace Label = "Indicator 1: Adherence to Job Description" in 9
replace Label = "Indicator 2: Follows procedures" in 10

* ---- SUB-DIMENSION 2 ----
replace Label = "SUB-DIMENSION 2: Physical Environment and Resources" in 11
replace Label = "Indicator 1: Access to Water" in 12
replace Label = "Indicator 2: Equipment in Good Condition" in 13
replace Label = "Indicator 3: Complete Equipment" in 14
replace Label = "Indicator 4: Functional Toilets" in 15
replace Label = "Indicator 5: Waiting Area" in 16

* ---- SUB-DIMENSION 3 ----
replace Label = "DIMENSION 3: Information Provided" in 17
replace Label = "Indicator 1: 4 Information Displayed" in 18
replace Label = "Indicator 2: Door/Office Signage" in 19

* ---- SUB - DIMENSION 4 ----
replace Label = "DIMENSION 4: Service Continuity Mechanism" in 20
replace Label = "Indicator 1: Opens on Time" in 21
replace Label = "Indicator 2: Staff on Time" in 22

* ---- SUB-DIMENSION 5 ----
replace Label = "DIMENSION 5: Staff-User Relationship (Interactions)" in 23
replace Label = "Indicator 1: Needs Met" in 24
replace Label = "Indicator 2: Procedure Explained" in 25
replace Label = "Indicator 3: Staff Greets" in 26
replace Label = "Indicator 4: Staff Smiles" in 27

* === Colonnes d'origine des résultats ===
gen Code_question = ""
gen Question      = ""

* 1) INDICE GLOBAL
replace Code_question = "AGREG" in 1
replace Question      = "Agrégation des dimensions 1–5" in 1

* ---------- SUB-DIMENSION 1: Employee Working Conditions ----------
replace Code_question = "AGREG(QA32,QA33,QA34,QA31,QA41,QA42)" in 2
replace Question = "Aggregate: equipment, comfort, management, feedback taken into account, job description, adherence to procedures" in 2

replace Code_question = "SOUS AGREG (QA32,QA33,QA34,QA31)" in 3
replace Question = "Aggregate: equipment, comfort, management, feedback" in 3
replace Code_question = "QA32" in 4
replace Question = "Workplace satisfaction?" in 4
replace Code_question = "QA33" in 5
replace Question = "Workplace comfort?" in 5

replace Code_question = "QA34" in 6
replace Question = "Satisfaction with management?" in 6
replace Code_question = "QA31" in 7
replace Question = "Is your opinion taken into account?" in 7
replace Code_question = "SOUS AGGREG QA41,QA42" in 8
replace Question = "Is your opinion taken into account?" in 8
replace Code_question = "QA41" in 9
replace Question = "Respect for the job description?" in 9
replace Code_question = "QA42" in 10
replace Question = "Follow-up to procedures?" in 10

* ---------- SUB-DIMENSION 2: Physical Environment & Resources ----------
replace Code_question = "AGREG(QP46__1,QP15,QP14,QP45,QP42)" in 11
replace Question = "Aggregate: water, equipment in good condition, complete equipment, toilets, waiting area" in 11

replace Code_question = "QP46__1" in 12
replace Question = "Access to drinking water?" in 12
replace Code_question = "QP15" in 13
replace Question = "Equipment functional and in good condition?" in 13
replace Code_question = "QP14" in 14
replace Question = "Complete necessary equipment?" in 14
replace Code_question = "QP45" in 15
replace Question = "Functional toilets?" in 15
replace Code_question = "QP42" in 16
replace Question = "Protected waiting area?" in 16

* ---------- SUB-DIMENSION 3: Information Provided ----------
replace Code_question = "AGREG(QP51__1..4=all,QP52)" in 17
replace Question = "Aggregate: 4 pieces of information displayed + signage on doors/offices" in 17

replace Code_question = "QP51__1..4 (all=Yes)" in 18
replace Question = "4 pieces of information displayed: services, costs, hours, contacts?" in 18
replace Code_question = "QP52" in 19
replace Question = "Signage/numbering on doors and offices?" in 19

* ---------- SUB-DIMENSION 4: Service Continuity Mechanism ----------
replace Code_question = "AGREG(QP61,QP62)" in 20
replace Question = "Aggregate: opening on time + staff on time" in 20

replace Code_question = "QP61" in 21
replace Question = "Are premises open on time?" in 21
replace Code_question = "QP62" in 22
replace Question = "Are service providers on time?" in 22

* === SUB-DIMENSION 5: Agent-User Relationship (Interactions) ===
replace Code_question = "AGREG(QU10,QU4,QU1,QU2)" in 23
replace Question = "Aggregate: needs met, procedure explained, greeting, smile" in 23

replace Code_question = "QU10" in 24
replace Question = "Did the agent ask the user if their needs had been met?" in 24
replace Code_question = "QU4" in 25
replace Question = "Did the agent explain the procedure before starting?" in 25
replace Code_question = "QU1" in 26
replace Question = "Did the agent greet the user upon arrival?" in 26
replace Code_question = "QU2" in 27
replace Question = "Did the agent smile during the first contact?" in 27


rename c1 score
order Label Code_question Question score
replace score = score * 100

export excel using "$OUT\indice_global_matrice_Harmean.xlsx", ///
sheet("INDICE 3") firstrow(variables) sheetmodify