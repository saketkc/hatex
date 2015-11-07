# MATH-650 Assignment 10
Saket Choudhary (USCID: 2170058637) (skchoudh@usc.edu)  
11/04/2015  

# Chapter 13: 12


```r
data <- read.csv('case1301.csv')
data$Cover <- data$Cover/100
data$Cover <- log(data$Cover/(1-data$Cover))
grandmean <- mean(data$Cover)
agg <- aggregate(Cover ~ Treat, data, mean)
agg
```

```
##     Treat      Cover
## 1 CONTROL  0.1804836
## 2       f -0.3136515
## 3      fF -0.8214197
## 4       L -1.7119924
## 5      Lf -2.0043847
## 6     LfF -2.7246679
```


```r
agg1 <- aggregate(Cover ~ Treat + Block, data, mean)
agg1
```

```
##      Treat Block       Cover
## 1  CONTROL    B1 -1.51180059
## 2        f    B1 -1.62171030
## 3       fF    B1 -2.04909167
## 4        L    B1 -3.17805383
## 5       Lf    B1 -3.21026883
## 6      LfF    B1 -4.24347007
## 7  CONTROL    B2 -0.94235279
## 8        f    B2 -1.30770463
## 9       fF    B2 -1.96591282
## 10       L    B2 -2.51451819
## 11      Lf    B2 -3.11381700
## 12     LfF    B2 -3.21026883
## 13 CONTROL    B3  1.11226627
## 14       f    B3  0.22200404
## 15      fF    B3 -0.12058103
## 16       L    B3 -0.31084411
## 17      Lf    B3 -1.55687711
## 18     LfF    B3 -2.53258512
## 19 CONTROL    B4  2.84798715
## 20       f    B4  1.83818418
## 21      fF    B4  0.63823686
## 22       L    B4 -0.80683089
## 23      Lf    B4 -0.52153713
## 24     LfF    B4 -1.92617786
## 25 CONTROL    B5 -0.27157495
## 26       f    B5 -0.68573964
## 27      fF    B5 -0.68437097
## 28       L    B5 -1.39946308
## 29      Lf    B5 -2.62903695
## 30     LfF    B5 -2.84798715
## 31 CONTROL    B6  0.71069284
## 32       f    B6 -0.18363476
## 33      fF    B6 -0.40616081
## 34       L    B6 -1.22917369
## 35      Lf    B6 -0.66390985
## 36     LfF    B6 -1.89142592
## 37 CONTROL    B7 -0.78507724
## 38       f    B7 -0.08085342
## 39      fF    B7 -0.73537410
## 40       L    B7 -2.59694117
## 41      Lf    B7 -2.58524200
## 42     LfF    B7 -2.37986447
## 43 CONTROL    B8  0.28372826
## 44       f    B8 -0.68975734
## 45      fF    B8 -1.24810310
## 46       L    B8 -1.66011416
## 47      Lf    B8 -1.75438883
## 48     LfF    B8 -2.76556416
```

### Part (a)

```r
means <- agg$Cover
variance <- var(means)
variance
```

```
## [1] 1.212415
```


```r
16*variance
```

```
## [1] 19.39864
```

which is what is in Display 13.11


### Part (b)


```r
#block.averages <- c(-2.64, -2.18, -.53, .34, -1.42, -.61, -1.53, -1.31)
agg2 <- aggregate(Cover ~ Block, agg1, mean)
variance.block.averages <- var(agg2$Cover)
agg2
```

```
##   Block      Cover
## 1    B1 -2.6357325
## 2    B2 -2.1757624
## 3    B3 -0.5311028
## 4    B4  0.3449771
## 5    B5 -1.4196955
## 6    B6 -0.6106020
## 7    B7 -1.5272254
## 8    B8 -1.3056999
```


```r
12*variance.block.averages 
```

```
## [1] 10.89123
```

which is same as what is in Display 13.11


### Part (c)


```r
cell48.variance <- var(agg1$Cover)
2*cell48.variance
```

```
## [1] 4.009835
```
which is same as model mean square  in Display 13.10

### Part (d)


```r
fit <- aov(Cover ~ Treat + Block + Block*Treat, data=data)
s <- summary(fit)
s
```

```
##             Df Sum Sq Mean Sq F value Pr(>F)    
## Treat        5  96.99  19.399  64.055 <2e-16 ***
## Block        7  76.24  10.891  35.963 <2e-16 ***
## Treat:Block 35  15.23   0.435   1.437  0.121    
## Residuals   48  14.54   0.303                   
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```


```r
block.ss <- 76.2386
treatment.ss <- 96.9932
interaction.ss <- 15.2304
between.ss <- 188.4622
between.ss - (block.ss+treatment.ss)
```

```
## [1] 15.2304
```

which is the same as `interaction.ss`(interaction sum of squares)

