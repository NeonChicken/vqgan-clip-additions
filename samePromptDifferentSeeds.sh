#!/bin/bash

# e.g. ./samePromptDifferentSeeds.sh "insert prompt here" result_amount

# Prompt overload
# TEXT="prompt"
TEXT="$1"

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

# TODO:
# Check if there are any arguments, otherwise run a random prompt
# And only generate the default of 6 images

# Generate some images
for ((i=1;i<"$2";i++));
do
	SEED=""
	for r in {1..10}
	do
	   pickword "${numbers[@]}"
	   SEED+=""$UPDATE
	done
	
	# TODO:
	# Remove $TEXT
	# Put prompt in a seperate txt file
	python generate.py -p "$TEXT" -s 500 500 -o export/"$i. $TEXT (seed=$SEED)".png -sd "$SEED" -i 500
done