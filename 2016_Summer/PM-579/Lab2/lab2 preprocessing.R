###############################################################################
## lab2 preprocessing.R
## PM579 summer 2016
## Authors: Kim Siegmund, Ying Wu
##
###############################################################################

###############################################################################
## INSTALL LIBRARIES
## You should not run these unless it says 'there is no package called ___' 
## after library(___) comand
###############################################################################
#source("http://bioconductor.org/biocLite.R") #installer
#biocLite("limma")
#biocLite("methylumi")
#biocLite(c("genefilter,vsn,sva"))
install.packages("latticeExtra")


###############################################################################
## read in GenomeStudio Summary files
###############################################################################
library("limma")
# These files contain Avg_Signal, Detection p, Avg_NBEADS, and BEAD_STDERR
sfile="data/irina-spp.txt" #standard probe profile output from GenomeStudio
cfile="data/irina-cpp.txt" #control probe profile output from GenomeStudio
rawdata = read.ilmn(files=sfile, ctrlfiles=cfile,
                    other.columns=c("Detection","Avg_NBEADS","BEAD_STDERR"))
dim(rawdata$E) #48118 x 24
table(rawdata$genes$Status) #slide 32
#targets file provides description of experiment
#make sure targets file description and arrayIDs are in the same order
# (will be done at rawdata$targets step)
targets=read.csv(file="data/SampleChars.csv",row.names=1) 
head(targets) #contains treatment/time/batch/Type(treat+time)
# Use Sample Barcodes to combine Sample Annotation information with gene expression data matrix 
# This next line is critical!  
# Sample annotation file is ordered to match the gene expression data
rawdata$targets=targets[colnames(rawdata),] #store targets w/rawdata
head(rawdata$targets)
table(rawdata$targets$Type,rawdata$targets$batch) #see slide 40
#setwd(wkdir)
#save(rawdata, "lab2.RData") #you can save it at this step if you want

###############################################################################
## Generate QC figures
###############################################################################

## boxplot of intensity of sample probes across arrays (slide 31)
boxplot(log2(rawdata$E[rawdata$genes$Status=="regular",]),range=0,xlab="Arrays",
	ylab="log2 intensities",main="Regular probes")
#whenever lines are indented like they are above, it usually means the 
# command was too long to fit on one line so we break it into two lines
# so it is easier to read, when you run it in R/Rstudio make sure you run
# both of the lines at the same time.

#IF YOU GET MARGIN ERROR
# please resize the plot window in Rstudio, by default it is on the
# bottom right corner of the window. Then type dev.off() and rerun the
# boxplot command. What happens is that R makes a new plotting window
# and tries to plot it but fails because margins are too small, so after you 
# resize the plotting window, you want R to close the old plotting window
# that was too small and plot it again. dev.off() is the command you run to
# close the old plotting window, if you used the plot command multiple times
# it will give you a number after typing dev.off(). You would want to keep
# typing dev.off() until you see 'null device 1'

#Here are two ways to save figures
# 1) In Rstudio, on the plot window, click 'zoom' and then right click (win)
#    or command click (mac) and save as
# 2) This is slightly more complicated but might give you more options
#    figdir=c("U:") #DO NOT USE DROPBOX FIGURE FOLDER, CREATE YOUR OWN
#    setwd(figdir) #change to directory where you want to save figures
#    dev.copy(png,'myplot.png') #you can also pdf/svg this way (higher quality)
#    dev.off()
#
## you can find more information at this website
#  http://www.stat.berkeley.edu/users/spector/s133/saving.html
#  The general way is the best way if you want to save high quality figures
#  There is also a dev.copy2pdf() option that will remember your window size
#  typing in ?pdf will give you more options including setting width/height
#  saving as PNG will often give banding artifacts svg or pdf is best
#  you can then convert svg/pdf -> png/jpg (search online for tool)
#  linux has a 'convert' shell command that can do the pdf->png conversion
#  if using windows/mac you could try inkscape (free) on a svg file or photoshop

## Make density plot of regular probes
# plot 1 sample first, then add other samples as lines to plot
plot(density(log2(rawdata$E[rawdata$genes$Status=="regular",1])),
	xlab="log2 intensities", ylab="Density",
	main="Density Plot of Intensities",ylim=c(0,1.3)) 
# add expression across each array (slide 31)
na=length(rownames(rawdata$target))
for (i in 2:na)
	lines(density(log2(rawdata$E[rawdata$genes$Status=="regular",i])),col=i,lty=i)
legend(12,1.3,rownames(rawdata$target),lty=1:5,col=1:6,cex=.9) 

# Number of beads per probe (usually 1 probe per gene), centered around 20
# slide 31
boxplot(rawdata$other$Avg_NBEADS[rawdata$genes$Status=="regular",],
    xlab="Arrays",ylab="Number of Beads") #regular probes
boxplot(rawdata$other$Avg_NBEADS[rawdata$genes$Status=="NEGATIVE",],
    xlab="Arrays",ylab="Number of Beads") #control probes 

# Plot Bead Stdev vs Avg Signal (slide 10)
BEADstdev=rawdata$other$BEAD_STDERR*sqrt(rawdata$other$Avg_NBEADS)
plot(rawdata$E[rawdata$genes$Status=="regular",1],
      BEADstdev[rawdata$genes$Status=="regular",1],
      xlab="Avg_Signal",ylab="BEAD_STDEV",cex=.5,log="xy",pch=".")
# You should do this for all arrays, but I won't do it here since it's slow
# But I will pause to introduce a new visualization tool for scatterdiagrams
smoothScatter(log10(rawdata$E[rawdata$genes$Status=="regular",1]),
              log10(BEADstdev[rawdata$genes$Status=="regular",1]),
              xaxt="n",yaxt="n",
              xlab="Mean(regular)",ylab="STDEV(regular)",nrpoints=500)
axis(1,at=c(2,3,4),labels=c(10^c(2,3,4)))
axis(2,at=c(1,2,3,4),labels=c(10^c(1,2,3,4)))

rm(BEADstdev) #remove BEADstdev since its a pretty big object

## QA plot from book (slide 11)
library("genefilter")
library("latticeExtra") #this requires special installation, see INSTALL above
dd=dist2(log2(rawdata$E[rawdata$genes$Status=="regular",]))
diag(dd)=0
dd.row=as.dendrogram(hclust(as.dist(dd)))
row.ord=order.dendrogram(dd.row)
legend=list(top=list(fun=dendrogramGrob,
                      args=list(x=dd.row,side="top")))
lp=levelplot(dd[row.ord,row.ord],
             scales=list(x=list(rot=90)),xlab="",
             ylab="",legend=legend)
lp
rm(dd,row.ord,lp)

## Estimate the proportion of Genes Expressed on each array
library(limma)
proportion=propexpr(rawdata)
names(proportion)=targets$Type
proportion
# average these over different conditions
tapply(proportion,targets$hour,mean)
tapply(proportion,targets$treatments,mean)
tapply(proportion,targets$Type,mean)

##  Summarize Numbers of control probes (slide 32)
head(unique(rawdata$gene$Status),n=10)
length(unique(rawdata$gene$Status))
sum(rawdata$gene$Status!="regular")
rawdata$gene$Status[which(substr(rawdata$gene$Status,1,4)=="ERCC")]="ERCC"
table(rawdata$gene$Status)

## Make boxplot of negative control probes (regular probe boxplot was made earlier)
boxplot(log2(rawdata$E[rawdata$genes$Status=="NEGATIVE",]),range=0,xlab="Arrays",
	ylab="log2 intensities",main="Negative control probes")

## Plot the control probes across arrays (slide 27)
## first the 770 control probes
sum(rawdata$gene$Status=="NEGATIVE")
n.ncp=sum(rawdata$gene$Status=="NEGATIVE")
l2i=t(log2(rawdata$E[rawdata$genes$Status=="NEGATIVE",]))
#dim(l2i) #24 x 770
x=array(rep(1:na,n.ncp),dim=c(na,n.ncp))
#dim(x) #24 x 770
matplot(x,l2i,type="l",ylim=c(6,max(log2(rawdata$E))),col=1,lty=1,
		xlab="Array",ylab="log2(raw intensity)",axes=F)
axis(1,1:24,rownames(rawdata$targets))
axis(2)
box()
rm(l2i)
# add HOUSEKEEPING GENES
sum(rawdata$gene$Status=="HOUSEKEEPING")
idx.hkg=which(rawdata$gene$Status=="HOUSEKEEPING")
matlines(x[,1:7],t(log2(rawdata$E[idx.hkg,])),col=4,lty=1,lwd=2)
# add BIOTIN
idx.b=which(rawdata$gene$Status=="BIOTIN")
matlines(x[,1:length(idx.b)],t(log2(rawdata$E[idx.b,])),col=2,lty=1,lwd=2)
# add CY3_HYB
idx.cy3=which(rawdata$gene$Status=="CY3_HYB")
matlines(x[,1:length(idx.cy3)],t(log2(rawdata$E[idx.cy3,])),col=5,lty=1,lwd=2)
#Draw Legend
legend(15,12,legend=c("BIOTIN","CY3_HYB","HOUSEKEEPING","NEGATIVE"),
	  lty=1,col=c(2,5,4,1),lwd=c(2,2,2,1))
rm(idx.hkg,idx.b,idx.cy3)


###############################################################################
## background correction + quantile normalization + log2 transformation
###############################################################################
jbc=neqc(rawdata)
dim(jbc) #47231 x 24 #control probes removed!

##  Illustrate the effect of log2 transf. on variance
library("genefilter") #required for rowSds
batch = unclass(jbc$targets$batch)

###############################################################################
## batch correction (slide 41+)
###############################################################################

## create MA plot of each batch
jbc=jbc[,order(jbc$targets$Type,jbc$targets$batch)]
idx=(jbc$targets$Type=="sip300_16h")
A=apply(jbc[,idx]$E,1,median)
M=jbc[,idx]$E-A
#pairs(jbc[,idx]$E,lower.panel=NULL,cex=.5)
plot(A,M[,1],ylab="M",cex=.5)
lines(lowess(A,M[,1]),col=2,lwd=4)
par(mfrow=c(2,2))
for (i in 1:4) {
  plot(A,M[,i],ylab="M",main=paste("Batch",i,"
vs Overall Avg"),cex=.3)
  lines(lowess(A,M[,i]),col=2,lwd=2)
}

dev.off()
rm(M,A)

##  Look for batch effects & correct for them (slide ?)
library("sva")
plotMDS(jbc,labels=paste(jbc$targets[,"Type"], unclass(jbc$targets[,3]), sep="_"),
        col=unclass(jbc$targets$Type),xlim = c(-1.5,1.5), ylim=c(-1,1)) #color by type
plotMDS(jbc,labels=paste(jbc$targets[,"Type"], unclass(jbc$targets[,3]), sep="_"),
        col=unclass(jbc$targets$batch),xlim = c(-1.5,1.5), ylim=c(-1,1)) #color by type

batch = unclass(jbc$targets$batch)
trt=unclass(jbc$targets$Type)
mod = model.matrix(~as.factor(trt), data=as.data.frame(trt))
mod0= model.matrix(~1,data=as.data.frame(trt))
# estimate number of surrogate variables
n.sv = num.sv(jbc$E,mod,method="leek")
n.sv
n.sv = num.sv(jbc$E,mod,method="be")
n.sv
# Estimate 4 surrogate variables
svobj = sva(jbc$E,mod,mod0,n.sv=2)
head(svobj$sv)
dim(svobj$sv)
modsv=model.matrix(~svobj$sv)
fit=lmFit(jbc$E,modsv)
yhat=fit$coef %*% t(modsv)
jbc.svresid=jbc$E-yhat
plotMDS(jbc.svresid,labels=paste(jbc$targets[,"Type"], unclass(jbc$targets[,3]), sep="_"),
        col=unclass(jbc$targets$Type),xlim=c(-1.5,1.5),
        ylim=c(-1,1.3)) #color by type
# Results after estimating 2 surrogate variables looked better

#ComBat
jbc.bc = ComBat(dat=jbc$E, batch=batch, mod=mod)
plotMDS(jbc.bc,labels=paste(jbc$targets[,"Type"], unclass(jbc$targets[,3]), sep="_"),
        col=unclass(jbc$targets$Type),xlim = c(-1.5,1.5), ylim=c(-1,1)) #color by type

#RUV-2
source("http://bioconductor.org/biocLite.R")
biocLite("ruv")
library(ruv)

design=model.matrix(~factor(jbc$target$Type))
fit=lmFit(jbc,design)
efit=eBayes(fit)
# This is an arbitrary definition to get ~11,000 features 
#                                        (~25% of features on array)
enc=efit$p.value[,2]>0.3 & efit$p.value[,3]>0.3 & efit$p.value[,4]>0.3 &
  efit$p.value[,5]>0.3 & efit$p.value[,6]>0.3
table(enc)
myX=matrix(design,ncol=6)[,-1]
ruvfit10=RUV2(Y=t(jbc$E),X=as.matrix(myX),ctl=enc,10)
str(ruvfit10)
# The W matrix provides the estimated covariates to include in analysis
modW=model.matrix(~ruvfit10$W)
fit=lmFit(jbc$E,modW)
yhat=fit$coef %*% t(modW)
jbc.Wresid=jbc$E-yhat
plotMDS(jbc.Wresid,labels=paste(jbc$targets[,"Type"], unclass(jbc$targets[,3]), sep="_"),
        col=unclass(jbc$targets$Type),xlim=c(-1.5,1.5),
        ylim=c(-1,1.3)) #color by type

#RUV-4
ruvfit10=RUV4(Y=t(jbc$E),X=as.matrix(myX),ctl=enc,10)
str(ruvfit10)
# The W matrix provides the estimated covariates to include in analysis
modW=model.matrix(~ruvfit10$W)
fit=lmFit(jbc$E,modW)
yhat=fit$coef %*% t(modW)
jbc.Wresid=jbc$E-yhat
plotMDS(jbc.Wresid,labels=paste(jbc$targets[,"Type"], unclass(jbc$targets[,3]), sep="_"),
        col=unclass(jbc$targets$Type),xlim=c(-1.5,1.5),
        ylim=c(-1,1.3)) #color by type


###############################################################################
## Visualize 2 samples
###############################################################################
jbc$target
par(mfrow=c(2,2))
# 2 replicates
x=jbc.bc[,c(9,12)]
head(x)
smoothScatter(x,nrpoints=500)
lines(lowess(x),col=2,lwd=4)
# 2 different timepoints
z=jbc.bc[,c(9,14)]
smoothScatter(z,nrpoints=500)
lines(lowess(z),col=2,lwd=4)
# MA plot
x[1:3,]
x=x%*%cbind(A=c(1,1)/2,M=c(-1,1))
x[1:3,]
smoothScatter(x,ylim=c(-3,4),nrpoints=500)
lines(lowess(x),col=2,lwd=4)
z[1:3,]
z=z%*%cbind(A=c(1,1)/2,M=c(-1,1))
z[1:3,]
smoothScatter(z,nrpoints=500)
lines(lowess(z),col=2,lwd=4)

## Note about files
# GSE31873 files are the files you will find uploaded to GEO
# irina-cpp.txt / irina-spp.txt files are output from GenomeStudio
# tips when outputting from GenomeStudio:
# 1. add additional data columns (hidden by default)
# 2. increase number of significant figures
# 3. output imputed probes
