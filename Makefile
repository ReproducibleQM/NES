
all: nes_data.csv

nes_data.csv: 05_analysis_scripts/PDF_Merge.R \
03_qa_data/474/res_review.csv \
03_qa_data/475/res_review.csv \
03_qa_data/476/res_review.csv \
03_qa_data/477/res_review.csv \
05_analysis_scripts/add_chl.R \
03_qa_data/chl.csv \
04_supporting_data/storet.csv \
04_supporting_data/retention_time_units.csv
	Rscript $<
	Rscript 05_analysis_scripts/add_chl.R
	