#!/usr/bin/env bash
set -ex

git clone https://github.com/microsoft/onnxruntime-genai /opt/onnxruntime-genai
cd /opt/onnxruntime-genai
git switch --detach 940bc102a317e886f488ad5e120533b96a34ddcd


wget http://jetson.webredirect.org:8000/jp6/cu124/onnxruntime-gpu-1.19.0.tar.gz
mkdir ort
tar -xzvf onnxruntime-gpu-1.19.0.tar.gz -C ort
mv ort/include/onnxruntime/onnxruntime_c_api.h ort/include
rm -rf ort/include/onnxruntime ort/lib/cmake ort/lib/pkgconfig

# pip install cmake -U
python3 build.py --use_cuda --cuda_home /usr/local/cuda-12.2 --skip_tests --skip_csharp --parallel

cp build/Linux/RelWithDebInfo/wheel/*.whl /opt

cd /tmp
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/arm64/cuda-keyring_1.1-1_all.deb
dpkg -i cuda-keyring_1.1-1_all.deb
apt-get update
apt-get -y install cudnn

cd /
