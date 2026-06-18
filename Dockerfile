FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

# =========================

# 🔽 SYSTEM DEPENDENCIES

# =========================

RUN apt-get update && apt-get install -y 
git 
wget 
curl 
python3 
python3-pip 
python3-venv 
ffmpeg 
libgl1

# Set python

RUN ln -s /usr/bin/python3 /usr/bin/python

# =========================

# 🔽 PYTHON + TORCH (RTX 50xx FIX)

# =========================

RUN pip install --upgrade pip

# 🔥 PyTorch NIGHTLY (RTX 5090 / Blackwell)

RUN pip install --pre torch torchvision torchaudio 
--index-url https://download.pytorch.org/whl/nightly/cu128

# =========================

# 🔽 CORE DEPENDENCIES

# =========================

RUN pip install 
opencv-python 
scikit-image 
pillow 
imageio 
imageio-ffmpeg 
piexif 
scipy 
tifffile 
einops 
transformers 
accelerate 
safetensors

# =========================

# 🔽 FILEBROWSER

# =========================

RUN curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash

# =========================

# 🔽 COMFYUI

# =========================

WORKDIR /workspace
RUN git clone https://github.com/comfyanonymous/ComfyUI

WORKDIR /workspace/ComfyUI
RUN pip install -r requirements.txt

# =========================

# 🔽 CUSTOM NODES

# =========================

WORKDIR /workspace/ComfyUI/custom_nodes

RUN git clone https://github.com/ltdrdata/ComfyUI-Manager

RUN git clone https://github.com/cubiq/ComfyUI_essentials

RUN git clone https://github.com/Fannovel16/comfyui_controlnet_aux

RUN git clone https://github.com/mythalosai/comfyui-flux2fun-controlnet.git

# =========================

# 🔽 INSTALL NODE REQUIREMENTS

# =========================

RUN find /workspace/ComfyUI/custom_nodes 
-name requirements.txt 
-exec pip install -r {} ; || true

# =========================

# 🔽 FINAL SETUP

# =========================

WORKDIR /workspace/ComfyUI

COPY start.sh /start.sh

RUN chmod +x /start.sh

CMD ["/start.sh"]
