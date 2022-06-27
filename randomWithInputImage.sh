#!/bin/bash

text_one=("Charcoal drawing" "Acrylic Painting" "Oil Painting" "Futurism" "Pencil Sketch")
text_two=("a Civilisation" "Time" "Taoism" "a Doodle" "Western esotericism")
text_three=("Black and white" "Greyscales" "Technicolors" "Blue and Yellow" "Primary Colors")

pickword() {
   local array=("$@")
   ARRAY_RANGE=$((${#array[@]}-1))
   RANDOM_ENTRY=`shuf -i 0-$ARRAY_RANGE -n 1`   
   UPDATE=${array[$RANDOM_ENTRY]}
}

# Make random seed to prevent prompt overwriting
numbers=("0" "1" "2" "3" "4" "5" "6" "7" "8" "9")
pickword "${numbers[@]}"
SEED=""
for r in {1..10}
do
   pickword "${numbers[@]}"
   SEED+=""$UPDATE
done

# Generate some images
for number in {1..1000}
do
   # Make some random text
   pickword "${text_one[@]}"
   TEXT=$UPDATE
   pickword "${text_two[@]}"
   TEXT+=" of $UPDATE "
   pickword "${text_three[@]}"
   TEXT+="with the colors $UPDATE"

   python generate.py -p "$TEXT" -s 720 405 -o export/"$number. $TEXT [seed=$SEED]".png -sd "$SEED" -i 50 -ii input.jpg
done
