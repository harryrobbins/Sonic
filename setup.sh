#cd /
cd /workspace
git clone https://github.com/harryrobbins/Sonic
cd Sonic
#ln -s /Sonic /workspace/sonic

apt update
apt install ffmpeg nano -y

pip install uv
uv pip install --system  opencv-python accelerate # hf_transfer
uv pip install --system  -r requirements.txt
uv pip install --system
uv pip install --system "huggingface_hub[hf_transfer]"



uv pip install --system  "huggingface_hub[cli]"

# Login to your HF account
huggingface-cli login
export HF_HUB_ENABLE_HF_TRANSFER=1
huggingface-cli download LeonJoe13/Sonic --local-dir  checkpoints
huggingface-cli download stabilityai/stable-video-diffusion-img2vid-xt --local-dir  checkpoints/stable-video-diffusion-img2vid-xt
huggingface-cli download openai/whisper-tiny --local-dir checkpoints/whisper-tiny



python demo.py 'examples/image/female_dianosu.png' 'examples/wav/sing_female_10s.wav' 'examples/results/female_dianosu_sing_female_10s.mp4'


