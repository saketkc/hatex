- high content screening
- Colocalization analysis 
- Interaction between bio-molecules, binidnig physically -> Colocalization between channels
- Correlation: Pearson's sumple
- Manders' colocalization coefficient to account for cooccurence $M_1 = \frac{\sum_i X_i I__{Y_i>T_y}}{\sum_i X_i}$

# Structured correlation detection
- Assume each (X_i, Y-i)^T follows bivariate normal distrbution
- Without colocalization: $H_0: Corr(X_i, Y_i)=0$
- Coloxalization located at an unknown region
- Likelihood ratio statisci $L_R = -(|R|-2)log(1-r_R^2)
- But location R us unkwon
- This doesnt work for two reasons
    - Too conservative for large regions
    - Computationally expensive: Too many rectangles 
-
