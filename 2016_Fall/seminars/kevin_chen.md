- {riortizing Non-coding variation 
- Nicotine-addition: CHRNA5 nicotininc receptor
- Many regulator elements in genome and many brain regionsa re not evolutionary conserved
so mouse not a good model for psychiatric ddisease


- Spectral learning of HMMs for predicting chromatin states for a single cell type
- enhancer RNAs - eRNAs -> used to identify enhancers

- Data from human epigenomics project
- PsychENCODE -> Specific to psychiatric disease


- Chromatin marks
    - H3K4Me1 --> Associated with enhancers
    - H3K4Me3 --> Associateed with promoters
    - H3K27Ac --> Associated with active enhancer
- Input: set of histone marks and other chromatin marks in a cell type
- Output: Chromaitcn states associated with genomic feature: enhancers. TSS

- EM not guaranteed to reach local optima, no provable xomplexity bounds
- Use method of moments, express expected moments of data as function of parametes, setting expected momemnts
equal to the sample moments calculated from the data
- Novel spectral learning: Coonsider all combinations of 8 histone marks: 2^8
- P_{1.2}$  has matrox of counts of consecutivate pairs of combinations of the genome
- {_{1,2,3}} is 3rd order tensor of counts of tripsi

- Matrix $O_i$ is the distribution of observation i
- Column vector $O_{i,k}=Pr(X_i|h_2=K)$
- Condition on hidden state: past present and future state


- REsults similar to ChromHMM
- but ChromHMM overfits 
- Comparison with GWAS SNP enrichments - seen in 20th state

- eRNAs - bidirectiona non spliced --> active enhacner
