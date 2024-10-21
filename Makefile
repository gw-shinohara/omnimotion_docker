.PHONY: build run

DATA_DIR=/media/gw-shinohara/GWSSD7/sequence_directory
DATA_NAME=anomally

build:
	docker build ./ -t omnimotion

preprocess:
	docker run -it --gpus all \
	-v $(DATA_DIR):/sequence_directory \
	-v ./:/workspace omnimotion \
	python /preprocessing/main_processing.py --data_dir /sequence_directory/$(DATA_NAME) --chain 

run:
	docker run -it --gpus all \
	-v $(DATA_DIR):/sequence_directory \
	-v ./:/workspace omnimotion \
	python /workspace/train.py --config /workspace/configs/default.txt --data_dir /sequence_directory/$(DATA_NAME)

exec:
	docker run -it --gpus all \
	-v $(DATA_DIR):/sequence_directory \
	-v ./:/workspace omnimotion \
	bash
