/**************************************************************************************************
 Project      : INQSP – Public Service Quality Index
 File         : 05_Global_INQSP_Index.do
 Author       : Djaha Armand Kouakou, M.Sc.
 Date         : August 2025

 Description
 -----------
 This script computes the national composite index INQSP by aggregating
 the dimension scores exported in the Excel workbook:

    indice_global_matrice_Harmean.xlsx

 Each dimension score corresponds to the first row of the following sheets:

    INDICE 1
    INDICE 2_2
    INDICE 3
    INDICE 4

 The final INQSP score is calculated as the simple average of these
 four dimensions.

 Output
 ------
 Excel sheet:
    INQSP

**************************************************************************************************/

/**************************************************************************************************
 SECTION 1 — INITIALIZATION
**************************************************************************************************/

clear all
set more off
do "code/00_setup.do"

tempfile all


/**************************************************************************************************
 SECTION 2 — IMPORT DIMENSION SCORES
**************************************************************************************************/

local sheets `" "INDICE 1" "INDICE 2_2" "INDICE 3" "INDICE 4" "'

local first = 1

foreach sh of local sheets {

    import excel using "$OUT\indice_global_matrice_Harmean.xlsx", ///
        sheet("`sh'") firstrow clear

    * Keep only the first row (dimension score)
    keep in 1

    * Identify the source sheet
    gen sheet = "`sh'"

    if `first' {
        save `all', replace
        local first = 0
    }
    else {
        append using `all'
        save `all', replace
    }
}


/**************************************************************************************************
 SECTION 3 — CONSOLIDATED DATASET
**************************************************************************************************/

use `all', clear
list sheet score


/**************************************************************************************************
 SECTION 4 — COMPUTE GLOBAL INQSP INDEX
**************************************************************************************************/

summarize score
scalar INQSP = r(mean)


/**************************************************************************************************
 SECTION 5 — STORE SUB-INDICES
**************************************************************************************************/

keep sheet score
tempfile subindices
save `subindices'


/**************************************************************************************************
 SECTION 6 — CREATE FINAL OUTPUT TABLE
**************************************************************************************************/

clear
set obs 1

gen sheet = "INQSP (global index)"
gen score = scalar(INQSP)

append using `subindices'


/**************************************************************************************************
 SECTION 7 — ORDER DIMENSIONS
**************************************************************************************************/

gen order = .

replace order = 0 if sheet=="INQSP (global index)"
replace order = 1 if sheet=="INDICE 1"
replace order = 2 if sheet=="INDICE 2_2"
replace order = 3 if sheet=="INDICE 3"
replace order = 4 if sheet=="INDICE 4"

sort order
drop order


/**************************************************************************************************
 SECTION 8 — CREATE LABELS
**************************************************************************************************/

gen full_label = ""

replace full_label = ///
"National Public Service Quality Index (INQSP)" ///
if sheet=="INQSP (global index)"

replace full_label = ///
"DIMENSION 1: QUALITY OF PUBLIC SERVICE TRANSFORMATION INITIATIVES" ///
if sheet=="INDICE 1"

replace full_label = ///
"DIMENSION 2: QUALITY OF SERVICES RECEIVED BY USERS" ///
if sheet=="INDICE 2_2"

replace full_label = ///
"DIMENSION 3: QUALITY OF SERVICES PROVIDED BY PUBLIC SERVICE DELIVERY POINTS (PPSP)" ///
if sheet=="INDICE 3"

replace full_label = ///
"DIMENSION 4: OVERALL PERCEPTION OF DECISION-MAKERS" ///
if sheet=="INDICE 4"


/**************************************************************************************************
 SECTION 9 — FINAL TABLE FORMAT
**************************************************************************************************/

rename sheet Label
rename full_label TITLE
rename score SCORE

order Label TITLE SCORE

replace LABEL = "DIMENSION 1" in 2
replace LABEL = "DIMENSION 2" in 3
replace LABEL = "DIMENSION 3" in 4
replace LABEL = "DIMENSION 4" in 5


/**************************************************************************************************
 SECTION 10 — EXPORT RESULTS
**************************************************************************************************/

list LABEL TITLE SCORE, noobs

export excel using "$OUT\indice_global_matrice_Harmean.xlsx", ///
    sheet("INQSP") ///
    firstrow(variables) ///
    sheetmodify