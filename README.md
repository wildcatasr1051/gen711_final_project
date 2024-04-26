# gen711_final_project

mkdir -p fish_final

cd fish_final 

mkdir -p raw_data

cd raw_data

cp -r /tmp/gen711_project_data//eDNA-fqs/mifish/fastqs/ .

cp /tmp/gen711_project_data/eDNA-fqs/mifish/GreatBay-Metadata.tsv .

cp /tmp/gen711_project_data/eDNA-fqs/mifish/Wells-Metadata.tsv .

conda activate qiime2-2022.8

mkdir fastp.sh

cp /tmp/gen711_project_data/scripts/fastp.sh ./fastp.sh

chmod +x ./fastp.sh/

mkdir trimmed_fastqs

cd raw_data

cd fastqs

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

mkdir no_primer

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


Not used:

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
