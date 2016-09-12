## Computational Approaches to Genomic Medicine

- Sequencing grow to 1 Zettabyte by 2024
- Arrays replaced --> High throughput


## Prediction of Medulloblastoma

- Brain tumor
- Common in children 
- Clinical outcomes are poor -- look at histology
  - 60-80% can be cured -- but huge effect of treatment nuerologically
  - Chemotherapy and radiation cause life altering neurologic side effects
- Probability of patients doing well post therapy


Gene expression data:

- Find genes correlated highly with one class -- permutation test for stat. significance
- Preditor based on best 10 correlated genes
- Cross validation accuracy of 78% but no insight into therapy or mechanism
- Problem --> Genes don't act independently 
- Solution --> User cellular response, interpret in context of known pathways or response signatures -- MSigDB


 GSEA
 - Sort genes by differential expression
 - Gene set coordinated well with MSIGDB , if this is randomly distrbited => Nothing to do with the biological implication
 - If cooordinately up or down regulated ==> Could be up or downregulated
 - USe KS test -- > but not sufficient as it would pull out diff sets not really DE -> Use weighted version of KS test
 
Prediction

- Datatypes:
  - Metastatis status
  - Histology
  - Expression
  - Moelcular subtype
  - Pathways
  - Copy number
  
- Non negative matrix factorization for identifying clusters
- Extracting features -> 4600 gene sets from MSIgDB , ciurated pathways, oncogene sets 
- Project gene level datat to 2600 gene sets signature space


Signature Projection
- GSEA like approach
- Bayesian network outcome: clinical, didsease subtype indepdent expression, dna copy number 
