# gen711_final_project

mkdir -p fish_final
   
    A directiory was created titled "fish_final". This is the directory where everything is done within.


cd fish_final 
 
    Changed directory to be within "finsh_final"


mkdir -p raw_data

   Withing the "fish_final" directory, a new directory titled "raw_data" was created.


cd raw_data
  
   Changed directory to be within the "raw_data" directory. This directory will contain any of the raw, untouched data used in this project.


cp -r /tmp/gen711_project_data//eDNA-fqs/mifish/fastqs/ .

   The file "fastqs" was copied from the class project data into the current, "raw_data", directory.


cp /tmp/gen711_project_data/eDNA-fqs/mifish/GreatBay-Metadata.tsv .

   The file "GreatBay-Metadata.tsv" was copied from the class project data into the current, "raw_data", directory.


cp /tmp/gen711_project_data/eDNA-fqs/mifish/Wells-Metadata.tsv .

   The file "Wells-Metadata.sv" was copied from the class project data into the current, "raw_data", directory.


conda activate qiime2-2022.8

   The conda environment was changed to qiime2-2022.8 so that all of the future comands (?) will work.


mkdir fastp.sh

   Within the current directory a file called "fastp.sh".
   

cp /tmp/gen711_project_data/scripts/fastp.sh ./fastp.sh

   The file "fastp.sh" was copied from the class project data directory into the created "fastp.sh" file.
   

chmod +x ./fastp.sh/

   The permission was changed for the "fastp.sh" file to add executable permission. (IDK what this fully means) 


cd ..

   The directory was changed to the previous directory "fish_final".


mkdir trimmed_fastqs
  
   A directory named "trimmed_fastqs" was created in the "fish_final" directory. This file will contained the trimmed fastq data.


cd raw_data
 
   The directory was changed to "raw_data".
   

cd fastqs

   The directory was changed to "fastqs"


qiime tools import \
   --type "SampleData[PairedEndSequencesWithQuality]"  \
   --input-format CasavaOneEightSingleLanePerSampleDirFmt \
   --input-path ./GreatBay/ \
   --output-path /home/users/nlf1022/fish_final/trimmed_fastqs/GreatBay_trimmed

Command uses QIIME software to import paired-end sequence data with quality information.

qiime tools import \
   --type "SampleData[PairedEndSequencesWithQuality]"  \
   --input-format CasavaOneEightSingleLanePerSampleDirFmt \
   --input-path ./Wells/ \
   --output-path /home/users/nlf1022/fish_final/trimmed_fastqs/Wells_trimmed

Command uses QIIME to import paired-end sequencing data with quality scores.


cd /home/users/nlf1022/fish_final

Changes directory 


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




