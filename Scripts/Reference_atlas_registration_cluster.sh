
WorkDir=/ibscratch/richardslab/g2c/Atlases
#ANTsDir=/ibscratch/richardslab/ANTs-2.1.0-Linux/bin

cd ${WorkDir}

## run ## qsub -b y -q medium.q -l h_vmem=80G -e ${WorkDir}/P4_2_P14_e.log -o ${WorkDir}/P4_2_P14_o.log /clusterdata/uqtedwar/ANTs-2.1.0-Linux/bin/./antsRegistrationSyN.sh -d 3 -f ${WorkDir}/P14/P14_wholebrain2.nii -m ${WorkDir}/P4/P4.nii -o ${WorkDir}/P14/P4_2_P14 -n 10 -r 4


## run ##	qsub -b y -q medium.q -l h_vmem=80G -e ${WorkDir}/P14_2_P28_e.log -o ${WorkDir}/P14_2_P28_o.log /clusterdata/uqtedwar/ANTs-2.1.0-Linux/bin/./antsRegistrationSyN.sh -d 3 -f ${WorkDir}/P28/P28_wholebrain.nii -m ${WorkDir}/P14/P14_wholebrain2.nii -o ${WorkDir}/P14/P14_2_P28 -n 10 -r 4

## run ## qsub -b y -q medium.q -l h_vmem=60G -e ${WorkDir}/P28_2_P56_e.log -o ${WorkDir}/P28_2_P56_o.log /clusterdata/uqtedwar/ANTs-2.1.0-Linux/bin/./antsRegistrationSyN.sh -d 3 -f ${WorkDir}/P56/P56.nii -m ${WorkDir}/P28/P28_wholebrain.nii -o ${WorkDir}/P28/P28_2_P56 -n 10 -r 4

## Apply warps ##

	# Warp P4 to P14 to P28

#qsub -b y -q medium.q -l h_vmem=30G -e ${WorkDir}/P4_2_P28_e.log -o ${WorkDir}/P4_2_P28_o.log

/clusterdata/uqtedwar/ANTs-2.1.0-Linux/bin/WarpImageMultiTransform 3 ${WorkDir}/P4/P4_2_P14Warped.nii.gz ${WorkDir}/P4/P4_2_P14_2_P28_wholebrain.nii -R ${WorkDir}/P28/P28_wholebrain.nii ${WorkDir}/P14/P14_2_P281Warp.nii.gz ${WorkDir}/P14/P14_2_P280GenericAffine.mat

#qsub -b y -q medium.q -l h_vmem=30G -e ${WorkDir}/P4_2_P56_e.log -o ${WorkDir}/P4_2_P56_o.log

/clusterdata/uqtedwar/ANTs-2.1.0-Linux/bin/WarpImageMultiTransform 3 ${WorkDir}/P4/P4_2_P14_2_P28_wholebrain.nii ${WorkDir}/P4/P4_2_P14_2_P28_2_P56.nii -R ${WorkDir}/P56/P56.nii ${WorkDir}/P28/P28_2_P561Warp.nii.gz ${WorkDir}/P28/P28_2_P560GenericAffine.mat


	# Warp P14 to P28 to P56

	#qsub -b y -q medium.q -l h_vmem=30G -e ${WorkDir}/P14_2_P56_e.log -o ${WorkDir}/P14_2_P56_o.log

	/clusterdata/uqtedwar/ANTs-2.1.0-Linux/bin/WarpImageMultiTransform 3 ${WorkDir}/P14/P14_2_P28Warped.nii.gz ${WorkDir}/P14/P14_2_P28_2_P56.nii -R ${WorkDir}/P56/P56.nii ${WorkDir}/P28/P28_2_P561Warp.nii.gz ${WorkDir}/P28/P28_2_P560GenericAffine.mat


			#sh ~/ANTs-2.1.0-Linux/bin/antsRegistrationSyN.sh -d 3 -f ${WorkDir}/P56/P56.nii -m ${WorkDir}/P4/P4.nii -o ${WorkDir}/P4/P4_2_P56_long -n 8


## rewarping the label file to the subject space due to introduction of the posterior commissure

		#${ANTsDir}/WarpImageMultiTransform 3 ${RefDir}/CAI_Richards_Jiang_label_new_revise_ero_neo_mid.nii ${WorkDir}/$i/CAI_Richards_Jiang/ANTs/${i}_dMRI_convert_label_Ave_nodif_erode_labeled_fix.nii -R ${WorkDir}/$i/bet/${i}_dMRI_convert_label_Ave_nodif_erode.nii --use-NN -i ${WorkDir}/$i/CAI_Richards_Jiang/ANTs/${i}_dMRI_convert_label_Ave_nodif_erode_Affine.txt ${WorkDir}/$i/CAI_Richards_Jiang/ANTs/${i}_dMRI_convert_label_Ave_nodif_erode_InverseWarp.nii.gz



#done
