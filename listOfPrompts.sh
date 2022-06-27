#!/bin/bash

declare -a StringArray=(
"Black black black black" 
"Butter chicken ice cream"
"Pop art"
"Pop art chicken"
"Dinosaur chicken drawing"
"Cartoon chicken"
"The essence of emptiness"
"Pop art pattern"
"Doodle art landscape"
"Space chicken drinking paint from a holy miracle in the sky"
"Orange hues with blue accents complementing"
"Wat maakt die van nederlands?"
"Liesje leerde lotje lopen langs de lange linden laan"
"Complementary colours"
"Colour wheel"
"Pop art gradient pattern"
"Colour without light"
"Happy art creature"
)

# Generate some images
for number in "${StringArray[@]}";
do
   TEXT=$number

   python generate.py -p "$TEXT" -s 500 500 -o export/"$TEXT".png -sd 1 -i 500
done
