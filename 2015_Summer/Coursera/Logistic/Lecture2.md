##Likelihood ratio testing

Assesing the signficance of variables in the model
IF the model that includes an extra variable tells
us more about the response variable, then a model without that
variable.

This is different from considering if the predicted values
are a good representation of the observed values, which is more
of a goodness-of-fit question. We are concerened
if the predicted vaues with the variable included are
in ‘some’ way are more accurate

Comparison here is baded on log likelihood function.
Consider s aturabted model: model with number of parameters
equal to the number of data points. E.g consider a line passing
through two points => Saturated!

## Likelihood ratio test


$$
D = -2 \frac{L_model}{L_saturated}
$$
D = Deviance
To assess the signifinance of a variable 
we consider consider this:

$$
G = D(model without variable) - D(model with variable) = -2ln(L_without/L_saturated)+2ln(L_with/L_saturated) = -2ln(L_without/L_with)

$$
Thus,
$$
G = -2ln(\frac{likelihood without variable}{likelihood with variable})
$$

$$
H_0: \beta_1 =0
$$
And $G \sim \Chi^2(1)$

If you reject the hypothesis, the va
riable should be included!


WALD Test:
$$
W = \frac{\hat\beta_1}{\hat SE(\hat\beta_1)}
$$

$h_0: \beta_1=0; W \sim N(0,1)$

But WALD test is not recommmended  for significance of variable.

## Finding CI for $\beta_1$ and $\pi$

Approx 95% CI: $\hat\beta_1 +- z_{1-\alpha/2}\sqrt{Var(\hat\beta_1)}

### For $\pi$

Approach to it for $logit(\pi(x)) = \beta_0+\beta_1x$ and transform it back:

\hat{\beta_0+\beta_1x}+-z_{1-\alpha/2}\sqrt{Var(\beta_0+\beta_1x)}

then insert it into 
$$
\pi(x) = frac{e^{\beta_0+\beta_1x}}{1+e^{\beta_0+\beta_1x}}


$$

### Independent variables are discrete, nominal scaled

IF jth intdependet variable has k_j levels, we create K-j-1 dummy 
variables to model the variable . If g(x) = \beta_0 + \beta_1x1 + \beta_2x_2+...

$\pi(x) = frac{e^g(x)}{1+e^g(x)}$


Under the null hypothesis all p slopes \beta_1 to \beta_p are zero
the LR test compares: G=-2$\log(likehlihood without the p independent variables/likelihood with all p variables(saturatedmode))$
and G is $\chi^2{p}$

