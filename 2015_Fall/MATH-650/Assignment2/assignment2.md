# MATH-650 Assignment 2
Saket Choudhary (USCID: 21270058637) (skchoudh@usc.edu)  
09/08/2015  



```r
ex0112<-read.csv('ex0112.csv')
fishoil.diet <- ex0112[ex0112$Diet=='FishOil',]
regularoil.diet <- ex0112[ex0112$Diet=='RegularOil',]
n1 <- nrow(fishoil.diet)
n2 <- nrow(regularoil.diet)
mu1 <- mean(fishoil.diet$BP)
mu2 <- mean(regularoil.diet$BP)
s1 <- sd(fishoil.diet$BP)
s2 <- sd(regularoil.diet$BP)
sp <- sqrt( ( (n1-1)*s1^2 + (n2-1)*s2^2 ) / (n1+n2-2) )
se <- sp*sqrt(1/n1+1/n2)
```


## Part(a)

Average of group with diet 'FishOil': $\mu_f=$ 6.5714286

Standard deviation  of group with diet 'FishOil': $\sigma_f=$ 5.8554004



Average of group with diet 'RegularOil': $\mu_r=$ -1.1428571

Standard deviation  of group with diet 'RegularOil': $\sigma_r=$ 3.1847853


## Part(b)

Pooled standard deviation = $s_P=\sqrt{\frac{(n_1-1)s_1^2+(n_2-1)s_2^2}{(n_1+n_2-2)}}$


$s_P=$ 4.7132033



## Part (c)

Standard error $SE(\bar{Y_2}-\bar{Y_1})=$ 2.5193132
