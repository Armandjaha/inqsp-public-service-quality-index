# INQSP – Methodological Demonstration (Simplified Reproducible Version)

This repository provides a simplified and reproducible demonstration of the statistical methodology used to construct Côte d’Ivoire’s first **National Public Service Quality Index (INQSP)**. The INQSP was developed by the Observatoire du Service Public (OSEP), the national structure responsible for strategic monitoring and decision-making support aimed at improving public service quality and user satisfaction. The construction of the INQSP was also supported by Côte d'Ivoire National Statistics Agency (ANStat)
All examples use **synthetic data**, and the repository does *not* include any confidential or official National Public Service Quality Survey (ENQSP) datasets.

This demonstration follows the scientific standards of the **OECD–JRC Handbook on Composite Indicators (2005)** and applied governance measurement frameworks such as **(Mothupl, Man, Tabana, & Knight, 2021)** and **OxCGRT**.

---

##  Objective

The purpose of this repository is to illustrate, in a transparent and fully replicable way:

- How indicators are validated psychometrically  
- How dimensions are constructed  
- How aggregation are applied  
- How robustness and sensitivity are assessed  
- How reproducible Stata and R workflows can be implemented  

This work is directly inspired by the methodology developed for the official INQSP.

---

##  Conceptual Framework (Simplified)

The INQSP measures public service quality across several latent dimensions, typically including:

- Quality of services received by users and Civil society organizations (cso)
- Quality of service delivery  
- Quality of public services according to decision-makers  
- Quality of transformation initiatives  

These dimensions aggregate indicators from multiple population groups (users, agents, initiative leaders, decision-makers).

### Conceptual Framework
![INQSP conceptual framework](methodology/inqsp_conceptual_framework.png)

---

##  Reproducible Code Included

### **Stata**
- `code/example_inqsp.do`  
Shows dimension scoring, composite-index construction, and basic robustness checks.

### **R**
- `code/example_inqsp.R`  
Equivalent implementation with synthetic data.

### **Data**
- `data/simulated_data.csv`  
Synthetic dataset **generated** for demonstration.

---

##  Statistical Validation

The INQSP methodology relies on:

- **Correlation analysis** (redundancy and contribution)  
- **Cronbach’s alpha** (internal consistency)  
- **Exploratory Factor Analysis (EFA)** (latent-structure validation)  
- **Dimension-level aggregation** (equal weighting)  
- **Robustness tests**  
  - Leave-One-Out (LOO)  
  - Sensitivity to thresholds (Top1 / Top2 box)  
  - Arithmetic vs geometric aggregation  

Details are presented in the technical appendix↓

 **See full mathematical appendix:**  
`/methodology/Mathematical_Appendix_INQSP.md`

---

## Author and Methodological Contribution

**Armand Djaha, M.Sc. Applied Economist**
a.djaha@stat.plan.gouv.ci
armandjaha@gmail.com

Lead methodological contributor to the INQSP:

- Design of the statistical framework  
- Construction of aggregation and weighting model  
- Development of automated Stata scripts  
- Psychometric validation and robustness testing  
- Drafting of the methodological note for national institutions  
  (including the **Conseil des Ministres**)


**Observatoire du Service Public de Côte d'Ivoire(OSEP)**
milie@osep.gouv.ci

**LUCIEN KOUAKOU,head of OSEP**
lvkosep@gmail.com
lucien.kouakou@osep.gouv.ci


---

## Institutional Relevance

The INQSP is used as a national decision-support tool for:
- Governance diagnostics  
- Public service evaluation  
- Strategic reforms  
- Accountability and transparency initiatives  

---

##  License

Distributed under the **MIT License** to encourage reproducibility and academic reuse.
