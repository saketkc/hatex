--------
date: 08/23/2016
--------
- Learning algorithms are based on a model, with an aim to optimise a loss function
- Linear regression
\begin{align*}
\hat{y} &= w^Tx\\\
l(y, \hat{y}) &= ||y-\hat{y}||^2\\
min \sum_i |y-\hat{y_i}|^2\\
&= \min_{w} \sum_i ||y_i-wx_i||^2
\end{align*} 

- Checkout UCI data repository dataset: http://archive.ics.uci.edu/ml/
- Logistic regression: $\frac{\log(P(y=1|x)}{\log(P(y=0|x)} \in [0 , \infty]$
so $\log(\frac{\log(P(y=1|x)}{\log(P(y=0|x)}) \in [-\infty, \infty]$
 - Parameter estimation MLE/MAP:
	MLE: $\hat{w} = argmax_w P(y_1, y_2, y_n|X)$

\begin{align*}
P(y=1) &= e^{w^Tx}(1-P(y=1))\\
P(y=1) &= \frac{e^{w^Tx}}{1+e^{w^Tx}}
\end{align*}

MLE estimation of $w$: 
\begin{align*}
\hat{w}&= argmax_w P(y_1,\dots, y_n|x)\\
&= argmax_w \prod_{i=1}P(y_i)\\
&= argmax_w \sum_i \log P(Y_i)\\
&= argmax_w -\sum_i \log(1+e^{w^Tx_i}) + \sum_{i, y_i=1) w^Tx_i
\end{align*}

- inf and sup: TODO
- Inner production: $<x,y> = \sum_i x_iy_i$
- CAuchy Schwartz $<x,y> \leq ||x||.||y||$. Equality if the are in the same plane

- Matrix inner producti $<A,B> = Tr(AB^T) = \sum_{ij}A_{ij}B_{ij}$
- Spectral radius: $\rho(A) = max(|\lambda_i|: \lambda_i\text{eigen value})$
- Matrix always has a SVD. Singular values $\sigma_i$ such that $\sigma_i^2$ is the eigen value of $AA^T$
- 

A^TX = \lambda X
AA^TX = \lambda AX
 = \lambda^2 X

- Norms: Forebenius Nuclear.


- TODO: Proof of inequalities
