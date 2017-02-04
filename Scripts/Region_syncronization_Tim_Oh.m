clear all;

WorkDir = '/ibscratch/richardslab/g2c';

addpath('/ibscratch/richardslab/FSL/fsl/etc/matlab')

%% Idea is to identify the parent structure, then assign the corresponding ID of
%% the parent structure to all daughter structures

%% First, import list of ROIs

Oh_list =  readtable(strcat(WorkDir,'/Atlases/P56/Regions_Oh.csv'));

%% Sort Oh_list

Oh_list = sortrows(Oh_list)

Tim_list = readtable(strcat(WorkDir,'/Atlases/P56/Regions_Tim.csv'));

Tim_list2 = Tim_list;

Tim_ID = table2array(Tim_list(:,2));

Oh_ID = table2array(Oh_list(:,2))


%% Load P56 Annotation

  fname = strcat(WorkDir,'/Atlases/P56/annotation_2011_ccfv3_reorient.nii');

  if exist(fname,'file') == 2

      [Annotation_img,Annotation_dims,Annotation_scales,Annotation_bpp,Annotation_endian] = read_avw(fname);

      Annotation_img2 = zeros([Annotation_dims(1),Annotation_dims(2),Annotation_dims(3)]);

      size(Annotation_img2)

  end

%% Loop through each row in column 3

Oh_num = length(Oh_ID);

Tim_num = length(Tim_ID);

for c_sub = 1:1:Oh_num;
    i_sub = Oh_list{c_sub,1};

    i_sub = char(i_sub);

    parent_sub = i_sub

        for k_sub = 1:1:Tim_num;

            j_sub = Tim_list{k_sub,1};

            j_sub = char(j_sub);

		daughter_sub = j_sub;

            %% now see if daughter_sub matches parent_sub

            if strfind(daughter_sub,parent_sub);

             Annotation_img2(Annotation_img == Tim_ID(k_sub)) = Oh_ID(c_sub);

              Tim_list2(k_sub,1) = Oh_list(c_sub,1);

              Tim_list2(k_sub,3) = Oh_list(c_sub,2);

            end
    end
end

dimensions = [25 25 25];

    nii = make_nii(Annotation_img2, dimensions, 0 , 768);

    savename = strcat(WorkDir,'/Atlases/P56/P56_annotation_Oh.nii');

    sname = char(savename)

    save_nii(nii,sname);

    fname = strcat(WorkDir,'/Atlases/P56/Regions_Tim_synchronized.csv')

    writetable(Tim_list2,fname)
