
WorkDir=/ibscratch/richardslab/g2c/data/gene_expression_data/coronal_P14_data
RefDir=/ibscratch/richardslab/g2c/Atlases

#ANTsDir=/ibscratch/richardslab/ANTs-2.1.0-Linux/bin

cd ${WorkDir}/niftis

for i in *
do

	gene=${i%.nii}

	echo $gene

if [ ! -d niftis/P56_warped ]
then
	mkdir niftis/P56_warped

	#qsub -b y -q medium.q -l h_vmem=30G -e ${WorkDir}/P4_2_P28_e.log -o ${WorkDir}/P4_2_P28_o.log

	/clusterdata/uqtedwar/ANTs-2.1.0-Linux/bin/WarpImageMultiTransform 3 ${WorkDir}/niftis/${gene}.nii ${WorkDir}/niftis/P56_warped/${gene}.nii -R ${RefDir}/P56/P56.nii ${RefDir}/P14/P14_2_P281Warp.nii.gz ${RefDir}/P14/P14_2_P280GenericAffine.mat ${RefDir}/P28/P28_2_P561Warp.nii.gz ${RefDir}/P28/P28_2_P560GenericAffine.mat

fi
done
