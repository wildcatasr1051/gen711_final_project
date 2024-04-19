# gen711_final_project
mdkir -p fish_final
  cd fish_final 
mdkir -p raw_data
cp -r /tmp/gen711_project_data//eDNA-fqs/mifish/fastqs/ .
cp /tmp/gen711_project_data/eDNA-fqs/mifish/GreatBay-Metadata.tsv .
cp /tmp/gen711_project_data/eDNA-fqs/mifish/Wells-Metadata.tsv .
conda activate qiime2-2022.8
mdkir fastp.sh
cp /tmp/gen711_project_data/scripts/fastp.sh ./fastp.sh
