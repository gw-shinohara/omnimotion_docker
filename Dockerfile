FROM rwthika/ros2-cuda:foxy-ros-base as build
# ------------ Arguments
ARG TIME_ZONE="Asia/Tokyo"

# ------------ Setting enviroment
ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs
ENV DISPLAY host.docker.internal:0.0
ENV DEBIAN_FRONTEND=noninteractive

# ------------ Setting timezone
RUN apt-get update && apt-get install -y tzdata
ENV TZ=$TIME_ZONE 

# ------------ Upgrade apt-get
RUN apt-get update && apt-get upgrade -y
RUN apt-get update && apt-get install -y ffmpeg libsm6 libxext6 

RUN apt-get update -y
RUN apt-get install -y libgl1-mesa-dev
RUN apt-get remove python-pip

RUN python3 -m pip install kornia scipy
RUN python3 -m pip install torch==1.10.0+cu111 \
    torchvision==0.11.0+cu111 \
    torchaudio==0.10.0 \
    -f https://download.pytorch.org/whl/torch_stable.html

RUN python3 -m pip install matplotlib \
    tensorboard scipy opencv-python tqdm \
    tensorboardX configargparse ipdb kornia \
    imageio[ffmpeg]

RUN python3 -m pip install typing-extensions

COPY ./preprocessing /preprocessing
WORKDIR /preprocessing
RUN mv exhaustive_raft.py filter_raft.py chain_raft.py RAFT/; \
    cd RAFT; ./download_models.sh; cd ../ 
RUN mv extract_dino_features.py dino/

WORKDIR /preprocessing
