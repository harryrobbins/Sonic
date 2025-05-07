import argparse
import os
import time
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument('image_path')
parser.add_argument('audio_path')
parser.add_argument('output_path')
parser.add_argument('--dynamic_scale', type=float, default=1.0)
parser.add_argument('--crop', action='store_true')
parser.add_argument('--seed', type=int, default=None)

args = parser.parse_args()

# Check if input files exist
image_path = Path(args.image_path)
audio_path = Path(args.audio_path)
output_path = Path(args.output_path)

if not image_path.exists():
    raise FileNotFoundError(f"Input image file not found: {image_path}")

if not audio_path.exists():
    raise FileNotFoundError(f"Input audio file not found: {audio_path}")

print("Input and output files both exist")

#import this after checking the files exist
from sonic import Sonic

pipe = Sonic(0)

# Check if output file exists, modify with timestamp if it does
if output_path.exists():
    timestamp = int(time.time())
    stem = output_path.stem
    suffix = output_path.suffix
    new_output_path = output_path.with_name(f"{stem}_{timestamp}{suffix}")
    args.output_path = str(new_output_path)
    print(f"Output file already exists. Using new path: {args.output_path}")

# Continue with processing
face_info = pipe.preprocess(args.image_path, expand_ratio=0.5)
print(face_info)
if face_info['face_num'] >= 0:
    if args.crop:
        crop_image_path = args.image_path + '.crop.png'
        pipe.crop_image(args.image_path, crop_image_path, face_info['crop_bbox'])
        args.image_path = crop_image_path
    os.makedirs(os.path.dirname(args.output_path), exist_ok=True)
    pipe.process(args.image_path, args.audio_path, args.output_path, min_resolution=512, inference_steps=25,
                 dynamic_scale=args.dynamic_scale)