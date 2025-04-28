#cd /
cd /workspace
git clone https://github.com/harryrobbins/Sonic
cd Sonic
#ln -s /Sonic /workspace/sonic

apt update
apt install ffmpeg nano -y

pip install uv
uv pip install --system  opencv-python accelerate hf_transfer
uv pip install --system  -r requirements.txt
uv pip install --system



uv pip install --system  "huggingface_hub[cli]"

# Login to your HF account
huggingface-cli login

huggingface-cli download LeonJoe13/Sonic --local-dir  checkpoints
huggingface-cli download stabilityai/stable-video-diffusion-img2vid-xt --local-dir  checkpoints/stable-video-diffusion-img2vid-xt
huggingface-cli download openai/whisper-tiny --local-dir checkpoints/whisper-tiny

hr-download LeonJoe13/Sonic --dir checkpoints --use-auth
hr-download stabilityai/stable-video-diffusion-img2vid-xt --dir checkpoints/stable-video-diffusion-img2vid-xt --use-auth
hr-download openai/whisper-tiny --dir checkpoints/whisper-tiny --use-auth

python demo.py 'examples/image/lara1.png' 'examples/wav/any_means_necessary.wav' 'examples/results/lara.mp4'