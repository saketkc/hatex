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
## 1    Obese     16      2045
## 2 NotObese      7      1044
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


Sample proportion of CVD deaths for obese group: $\pi_1=0.0077632$

Sample proportion of CVD deaths for nonbese group: $\pi_2=0.0066603$


### Part (ii)



```r
seci <- sqrt(p1*(1-p1)/n1+p2*(1-p2)/n2)
setest <- sqrt(pc*(1-pc)/n1+pc*(1-pc)/n2)
```

Standard error for difference : 0.0031674

### Part (iii)




```r
difference <- p1-p2
Z <- difference/setest
halfwidth <- 1.96*setest
hci <- difference + halfwidth
lci <- difference - halfwidth
```

95% confidence interval: $[-0.0052602, 0.007466]$


## Part (b)


```r
pval <- 1-pnorm(Z)
```


One sided p-value: 0.3670332

## Part (c)


```r
w1 <- obese$Deaths/obese$NonDeaths
w2 <- notobese$Deaths/notobese$NonDeaths
oddsratio <- w1/w2
logodds <- log(oddsratio)
selogci <- sqrt(1/obese$Deaths + 1/obese$NonDeaths + 1/notobese$Deaths + 1/notobese$NonDeaths)
selogtest <- sqrt(1/(n1*pc*(1-pc)) + 1/(n2*pc*(1-pc)) )
logwidth <- 1.96*selogci
loglci <- selogci-logwidth
loghci <- selogci+logwidth
```
### Part (i)
Sample Odds: $\omega_1=0.007824$ ; $\omega_2=0.006705$

### Part (ii)

Odds ratio: $1.1668879$

### Part (iii)

Standard error of the log odds ratio: $0.4547571$

### Part (iv)

95% confidence interval for log odds ratio: $[-0.4365668, 1.3460809]$


## Part (d)

...

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
