# INQSP-Methodology-Demo — Simulated ENQSP Modules (for Reproducibility)

This repository provides **simulated microdata** reproducing the structure of the official ENQSP survey modules used to construct the **INQSP (Indice National de Qualité du Service Public)**.

## Language Note
Variable names follow the original **French survey structure** to preserve methodological consistency with the official dataset.  
All explanations below are provided in **English** for international readability.

---

## frontline_workers.csv

Simulated dataset representing **frontline public service workers** (agents prestataires).  
This dataset reproduces the structure of the official ENQSP staff module used in INQSP construction.

### Structure Overview
The dataset contains five blocks of variables:
1. Identification  
2. PPSP Information  
3. Agent Characteristics  
4. Quality Assessment Indicators (QA21–QA43)  
5. System Metadata  

### Detailed Variable Dictionary – frontline_workers.csv

| Variable | Description |
|----------|------------|
| interview__key | Unique identifier of the interview (string format). |
| interview__id | Internal system-generated interview ID. |
| ip1 | Primary identification code assigned to the observation. |
| localite | Locality where the PPSP is located. |
| structure | Name of the public structure. |
| code_ppsp | Numerical identifier of the public service point. |
| intitule_ppsp | Official name/title of  the service point (PPSP) in the structure. |
| code_agent | Unique identifier of the frontline agent interviewed. |
| sexe_agent_interv | Gender of the agent (male/female). |
| age | Age of the agent (in years). |
| handicap_agent_interv | Indicates whether the agent is in a situation of disability. |
| annee_prise_poste | Year the agent took office or was appointed. |
| qa21 | Indicates whether the agent received hierarchical supervision during the year. |
| qa22 | Indicates whether training needs were met. |
| qa23 | Perceived usefulness of training received. |
| qa31 | Satisfaction with the consideration given to the agent’s opinion by the supervisor. |
| qa32 | Satisfaction with the quality of available working materials. |
| qa33 | Satisfaction with workplace comfort conditions. |
| qa34 | Satisfaction with hierarchical management practices. |
| qa35 | Self-reported motivation to serve users effectively. |
| qa41 | Compliance with instructions outlined in the job description. |
| qa42 | Application of established work procedures. |
| qa43 | Suggestion for improving working conditions (binary encoded). |
| sssys_irnd | Random internal system score (technical variable for simulation/testing). |
| has__errors | Indicator flagging presence of system-recorded errors (0 = none). |
| interview__status | Interview completion status code. |
| assignment__id | Assignment batch identifier within the survey system. |
| secteur | Sector label associated with the PPSP. |
| Code_secteur | Sector classification code (1–9). |

---

## decision_makers.csv

Simulated dataset representing **institutional decision-makers** (décideurs).  
This dataset reproduces the structure of the official ENQSP decision-maker module used in INQSP construction.

### Detailed Variable Dictionary – decision_makers.csv

| Variable | Description |
|----------|------------|
| interview__key | Unique identifier of the interview (string format). |
| interview__id | Internal system-generated interview ID. |
| ip1 | Primary identification code assigned to the decision-maker. |
| ministere | Ministry to which the respondent belongs. |
| responsable | Name or identifier of the institutional decision-maker. |
| sexe | Gender of the decision-maker. |
| heure_fin | Interview completion time. |
| sssys_irnd | Random internal system score (technical variable for simulation/testing). |
| has__errors | Indicator flagging presence of system-recorded errors (0 = none). |
| interview__status | Interview completion status code. |
| assignment__id | Assignment batch identifier within the survey system. |
| responsable_intitule | Official title or function of the respondent (e.g., Director, Head of Department). |
| Code_secteur | Sector classification code (1–9). |
| q1 | Perception of the overall quality of public service delivery. |
| q2 | Perceived changes in service quality observed in 2024. |
| q3 | Major change observed within the respondent’s sector. |
| q4 | Major change observed in relation to users (service beneficiaries). |
| q5 | Existence of structural or operational challenges hindering service improvement. |
| q6 | Main sector-specific challenge identified. |
| q7 | Main user-related challenge identified. |
| q8 | Existence of a satisfaction monitoring or evaluation mechanism. |
| q81 | Reported level of user satisfaction in 2022. |
| q82 | Reported level of user satisfaction in 2023. |
| q9 | Recommendations proposed to improve service quality. |

---

## initiatives_lead.csv

Simulated dataset representing **initiative leads** (responsables d’initiatives).  
This dataset reproduces the structure of the official ENQSP initiatives module used in INQSP construction.

### Detailed Variable Dictionary – initiatives_lead.csv

| Variable | Description |
|----------|------------|
| interview__key | Unique identifier of the interview (string format). |
| interview__id | Internal system-generated interview ID. |
| ip1 | Primary identification code assigned to the initiative lead. |
| q1 | Year since which the initiative has been operational. |
| sssys_irnd | Random internal system score (technical variable for simulation/testing). |
| has__errors | Indicator flagging presence of system-recorded errors (0 = none). |
| interview__status | Interview completion status code. |
| assignment__id | Assignment batch identifier within the survey system. |
| Code_secteur | Sector classification code (1–9). |
| q2 | Existence of a beneficiary awareness mechanism. |
| q3 | Existence of an operational mechanism to evaluate initiative usage. |
| q4 | Whether a structural change has been observed since implementation of the initiative. |
| q5 | Description of the most important change observed (if applicable). |
| q6 | Existence of usage statistics related to the initiative. |
| q7 | Reported number of users benefiting from the initiative (if statistics exist). |
| q8 | Existence of an operational mechanism to evaluate impact. |
| q10 | Estimated percentage of beneficiaries satisfied with the initiative. |
| q11 | Main recommendation to improve the initiative. |
| q12 | Awareness of the concept of “Fonctionnaire Nouveau”. |
| q13 | Personal appropriation of the “Fonctionnaire Nouveau” concept (if aware). |
| q14 | Perceived appropriation of the concept among colleagues. |
| sexe | Gender of the initiative lead. |
| ministere | Ministry responsible for the initiative. |
| initiative | Name or identifier of the initiative. |
| structure | Structure or administrative unit implementing the initiative. |
| repondant | Role or title of the respondent within the initiative. |

---

## Interaction.csv

Simulated dataset representing **observed service interactions** between users and frontline workers.  
This dataset reproduces the structure of the official ENQSP observation module used in INQSP construction.

### Detailed Variable Dictionary – Interaction.csv

| Variable | Description |
|----------|------------|
| interview__key | Unique identifier of the interview (string format). |
| interview__id | Internal system-generated interview ID. |
| ip1 | Primary identification code assigned to the observation. |
| localite | Locality where the interaction took place. |
| structure | Name of the public service structure (PPSP). |
| code_ppsp | Numerical identifier of the public service point. |
| intitule_ppsp | Official short label of the PPSP. |
| code_agent | Unique identifier of the frontline agent involved in the interaction. |
| code_interaction | Unique identifier of the specific observed interaction. |
| qu1 | Indicates whether the agent greeted the user upon arrival. |
| qu2 | Indicates whether the agent smiled at the user during first contact. |
| qu3 | Indicates whether the agent offered a seat if available. |
| qu4 | Indicates whether the agent explained the procedure before starting the service. |
| qu5 | Indicates whether the agent informed the user about the service cost before starting. |
| qu6 | Indicates whether the agent listened to the user without interrupting. |
| qu7 | Indicates whether the agent answered the user’s questions. |
| qu8 | Indicates whether the agent appeared distracted during the interaction. |
| qu9 | Indicates whether the agent explained the next steps after service delivery. |
| qu10 | Indicates whether the agent asked if the user’s needs were fully met. |

---

## cso.csv

Simulated dataset representing **civil society organizations (OSC)** providing an external institutional perspective on service quality.  
This dataset reproduces the structure of the official ENQSP OSC module used in INQSP construction.

### Detailed Variable Dictionary – cso.csv

| Variable | Description |
|----------|------------|
| interview__key | Unique identifier of the interview (string format). |
| interview__id | Internal system-generated interview ID. |
| ip1 | Primary identification code assigned to the CSO respondent. |
| commune | Municipality where the CSO operates. |
| osc | Name or short label of the civil society organization. |
| repondant | Name or title of the respondent within the organization. |
| sexe | Gender of the respondent. |
| type_organisation | Type of organization (association, NGO, foundation, etc.). |
| autre_type_organisation | Specification if “other” organization type was selected. |
| nombre_anne_organisation | Number of years since the organization was established. |
| nbre_collaborateurs | Approximate number of collaborators within the organization. |
| secteur_activite | Main sector of activity (health, education, governance, etc.). |
| zone_geo | Main geographical scope of intervention. |
| contact_direct | Indicates whether the organization had direct interaction with public services. |
| satisf_globale | Overall satisfaction with the quality of public services received in 2024. |
| access_info | Satisfaction with accessibility of information regarding public services. |
| q23 | Satisfaction regarding clarity of administrative procedures. |
| q24 | Assessment of competence of public service agents. |
| q25 | Perception of reasonableness of service delivery delays. |
| q26 | Perception of how well services respond to organizational needs. |
| q29 | Willingness to recommend public services to other organizations. |
| q221 | Overall perception of service quality without direct interaction. |
| q222 | Perceived effectiveness of public services based on indirect knowledge. |
| q224 | Intention to use public services in the future. |
| points_forts | Main strengths identified in public services. |
| points_ameliorer | Key aspects needing improvement. |
| q223 | Additional aspects requiring improvement. |
| q225 | Explanation of future service use intention. |
| suggestion | Main recommendation to improve public service quality. |

---

## ppsp.csv

Simulated dataset representing **public service delivery points (PPSP)** and their operational conditions.  
This dataset reproduces the structure of the official ENQSP PPSP module used in INQSP construction.

### Detailed Variable Dictionary – ppsp.csv

| Variable | Description |
|----------|------------|
| interview__key | Unique identifier of the interview (string format). |
| interview__id | Internal system-generated interview ID. |
| ip1 | Primary identification code assigned to the PPSP record. |
| localite | Locality where the public service point (PPSP) is located. |
| structure | Name of the public service structure (PPSP). |
| code_ppsp | Numerical identifier of the public service point. |
| intitule_ppsp | Official name/title of the PPSP. |
| qp11 | Number of frontline service agents working in the PPSP. |
| qp12 | Whether staffing levels are sufficient to deliver fast and high-quality services. |
| qp13 | Number of additional agents needed (if staffing is insufficient). |
| qp14 | Availability of necessary work equipment (computers, chairs, etc.). |
| qp15 | Whether available equipment is functional and in good condition. |
| qp21 | Whether all services expected for this PPSP are effectively provided to users. |
| qp22 | Whether at least one service is accessible online without physical travel. |
| qp31__1 | Availability of statistical production element #1 (e.g., register, software, etc.). |
| qp31__2 | Availability of statistical production element #2. |
| qp31__3 | Availability of statistical production element #3. |
| qp31__4 | Availability of statistical production element #4. |
| qp32 | Whether the PPSP produces statistics on user attendance/frequency. |
| qp41 | Existence of accessibility arrangements for persons with reduced mobility (PMR). |
| qp42 | Existence of a protected waiting area for users (shelter from weather). |
| qp43__1 | Waiting area condition requirement #1 (e.g., ventilated, etc.). |
| qp43__2 | Waiting area condition requirement #2. |
| qp43__3 | Waiting area condition requirement #3. |
| qp43__4 | Waiting area condition requirement #4. |
| qp43__5 | Waiting area condition requirement #5. |
| qp44 | Number of distinct service delivery locations within the PPSP. |
| qp45 | Existence of functional toilets within the PPSP. |
| qp451 | Number of functional toilets available. |
| qp46__1 | Availability of basic amenity #1 (e.g., water). |
| qp46__2 | Availability of basic amenity #2 (e.g., electricity). |
| qp51__1 | Public information displayed #1 (e.g., opening hours). |
| qp51__2 | Public information displayed #2 (e.g., service costs). |
| qp51__3 | Public information displayed #3. |
| qp51__4 | Public information displayed #4. |
| qp52 | Presence of office signage (names or numbers) for navigation. |
| qp61 | Whether the PPSP opened in accordance with official hours. |
| qp62 | Whether service agents were present at their post at official opening time. |
| qp63 | Whether at least one user arrived before official opening time. |
| qp64 | Whether the first user was received at the official opening time. |
| qp65 | Existence of a functional document archiving system. |
| qp651__1 | Archiving system type/category #1. |
| qp651__2 | Archiving system type/category #2. |
| sssys_irnd | Random internal system score (technical variable for simulation/testing). |
| has__errors | Indicator flagging presence of system-recorded errors (0 = none). |
| interview__status | Interview completion status code. |
| assignment__id | Assignment batch identifier within the survey system. |
| secteur | Sector label associated with the PPSP. |
| Code_secteur | Sector classification code (1–9). |

---

## users.csv

Simulated dataset representing **public service users** (usagers-clients).  
This dataset reproduces the structure of the official ENQSP user module used in INQSP construction.

### Detailed Variable Dictionary – users.csv

| Variable | Description |
|----------|------------|
| interview__key | Unique identifier of the interview (string format). |
| interview__id | Internal system-generated interview ID. |
| ip1 | Primary identification code assigned to the user record. |
| localite | Locality where the public service point (PPSP) is located. |
| structure | Name of the public service structure (PPSP). |
| code_ppsp | Numerical identifier of the public service point. |
| intitule_ppsp | Official name/title of the PPSP. |
| code_usager | Unique identifier assigned to the user-client. |
| sexe | Gender of the user-client. |
| age | Age of the user-client (self-reported). |
| handicap | Indicates whether the user is in a situation of disability. |
| niveau_etude | Highest completed education level of the user. |
| professionnele | Current professional status (employed, unemployed, student, etc.). |
| qu21 | Most recent service requested by the user during the visit. |
| qu22 | Overall satisfaction with the service received today. |
| qu23 | Perceived ease of access to the PPSP. |
| qu24 | Perceived availability of service agents when needed. |
| qu25 | Evaluation of waiting time before being served. |
| qu26 | Perceived courtesy and respect demonstrated by agents. |
| qu27 | Perceived clarity and understanding of explanations provided. |
| qu28 | Degree of comfort/aisance during the visit. |
| qu29 | Perceived feeling of safety during the visit. |
| qu213 | Overall satisfaction with services received over the past 6 months. |
| qu210 | Indicates whether the user received everything they came to request. |
| qu211 | Indicates whether the service was delivered within expected deadlines. |
| qu212 | Indicates whether the user would recommend the PPSP to others. |
| qu214__1 | Priority sector identified for improvement (option 1). |
| qu214__2 | Priority sector identified for improvement (option 2). |
| qu214__3 | Priority sector identified for improvement (option 3). |
| qu214__4 | Priority sector identified for improvement (option 4). |
| qu214__5 | Priority sector identified for improvement (option 5). |
| qu214__6 | Priority sector identified for improvement (option 6). |
| qu214__7 | Priority sector identified for improvement (option 7). |
| qu214__8 | Priority sector identified for improvement (option 8). |
| autre_a_preciser | Additional aspect to specify if not captured in predefined sectors. |
| suggestion | Main recommendation proposed by the user to improve service quality. |
| heure_fin | Interview completion time. |
| sssys_irnd | Random internal system score (technical simulation variable). |
| has__errors | Indicator flagging system-recorded errors (0 = none). |
| interview__status | Interview completion status code. |
| assignment__id | Assignment batch identifier within the survey system. |
| secteur | Sector label associated with the PPSP. |
| Code_secteur | Sector classification code (1–9). |


