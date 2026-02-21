clear
set more off
set seed 987654
set obs 30000

****************************************************
* IDENTIFIANTS
****************************************************
gen str11 interview__key = string(_n, "%011.0f")
label var interview__key "Interview key"

gen str32 interview__id = string(_n*1000, "%032.0f")
label var interview__id "Interview ID"

gen str25 ip1 = "IP_"+string(_n)
label var ip1 "Identifiant IP1"

gen str10 localite = "LOC"+string(mod(_n,300))
label var localite "Localité du PPSP"

gen strL structure = "Structure_"+string(mod(_n,200))
label var structure "Nom de la structure"

gen code_ppsp = ceil(runiform()*983)
label var code_ppsp "Code du PPSP"

gen str93 intitule_ppsp = "PPSP_"+string(code_ppsp)
label var intitule_ppsp "Intitulé du PPSP"

gen code_usager = ceil(runiform()*6000)
label var code_usager "Code usager-client"

****************************************************
* CARACTÉRISTIQUES DE L'USAGER
****************************************************
gen sexe = cond(runiform()<0.5,"Homme","Femme")
label var sexe "Sexe de l'usager"

gen str18 age = string(18 + ceil(runiform()*55))
label var age "Âge de l'usager"

gen handicap = cond(runiform()<0.08,"Oui","Non")
label var handicap "Usager en situation de handicap"

gen niveau_etude = ///
cond(runiform()<0.3,"Primaire", ///
cond(runiform()<0.6,"Secondaire","Supérieur"))
label var niveau_etude "Niveau d'étude"

gen professionnele = ///
cond(runiform()<0.4,"Informel", ///
cond(runiform()<0.7,"Privé","Public"))
label var professionnele "Situation professionnelle"

****************************************************
* PRESTATION & SATISFACTION (USAGERS)
****************************************************
* QU22 (CHOIX UNIQUE) : Très insatisfait / Insatisfait / Satisfait / Très satisfait
local s1 "Très insatisfait"
local s2 "Insatisfait"
local s3 "Satisfait"
local s4 "Très satisfait"

gen qu22 = cond(runiform()<0.12,"`s1'", ///
           cond(runiform()<0.32,"`s2'", ///
           cond(runiform()<0.80,"`s3'","`s4'")))
label var qu22 "QU22 Satisfaction globale de la prestation recue aujourd'hui"

* QU23 (CHOIX UNIQUE) : Très difficile / Plutot difficile / Plutot facile / Très facile
local a1 "Très difficile"
local a2 "Plutôt difficile"
local a3 "Plutôt facile"
local a4 "Très facile"

gen qu23 = cond(runiform()<0.10,"`a1'", ///
           cond(runiform()<0.35,"`a2'", ///
           cond(runiform()<0.80,"`a3'","`a4'")))
label var qu23 "QU23 Facilite d'acces au PPSP aujourd'hui"

* QU24 (CHOIX UNIQUE) : Très indisponible / Plutot indisponible / Plutot disponible / Très disponible
local d1 "Très indisponible"
local d2 "Plutôt indisponible"
local d3 "Plutôt disponible"
local d4 "Très disponible"

gen qu24 = cond(runiform()<0.10,"`d1'", ///
           cond(runiform()<0.30,"`d2'", ///
           cond(runiform()<0.78,"`d3'","`d4'")))
label var qu24 "QU24 Disponibilite des agents au moment necessaire"

* QU25 (CHOIX UNIQUE) : Très long / Plutot long / Plutot court / Très court
local t1 "Très long"
local t2 "Plutôt long"
local t3 "Plutôt court"
local t4 "Très court"

gen qu25 = cond(runiform()<0.12,"`t1'", ///
           cond(runiform()<0.40,"`t2'", ///
           cond(runiform()<0.82,"`t3'","`t4'")))
label var qu25 "QU25 Appreciation du temps d'attente avant d'etre recu"

* QU26 (CHOIX UNIQUE) : Toujours / Parfois / Rarement / Jamais
local c1 "Toujours"
local c2 "Parfois"
local c3 "Rarement"
local c4 "Jamais"

gen qu26 = cond(runiform()<0.55,"`c1'", ///
           cond(runiform()<0.82,"`c2'", ///
           cond(runiform()<0.95,"`c3'","`c4'")))
label var qu26 "QU26 Courtoisie et respect manifestes par les agents"

* QU27 (CHOIX UNIQUE) : Très faciles à comprendre / Plutot faciles à comprendre / Plutot difficiles à comprendre / Très difficiles à comprendre
local e1 "Très faciles à comprendre"
local e2 "Plutôt faciles à comprendre"
local e3 "Plutôt difficiles à comprendre"
local e4 "Très difficiles à comprendre"

gen qu27 = cond(runiform()<0.25,"`e1'", ///
           cond(runiform()<0.65,"`e2'", ///
           cond(runiform()<0.90,"`e3'","`e4'")))
label var qu27 "QU27 Clarte et comprehension des explications"

* QU28 (CHOIX UNIQUE) : Pas du tout à l'aise / Peu à l'aise / Plutot à l'aise / Très à l'aise
local z1 "Pas du tout à l'aise"
local z2 "Peu à l'aise"
local z3 "Plutôt à l'aise"
local z4 "Très à l'aise"

gen qu28 = cond(runiform()<0.10,"`z1'", ///
           cond(runiform()<0.28,"`z2'", ///
           cond(runiform()<0.78,"`z3'","`z4'")))
label var qu28 "QU28 Degre d'aisance durant la visite"

* QU29 (CHOIX UNIQUE) : Pas du tout en securite / Plutot en danger / Plutot en securite / Tout a fait en securite
local g1 "Pas du tout en sécurité"
local g2 "Plutôt en danger"
local g3 "Plutôt en sécurité"
local g4 "Tout à fait en sécurité"

gen qu29 = cond(runiform()<0.08,"`g1'", ///
           cond(runiform()<0.18,"`g2'", ///
           cond(runiform()<0.78,"`g3'","`g4'")))
label var qu29 "QU29 Sentiment de securite durant la visite"

* QU210 (CHOIX UNIQUE) : Oui / Non
gen qu210 = cond(runiform()<0.80,"Oui","Non")
label var qu210 "QU210 Avez-vous recu tout ce que vous etes venu demander ?"

* QU211 (CHOIX UNIQUE) : Oui / Non (conditionnellement plus faible si QU210=Non)
gen qu211 = "Non"
replace qu211 = cond(runiform()<0.75,"Oui","Non") if qu210=="Oui"
replace qu211 = cond(runiform()<0.25,"Oui","Non") if qu210=="Non"
label var qu211 "QU211 Avez-vous recu l'acte ou la prestation dans les delais ?"

* QU212 (CHOIX UNIQUE) : Oui / Non
gen qu212 = cond(runiform()<0.72,"Oui","Non")
label var qu212 "QU212 Recommandation du PPSP a une autre personne"

* QU213 (CHOIX UNIQUE) : Très insatisfait / Insatisfait / Satisfait / Très satisfait
gen qu213 = cond(runiform()<0.10,"`s1'", ///
            cond(runiform()<0.28,"`s2'", ///
            cond(runiform()<0.78,"`s3'","`s4'")))
label var qu213 "QU213 Satisfaction vis-a-vis des prestations recues sur les 6 derniers mois"

* QU214__1..8 (CHOIX MULTIPLE) : Oui / Non (au moins 1 coche)
forvalues k=1/8 {
    gen qu214__`k' = cond(runiform()<0.20,"Oui","Non")
    label var qu214__`k' "QU214__`k' Secteurs a ameliorer (item `k')"
}


* autre_a_preciser (TEXTE) si "Autre" (qu214__8) = Oui
gen strL autre_a_preciser = ""
replace autre_a_preciser = "Autre secteur a preciser" if qu214__8=="Oui"
label var autre_a_preciser "autre_a_preciser"

* Suggestion (TEXTE)
gen strL suggestion = "Suggestion_"+string(ceil(runiform()*500))
label var suggestion "Suggestion"
****************************************************
* VARIABLES TECHNIQUES
****************************************************
gen str20 heure_fin = "12:"+string(ceil(runiform()*59))
label var heure_fin "Heure de fin d'entretien"

gen sssys_irnd = runiform()
label var sssys_irnd "Score random système interne"

gen has__errors = 0
label var has__errors "Indicateur d'erreur"

gen interview__status = 65 + ceil(runiform()*65)
label var interview__status "Statut interview"

gen assignment__id = 1000 + ceil(runiform()*900)
label var assignment__id "ID assignation"

gen str61 secteur = "Secteur_"+string(ceil(runiform()*9))
label var secteur "Libellé secteur"

gen Code_secteur = ceil(runiform()*9)
label var Code_secteur "Code secteur (1-9)"

/*
****************************************************
* ENCODAGE AUTOMATIQUE DES VARIABLES USAGERS
****************************************************
foreach v of varlist ///
sexe handicap niveau_etude professionnele ///
qu22 qu23 qu24 qu25 qu26 qu27 qu28 qu29 ///
qu210 qu211 qu212 qu213 ///
qu214__1 qu214__2 qu214__3 qu214__4 ///
qu214__5 qu214__6 qu214__7 qu214__8 {

    encode `v', gen(_tmp)
    drop `v'
    rename _tmp `v'
}
*/
****************************************************
* SAUVEGARDE
****************************************************
export delimited using ///
"C:\Users\a_djaha\Desktop\PHAS\OSEP_ENQSP\INDICE\Version 1\Données simulées pour GITHUB\USAGERS-CLIENTS\users.csv", replace

save ///
"C:\Users\a_djaha\Desktop\PHAS\OSEP_ENQSP\INDICE\Version 1\Données simulées pour GITHUB\USAGERS-CLIENTS\users.dta", replace
