I came across 4.14.45 which describes kurtosis.
Using the definition
E(U) = 0.5
Var(U) = 1/12
Kurtosis(U) = 9/5

Since X,Y are i.i.d:
Kurtosis(X+Y) = 1/2^2*(Kurtosis(X)+Kurtosis(Y)) = Kurtosis(X)/2

Using the definition of Excess Kurtosis where Kurtosis is defined with
respect to a normal distribution(see reference):
EKurtosis(U) = Kurtosis(U)-3 = 9/5-3 = -6/5
EKurtosis(X) = 2*Ekurtosis(U) = -3/5 < -2

and EKurtosis should always be greater than or equal to -2(equality
holding for a bionomial with p=1/2) Hence a contradiction. This
appraoch holds for U expressed as sum of any number of i.i.ds

Reference: http://www.columbia.edu/~ld208/psymeth97.pdf
