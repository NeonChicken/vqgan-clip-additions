#!/bin/bash

# e.g. ./saveAsPrompt.sh "insert prompt here"

# Prompt overload
# TEXT="prompt"
TEXT="$1"

# Can overload prompt from script if first passed argument == "overload"
if [ "$1" = "overload" ]; then
	# Overload prompt from script here
	TEXT="cavemen dancing around a campfire in vibrant oil paint with reflective colours | colour wheel:0.5"
fi

# Generate seed for generation
pickword() {
   local array=("$@")
   ARRAY_RANGE=$((${#array[@]}-1))
   RANDOM_ENTRY=`shuf -i 0-$ARRAY_RANGE -n 1`
   UPDATE=${array[$RANDOM_ENTRY]}
}
numbers=("0" "1" "2" "3" "4" "5" "6" "7" "8" "9")
pickword "${numbers[@]}"
SEED=""
for r in {1..10}
do
   pickword "${numbers[@]}"
   SEED+=""$UPDATE
done

# Generate
python generate.py -p "$TEXT" -s 500 500 -o export/"$TEXT (seed=$SEED)".png -sd "$SEED" -i 5000