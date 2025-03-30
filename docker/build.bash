#!/usr/bin/env bash

IMAGE_NAME=stereocrafter-cuda

echo "building base image"
podman build --build-arg HUGGINGFACE_TOKEN=$HUGGINGFACE_TOKEN -t $IMAGE_NAME .

CONTAINER_ID=$(podman run -d \
  --device nvidia.com/gpu=all \
  --hooks-dir=/usr/share/containers/oci/hooks.d \
  localhost/$IMAGE_NAME:latest \
  sleep infinity)

if [ -z "$CONTAINER_ID" ]; then
    echo "Error: Failed to start container."
    exit 1
fi

podman exec $CONTAINER_ID sh ./dependency/Forward-Warp/install.sh
podman commit $CONTAINER_ID $IMAGE_NAME

podman kill $CONTAINER_ID
podman rm $CONTAINER_ID

echo "image created: $IMAGE_NAME"
echo "$ podman run -it --rm --device nvidia.com/gpu=all -v \$HOME/tmp:/workspace/StereoCrafter/outputs --hooks-dir=/usr/share/containers/oci/hooks.d localhost/$IMAGE_NAME:latest bash run_inference.sh"
