#!/bin/bash

# e.g. ./samePromptDifferentModels.sh "insert prompt here"

# Prompt overload
# TEXT="prompt"
TEXT="$1"

declare -a MODELS=("RN50" "RN101" "ViT-B/16" "ViT-B/32")

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
echo "$TEXT" "seed=""$SEED" "0=RN50" "1=RN101" "2=ViT-B/16" "3=ViT-B/32" > $file
cat $file

COUNT=0
for i in "${MODELS[@]}"; do
	
	# TODO:
	# Remove $TEXT, replace with checkpoint type
	# Put prompt in a seperate txt file
	python generate.py -p "$TEXT" -s 500 500 -o export/"$COUNT".png -sd "$SEED" -m "$i" -i 500
	COUNT=$((COUNT+1))
done