Independent RV $P(X=x,Y=y) = P(X=x)P(Y=y)$i or $P(X \in A, Y \in B) = P(X \in A)P(Y \in B)$

$E[X] = \sum_x xP(X=x)$ or $E[X] = \int xf(x)dx$

$Variance = E[(X-\mu)^2] = E[X^2]-(E[X])^2$

$Cov(X,Y) = E[(X-\mu_X)(Y-\mu_Y)] = E[XY]-E[X]E[Y]$

Independence $\implies$ Cov = 0

Cov =0 does not $\implies$ Indepennce.
Example: $X= \{-1,0,1\}$ and $Y=X^2$


Indicator variable: $E[I_x] = P(I_x=1)$

Moment generating function: $\psi(t) = E[e^{tX}]$

$\frac{d\psi(t)}\frac{dt} = \frac{d}{dt} \int  e^{tx} f(x) dx =  \int xe^{tx} f(x) dx$
Thus, $\psi'(0) = E[X]$

$\psi''(t) = E[X^2]$

$\psi^n(t) = E[X^n]$


Example: Two gaussian Rv. $X,Y$, $Z=X+Y$
$M_Z = E[e^{tX+tY}] = E[e^{tX}]E[e^{tY}] = \psi_X(t) \psi_Y(t) = e^{\mu_xt + \frac{1}{2} \sigma_x^2} \times e^{\mu_yt+\frac{1}{2}\sigma_y^2} 
= e^{\mu_xt+\mu_yt + \frac{1}{2}(\sigma_x^2+\sigma_y^2) $


Joint MGF: $\psi(t_1, t_2, \dots, t_n) = E[e^{\sum_i t_i X_i}]$


## Conditional distrbituion and conditional expectation

$E[X_1+X_2|Y=y] = E[X_1|Y=y] + E[X_2|Y=y]$

## Conditional expectation as r.v

Y - discrete r.v.

X - discerte r.v

$E[X|Y=y_1] = \sum x P(X|Y=y_1)$

$h(y_i) = E[X|Y=y_i]$ so h(Y) is like a r.v.

$E[h(y)] = \sum_i h(y_i)P(Y=y_i) = \sum E[X|Y=y_i]P(Y=y_i)  = \sum_i \sum_j x_j P(X=x_j|Y=y_i)P(Y=y_i) = \sum_i \sum_j x_j P(X=x_j, Y=y_j)
= \sum_j \sum_i x_j P(X=x_j)$

Smoothing property: $E[E[X|Y]] = EX$


$E[E[X|Y]] = \int E[X|Y=y] f(y) dy$
   
  /---\  1
 A --- B 2
  \---/  3

$P(Z=i)=p_i$
$E[D|Z=i] = d_i$ $\implies$ $E[D] = E[E[D|Z]] = \sum p_id_i$

## Probability inequalities

Markov's inequality: 
$X$ is non negative RV $X \geq 0$ then for $a > 0$, $P(X \geq a) \leq E[X]/a$

Proof. $E[X] = \int_0^{\infty} xf(x)dx = \int_{0}^a xf(x)dx + \int_a^{\infty} xf(x)dx \geq \int_{a}^{\infty} xf(x) dx \geq aP(X\geq a) $
Alter. $X \geq a I_A$


Chebychev's Inequality:
$X$ is r.v. with mean $\mu$ and $var =\sigma^2$

$P(|X-\mu| \geq a) \leq \sigma^2\a^2$

Proof: $Y=(X-\mu)^2$ $P(Y \geq a^2) \leq EY/a^2$

Jensen's Ineuqlity:

Convex function: $f(\lambda x + (1-\lambda)y) \leq \lambda f(x) + (1-\lambda) f(y)$

If $f(x)$ is convex then $E[f(x)] \geq f(E[X])$

 

