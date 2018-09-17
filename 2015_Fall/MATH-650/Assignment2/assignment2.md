# MATH-650 Assignment 2
Saket Choudhary (USCID: 2170058637) (skchoudh@usc.edu)  
09/08/2015  



```r
ex0112<-read.csv('ex0112.csv')
fishoil.diet <- ex0112[ex0112$Diet=='FishOil',]
regularoil.diet <- ex0112[ex0112$Diet=='RegularOil',]
```


## Part(a)

```r
n1 <- nrow(fishoil.diet)
n2 <- nrow(regularoil.diet)
mu1 <- mean(fishoil.diet$BP)
mu2 <- mean(regularoil.diet$BP)
s1 <- sd(fishoil.diet$BP)
s2 <- sd(regularoil.diet$BP)
```

Average of group with diet 'FishOil': $\mu_f=$ 6.5714286

Standard deviation  of group with diet 'FishOil': $\sigma_f=$ 5.8554004



Average of group with diet 'RegularOil': $\mu_r=$ -1.1428571

Standard deviation  of group with diet 'RegularOil': $\sigma_r=$ 3.1847853


## Part(b)

```r
sp <- sqrt( ( (n1-1)*s1^2 + (n2-1)*s2^2 ) / (n1+n2-2) )
```

Pooled standard deviation = $s_P=\sqrt{\frac{(n_1-1)s_1^2+(n_2-1)s_2^2}{(n_1+n_2-2)}}$


$s_P=$ 4.7132033



## Part (c)

```r
se <- sp*sqrt(1/n1+1/n2)
```

Standard error $SE(\bar{Y_2}-\bar{Y_1})=$ 2.5193132

## Part (d)

```r
df <- n1+n2-2
qt975 <- qt(c(.975), df=df)
```
Degrees of freedom = $n_1+n_2-2$= 12

$97.5^{th}$ percentile of $t-distribution$ ($df=$ 12):   2.1788128

## Part (e)

```r
alpha <- 0.05
t <- qt(1-alpha/2,df)
CI_l <- (mu2-mu1)-t*se
CI_h <- (mu2-mu1)+t*se
```
$95\%$ CI for $\mu_2-\mu_1$: $[$-13.2033975,-2.2251739$]$
$t=$ 2.1788128

## Part (f)


```r
T <- (mu2-mu1)/se
p <-  pt(T, df=df)
```

The t-statistic is given by: $t=$ -3.0620591 with $df=$ 12


## Part (g)
The appropriate one sided p-value is(since $t<0$): 0.9975347

# Problem (14)


```r
ttest <- t.test( regularoil.diet$BP, fishoil.diet$BP, alternative="greater", var.equal=F)
ttest
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  regularoil.diet$BP and fishoil.diet$BP
## t = -3.0621, df = 9.2643, p-value = 0.9935
## alternative hypothesis: true difference in means is greater than 0
## 95 percent confidence interval:
##  -12.31752       Inf
## sample estimates:
## mean of x mean of y 
## -1.142857  6.571429
```
p-value from 't.test' = 0.993458

# Problem 19

## Part (19a)


```r
n2 <- nrow(regularoil.diet)
mu2 <- mean(regularoil.diet$BP)
s2 <- sd(regularoil.diet$BP)
df2 <- n2-1
```

Average=: -1.1428571
Standard Devaiation: 3.1847853
Degree of Freedom: 6

## Part (19b)

```r
se2 <- s2/sqrt(n2)
```

Standard error of the average: 1.2037357


## Part (19c)


```r
qt975_2 <- qt(c(.975), df=df2)
CI_l2 <- mu2 - qt975_2*se2
CI_h2 <- mu2 + qt975_2*se2
```


CI: $[$-4.0882922,1.802578$]$

## Part 19(d)


```r
T2 <- mu2/se2
p2 <- pt(T2, df=df2)
```
p-value: 0.1895308

t-statistics: -0.9494253
