*==================================================
* 00_setup.do — INQSP Personal Reproducible Demo
* Purpose: initialize project folders and checks
*==================================================

clear all
set more off
set linesize 255
version 17

* Reproducibility (simulated data)
set seed 12345

* Relative paths (assumes working directory = repo root)
global ROOT "data"
global OUT  "output"
global CODE "code"

* Create output folders
cap mkdir "$OUT"
cap mkdir "$OUT/tables"
cap mkdir "$OUT/figures"
cap mkdir "$OUT/logs"

* Check that we're in the repo root
capture confirm file "$CODE/00_setup.do"
if _rc {
    di as error "Cannot find code/00_setup.do in current folder."
    di as error "Set working directory to the repository root (the folder containing 'code' and 'data')."
    di as error "Tip: in Stata, use: cd ""path\to\INQSP_methodo"""
    exit 198
}

* Check data folder exists by trying to cd into it (works for folders)
capture cd "$ROOT"
if _rc {
    di as error "Folder 'data' not found in current working directory."
    di as error "You must run Stata from the repository root."
    exit 198
}
cd ".."   // return to repo root

di as txt "Setup OK. ROOT=$ROOT | OUT=$OUT"