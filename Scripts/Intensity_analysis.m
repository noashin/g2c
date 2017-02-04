%   Summary of this function goes here
%   Detailed explanation goes here

% Import images

WorkDir = '/ibscratch/richardslab/g2c';

GeneDir = '/ibscratch/richardslab/g2c/data/gene_expression_data/coronal_P14_data/niftis/P56_warped';

addpath('/ibscratch/richardslab/FSL/fsl/etc/matlab')

  atlas = 'P14';

%% Fully reconstructed histology volumes should now be registered to MRI space; in turn, the C57 atlas has been registered to each MRI volume..
%% So, need to generate 76 mean intensity values - one for each ROI in C57 atlas

%% First, create zero matrices that we are going to fill with connectivity values

%% Import Annotation

  fname = strcat(WorkDir,'/Atlases/P56/P56_annotation_Oh.nii');

  if exist(fname,'file') == 2

      [Annotation_img,Annotation_dims,Annotation_scales,Annotation_bpp,Annotation_endian] = read_avw(fname);

      %Annotation_img_reshape = reshape(Annotation_img,1,Annotation_dims(1)*Annotation_dims(2)*Annotation_dims(3));

  end

%% Now loop through each

  %% import csv of included region ids

  Region_list = readtable(strcat(WorkDir,'/Atlases/P56/Regions_Oh.csv'));

	ROI_ID = table2array(Region_list(:,2));

ROI_num = length(ROI_ID);


%% Loop through each gene in expression data

  %% Read list of genes

    gene_list = importdata(strcat(GeneDir,'/','gene_list'));

    expression = zeros(ROI_num,length(gene_list));

    for a_sub = 1:1:length(gene_list);
        b_sub = gene_list{a_sub}

        fname = strcat(GeneDir,'/',b_sub);

            [gene_img,gene_dims,gene_scales,gene_bpp,gene_endian] = read_avw(fname);

            %gene_img_reshape = reshape(gene_img,1,gene_dims(1)*gene_dims(2)*gene_dims(3));


        %% Loop through each ROI value in region list
        for c_sub = 1:1:ROI_num;
        i_ROI = ROI_ID(c_sub)

        %% initialize with zero matrix

        	ROI_img = Annotation_img;

       	 	ROI_img(ROI_img~=i_ROI) = 0;

        %ROI_img_reshape = reshape(ROI_img,1,Annotation_dims(1)*Annotation_dims(2)*Annotation_dims(3));

        	ROI_img_bin = ROI_img;
        	ROI_img_bin(ROI_img_bin > 0) = 1;

          size(find(ROI_img_bin > 0))

          if ~size(find(ROI_img_bin > 0));
          then
              i_ROI
          end

        	Gene_expression_ROI = gene_img .* ROI_img_bin;


        %% Report the mean intensity in the ROI

        mean_Gene_expression_ROI = mean(mean(mean(Gene_expression_ROI,1),2),3);


        expression(c_sub,a_sub) = mean_Gene_expression_ROI;

        end
    end

%    %----------------- Matrix Save ---------------------------------
    SaveDir = WorkDir;

%    if exist(SaveDir,'dir') ~=7

%        mkdir(SaveDir);

%    end

    fname = strcat(SaveDir,'/expression.mat');
    save(fname,'expression');
