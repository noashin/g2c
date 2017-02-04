#!/bin/bash

WorkDir=/home/uqtedwar/g2c/data/gene_expression_data

cd $WorkDir

for j in *
do

	echo $j
	
	cd $j

	for i in *
	do
		echo $i

		filename=$i

		filename="${filename%.*}"

		echo $filename

		echo mkdir $filename

		echo unzip $i -d $filename
	done

	rm *.zip

	cd ..

done
