#!/bin/bash
# Video styler - Use all images in a directory and style them
# video_styler.sh video.mp4

# Style text
# TEXT="crazy man drinking water, vibrant colors"
# declare -a PROMPTS=("Charcoal drawing of a civilisation in black and white" "Acrylic painting of time in greyscales" "Oil painting of Taoism using Technicolors" "A doodle visualising futurism in blue and yellow" "A pencil sketch of western esotericism in primary colors")

text_one=("Charcoal drawing" "Acrylic Painting" "Oil Painting" "Futurism" "Pencil Sketch")
text_two=("a Civilisation" "Time" "Taoism" "a Doodle" "Western esotericism")
text_three=("Black and white" "Greyscales" "Technicolors" "Blue and Yellow" "Primary Colors")

pickword() {
   local array=("$@")
   ARRAY_RANGE=$((${#array[@]}-1))
   RANDOM_ENTRY=`shuf -i 0-$ARRAY_RANGE -n 1`   
   UPDATE=${array[$RANDOM_ENTRY]}
}

# Make some random text
pickword "${text_one[@]}"
TEXT=$UPDATE
pickword "${text_two[@]}"
TEXT+=" of $UPDATE "
pickword "${text_three[@]}"
TEXT+="with the colors $UPDATE"

## Input and output frame directories
FRAMES_IN="./video/toon/full"
FRAMES_OUT="./video/toon/export"

## Output image size
HEIGHT=720 # (def) 640
WIDTH=405 # (def) 360

## Iterations
ITERATIONS=20
SAVE_EVERY=$ITERATIONS

## Optimiser & Learning rate
OPTIMISER=Adagrad	# Adam, AdamW, Adagrad, Adamax
LR=0.2

# Fixed seed
SEED=`shuf -i 1-9999999999 -n 1` # Keep the same seed each frame for more deterministic runs

# MAIN
############################
mkdir -p "$FRAMES_IN"
mkdir -p "$FRAMES_OUT"

# For cuDNN determinism
export CUBLAS_WORKSPACE_CONFIG=:4096:8

# Extract video into frames
ffmpeg -y -i "$1" -q:v 2 "$FRAMES_IN"/frame-%04d.jpg

# Switch prompt after amount of frames
SWITCH=48

COUNT=0
SWITCHES=0

file="video/toon/export/output.txt"
echo "$TEXT" >> $file

# Style all the frames
ls "$FRAMES_IN" | while read file; do
	# Set the output filename
	FILENAME="$FRAMES_OUT"/"$file"-"out".jpg

	# And imagine!
	echo "Input frame: $file"
	echo "Style text: $TEXT"
	echo "Output file: $FILENAME"
	
	if (("$COUNT" > "$SWITCH"))
	then
		COUNT=0
		# TEXT="${PROMPTS["$SWITCHES"]}"
		# SWITCHES=$((SWITCHES+1))
		
		# Make some random text
		pickword "${text_one[@]}"
		TEXT=$UPDATE
		pickword "${text_two[@]}"
		TEXT+=" of $UPDATE "
		pickword "${text_three[@]}"
		TEXT+="with the colors $UPDATE"
		
		echo "$TEXT" >> $file
	fi
	
	python generate.py -p "$TEXT" -ii "$FRAMES_IN"/"$file" -o "$FILENAME" -opt "$OPTIMISER" -lr "$LR" -i "$ITERATIONS" -se "$SAVE_EVERY" -s "$HEIGHT" "$WIDTH" -sd "$SEED"
	# removed -d True
	COUNT=$((COUNT+1))
done

cat $file

ffmpeg -y -i "$FRAMES_OUT"/frame-%04d.jpg-out.jpg -b:v 8M -c:v h264_nvenc -pix_fmt yuv420p -strict -2 -filter:v "minterpolate='mi_mode=mci:mc_mode=aobmc:vsbmc=1:fps=60'" style_video.mp4
