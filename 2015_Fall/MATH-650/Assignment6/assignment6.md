# MATH-650 Assignment 6
Saket Choudhary (USCID: 2170058637) (skchoudh@usc.edu)  
09/15/2015  

# Problem 19

```r
pH.data <- read.csv('case0702.csv', header=T)
logT <- log(pH.data$Time)
pH.data$logT <- logT
n <- nrow(pH.data)
```

Simple linear regression model for $log(pH)$ is given by:
$$
pH = \beta_0 + \beta_1log(T)
$$


### Part (a)

```r
fit <- lm(pH~logT, data=pH.data)
s <- summary(fit)
b0 <- fit$coefficients[1]
b1 <- fit$coefficients[2]
se0 <- s$coefficients[3]
se1 <- s$coefficients[4]
t0 <- s$coefficients[5]
t1 <- s$coefficients[6]
p0 <- s$coefficients[7]
p1 <- s$coefficients[8]
```

Thus, $\beta_0=6.983626(S.E=0.048532, p-value=6.0839895\times 10^{-15})$ and $\beta_1=-0.7256578(S.E=0.0344263, p-value=2.6951582\times 10^{-8})$

### Part (b)


```r
Xbar <- mean(log(pH.data$Time))#1.190
sx2 <- var(log(pH.data$Time))#0.6344
mu <- b0 +b1*log(5)
```

Thus, $\hat\mu\{Y|log(5)\} = 5.8157249$ 


### Part (c)


```r
sigmahat <- 0.08226
se = sigmahat *sqrt(1/n+(log(5)-Xbar)^2/(n-1*sx2))
```

$SE[\hat\mu\{Y|log(5)\}] = 0.0283496$


# Problem 25

### Part (a)
$$
\begin{align*}
SS(\beta_0,\beta_1) &= \sum_{i=1}^N (Y_i-\beta_0-\beta_1X_i)^2\\
\frac{\partial SS}{\partial \beta_0} &= -2\sum_{i=1}^N (Y_i-\beta_0-\beta_1X_i)\\
\frac{\partial SS}{\partial \beta_1} &= -2\sum_{i=1}^N (Y_i-\beta_0-\beta_1X_i)X_i\\
\end{align*}
$$


$$
\begin{align*}
\frac{\partial SS}{\partial \beta_0} &= -2\sum_{i=1}^N (Y_i-\beta_0-\beta_1X_i) =0\\
\implies \sum_{i=1}^N Y_i &= \sum_{i=1}^N (\beta_0 +\beta_1X_i)\\
\implies \sum_{i=1}^N Y_i &= \beta_0n +\beta_1\sum_{i=1}^N X_i\tag{1}
\end{align*}
$$


$$
\begin{align*}
\frac{\partial SS}{\partial \beta_1} &= -2\sum_{i=1}^N (Y_i-\beta_0-\beta_1X_i)X_i = 0\\
\implies \sum_{i=1}^N Y_iX_i &= \sum_{i=1}^N(\beta_0+\beta_1X_i)X_i\\
\implies \sum_{i=1}^N Y_iX_i &= \beta_0\sum_{i=1}^NX_i+\sum_{i=1}^N\beta_1 X_i^2\tag{2}
\end{align*}
$$

### Part (b)
$$
\begin{align*}
\hat{\beta_0} &= \bar{Y}-\hat{\beta_1}\bar{X}  \tag{3}
\end{align*}
$$

And,

$$
\begin{align*}
\hat{\beta_1} &= \frac{\sum_{i=1}^N (X_i-\bar{X}) (Y_i-\bar{Y})}{\sum_{i=1}^N(X_i-\bar{X})^2}\\
&= \frac{\sum_{i=1}^N(X_iY_i-\bar{X}Y_i+\bar{X}\bar{Y}-X_i\bar{Y})}{\sum_{i=1}^N(X_i^2-2\bar{X}X_i + \bar{X}^2)}\\
&= \frac{\sum_{i=1}^N X_iY_i -n\bar{X}\bar{Y}}{\sum_{i=1}^NX_i^2-n\bar{X}^2}
\end{align*}
$$

Thus,
$$
\begin{align*}
\hat{\beta_1}\sum_{i=1}^N X_i^2-n \hat{\beta_1} \bar{X}^2 &=\sum_{i=1}^N X_iY_i -n\bar{X}\bar{Y}\\
\hat{\beta_1}\sum_{i=1}^N X_i^2 + n\bar{X}\bar{Y} -n \hat{\beta_1} \bar{X}^2 &= \sum_{i=1}^N X_iY_i\\
\hat{\beta_1}\sum_{i=1}^N X_i^2 + n\bar{Y}(\bar{X} - \hat{\beta_1} \bar{X}) &= \sum_{i=1}^N X_iY_i \tag{4}\\
\end{align*}
$$


Substituting (3) in (4), we get
$$
\begin{align*}
\hat{\beta_1}\sum_{i=1}^N X_i^2 + n\bar{X}(\bar{Y} - \hat{\beta_1} \bar{X}) &= \sum_{i=1}^N X_iY_i\\
\hat{\beta_1}\sum_{i=1}^N X_i^2 + n\bar{X}(\hat{\beta_0}) \bar{X} &= \sum_{i=1}^N X_iY_i\\
\hat{\beta_1}\sum_{i=1}^N X_i^2 + \hat{\beta_0} \sum_{i=1}^N X_i &= \sum_{i=1}^N X_iY_i\tag{5}\\
\end{align*}
$$

Thus, (5) is same as (2)

Now, From (3)
$$
\begin{align*}
\hat{\beta_0} &= \bar{Y}-\hat{\beta_1}\bar{X}\\
\bar{Y} &= \hat{\beta_0} + \hat{\beta_1}\bar{X}\\
\frac{\sum_{i=1}^N Y_i}{N} &= \hat{\beta_0} + \hat{\beta_1}\frac{\sum_{i=1}^N X_i}{N}\\
\sum_{i=1}^N Y_i &= n\hat{\beta_0} + \hat{\beta_1}\sum_{i=1}^N X_i \tag{6}
\end{align*}
$$

Thus, (6) is same as (1)

Consider second order differentials:
$$
\begin{align*}
\frac{\partial^2SS}{\partial\beta_0^2} &= -2*-n=2n\\
\frac{\partial^2SS}{\partial\beta_0\partial\beta_1} &= 2 \sum_{i=1}^NX_i\\
\frac{\partial^2SS}{\partial\beta_1\partial\beta_0} &= 2 \sum_{i=1}^NX_i\\
\frac{\partial^2SS}{\partial\beta_1^2} &= 2 \sum_{i=1}^NX_i^2\\
Hessian(H) &= \begin{bmatrix} 
2 & 2 \sum_{i=1}^NX_i\\
2 \sum_{i=1}^NX_i & 2 \sum_{i=1}^NX_i^2
\end{bmatrix}\\
2n > 0 \text{and, } \\
det(H) &= 4(n\sum_{i=1}^NX_i^2-(\sum_{i=1}^NX_i)^2) = 4n(n-1)Var(X) > 0\ \text{always}
\end{align*}
$$

Thus, the values of $\hat{\beta_0},\hat{\beta_1}$ indeed guarantee a minima since the Hessian is positive definitee.

### Part (c)

# Problem 13
Intercept = 0.3991
Standard Error = 0.1185
df = 22
$t_{0.975,22} = 2.073$

Upper limit = 0.3991 + 2.073 * 0.1185 = 0.6447505
Lower limit = 0.3991 - 2.073 * 0.1185 =  0.1534495

Thus, the 95% CI for  Intercept is [0.1534495, 0.6447505]


Also following is the R code:

```r
intercept <- 0.3991
se <- 0.1185
df <- 22
t975 <- qt(0.975,df)
limit.upper <- intercept + t975*se
limit.lower <- intercept - t975*se
limit.upper
```

```
## [1] 0.644854
```

```r
limit.lower
```

```
## [1] 0.153346
```
