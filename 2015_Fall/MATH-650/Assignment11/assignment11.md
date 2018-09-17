# MATH-650 Assignment 11
Saket Choudhary (USCID: 2170058637) (skchoudh@usc.edu)  
11/19/2015  

# Chapter 18: 9


```r
obesity.data <- read.csv('case1801.csv')
obese <- obesity.data[obesity.data$Obesity=='Obese',]
notobese <- obesity.data[obesity.data$Obesity=='NotObese',]

obesity.data
```

```
##    Obesity Deaths NonDeaths
## 1    Obese     22      1179
## 2 NotObese     22      1409
```


```r
n1 = obese$Deaths+obese$NonDeaths
n2 = notobese$Deaths+notobese$NonDeaths
pc = (obese$Deaths+notobese$Deaths)/(n1+n2)
```

## Part (a)

### Part (i)

```r
p1 = obese$Deaths/n1
p2 = notobese$Deaths/n2
```


Sample proportion of CVD deaths for obese group: $\pi_1=0.0183181$

Sample proportion of CVD deaths for nonbese group: $\pi_2=0.0153739$


### Part (ii)



```r
seci <- sqrt(p1*(1-p1)/n1+p2*(1-p2)/n2)
setest <- sqrt(pc*(1-pc)/n1+pc*(1-pc)/n2)
```

Standard error for difference : 0.0050548

### Part (iii)




```r
difference <- p1-p2
Z <- difference/setest
halfwidth <- 1.96*setest
hci <- difference + halfwidth
lci <- difference - halfwidth
```

95% confidence interval: $[-0.0068898, 0.0127782]$


## Part (b)


```r
pval <- 1-pnorm(Z)
```


One sided p-value: 0.2786674

## Part (c)


```r
w1 <- obese$Deaths/obese$NonDeaths
w2 <- notobese$Deaths/notobese$NonDeaths
oddsratio <- w1/w2
logodds <- log(oddsratio)
selogci <- sqrt(1/obese$Deaths + 1/obese$NonDeaths + 1/notobese$Deaths + 1/notobese$NonDeaths)
selogtest <- sqrt(1/(n1*pc*(1-pc)) + 1/(n2*pc*(1-pc)) )
logwidth <- 1.96*selogci
loglci <- logodds-logwidth
loghci <- logodds+logwidth
```
### Part (i)
Sample Odds: $\omega_1=0.0186599$ ; $\omega_2=0.0156139$

### Part (ii)

Odds ratio: $1.1950806$

### Part (iii)

Standard error of the log odds ratio: $0.3040839$

### Part (iv)

95% confidence interval for log odds ratio: $[-0.4177907, 0.774218]$


## Part (d)
<!-- The odds of deaths for obese group are estimated to be 1.1950806 times the odds of deaths for nonobese group(approximate 95% CI: $[-0.4177907, 0.774218]$) .-->
While testing for equality, we opbtained a p-value of 0.2786674. Also the 95% CI for log odds ratio is  $[-0.4177907, 0.774218]$ which does not include the estimated odds ratio of  $1.1950806$ and thus there is no evidence that odds ratio of deaths among obese grooup over nonobese groups is different from 1.

# Chapter 18: 11

## Part (a)

```r
smoker.data <- read.csv('smokers.csv')
smokers <- smoker.data[smoker.data$Smoker=='Smokers',]
nonsmokers <- smoker.data[smoker.data$Smoker=='Nonsmokers',]
```


```r
cancer.smokers <- smokers$Cancer/(smokers$Cancer+smokers$NoCancer)
```
Proportion of lung cancer patients among smokers: $4.9975012\times 10^{-4}$

## Part (b)


```r
cancer.nonsmokers <- nonsmokers$Cancer/(nonsmokers$Cancer+nonsmokers$NoCancer)
```

Proportion of lung cancer patients among nonsmokers: $4.9975012\times 10^{-4}$


## Part (c)


```r
difference.smokers <- cancer.smokers - cancer.nonsmokers 
difference.smokers
```

```
## [1] 0.0002498126
```
