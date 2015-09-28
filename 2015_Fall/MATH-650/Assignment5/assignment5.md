# MATH-650 Assignment 5
Saket Choudhary (USCID: 2170058637) (skchoudh@usc.edu)  
09/28/2015  

## Problem 20


```r
data <- read.csv('case0501.csv')
labels <- unique(data$Diet)
sp <- 0
N <- 0
out <- (paste("Group", "n", "SD", "\n", sep="\t\t"))
for (x in labels){
  d <- data[data$Diet == x, ]$Lifetime
  n <- length(d)
  s <- sd(d)
  sp <- (n-1)*s*s+sp
  out <- (paste(out , "\n", x,n,s,sep="\t\t"))
  N <- N+n-1
}
cat(out)
```

```
## Group		n		SD		
## 		
## 		NP		49		6.1337009557824		
## 		N/N85		57		5.12529722837593		
## 		lopro		56		6.99169451619507		
## 		N/R50		71		7.76819471270947		
## 		R/R50		56		6.68315191212346		
## 		N/R40		60		6.70340582968942
```

```r
sp <- sqrt(sp/N)
```

Pooled variance: $s_p=6.6782392$ and $df=343$


```r
estimator <- function(a,b){
  x <- data[data$Diet == a,]$Lifetime
y <- data[data$Diet == b,]$Lifetime
n1 <- length(x)
n2 <- length(y)
se <- sp*sqrt(1/n1+1/n2)
estimate <- mean(x)-mean(y)
CI <- c(estimate-1.96*se, estimate+1.96*se)
tstat <- estimate/se
out <- (paste('Confidence Interval Low', CI[1], sep="\t"))
out <- (paste(out , '\n', 'Confidence Interval High', CI[2], sep="\t"))
out <- paste(out, '\n', 'Estimate', estimate, sep='\t')
out <- paste(out, '\n', 'SE', se,sep='\t')
out <- paste(out, '\n', 't-stat',tstat, sep='\t')
cat(out)
}
```
## N/R50 vs N/N85

```r
#N/R50 vs N/N85
estimator('N/R50', 'N/N85')
```

```
## Confidence Interval Low	7.27809735963633	
## 	Confidence Interval High	11.9338126971959	
## 	Estimate	9.60595502841611	
## 	SE	1.18768248407132	
## 	t-stat	8.08798240038647
```

## R/R50 vs N/R50

```r
#R/R50 vs N/R50
estimator('R/R50', 'N/R50')
```

```
## Confidence Interval Low	-1.75082694441255	
## 	Confidence Interval High	2.92788931865801	
## 	Estimate	0.588531187122733	
## 	SE	1.19355006710984	
## 	t-stat	0.493093003251931
```

## N/R40 vs N/R50

```r
#N/R40 vs N/R50
estimator('N/R40', 'N/R50')
```

```
## Confidence Interval Low	0.524133718935906	
## 	Confidence Interval High	5.11483341721432	
## 	Estimate	2.81948356807511	
## 	SE	1.17109686180572	
## 	t-stat	2.40755795701454
```

## N/R50 lopro vs N/R50

```r
#N/R50 lopro vs N/R50
estimator('lopro', 'N/R50')
```

```
## Confidence Interval Low	-4.95082694441255	
## 	Confidence Interval High	-0.27211068134199	
## 	Estimate	-2.61146881287727	
## 	SE	1.19355006710984	
## 	t-stat	-2.18798430400235
```

## N/N85 vs NP

```r
##N/N85 vs NP
estimator('N/N85', 'NP')
```

```
## Confidence Interval Low	2.73921470559591	
## 	Confidence Interval High	7.83915980210191	
## 	Estimate	5.28918725384891	
## 	SE	1.3010064021699	
## 	t-stat	4.0654582829318
```
