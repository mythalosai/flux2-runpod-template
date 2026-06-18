FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

# =========================
# 🔽 SYSTEM DEPENDENCIES
# =========================

RUN apt-get update && apt-get install -y \
    git \
    wget \
    python3 \
    python3-pip \
    python3-venv \
    ffmpeg \
    libgl1

# Set python
RUN ln -s /usr/bin/python3 /usr/bin/python

# =========================
# 🔽 PYTHON + TORCH (RTX 50xx FIX)
# =========================

RUN pip install --upgrade pip

# 🔥 PyTorch NIGHTLY (soporte RTX 5090 / sm_120)
RUN pip install --pre torch torchvision torchaudio \
    --index-url https://download.pytorch.org/whl/nightly/cu128

# =========================
# 🔽 CORE DEPENDENCIES (IMPACT PACK FIX)
# =========================

RUN pip install \
    opencv-python \
    scikit-image \
    pillow \
    imageio \
    imageio-ffmpeg \
    piexif \
    scipy \
    tifffile \
    einops \
    transformers \
    accelerate \
    safetensors

# 🔥 Segment Anything (necesario para Impact Pack)
RUN pip install git+https://github.com/facebookresearch/segment-anything.git

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
RUN git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack
RUN git clone https://github.com/rgthree/rgthree-comfy
RUN git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite
RUN git clone https://github.com/kijai/ComfyUI-KJNodes
RUN git clone https://github.com/jtydhr88/ComfyUI-qwenmultiangle.git

# =========================
# 🔽 FINAL SETUP
# =========================

WORKDIR /workspace/ComfyUI

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
