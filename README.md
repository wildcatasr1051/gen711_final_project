#!/bin/bash

# gen711_final_project

#Mkdir fish_final: this will contain all files for final project

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


qiime tools import \
   --type "SampleData[PairedEndSequencesWithQuality]"  \
   --input-format CasavaOneEightSingleLanePerSampleDirFmt \
   --input-path ./GreatBay/ \
   --output-path /home/users/nlf1022/fish_final/trimmed_fastqs/GreatBay_trimmed

#Command uses QIIME software to import paired-end sequence data with quality information.

   qiime tools import \
      --type "SampleData[PairedEndSequencesWithQuality]"  \
      --input-format CasavaOneEightSingleLanePerSampleDirFmt \
      --input-path ./Wells/ \
      --output-path /home/users/nlf1022/fish_final/trimmed_fastqs/Wells_trimmed

#Command uses QIIME to import paired-end sequencing data with quality scores.

   cd /home/users/nlf1022/fish_final
   
#Create a new directory named "no_primer" in current working directory
   mkdir no_primer

Creates a new directory named "no_primer" in the current working directory. 


qiime cutadapt trim-paired \
    --i-demultiplexed-sequences /home/users/nlf1022/fish_final/trimmed_fastqs/GreatBay_trimmed.qza \
    --p-cores 4 \
    --p-front-f GTCGGTAAAACTCGTGCCAGC \
    --p-front-r CATAGTGGGGTATCTAATCCCAGTTTG \
    --p-discard-untrimmed \
    --p-match-adapter-wildcards \
    --verbose \
    --o-trimmed-sequences ./no_primer/GreatBay_no_primer.qza

Trims primer sequences from paired-end sequences stored in the file. Specifies the use of 4 processing cores and provides forward and reverse primer sequencing for trimming. Discards 

    
qiime cutadapt trim-paired \
    --i-demultiplexed-sequences /home/users/nlf1022/fish_final/trimmed_fastqs/Wells_trimmed.qza \
    --p-cores 4 \
    --p-front-f GTCGGTAAAACTCGTGCCAGC \
    --p-front-r CATAGTGGGGTATCTAATCCCAGTTTG \
    --p-discard-untrimmed \
    --p-match-adapter-wildcards \
    --verbose \
    --o-trimmed-sequences ./no_primer/Wells_no_primer.qza

cd no_primer

qiime demux summarize \
--i-data ./GreatBay_no_primer.qza \
--o-visualization  ./GreatBay_Summary.qzv 

qiime demux summarize \
--i-data ./Wells_no_primer.qza \
--o-visualization  ./Wells_Summary.qzv 

cd .. 

mkdir denoising 

qiime dada2 denoise-paired \
    --i-demultiplexed-seqs /home/users/nlf1022/fish_final/no_primer/GreatBay_no_primer.qza  \
    --p-trunc-len-f  120 \
    --p-trunc-len-r 115 \
    --p-trim-left-f 0 \
    --p-trim-left-r 0 \
    --p-n-threads 4 \
    --o-denoising-stats /home/users/nlf1022/fish_final/denoising/GreatBay_denoising-stats.qza \
    --o-table /home/users/nlf1022/fish_final/denoising/GreatBay_feature_table.qza \
    --o-representative-sequences /home/users/nlf1022/fish_final/denoising/GreatBay_rep-seqs.qza

qiime dada2 denoise-paired \
    --i-demultiplexed-seqs /home/users/nlf1022/fish_final/no_primer/Wells_no_primer.qza  \
    --p-trunc-len-f  120 \
    --p-trunc-len-r 115 \
    --p-trim-left-f 0 \
    --p-trim-left-r 0 \
    --p-n-threads 4 \
    --o-denoising-stats /home/users/nlf1022/fish_final/denoising/Wells_denoising-stats.qza \
    --o-table /home/users/nlf1022/fish_final/denoising/Wells_feature_table.qza \
    --o-representative-sequences /home/users/nlf1022/fish_final/denoising/Wells_rep-seqs.qza

qiime metadata tabulate \
    --m-input-file /home/users/nlf1022/fish_final/denoising/GreatBay_denoising-stats.qza \
    --o-visualization /home/users/nlf1022/fish_final/denoising/GreatBay_denoising-stats.qzv

qiime metadata tabulate \
    --m-input-file /home/users/nlf1022/fish_final/denoising/Wells_denoising-stats.qza \
    --o-visualization /home/users/nlf1022/fish_final/denoising/Wells_denoising-stats.qzv

qiime feature-table tabulate-seqs \
        --i-data /home/users/nlf1022/fish_final/denoising/GreatBay_rep-seqs.qza \
        --o-visualization /home/users/nlf1022/fish_final/denoising/GreatBay_rep-seqs.qzv

qiime feature-table tabulate-seqs \
        --i-data /home/users/nlf1022/fish_final/denoising/Wells_rep-seqs.qza \
        --o-visualization /home/users/nlf1022/fish_final/denoising/Wells_rep-seqs.qzv

mkdir taxonomy

cd denoising 

qiime feature-table merge-seqs \
   --i-data ./GreatBay_rep-seqs.qza \
   --i-data ./Wells_rep-seqs.qza \
   --o-merged-data ./combined_rep-seqs.qza

qiime feature-table merge \
  --i-tables ./GreatBay_feature_table.qza \
  --i-tables ./Wells_feature_table.qza \
  --o-merged-table ./combined_feature_table.qza

qiime feature-classifier classify-sklearn \
  --i-classifier /tmp/gen711_project_data/eDNA-fqs/mifish/ref-database/mitofish-classifier.qza \
  --i-reads ./combined_rep-seqs.qza \
  --o-classification /home/users/nlf1022/fish_final/taxonomy/taxonomy.qza

cp /tmp/gen711_project_data/eDNA-fqs/mifish/mifish-metadata.tsv /home/users/nlf1022/fish_final/raw_data

qiime feature-table filter-samples \
  --i-table ./combined_feature_table.qza \
  --m-metadata-file /home/users/nlf1022/fish_final/raw_data/mifish-metadata.tsv \
  --o-filtered-table ./feature_table_filtered.qza

qiime taxa barplot \
     --i-table ./feature_table_filtered.qza \
     --m-metadata-file /home/users/nlf1022/fish_final/raw_data/mifish-metadata.tsv \
     --i-taxonomy /home/users/nlf1022/fish_final/taxonomy/taxonomy.qza \
     --o-visualization ./filtered-barplot.qzv
