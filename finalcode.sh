#!/bin/bash

# gen711_final_project

#Creates new file in home directory called 'fish_final': this will contain all files for final project

   mkdir -p fish_final

#Change directory to "fish_final"

   cd fish_final 
 
#Within the "fish_final" directory create a "raw_data" directory

      mkdir -p raw_data
   
#Change directory to be within the "raw_data" directory. This directory contains any raw, untouched data
   
      cd raw_data

#Copy files "fastqs," "GreatBay-Metadata.tsv," and "Wells-Metadata.sv" into directory "raw_data

      cp -r /tmp/gen711_project_data//eDNA-fqs/mifish/fastqs/ .

      cp /tmp/gen711_project_data/eDNA-fqs/mifish/GreatBay-Metadata.tsv .

      cp /tmp/gen711_project_data/eDNA-fqs/mifish/Wells-Metadata.tsv .

#Activate the qiime2-2022.8 conda environment 

      conda activate qiime2-2022.8

#Make directory "fastp.sh" in current directory

      mkdir fastp.sh
   
#Copy "fastp.sh" into fastp.sh directory

      cp /tmp/gen711_project_data/scripts/fastp.sh ./fastp.sh 

#Change permissions on fastp.sh to run qiime analysis
 
   chmod +x ./fastp.sh/

#Return to previous directory "fish_final"

   cd ..

#Make directory "trimmed_fastqs" in "fish_final" 
 
   mkdir trimmed_fastqs
  
   cd raw_data

   cd fastqs

#Command uses QIIME software to import paired-end sequence data with quality information. Use for both GreatBay and Wells data

qiime tools import \
   --type "SampleData[PairedEndSequencesWithQuality]"  \
   --input-format CasavaOneEightSingleLanePerSampleDirFmt \
   --input-path ./GreatBay/ \
   --output-path /home/users/nlf1022/fish_final/trimmed_fastqs/GreatBay_trimmed

   qiime tools import \
      --type "SampleData[PairedEndSequencesWithQuality]"  \
      --input-format CasavaOneEightSingleLanePerSampleDirFmt \
      --input-path ./Wells/ \
      --output-path /home/users/nlf1022/fish_final/trimmed_fastqs/Wells_trimmed

   cd /home/users/nlf1022/fish_final
   
#Create a new directory named "no_primer" in current working directory

   mkdir no_primer 

#Trims primer sequences from paired-end sequencing data. Specifies the use of 4 processing cores and provides forward and reverse primer sequencing for trimming.

qiime cutadapt trim-paired \
    --i-demultiplexed-sequences /home/users/nlf1022/fish_final/trimmed_fastqs/GreatBay_trimmed.qza \
    --p-cores 4 \
    --p-front-f GTCGGTAAAACTCGTGCCAGC \
    --p-front-r CATAGTGGGGTATCTAATCCCAGTTTG \
    --p-discard-untrimmed \
    --p-match-adapter-wildcards \
    --verbose \
    --o-trimmed-sequences ./no_primer/GreatBay_no_primer.qza

qiime cutadapt trim-paired \
    --i-demultiplexed-sequences /home/users/nlf1022/fish_final/trimmed_fastqs/Wells_trimmed.qza \
    --p-cores 4 \
    --p-front-f GTCGGTAAAACTCGTGCCAGC \
    --p-front-r CATAGTGGGGTATCTAATCCCAGTTTG \
    --p-discard-untrimmed \
    --p-match-adapter-wildcards \
    --verbose \
    --o-trimmed-sequences ./no_primer/Wells_no_primer.qza

#Change directory to 'no_primer'

cd no_primer

#Generate a visualized summary of demultiplexed sequencing data stored in the file. Use twice, once with the GreatBay data and once with the Wells data.

qiime demux summarize \
--i-data ./GreatBay_no_primer.qza \
--o-visualization  ./GreatBay_Summary.qzv 

qiime demux summarize \
--i-data ./Wells_no_primer.qza \
--o-visualization  ./Wells_Summary.qzv 

#Change back to 'fish_final' directory 

cd .. 

#create new directory called 'denoising'

mkdir denoising 

#Process paired end reads by trimming reads to improve quality and denoise to correct sequencing errors. Use for both GreatBay and Wells data.

qiime dada2 denoise-paired \
    --i-demultiplexed-seqs ~/fish_final/no_primer/GreatBay_no_primer.qza  \
    --p-trunc-len-f  120 \
    --p-trunc-len-r 115 \
    --p-trim-left-f 0 \
    --p-trim-left-r 0 \
    --p-n-threads 4 \
    --o-denoising-stats ~/fish_final/denoising/GreatBay_denoising-stats.qza \
    --o-table ~/fish_final/denoising/GreatBay_feature_table.qza \
    --o-representative-sequences ~/fish_final/denoising/GreatBay_rep-seqs.qza

qiime dada2 denoise-paired \
    --i-demultiplexed-seqs ~/fish_final/no_primer/Wells_no_primer.qza  \
    --p-trunc-len-f  120 \
    --p-trunc-len-r 115 \
    --p-trim-left-f 0 \
    --p-trim-left-r 0 \
    --p-n-threads 4 \
    --o-denoising-stats ~/fish_final/denoising/Wells_denoising-stats.qza \
    --o-table ~/fish_final/denoising/Wells_feature_table.qza \
    --o-representative-sequences ~/fish_final/denoising/Wells_rep-seqs.qza

#Create a visualization from denoising, allowing easier interpretations of the data. Use for both GreatBay and Wells data.

qiime metadata tabulate \
    --m-input-file ~/fish_final/denoising/GreatBay_denoising-stats.qza \
    --o-visualization ~/fish_final/denoising/GreatBay_denoising-stats.qzv

qiime metadata tabulate \
    --m-input-file ~/fish_final/denoising/Wells_denoising-stats.qza \
    --o-visualization ~/fish_final/denoising/Wells_denoising-stats.qzv

#Create a visualization from rep-seq files, allowing easier interpretations of the data. Use for both GreatBay and Wells data.

qiime feature-table tabulate-seqs \
        --i-data ~/fish_final/denoising/GreatBay_rep-seqs.qza \
        --o-visualization ~/fish_final/denoising/GreatBay_rep-seqs.qzv

qiime feature-table tabulate-seqs \
        --i-data ~/fish_final/denoising/Wells_rep-seqs.qza \
        --o-visualization ~/fish_final/denoising/Wells_rep-seqs.qzv

#Create new directory called 'taxonomy' in the 'fish_final' directory. This directory will contain any files pertaining to taxonomy

mkdir taxonomy

cd denoising 

#Merge the GreatBay and Wells rep-seq files into a single combined file

qiime feature-table merge-seqs \
   --i-data ./GreatBay_rep-seqs.qza \
   --i-data ./Wells_rep-seqs.qza \
   --o-merged-data ./combined_rep-seqs.qza

#Merge the GreatBay and Wells feature table files into a single combined file

qiime feature-table merge \
  --i-tables ./GreatBay_feature_table.qza \
  --i-tables ./Wells_feature_table.qza \
  --o-merged-table ./combined_feature_table.qza

#Use 'mitofish-classifier' from the temporatry project directory and the comined rep-seqs file to make a a file with the taxonomy of the data

qiime feature-classifier classify-sklearn \
  --i-classifier /tmp/gen711_project_data/eDNA-fqs/mifish/ref-database/mitofish-classifier.qza \
  --i-reads ./combined_rep-seqs.qza \
  --o-classification ~/fish_final/taxonomy/taxonomy.qza

#Use the taxonomy file and the combined feature table file in order to create a barplot

qiime taxa barplot      
   --i-table ./combined_feature_table.qza \   
   --i-taxonomy ~/fish_final/taxonomy/taxonomy.qza \     
   --o-visualization ~/fish_final/taxonomy/barplot.qzv

#Copy 'new_meta.tsv' file from the temporary project directory into raw_data. This is the combined metadata file.

cp /tmp/gen711_project_data/eDNA-fqs/mifish/new_meta.tsv ~/fish_final/raw_data

#Filter the combined feature table and filter it using the metadata
        
qiime feature-table filter-samples \
  --i-table ./combined_feature_table.qza \
  --m-metadata-file /home/users/nlf1022/fish_final/raw_data/new_meta.tsv \
  --o-filtered-table ./feature_table_filtered.qza

#Create a filtered barplot using the filtered feature table

qiime taxa barplot \
     --i-table /home/users/nlf1022/fish_final/denoising/feature_table_filtered.qza \
     --m-metadata-file /home/users/nlf1022/fish_final/raw_data/new_meta.tsv \
     --i-taxonomy /home/users/nlf1022/fish_final/taxonomy/taxonomy.qza \
     --o-visualization /home/users/nlf1022/fish_final/taxonomy/filtered-barplot.qzv  

#Create phylogony files containing alignment, masked alignment, unrooted tree, and rooted tree using the 'comined_rep-seqs.qza' file/

qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences /home/users/nlf1022/fish_final/denoising/combined_rep-seqs.qza \
  --o-alignment /home/users/nlf1022/fish_final/taxonomy/alignments \
  --o-masked-alignment /home/users/nlf1022/fish_final/taxonomy/masked-alignment \
  --o-tree /home/users/nlf1022/fish_final/taxonomy/unrooted-tree \
  --o-rooted-tree /home/users/nlf1022/fish_final/taxonomy/rooted-tree \
  --p-n-threads 4

#
  
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny /home/users/nlf1022/fish_final/taxonomy/rooted-tree.qza \
  --i-table /home/users/nlf1022/fish_final/denoising/combined_feature_table.qza \
  --p-sampling-depth 500 \
  --m-metadata-file /home/users/nlf1022/fish_final/raw_data/new_meta.tsv  \
  --p-n-jobs-or-threads 4 \
  --output-dir /home/users/nlf1022/fish_final/taxonomy/core-metric

qiime feature-table relative-frequency \
  --i-table /home/users/nlf1022/fish_final/taxonomy/core-metric/rarefied_table.qza \
  --o-relative-frequency-table /home/users/nlf1022/fish_final/taxonomy/core-metric/relative_rarefied_table

qiime diversity pcoa-biplot \
  --i-features /home/users/nlf1022/fish_final/taxonomy/core-metric/relative_rarefied_table.qza \
  --i-pcoa /home/users/nlf1022/fish_final/taxonomy/core-metric/unweighted_unifrac_pcoa_results.qza \
  --o-biplot /home/users/nlf1022/fish_final/taxonomy/core-metric/unweighted_unifrac_pcoa_biplot

qiime emperor biplot \
  --i-biplot /home/users/nlf1022/fish_final/taxonomy/core-metric/unweighted_unifrac_pcoa_biplot.qza \
  --m-sample-metadata-file /home/users/nlf1022/fish_final/raw_data/new_meta.tsv \
  --o-visualization /home/users/nlf1022/fish_final/taxonomy/core-metric/unweighted_unifrac_pcoa_biplot

qiime diversity alpha-group-significance \
  --i-alpha-diversity /home/users/nlf1022/fish_final/taxonomy/core-metric/shannon_vector.qza \
  --m-metadata-file /home/users/nlf1022/fish_final/raw_data/new_meta.tsv \
  --o-visualization /home/users/nlf1022/fish_final/taxonomy/core-metric/alpha-group-significance

qiime diversity beta-group-significance \
  --i-distance-matrix /home/users/nlf1022/fish_final/taxonomy/core-metric/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file /home/users/nlf1022/fish_final/raw_data/new_meta.tsv \
  --m-metadata-column site_name \
  --p-pairwise \
  --o-visualization /home/users/nlf1022/fish_final/taxonomy/core-metric/unweighted_unifrac-beta-group-significance

qiime diversity alpha-phylogenetic \
--i-table /home/users/nlf1022/fish_final/denoising/combined_feature_table.qza \
--i-phylogeny /home/users/nlf1022/fish_final/taxonomy/rooted-tree.qza \
--p-metric faith_pd \
--o-alpha-diversity /home/users/nlf1022/fish_final/taxonomy/core-metric/faith_pd


#Codes used to change files into viewable data during troubleshooting:

qiime metadata tabulate \
      --m-input-file ~/fish_final/raw_data/new_meta.tsv \
      --o-visualization ~/fish_final/raw_data/tabulated-metadata.qzv

qiime feature-table summarize \
    --i-table /home/users/nlf1022/fish_final/denoising/Wells_feature_table.qza \
    --o-visualization /home/users/nlf1022/fish_final/denoising/Wells_feature_table.qzv

qiime feature-table summarize \
    --i-table /home/users/nlf1022/fish_final/denoising/GreatBay_feature_table.qza \
    --o-visualization /home/users/nlf1022/fish_final/denoising/GreatBay_feature_table.qzv
    
qiime feature-table summarize \
    --i-table /home/users/nlf1022/fish_final/denoising/combined_feature_table.qza \
    --o-visualization /home/users/nlf1022/fish_final/denoising/combined_feature_table.qzv

qiime feature-table summarize \
    --i-table /home/users/nlf1022/fish_final/denoising/feature_table_filtered.qza \
    --o-visualization /home/users/nlf1022/fish_final/denoising/feature_table_filtered.qzv
