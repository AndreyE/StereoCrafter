# Базовый образ с CUDA 11.8 и Ubuntu 22.04
FROM docker.io/nvidia/cuda:11.7.1-devel-ubuntu22.04

# Установка необходимых пакетов
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    build-essential \
    libgl1-mesa-dev \
    libglib2.0-0 \
    git \
    ninja-build \
    && rm -rf /var/lib/apt/lists/* \
    && ln -sf /usr/bin/python3 /usr/bin/python \
    && pip install huggingface_hub

# Создание рабочей директории
WORKDIR /workspace/StereoCrafter

RUN git clone --recursive https://github.com/AndreyE/StereoCrafter.git .

# Передача HF_AUTH_TOKEN через аргумент сборки
ARG HUGGINGFACE_TOKEN

# Загрузка модели SVD img2vid
RUN mkdir -p /workspace/StereoCrafter/weights/stable-video-diffusion-img2vid-xt-1-1 && \
    huggingface-cli download stabilityai/stable-video-diffusion-img2vid-xt-1-1 --repo-type model --local-dir /workspace/StereoCrafter/weights/stable-video-diffusion-img2vid-xt-1-1 --token $HUGGINGFACE_TOKEN

# Загрузка модели DepthCrafter
RUN mkdir -p /workspace/StereoCrafter/weights/DepthCrafter && \
    huggingface-cli download tencent/DepthCrafter --repo-type model --local-dir /workspace/StereoCrafter/weights/DepthCrafter --token $HUGGINGFACE_TOKEN

# Загрузка модели StereoCrafter
RUN mkdir -p /workspace/StereoCrafter/weights/StereoCrafter && \
    huggingface-cli download TencentARC/StereoCrafter --repo-type model --local-dir /workspace/StereoCrafter/weights/StereoCrafter --token $HUGGINGFACE_TOKEN

# Установка переменных окружения (по необходимости)
ENV PYTHONPATH=/workspace/StereoCrafter:$PYTHONPATH

RUN pip install -r requirements.txt

# А теперь ручками!
# см. https://podman-desktop.io/docs/podman/gpu про nvidia-ctk
# $ podman run -it --rm --device nvidia.com/gpu=all --hooks-dir=/usr/share/containers/oci/hooks.d localhost/stereocrafter-base-cuda:latest bash -c "sh ./dependency/Forward-Warp/install.sh && bash"
# ...
# $ podman ps
# $ podman commit 3a2e2dc64016 stereocrafter-base-cuda:latest

# ENTRYPOINT ["sh", "-c", "pkill -f sleep infinity || true && exec \"$@\"", "--"]
# CMD ["bash", "run_inference.sh"]
