# Mathematical Appendix – INQSP Composite Index 

This appendix presents the complete mathematical framework used to construct Côte d’Ivoire’s first National Public Service Quality Index (INQSP). It follows the methodological standards of the OECD–JRC Handbook on Composite Indicators (2005) and applied governance and service-delivery measurement frameworks.

---

# 1. Redundancy and Contribution Analysis

This step ensures that indicators capture unique information and do not double-count the same latent phenomenon.

## 1.1 Correlation Matrix

The linear correlation between two indicators x_i and x_j is:

rho_ij = cov(x_i, x_j) / (sigma_i * sigma_j)

Decision rules:
- High redundancy: if rho_ij > 0.95 --> remove one of the indicators
- Low contribution: if mean correlation of an indicator with all others < 0.30 --> remove indicator

When redundancy is detected, the removed indicator is typically:
- the one with lower variance, or
- the one with weaker conceptual relevance.

---

## 1.2 Internal Consistency – Cronbach’s Alpha

Cronbach’s alpha measures the internal coherence of a set of indicators:

alpha = (Q / (Q - 1)) * (1 - sum(Var(x_j)) / Var(sum(x_j)))

Where:
- Q = number of items
- Var(x_j) = variance of item j
- Var(sum(x_j)) = variance of the composite raw score

Interpretation:
> 0.80 : Excellent  
0.70–0.80 : Acceptable  
< 0.70 : Weak consistency  

---

# 2. Exploratory Factor Analysis (EFA)

EFA verifies that indicators cluster around coherent latent constructs.

## 2.1 Factor Model

Each indicator is represented as:

x_i = a_i1 * F1 + a_i2 * F2 + ... + a_im * Fm + e_i

Where:
- a_ij = factor loading
- F_j = latent factor
- e_i = specific error

## 2.2 Steps

1. Construct correlation matrix  
2. Extract eigenvalues and eigenvectors  
3. Retain factors according to:
   - Kaiser rule (eigenvalue > 1)
   - Variance explained (≥ 40% for main factor)
   - Interpretability and dimensional coherence  

Indicators are selected based on:
- loading ≥ 0.40,
- contribution to reliability,
- conceptual relevance.

---

# 3. Normalisation 

INQSP relies mainly on binary satisfaction indicators:

X_ij = 1 if response is in the satisfaction category  
X_ij = 0 otherwise

---

# 4. Aggregation Rules

## 4.1 Within-Dimension Aggregation (Equal Weights)

D_j = (1 / n_j) * sum(X_ij)

Where:
- D_j = dimension j score
- n_j = number of validated indicators

## 4.2 Across-Dimensions Aggregation (Equal Weights)

INQSP = (1 / J) * sum(D_j)

Where J = 4 dimensions.

Equal weighting ensures transparency and interpretability.

---

# 5. Robustness and Sensitivity Analysis

This step tests whether index results remain stable under alternative assumptions.

---

## 5.1 Leave-One-Out (LOO)

For a dimension with L indicators:

DI_without_j = (1 / (L - 1)) * sum( X_l  for all l ≠ j )

Robustness metrics:

- Level correlation:
  rho_level = corr(DI, DI_without_j)

- Rank correlation (Spearman):
  rho_rank = corr_rank(DI, DI_without_j)

- Mean Absolute Deviation:
  MAD = (1 / N) * sum(abs(DI_without_j - DI))

- Decile instability:
  rshiftshare = (1 / N) * sum(q(DI) != q(DI_without_j))

Where q(.) is the decile classification.

---

## 5.2 Sensitivity to Satisfaction Thresholds (Top 1 vs Top 2)

Definitions:

X_top1 = 1 if response = 4  
X_top2 = 1 if response in {3, 4}

Scores:

DI_top1 = (1 / L) * sum(X_top1)  
DI_top2 = (1 / L) * sum(X_top2)

Compare via correlations and decile shifts.

---

## 5.3 Arithmetic vs Geometric Aggregation

Arithmetic mean (default):

D_A = (1 / n_j) * sum(X_ij)

Geometric mean (using epsilon > 0 to avoid log(0)):

D_G = exp( (1 / L) * sum( ln(X_i + epsilon) ) )

Correlation comparison:

rho_AG = corr(D_A, D_G)

For binary data, geometric means over-penalize zeros and are not recommended.

---

# 6. Final INQSP Structure (2024)

The final validated structure includes:

- 4 dimensions  
- A core set of validated indicators  
- Equal weighting across and within dimensions  
- Full robustness and sensitivity validation  

---

# 7. Reproducibility

All implementation scripts are provided:

- Stata workflow: `code/example_inqsp.do`
- R workflow: `code/example_inqsp.R`
- Synthetic data: `data/simulated_data.csv`
