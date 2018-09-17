###############################################
##
## Data visualization lab.R
##
## by kds   6/01/2016
##
###############################################

#####################################
##
## load libraries
##
#####################################

source("http://bioconductor.org/biocLite.R")
biocLite("matlab")



##################################################
##
## Data visualization
##
##################################################
library(limma)
library(sva)
library(matlab)
library(Biobase)

sfile="data/JBC_2012/GSE31873 Sample Probe Profile.txt"
cfile="data/JBC_2012/GSE31873 Control Probe Profile.txt"
rawdata = read.ilmn(files=sfile, ctrlfiles=cfile)
targets=read.csv(file="data/JBC_2012/SampleChars.csv",row.names=1) 
head(targets) #contains treatment/time/batch/Type(treat+time)
rawdata$targets=targets[colnames(rawdata),] #store targets w/rawdata
# background correct; quantile normalize; log2 transform
jbc=neqc(rawdata)
# correct for batch using ComBat
batch = unclass(jbc$targets$batch)
trt=unclass(jbc$targets$Type)
mod = model.matrix(~as.factor(trt), data=as.data.frame(trt))
jbc.bc = ComBat(dat=jbc$E, batch=batch, mod=mod)

plotMDS(jbc.bc,labels=paste(jbc$targets[,"Type"], unclass(jbc$targets[,3]), sep="_"),
        col=unclass(jbc$targets$Type),xlim = c(-1.5,1.5), ylim=c(-1,1)) #color by type

# Now grab the data from GEO
# Import C42b cell line data from GE
#Illumina HumanHT-12 V4.0 expression beadchip
#GPL10558; 47231 rows
#if(!require('GEOquery')) biocLite('GEOquery')
library(GEOquery)
# gse31873=getGEO('GSE31873',GSEMatrix=TRUE)   # this is slow over wifi, let's skip and load the saved object
# save(gse31873,file="gse31873.rda") 
load("../data/JBC_2012/gse31873.rda")              
show(gse31873)
c42b=gse31873$GSE31873_series_matrix.txt.gz
ec42b=exprs(c42b)
ec42b[1:4,1:3]
#compare to processed jbc data
jbc.bc[1:4,1:3] # need to sort rows alphabetically
jbcE=jbc.bc[sort(rownames(jbc.bc)),]
jbcE[1:4,1:3]  # they match! (need to check entire matrix)
# to get the phenotype data we would type pdata()
targets=pData(c42b)
colnames(targets)
targets$title[1:4]

##########################################
##
## Show  heat map of preprocessed data
##
##########################################
## Pick 500 most variable probes
top500var=which(rank(apply(jbc.bc,1,IQR))>nrow(jbc.bc)-500)
length(top500var)

## assign colors to sample annotation variables
library(car)
rxcol=rawdata$targets$treatments
timecol=rawdata$targets$hour
clab=as.matrix(cbind.data.frame(rxcol,timecol))
clab
clab[,1]=recode(clab[,1], "'siNS'='pink'; 'sip300'='orange'; 'siCBP'='purple'")
clab[,2]=recode(clab[,2], "'0h'='grey'; '16h'='lightgreen'")
clab

source("heatmap.3.R")
#source("C:/Users/kims/Dropbox/PM579/PM579-Summer2016/labs/heatmap.3.R")
par(cex.main=1)
heatmap.3(jbc.bc[top500var,], scale="none",  margins=c(2,10), Rowv=TRUE, Colv=TRUE,
          ColSideColors=clab,NumColSideColors=4, labCol=FALSE, labRow=NA,cexCol=1.8,
          symbreaks=FALSE, key=TRUE, symkey=FALSE, density.info="none", trace="none", 
          KeyValueName="log2(Expr)",
          col=jet.colors(32) )
legend("topright",
       c("NS","CBP","p300","0hr","16hr"),cex=1.2,
       fill=c("pink","purple","orange","grey","lightgreen"), border=FALSE,bty="n")

########################
##
##  Cluster Analysis
##
########################
##
## To give probes equal weight when clustering samples, we standardize
##  the probes. We do this using robust measures of location/variation
## 
rowIQRs=function(x) (apply(x,1,IQR))
standardize=function(x){
  (x-rowMedians(x))/rowIQRs(x)
}
jbcstd=standardize(jbc.bc)

##
## select top 500 of genes ranked by variation
##
top500iqr=which(rank(rowIQRs(jbc.bc))>nrow(jbc.bc)-500)
genesubset=jbcstd[top500iqr,]

##
## show dendrogram of sample cluster from selecting 500 most varying genes
##
colnames(genesubset)=jbc$targets$Type
col.dist<-dist(t(genesubset))  #Euclidean distance is the default
hc=hclust(col.dist,method="average")
par(cex=1.2,lwd=2)
plot(hc)

##
## show heatmap of sample correlation matrix
##
cc=as.character(jbc$targets$Type)
cc=recode(cc, "'siNS_0h'='lightgreen';  'siNS_16h'='darkgreen';
              'siCBP_0h'='lightblue';  'siCBP_16h'='darkblue';
             'sip300_0h'='pink';    'sip300_16h'='purple'")

col.dist<-dist(t(genesubset))
#default heatmap colors are red-yellow
heatmap(as.matrix(col.dist),sym=TRUE,distfun=function(x)(as.dist(x)),
        hclustfun=function(x)(hclust(col.dist,method="average")),
        ColSideColors=cc)
#red is low (distance), yellow is high
# run using jet.colors(32)
heatmap(as.matrix(col.dist),sym=TRUE,distfun=function(x)(as.dist(x)),
        hclustfun=function(x)(hclust(col.dist,method="average")),
        ColSideColors=cc,
        col=jet.colors(32))
######################
##
##  Make Heatmap of Filtered & Std data
##
######################
top500iqr=which(rank(apply(jbc.bc,1,IQR))>nrow(jbc.bc)-500)
genesubset=jbcstd[top500iqr,]
##
##  use correlation metric for genes, Euclidean for samples
##
## as.dist() takes a matrix of pair-wise distances and makes it a distance function (lower-diagonal matrix)
##  genes are the rows of the matrix, but cor() computes correlations between
##  columns so we must transpose the matrix
row.dist<-as.dist(1-cor(t(genesubset)))
## dist() takes a data matrix and computes distances between rows.
## Typically in statistics the rows are the samples (but not for microarray data)
##  so we have to transpose the matrix to do this for the correct dimension
col.dist<-dist(t(genesubset))
##
## heatmap
## 
hmp.dist<-heatmap(genesubset,labRow=NA,labCol=NA,
                  Colv=as.dendrogram(hclust(col.dist,method="average")),
                  Rowv=as.dendrogram(hclust(row.dist,method="average")),
                  ColSideColors=cc,xlab="Samples",ylab="Features",
                  col=jet.colors(32))

######################
##
##   MDS plot
##
######################
plotMDS(jbc.bc,labels=paste(jbc$targets[,"Type"], unclass(jbc$targets[,3]), sep="_"),
        col=cc,xlim = c(-1.5,1.5), ylim=c(-1,1),
        main="MDS plot") #color by type
#
# We also propose to use classical multi-dimensional scaling plots 
# for visualizing the classes. Here we chose 2 scaling dimensions
col.dist<-dist(t(jbc.bc))
cmd1=cmdscale(col.dist,2,x.ret=T)
plot(cmd1$points, col=as.character(cc),  
     main="MDS plot",xlab="Scaling Dimension 1",
     ylab="Scaling Dimension 2", cex.axis=1.5,cex.lab=1.5, 
     cex.main=1.5,pch=18,cex=1.5)
#
cmd1=cmdscale(col.dist,k=12,eig=T)
cmd1$eig
sum(cmd1$eig)
par(lwd=2,cex=1.3)
plot(1:12,cumsum(cmd1$eig[1:12])/sum(abs(cmd1$eig)),type="b",
     xlab="Scaling Dimensions",ylab="Goodness-of-Fit",ylim=c(0.2,1))
plot(1:12,cmd1$eig[1:12],type="b",
     xlab="Scaling Dimensions",ylab="Eigenvalue")

# principle components analysis
my.pca=prcomp(t(jbc.bc),retx=TRUE)
plot(my.pca$x[,1:2], col=as.character(cc),  
     main="PCA plot",xlab="PC 1",
     ylab="PC 2", cex.axis=1.5,cex.lab=1.5, 
     cex.main=1.5,pch=18,cex=2)

pcid=c(1,4)
plot(my.pca$x[,pcid], col=as.character(cc),  
     main="PCA plot",xlab=colnames(my.pca$x[,pcid])[1],
     ylab=colnames(my.pca$x[,pcid])[2], cex.axis=1.5,cex.lab=1.5, 
     cex.main=1.5,pch=18,cex=2)

# Now get it by SVD
# center the gene expression matrix
cjbc.bc=sweep(jbc.bc,1,apply(jbc.bc,1,mean))
s.all=svd(cjbc.bc)
# first 2 PCs for samples
PCs=cbind(s.all$d[1]*s.all$v[,1],s.all$d[2]*s.all$v[,2])
colnames(PCs)=c("PC 1","PC 2")
plot(PCs[,1],PCs[,2],col=as.character(cc),
       xlab=colnames(PCs)[1],
       ylab=colnames(PCs)[2],
      cex.axis=1.5,cex.lab=1.5,cex.main=1.5,pch=18,cex=2)

# compute %variance from s.all$d
round(cumsum(s.all$d^2)/sum(s.all$d^2),2)
plot(1:24,round(cumsum(s.all$d^2)/sum(s.all$d^2),2),
     type="b",ylab="%Variance explained",xlab="PCs")
plot(1:24,s.all$d,type="b",ylab="Eigenvalue",xlab="PCs")



##############################################################
##
## Cluster analysis using K-means
##
##############################################################
library(stats)
top500iqr=which(rank(rowIQRs(jbc.bc))>nrow(jbc.bc)-500)
genesubset=jbcstd[top500iqr,]
set.seed(46)

#
# pick random start values 1 time only
#
km4=kmeans(t(genesubset),4)
table(km4$cluster,jbc$targets[,"Type"])
km4$withinss
sum(km4$withinss)

#
# Now try 25 random starts and pick the best solution (minimum WSS)
#
kmx=kmeans(t(genesubset),centers=4,nstart=25)
kmx$withinss
sum(kmx$withinss)
table(kmx$cluster,jbc$targets[,"Type"])

##
## Partitioning around Medoids (PAM)
##
library(cluster)
p4=pam(t(genesubset),4)
table(p4$cluster,jbc$targets[,"Type"])

# silhouette plot
silpam4=silhouette(p4)
plot(silpam4)
silpam4
# average sillouette distance(width)
summary(p4)$silinfo$avg.width

p3=pam(t(genesubset),3)
table(p3$cluster,jbc$targets[,"Type"])
summary(p3)$silinfo$avg.width

##
## Heatmap using PAM cluster order for samples
##
okp4=order(p4$cluster)
ogenesubset=genesubset[,okp4]
row.dist=as.dist(1-cor(t(ogenesubset)))
# plot heatmap with columns fixed by order of PAM results
# the default is to scale the rows if symm = FALSE (default), o.w. none
hmp.dist<-heatmap(ogenesubset,labRow=NA,labCol=NA,
                  Colv=NA,
                  Rowv=as.dendrogram(hclust(row.dist,method="average")),
                  ColSideColors=as.character(p4$cluster[okp4]),
                  xlab="",ylab="",col=jet.colors(32))
##
##  Show PAM clusters (by colors) using MDS
##
col.dist<-dist(t(jbc.bc))
cmd1=cmdscale(col.dist,2,x.ret=T)
plot(cmd1$points, col=as.character(p4$cluster),  
     main="MDS plot",xlab="Scaling Dimension 1",
     ylab="Scaling Dimension 2", cex.axis=1.5,cex.lab=1.5, 
     cex.main=1.5,pch=18,cex=1.5)

