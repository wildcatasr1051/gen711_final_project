# **eDNA Final Project**
Nicole Farber, Sarah Polagruto,  Mandy Rosenberg

# Background
* eDNA can be used to monitor biodiversity
	* Takes samples from a species' habitat
	* This study uses water at multiple sites to detect fish DNA 
* Samples taken from two locations: GreatBay (NH)and Wells (ME) Estuaries 
	* Each had 3 different sites with 3 samples taken from each site
	* All samples taken during a single season
* Diversity of species will vary between sites Great Bay and Wells 
	* Null: species’ diversity will be the same between locations 
![image](https://github.com/wildcatasr1051/gen711_final_project/assets/158529668/585d9eb9-d0d4-42dc-a05d-7c747f89eb4e)



![Raw Data](https://github.com/wildcatasr1051/gen711_final_project/assets/158529668/4497e2e4-037d-4cc4-ac54-2ff5825aae55)

# Methods
* Kept all files in master directory directory ‘fish_final’
	* Import raw data into subdirectory
* Copied trimmed poly-g sequences (‘fastp.sh’) 
	* Process paired-end sequences for quality scoring
 
 ### Demultiplexing: sort individual samples comes from barcodes ###
* Cutadapt was used to trim the paired-end sequences to remove the primer
		* If kept, the alignments would be off due to the primers all being the same for each sequence
* Demux was used to create a visualized summary of the demultiplexed sequencing data
	* This allowed the quality scores to be obtained for the Great Bay and Wells forward and reverse sequences
   
### Denoising: remove sequencing errors [Dada2] ###
* Removes low quality sequencing and align pairs
* Metadata tabulate was used to make any metadata files viewable. Used to make sure the code for the files works and can be understood
* Classified merged sequencing against "Mitofish" database
* Feature table merge and feature table merge-seqs were used to combine data from two sequencing runs into one feature table and sequence file
* Feature-classifier classify-sklearn was used to process sequences in the study and compare them to a database of pre-labeled sequences. 
	* The feature-classifer classify sklearn generates classifications for each of the sequences


### Taxonomic assignment ###
* Taxa barplot creates a stacked bar plot of taxonomic distribution using relative frequncy
	* The barplot depicts the taxonomic breakdown of each of the sites sampled from both locations
* Feature-table filter-samples was used to filter the feature table using the meta data
* Featured-filtered table and filtered bar-plot was repeated with the metadata
  
### Phylogenetic Configuration ###
* Phylogeny align-to-tree-mafft-fasttree creates multiple files pertaining to taxonomy such as rooted and unrooted trees and alignments
	* The results of the phylogeny-align-to-tree-fasttree were used for later tools
* Diversity core-metrics-phylogenetic was used to create a core metric directory containing many different plots
* The core-metrics plots were used as results or as metrics in statistical tests

### Diversity Measure Statiscal Tests ###
* Feature-table relative-frequency was used to create a relative rarefied table used for later plots
* Diversity pcoa-biplot was used to create an unweighted unifrac pcoa biplot .qza file
* Emperor biplot was used to make the unerighted unifrac pcoa biplot viewable in qiime
* Diversity alpha-group-significance was used to create an alpha group significance plot using Shannon-entropy 
* Diversity beta-group-significance was used to create an unweighted unifrac beta group significance plot
* Diversity alpha-phylogenetic was used to create an alpha group significance plot using faith pd 
* Diversity alpha-group-significance was used to make the faith pd plot be viewable through qiime

# Figures and Results 

![Screenshot 2024-05-03 141615](https://github.com/wildcatasr1051/gen711_final_project/assets/158356198/86bc98b0-858e-4dcb-af9b-ee959ff1476f)
Wells Quality Score: Shows that the data is of good quality for the Well's data with the middle having a good quality score while the ends have a lower qality for both forward and reverse reads. This is expected of quality scores. 

![Screenshot 2024-05-03 141818](https://github.com/wildcatasr1051/gen711_final_project/assets/158356198/ddcdfc88-4f40-42ff-bf60-20564f78626e)
Great Bay Quality Score: Shows that the data is of good quality for the Great Bay's data with the middle having a good quality score while the ends have a lower qality for both forward and reverse reads. This is expected of quality scores. 

![Screenshot 2024-05-09 154254](https://github.com/wildcatasr1051/gen711_final_project/assets/158356198/2a578382-121f-4166-ba98-7c6cd6beeff9)

Without metadata: Looking at occurence of taxa across the combined environmental data at the order level. Bar plot depicts relative frequency across samples before filtering with metadata.

![Screenshot 2024-05-09 154442](https://github.com/wildcatasr1051/gen711_final_project/assets/158356198/bb1bed60-7553-4fa5-8a4f-4f3e5c50dd3a)

With metadata: Looking at the occurence of taxa across the combined evironmental data at the order level. Bar plot depicts relative freqeuency across samples after filtering with metadata. 

![Screenshot 2024-05-09 154344](https://github.com/wildcatasr1051/gen711_final_project/assets/158356198/ff4f2327-01cd-4a82-a841-d2a9f1b94cbc)

The bar plots depicting the taxa with and without the metadata are the same. They both show that in some areas of the Wells and Great Bay have different taxa orders as well as higher or lower biodiversity in certain sample locations.

![Screenshot 2024-05-11 152910](https://github.com/wildcatasr1051/gen711_final_project/assets/158356198/f5407ad7-479b-4dbb-8cf4-12985df8a8d0)
Alpha Diversity plot with Shannon Entropy for Wells and Great Bay (p-value: 0.865)

![Screenshot 2024-05-11 152923](https://github.com/wildcatasr1051/gen711_final_project/assets/158356198/a4c60333-d58c-4c13-a98c-3068be77fe66)
Alpha Diversity plot with Shannon Entropy for sites (p-value: 0.150)
Alpha-diversity measures using shannon entropy indicate no significant difference between biodiversity across locations and samples.

![Screenshot 2024-05-09 144754](https://github.com/wildcatasr1051/gen711_final_project/assets/158356198/3add8bfd-c7ce-48be-b1e9-393a18f9a844)
Alpha Diversity plot with Faith pd for Wells and Great Bay (p-value: 0.020): Examining phylogenetic diversity.

![Screenshot 2024-05-09 145228](https://github.com/wildcatasr1051/gen711_final_project/assets/158356198/19fed847-f81c-4b6c-98f2-c1aea28e5445)
Alpha Diversity plot with Faith pd for sites (p-value: 0.073): Low p-value indicates there is significant difference between evolutionary history of species. 

![Screenshot 2024-05-11 153235](https://github.com/wildcatasr1051/gen711_final_project/assets/158356198/4f467ecc-9bd6-48de-a15b-a4c0f0f8ea0e)
Bray Curtis Emperor: Dissimilarity - calculating composition-based differences between samples. Points represent samples. The closer the points to each other, the more similar they are.  

![Screenshot 2024-05-11 153339](https://github.com/wildcatasr1051/gen711_final_project/assets/158356198/0b0e3f1a-84a0-4586-941e-cbf15859bc51)
Jaccard Emperor: Displays how communities compare based on presence or absence of species.

![Screenshot 2024-05-11 153505](https://github.com/wildcatasr1051/gen711_final_project/assets/158356198/9d2683e4-0dae-444c-9036-811529d1dfb6)
Unweighted Unifrac Emperor:  considers only the presence or absence of species (OTUs) in the communities being compared. It calculates dissimilarity based on the fraction of branches in the phylogenetic tree that lead exclusively to members of one community or the other.

![Screenshot 2024-05-11 154031](https://github.com/wildcatasr1051/gen711_final_project/assets/158356198/7278064c-ecc5-4dca-a66a-b41d346bfe39)
Weighted Unifrac Emperor: Takes both presence and abundance of taxa into account. It calculates dissimilarity by considering the differences in abundance of shared OTUs between communities along the phylogenetic tree.

![Screenshot 2024-05-11 153746](https://github.com/wildcatasr1051/gen711_final_project/assets/158356198/701b398b-8c84-4f0e-9a7d-1ef591521e37)
Unweighted Unifrac pcoa Biplot Emperor: Considers presence or absence of taxa, looking at the influence of different taxa. It calculates dissimilarity based on the fraction of branches in the phylogenetic tree that lead exclusively to members of one community or the other.

![Screenshot 2024-05-05 163938](https://github.com/wildcatasr1051/gen711_final_project/assets/158356198/b3d71bde-00ef-437d-a0aa-d9e4ca5487c7)
![Screenshot 2024-05-05 163817](https://github.com/wildcatasr1051/gen711_final_project/assets/158356198/21b42b17-feeb-4578-bab8-ebe429dc97b1)
![Screenshot 2024-05-05 163709](https://github.com/wildcatasr1051/gen711_final_project/assets/158356198/c1305e34-426d-4a1d-b4bf-8baf165cefff)
![Screenshot 2024-05-05 163538](https://github.com/wildcatasr1051/gen711_final_project/assets/158356198/2dac8288-8a6e-496b-b8c9-1229d81ec64a)
![Screenshot 2024-05-05 164115](https://github.com/wildcatasr1051/gen711_final_project/assets/158356198/7cf43d1a-9074-46a1-a1c5-f40f1aef29cd)
![Screenshot 2024-05-05 164012](https://github.com/wildcatasr1051/gen711_final_project/assets/158356198/f0b1f469-2799-49e6-b2dd-85eb0734bafe)
Unweighted Unifrac Beta Group Significance: Look at the differences in compostitions across groups and if they are statistically significant. 

# Conclusions
* There is not a significant diversity, species richness between locations Wells and Great Bay
* Do not reject null hypothesis 
* There are differences in phylogenetic diversity between sites (Faith-PD)
* Future Experimentation: Take samples over multiple seasons and identify ideal sampling seasons (Hayami et al.) 
* Include plant or planktonic species to test for effects of other ecological factors 
* Relevance: Help with conservation efforts, learn about invasive or non-native species, prevent contamination  (Nguyen et. al). 



# Bibliography 

Anderson, M. J. (2001). A new method for non-parametric multivariate analysis of variance. Austral Ecology, 26(1), 32–46. https://doi.org/https://doi.org/10.1111/j.1442-9993.2001.01070.pp.x

Bokulich, N. A., Kaehler, B. D., Rideout, J. R., Dillon, M., Bolyen, E., Knight, R., Huttley, G. A., & Caporaso, J. G. (2018). Optimizing taxonomic classification of marker-gene amplicon sequences with QIIME 2’s q2-feature-classifier plugin. Microbiome, 6(1), 90. https://doi.org/10.1186/s40168-018-0470-z

Bolyen, E., Rideout, J. R., Dillon, M. R., Bokulich, N. A., Abnet, C. C., Al-Ghalith, G. A., Alexander, H., Alm, E. J., Arumugam, M., Asnicar, F., Bai, Y., Bisanz, J. E., Bittinger, K., Brejnrod, A., Brislawn, C. J., Brown, C. T., Callahan, B. J., Caraballo-Rodríguez, A. M., Chase, J., … Caporaso, J. G. (2019). Reproducible, interactive, scalable and extensible microbiome data science using QIIME 2. Nature Biotechnology, 37(8), 852–857. https://doi.org/10.1038/s41587-019-0209-9

Bolyen, E., Rideout, J. R., Dillon, M. R., Bokulich, N. A., Abnet, C. C., Al-Ghalith, G. A., Alexander, H., Alm, E. J., Arumugam, M., Asnicar, F., Bai, Y., Bisanz, J. E., Bittinger, K., Brejnrod, A., Brislawn, C. J., Brown, C. T., Callahan, B. J., Caraballo-Rodríguez, A. M., Chase, J., … Caporaso, J. G. (2019a). Reproducible, interactive, scalable and extensible microbiome data science using QIIME 2. Nature Biotechnology, 37(8), 852–857. https://doi.org/10.1038/s41587-019-0209-9

Bolyen, E., Rideout, J. R., Dillon, M. R., Bokulich, N. A., Abnet, C. C., Al-Ghalith, G. A., Alexander, H., Alm, E. J., Arumugam, M., Asnicar, F., Bai, Y., Bisanz, J. E., Bittinger, K., Brejnrod, A., Brislawn, C. J., Brown, C. T., Callahan, B. J., Caraballo-Rodríguez, A. M., Chase, J., … Caporaso, J. G. (2019b). Reproducible, interactive, scalable and extensible microbiome data science using QIIME 2. Nature Biotechnology, 37(8), 852–857. https://doi.org/10.1038/s41587-019-0209-9

Bolyen, E., Rideout, J. R., Dillon, M. R., Bokulich, N. A., Abnet, C. C., Al-Ghalith, G. A., Alexander, H., Alm, E. J., Arumugam, M., Asnicar, F., Bai, Y., Bisanz, J. E., Bittinger, K., Brejnrod, A., Brislawn, C. J., Brown, C. T., Callahan, B. J., Caraballo-Rodríguez, A. M., Chase, J., … Caporaso, J. G. (2019c). Reproducible, interactive, scalable and extensible microbiome data science using QIIME 2. Nature Biotechnology, 37(8), 852–857. https://doi.org/10.1038/s41587-019-0209-9

Callahan, B. J., McMurdie, P. J., Rosen, M. J., Han, A. W., Johnson, A. J. A., & Holmes, S. P. (2016). DADA2: high-resolution sample inference from Illumina amplicon data. Nature Methods, 13(7), 581. https://doi.org/10.1038/nmeth.3869

Halko, N., Martinsson, P.-G., Shkolnisky, Y., & Tygert, M. (2011). An Algorithm for the Principal Component Analysis of Large Data Sets. SIAM Journal on Scientific Computing. https://doi.org/10.1137/100804139

Hamady, M., Lozupone, C., & Knight, R. (2010). Fast UniFrac: facilitating high-throughput phylogenetic analyses of microbial communities including analysis of pyrosequencing and PhyloChip data. The ISME Journal, 4(1), 17–27. https://doi.org/10.1038/ismej.2009.97

Jaccard, P. (1908). Nouvelles recherches sur la distribution floral. Bull. Soc. Vard. Sci. Nat, 44, 223–270.

Katoh, K., & Standley, D. M. (2013). MAFFT multiple sequence alignment software version 7: improvements in performance and usability. Molecular Biology and Evolution, 30(4), 772–780. https://doi.org/10.1093/molbev/mst010

Kruskal, W. H., & Wallis, W. A. (1952). Use of ranks in one-criterion variance analysis. Journal of the American Statistical Association, 47(260), 583–621. https://doi.org/10.1080/01621459.1952.10483441

Lane, D. (1991). 16S/23S rRNA sequencing. In E. Stackebrandt & M. Goodfellow (Eds.), Nucleic Acid Techniques in Bacterial Systematics (pp. 115–175). John Wiley.

Legendre, P., & Legendre, L. (2012). Numerical Ecology (Third, p. 499). Elsevier.

Legendre, P., & Legendre, L. (2012a). Numerical Ecology (Third, p. 499). Elsevier.

Legendre, P., & Legendre, L. (2012b). Numerical Ecology (Third, p. 499). Elsevier.

Lozupone, C. A., Hamady, M., Kelley, S. T., & Knight, R. (2007). Quantitative and Qualitative β Diversity Measures Lead to Different Insights into Factors That Structure Microbial Communities. Applied and Environmental Microbiology, 73(5), 1576–1585. https://doi.org/10.1128/AEM.01996-06

Lozupone, C., & Knight, R. (2005). UniFrac: a New Phylogenetic Method for Comparing Microbial Communities. Applied and Environmental Microbiology, 71(12), 8228–8235. https://doi.org/10.1128/AEM.71.12.8228-8235.2005

Lozupone, C., Lladser, M. E., Knights, D., Stombaugh, J., & Knight, R. (2011). UniFrac: an effective distance metric for microbial community comparison. The ISME Journal, 5(2), 169–172. https://doi.org/10.1038/ismej.2010.133

Martin, M. (2011). Cutadapt removes adapter sequences from high-throughput sequencing reads. EMBnet. Journal, 17(1), pp-10. https://doi.org/10.14806/ej.17.1.200

McDonald, D., Clemente, J. C., Kuczynski, J., Rideout, J. R., Stombaugh, J., Wendel, D., Wilke, A., Huse, S., Hufnagle, J., Meyer, F., Knight, R., & Caporaso, J. G. (2012a). The Biological Observation Matrix (BIOM) format or: how I learned to stop worrying and love the ome-ome. GigaScience, 1(1), 7. https://doi.org/10.1186/2047-217X-1-7

McDonald, D., Clemente, J. C., Kuczynski, J., Rideout, J. R., Stombaugh, J., Wendel, D., Wilke, A., Huse, S., Hufnagle, J., Meyer, F., Knight, R., & Caporaso, J. G. (2012b). The Biological Observation Matrix (BIOM) format or: how I learned to stop worrying and love the ome-ome. GigaScience, 1(1), 7. https://doi.org/10.1186/2047-217X-1-7

McDonald, D., Clemente, J. C., Kuczynski, J., Rideout, J. R., Stombaugh, J., Wendel, D., Wilke, A., Huse, S., Hufnagle, J., Meyer, F., Knight, R., & Caporaso, J. G. (2012c). The Biological Observation Matrix (BIOM) format or: how I learned to stop worrying and love the ome-ome. GigaScience, 1(1), 7. https://doi.org/10.1186/2047-217X-1-7

McDonald, D., Vázquez-Baeza, Y., Koslicki, D., McClelland, J., Reeve, N., Xu, Z., Gonzalez, A., & Knight, R. (2018). Striped UniFrac: enabling microbiome analysis at unprecedented scale. Nature Methods, 15(11), 847–848. https://doi.org/10.1038/s41592-018-0187-8

Pedregosa, F., Varoquaux, G., Gramfort, A., Michel, V., Thirion, B., Grisel, O., Blondel, M., Prettenhofer, P., Weiss, R., Dubourg, V., Vanderplas, J., Passos, A., Cournapeau, D., Brucher, M., Perrot, M., & Duchesnay, É. (2011a). Scikit-learn: Machine learning in Python. Journal of Machine Learning Research, 12(Oct), 2825–2830.

Pedregosa, F., Varoquaux, G., Gramfort, A., Michel, V., Thirion, B., Grisel, O., Blondel, M., Prettenhofer, P., Weiss, R., Dubourg, V., Vanderplas, J., Passos, A., Cournapeau, D., Brucher, M., Perrot, M., & Duchesnay, É. (2011b). Scikit-learn: Machine learning in Python. Journal of Machine Learning Research, 12(Oct), 2825–2830.

Price, M. N., Dehal, P. S., & Arkin, A. P. (2010). FastTree 2–approximately maximum-likelihood trees for large alignments. PloS One, 5(3), e9490. https://doi.org/10.1371/journal.pone.0009490

Robeson, M. S., O\textquoterightRourke, D. R., Kaehler, B. D., Ziemski, M., Dillon, M. R., Foster, J. T., & Bokulich, N. A. (2021a). RESCRIPt: Reproducible sequence taxonomy reference database management. https://doi.org/10.1371/journal.pcbi.1009581

Robeson, M. S., O\textquoterightRourke, D. R., Kaehler, B. D., Ziemski, M., Dillon, M. R., Foster, J. T., & Bokulich, N. A. (2021b). RESCRIPt: Reproducible sequence taxonomy reference database management. https://doi.org/10.1371/journal.pcbi.1009581

Rognes, T., Flouri, T., Nichols, B., Quince, C., & Mahé, F. (2016). VSEARCH: a versatile open source tool for metagenomics. PeerJ, 4, e2584. https://doi.org/10.7717/peerj.2584

Shannon, C. E. (1948). A mathematical theory of communication. The Bell System Technical Journal, 27(3), 379–423, 623–656. https://doi.org/10.1002/j.1538-7305.1948.tb01338.x

Sørensen, T. (1948). A method of establishing groups of equal amplitude in plant sociology based on similarity of species and its application to analyses of the vegetation on Danish commons. Biol. Skr., 5, 1–34.

Vázquez-Baeza, Y., Gonzalez, A., Smarr, L., McDonald, D., Morton, J. T., Navas-Molina, J. A., & Knight, R. (2017). Bringing the dynamic microbiome to life with animations. Cell Host & Microbe, 21(1), 7–10. https://doi.org/10.1016/j.chom.2016.12.009

Vázquez-Baeza, Y., Pirrung, M., Gonzalez, A., & Knight, R. (2013). EMPeror: a tool for visualizing high-throughput microbial community data. Gigascience, 2(1), 16. https://doi.org/10.1186/2047-217X-2-16

Weiss, S., Xu, Z. Z., Peddada, S., Amir, A., Bittinger, K., Gonzalez, A., Lozupone, C., Zaneveld, J. R., Vázquez-Baeza, Y., Birmingham, A., Hyde, E. R., & Knight, R. (2017). Normalization and microbial differential abundance strategies depend upon data characteristics. Microbiome, 5(1), 27. https://doi.org/10.1186/s40168-017-0237-y

Wes McKinney. (2010). Data Structures for Statistical Computing in Python . In S. van der Walt & Jarrod Millman (Eds.), Proceedings of the 9th Python in Science Conference (pp. 51–56).

Wes McKinney. (2010a). Data Structures for Statistical Computing in Python . In S. van der Walt & Jarrod Millman (Eds.), Proceedings of the 9th Python in Science Conference (pp. 51–56).

Wes McKinney. (2010b). Data Structures for Statistical Computing in Python . In S. van der Walt & Jarrod Millman (Eds.), Proceedings of the 9th Python in Science Conference (pp. 51–56).

Wes McKinney. (2010c). Data Structures for Statistical Computing in Python . In S. van der Walt & Jarrod Millman (Eds.), Proceedings of the 9th Python in Science Conference (pp. 51–56).

### Outside references ###
Hayami, K., Sakata, M. K., Inagawa, T., Okitsu, J., Katano, I., Doi, H., Nakai, K., Ichiyanagi, H., Gotoh, R. O., Miya, M., Sato, H., Yamanaka, H., & Minamoto, T. (2020). Effects of sampling seasons and locations on fish environmental DNA metabarcoding in dam reservoirs. Ecology and evolution, 10(12), 5354–5367. https://doi.org/10.1002/ece3.6279

Nguyen, V. M., Young, N., & Cooke, S. J. (2017). A roadmap for knowledge exchange and mobilization research in conservation and natural resource management. Conservation biology : the journal of the Society for Conservation Biology, 31(4), 789–798. https://doi.org/10.1111/cobi.12857

What is demultiplexing?: https://astrobiomike.github.io/amplicon/demultiplexing

Chat-GPT 


