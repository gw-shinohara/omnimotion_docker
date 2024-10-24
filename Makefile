.PHONY: build run

DATA_DIR=/media/gw-tech/hdd6TB/dev/CS2/shinohara/sequence_directory
DATA_NAME=anomally
LAUNCH_TIME=${date +'%Y%m%d%H%M%S'}

build:
	docker build ./ -t omnimotion

preprocess:
	docker run -it --gpus all \
	-v $(DATA_DIR):/sequence_directory \
	-v ./:/workspace omnimotion \
	python /preprocessing/main_processing.py \
		--data_dir /sequence_directory/$(DATA_NAME) \
		--cycle_th 1.0 --chain 

run:
	docker run -it --gpus all \
	-v $(DATA_DIR):/sequence_directory \
	-v ./:/workspace omnimotion \
	python /workspace/train.py --config /workspace/configs/default.txt \
		--data_dir /sequence_directory/$(DATA_NAME) \
		--save_dir /workspace/output/$(LAUNCH_TIME) \
		--num_iters 30000

vis:
	docker run -it --gpus all \
	-v $(DATA_DIR):/sequence_directory \
	-v ./:/workspace omnimotion \
	python /workspace/viz.py --config /workspace/configs/default.txt \
		--data_dir /sequence_directory/$(DATA_NAME) \
		--save_dir /workspace/output/$(LAUNCH_TIME) \
		--query_frame_id 25

exec:
	docker run -it --gpus all \
	-v $(DATA_DIR):/sequence_directory \
	-v ./:/workspace omnimotion \
	bash
