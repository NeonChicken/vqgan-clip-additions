file="test.txt"
echo "this" "is =""test" >> $file
echo "next line" >> $file

if ((2 > 1))
then
	echo "2 bigger than 1" >> $file
fi

for number in {1..3}
do
   echo "$number" >> $file
done

cat $file