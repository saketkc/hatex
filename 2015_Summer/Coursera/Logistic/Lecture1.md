Goal: Find simple relation between a dependent variable and covariates
The dependent variable is binary

Model:

$$
\pi(x) = \frac{e^{\beta_0+\beta_1x}}{1+e^{\beta_0+\beta_1x}}
$$

$\pi(x)$ is like a probability

Odds:
$$
g(x) = log(\frac{\pi(x)}{1-\pi(x)}) = log(e^{\beta_0+\beta_1x}) = \beta_0+\beta_1x
$$

A linear regression:

$$
y=E[Y|X] + \epsilon
$$


where $\epsilon \sim N(0, \sigma^2)$ and hence $y|x \sim N(E[Y|X], \sigma^2)$

But with a dichotomous variable y, normality cannot hold!

so we model it as:

$y \sim \pi(x) + \epsilon$

and $\epsilon$ assumes only two values:

	When $y=1$, $\epsilon = 1-\pi(x)$ with probability $\pi(x)$
	When $y=0$, $\epsilon = -\pi(x)$ with probability $1-\pi(x)$ 

Thus, $y \binom(\pi(x))$

Strategy to find parameters $\beta_0, \beta_1$ in linear regression:
By minimising $\sum (y_i - y_i')$ we obtain UMVUE estimates $\beta_0', \beta_1'$

## Log Likelihood for ML estimates(UMVUE not guaranteed)

$$
L = \Prod\frac{e^{(\beta_0+\beta_1x_i)I_i}}{1+e^{\beta_0+\beta_1x}}
$$


Or in a much better way:

$$
L = \Prod \epsilon(x_i)
$$
where
$$
\epsilon(x_i) = \pi(x_i)^{y_i}[1-\pi(x_i)]^{1-y_i}
$$

$y_i$ is either 0 or 1


$$
log l = \sum (y_i ln(\pi(x_i)) + (1-y_i)ln(1-\pi(x_i)))
$$

$$
\sum y_i = \sum \hat\pi(x_i)
$$

where $\hat\pi(x)$ is the conditional probabilty of X=x given y=1


