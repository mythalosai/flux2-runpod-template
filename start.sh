#!/bin/bash

set -e

cd /workspace/ComfyUI

echo "📦 Setting up Flux2 environment..."

# =====================================
# CREATE DIRECTORIES
# =====================================

mkdir -p models/diffusion_models
mkdir -p models/text_encoders
mkdir -p models/vae
mkdir -p models/controlnet

# =====================================
# TEXT ENCODER
# =====================================

if [ ! -f models/text_encoders/mistral_3_small_flux2_bf16.safetensors ]; then
    echo "Downloading Mistral Flux2 Encoder..."
    wget -c -O models/text_encoders/mistral_3_small_flux2_bf16.safetensors \
    https://huggingface.co/Comfy-Org/flux2-dev/resolve/14533cbcf23a4a995b31c67938748fa56f02793c/split_files/text_encoders/mistral_3_small_flux2_bf16.safetensors
fi

# =====================================
# DIFFUSION MODEL
# =====================================

if [ ! -f models/diffusion_models/flux2-dev.safetensors ]; then
    echo "Downloading FLUX.2 Dev..."
    wget -c -O models/diffusion_models/flux2-dev.safetensors \
    https://huggingface.co/black-forest-labs/FLUX.2-dev/resolve/main/flux2-dev.safetensors
fi

# =====================================
# VAE
# =====================================

if [ ! -f models/vae/flux2-vae.safetensors ]; then
    echo "Downloading Flux2 VAE..."
    wget -c -O models/vae/flux2-vae.safetensors \
    https://huggingface.co/Comfy-Org/flux2-dev/resolve/main/split_files/vae/flux2-vae.safetensors
fi

# =====================================
# CONTROLNET
# =====================================

if [ ! -f models/controlnet/FLUX.2-dev-Fun-Controlnet-Union.safetensors ]; then
    echo "Downloading Flux2 Fun ControlNet..."
    wget -c -O models/controlnet/FLUX.2-dev-Fun-Controlnet-Union.safetensors \
    https://huggingface.co/alibaba-pai/FLUX.2-dev-Fun-Controlnet-Union/resolve/main/FLUX.2-dev-Fun-Controlnet-Union.safetensors
fi

# =====================================
# START FILEBROWSER
# =====================================

echo "📁 Starting FileBrowser..."

filebrowser \
-r /workspace \
-a 0.0.0.0 \
-p 8080 &

# =====================================
# START COMFYUI
# =====================================

echo "🚀 Starting ComfyUI..."

python main.py \
--listen 0.0.0.0 \
--port 8188 \
--enable-cors-header
