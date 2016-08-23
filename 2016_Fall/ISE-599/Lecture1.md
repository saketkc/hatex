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
