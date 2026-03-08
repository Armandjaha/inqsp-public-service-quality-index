/**************************************************************************************************
 Project      : INQSP – Public Service Quality Index
 File         : 00_master.do
 Author       : Djaha Armand Kouakou, M.Sc.
 Institution  : ANStat
 Date         : August 2025

 Description
 -----------
 Master script that runs the full INQSP pipeline.

 The pipeline computes the following components:

    1. Dimension 1 – Quality of transformation initiatives
    2. Dimension 2 – Quality of services received
    3. Dimension 3 – Quality of services delivered by PPSP
    4. Dimension 4 – Perception of decision-makers
    5. National composite index (INQSP)

 Running this script will reproduce all results and outputs.

**************************************************************************************************/

/**************************************************************************************************
 SECTION 1 — INITIALIZATION
**************************************************************************************************/

clear all
set more off

* Load project paths
do "code/00_setup.do"

display "--------------------------------------------"
display "INQSP computation started..."
display "--------------------------------------------"

timer clear
timer on 1


/**************************************************************************************************
 SECTION 2 — DIMENSION 1
**************************************************************************************************/

display "Running Dimension 1: Transformation initiatives"
do "code/01_quality_transformation.do"


/**************************************************************************************************
 SECTION 3 — DIMENSION 2
**************************************************************************************************/

display "Running Dimension 2: Quality of services received"
do "code/02_quality_services_received.do"


/**************************************************************************************************
 SECTION 4 — DIMENSION 3
**************************************************************************************************/

display "Running Dimension 3: Services delivered by PPSP"
do "code/03_quality_services_delivered.do"


/**************************************************************************************************
 SECTION 5 — DIMENSION 4
**************************************************************************************************/

display "Running Dimension 4: Perception of decision-makers"
do "code/04_quality_services_by_dm.do"


/**************************************************************************************************
 SECTION 6 — FINAL INQSP INDEX
**************************************************************************************************/

display "Computing final INQSP index"
do "code/05_final_index.do"


/**************************************************************************************************
 SECTION 7 — END
**************************************************************************************************/

timer off 1
timer list 1

display "--------------------------------------------"
display "INQSP computation completed successfully"
display "--------------------------------------------"