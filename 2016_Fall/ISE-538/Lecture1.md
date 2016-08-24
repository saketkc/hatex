$X$ = random variable

$ S = \{1,2,3,4,5,6\}$


$ X = $ sum of two dice

\begin{align*}
P(X=2) = 1/36\\
P(X=3) = 2/36\\
\end{align*}


PMF $p(X_i) = P(X=i)$

## Expectation

E[X] = Expectation of $X$ = Mean of $X$

$X_1, X_2, X_n$ iid and define $X_i = \begin{cases}1 & i^{th}\text{ flip is heads} \\ 0 & \text{otherwise} \end{cases}$

$P(X_i =1) = p$ and $P(X_i=0) = 1-p$

Strong large of large numbers
$\frac{X_1+X_2 + \dots +X_n}{n} \longrightarrow E[X]$ as $n \longrightarrow \infty$

IT is possible to have a sequnece of all H in a n flip experiment, However the probability of this happening is 0. $n \longrightarrow \infty$ $\frac{1}{2^n} \longrightarrow 0$, but it can still happen, logically. The probability of this happening is zero

$E[\sum_i X_i] = \sum_i E[X_i]$

Example: Roll a fair dice 10 times, $X=$ sum of values

$ X = X_1 + X_2 + \dots + X_{10}$ 
$EX = \sum_i E[X_i] = 35$

Example: Matching Problem
--------------------------

$n$ people, each brings a hat. Each throws the hat in the center, mix them up. Each randomly chooses a hat, puts in on their head. A match is a person gets his own hat.

$X = # of matches$

$P(X=k) = $

$P(X=0) = 1-P(at least one match) = 1 - P(\cup A_i)$

Inculsion Exclusion: $P(\cup A_i) = \sum_i P(A_i) - \sum_{i< j} P(A_i \cap A_j) + \sum_{i<j<k} P(A_i \cap A_j \cap A_k)$

$EX = \sum_i P(X_i=1) = \sum_i \frac{1}{n} = 1$

Example 2: $n$ balls, $k$ boxes. Each ball independently in $i^{th}$ box with probability $p_i$
Number of empty boxes: $EX = \sum_iE[X_i]$ $X_i = 1$ if $i^{th}$ bos is empty
P(X_i=1) = (1-p_i)^n$

$E[X] = \sum_i (1-p_i)^n$


$Var(X) = E[(X-\mu)^2] = E[X^2-2\mu X + \mu^2] = E[X^2]-2\mu^2+\mu^2 = E[X^2]-(E[X])^2$

$Var(a+bX) = b^2Var(X)$

$E[X] = \mu$ $E[Y] = \mu_y$
$Cov(X,Y) = E[(X-\mu_X)(Y-\mu_Y)]$










