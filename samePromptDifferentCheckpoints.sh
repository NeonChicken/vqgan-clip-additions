#!/bin/bash

# e.g. ./samePromptDifferentCheckpoints.sh "insert prompt here"

# Prompt overload
# TEXT="prompt"
TEXT="$1"

# declare -a CHECKPOINTS=("coco" "faceshq" "sflckr" "vqgan_gumbel_f8_8192" "vqgan_imagenet_f16_16384" "wikiart_16384")
declare -a CHECKPOINTS=("coco" "faceshq" "sflckr" "vqgan_imagenet_f16_16384")

# Can overload prompt from script if first passed argument == "overload"
if [ "$1" = "overload" ]; then
	# Overload prompt from script here
	TEXT="cavemen dancing around a campfire in vibrant oil paint with reflective colour wheel"
fi

# Generate seed for generation
pickword() {
   local array=("$@")
   ARRAY_RANGE=$((${#array[@]}-1))
   RANDOM_ENTRY=`shuf -i 0-$ARRAY_RANGE -n 1`
   UPDATE=${array[$RANDOM_ENTRY]}
}

numbers=("0" "1" "2" "3" "4" "5" "6" "7" "8" "9")
SEED=""
for r in {1..10}
do
   pickword "${numbers[@]}"
   SEED+=""$UPDATE
done

file="export/output.txt"
echo "$TEXT" "seed=""$SEED" > $file
cat $file

for i in "${CHECKPOINTS[@]}"; do
	
	# TODO:
	# Remove $TEXT, replace with checkpoint type
	# Put prompt in a seperate txt file
	python generate.py -p "$TEXT" -s 500 500 -o export/"$i".png -sd "$SEED" -i 500 -ckpt checkpoints/"$i".ckpt
done