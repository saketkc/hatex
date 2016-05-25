------------------
date: 05/25/2016
-----------------

Probe SD vs Probe mean plot
--------------------------
=> 45 deg line
i.e. Higher mean => Higher SD. Sometimes
a kink on the top right corner indicates saturation.
May or may not affect analysis


Between array distances
-----------------------
Median of asbolute value of difference (on log scale) for all arrays
-> Pairwise
Clustering shows association between chips.(Along diagonals)


We don't throw away genes that are outliers but the beads
which are outliers. Each bead willl have different genes mapping(?) to it
(READ about illumina arrays)

Additive Multiplicative error model
-----------------------------------

I=B+kS

k=gain factor
S = random specific binding
B=random background noise

log(S) = \theta + \epsilon + \phi

\theta = Log of true abundance
\phi = Probe specific effect
\epsilon = measurement error


Effect of Background Noise
--------------------------
Low expression => Background effect is more profund,
Smaller concentration => Greater bias (Effect of additive background noise)

Fold changes and log ratios
---------------------------

q = log_2(I_1/I_2) = log_2(k_s_1+b_1/(ks_2+b_2))
I_1,I_2 intensities(no units).

b_1,b_2 > 0 will bias q toward 1

3 (? more) different ways to estimate b

Background Adjustment
---------------------

Method: Normal-Exponential Convolution

X_F = S+B

X_F = Observed intensity
S - exp(\alpha)
B ~ N(\mu. \sigma^2)

S,B independent random variables

mu, sigma => Estimate using control probes
alpha => using mean in observed minus mean in controls

Bias Varianced tradeoff (Rather than just taking an unbiased estimator,
adding bias reduces variance)

Normalization
-------------

Quantile Normalization => Same rank order
Might be troublesome for different tissues or
methylation data


Variance Stabilization
-----------------------
Untransfomred data makes tests such as t-tests difficult because the
variances are going to be different so employ variance
stabilization

Between array normalization is only appropriate for
samples that are run in single experiment/batch



