# gen711_final_project

mkdir -p fish_final

cd fish_final 

mkdir -p raw_data

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


