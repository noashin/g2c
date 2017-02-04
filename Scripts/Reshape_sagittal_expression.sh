#!/bin/bash

WorkDir=/home/uqtedwar/g2c/data/gene_expression_data

cd $WorkDir/sagittal_P14_data/niftis

#for i in *
#do

	i=Dcc_P14_sagittal_100038991_200um

	echo $i

	filename=$i

	filename="${filename%.*}"

	## resize voxels to match reference image

	mrresize $filename.nii -voxel 16.752,16.752,25 $filename_scale.nii

	%% Crop image at approximate midline matching the reference volume for sagittal data

	%P14

	Center=191

	mrcrop $filename.nii -axis 0 191 ${filename}_crop.nii

	%P14

	Center=203

	mrcrop $filename.nii -axis 0 191 ${filename}_crop.nii


echo	mrcrop -axis 2 0 194 $filename.nii ${filename}_half.nii

echo	mrcrop -axis 2 0 193 $filename.nii ${filename}_half_193.nii

echo	mrpad -axis 2 0 195 ${filename}_half.nii ${filename}_half_pad.nii -force

echo 	mrpad -axis 2 0 196 ${filename}_half_193.nii ${filename}_half_193_pad.nii -force


#done
