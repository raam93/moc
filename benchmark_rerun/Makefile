model_dir = ../saved_objects_rerun/benchmark/models_benchmark.rds
data_dir = ../saved_objects_rerun/benchmark
config_dir = ../saved_objects/best_configs.rds
tasks_dir = ../helpers/benchmark_task_ids.rds

all : train-models run-tweaking run-pair run-moc

train-models :
	Rscript ../helpers/train_models.R --savekeras TRUE --task_ids $(tasks_dir) --savedir $(model_dir) --datadir $(data_dir)

run-tweaking : 
	Rscript featuretweaking/run_feature_tweaking.R --readdir $(model_dir) --datadir $(data_dir) --configdir $(config_dir)

run-pair : 	
	Rscript run_pair.R 	--readdir $(model_dir) --datadir $(data_dir)
  
run-moc : 
	Rscript run_moc.R --readdir $(model_dir) --configdir $(config_dir)	--datadir $(data_dir) 
	
