%% Mirroring left ROIs to right side

clear all;
WorkDir = '/home/uqtedwar/g2c/Atlases';

%Atlas_list=importdata(strcat(WorkDir,'/Atlas_list'));

addpath('/home/uqtedwar/spm12/spm12');

%for c=1:1:length(ROI_list);
%    i_ROI=ROI_list(c,:)


    %disp(sprintf('Flipping %s', i))


%% 1) Upload the image to Matlab (you need to have spm which is free):
V = spm_vol(strcat(WorkDir,'/P28/P28_half_pad.nii'));
Y = load_nii(V.fname);

%figure;
%imagesc(Y(:,:,90)); % display the axial slice where z=50

centerZ = 203;

%% 2) Reflect the matrix:
REF = zeros(size(Y.img,1),size(Y.img,2),size(Y.img,3));
it = centerZ;
i = centerZ;
while i<=size(Y.img,3) && it>0
        REF(:,:,it) = Y.img(:,:,i);
        REF(:,:,i) = Y.img(:,:,it);
        it = it-1;
        i = i+1;
end

%% 3) save the output

%fname=sprintf(i_ROI)
%V2=V{1,1};
%V2.fname=fname;
%V2.dim(1:3)=V{1,1}.dim(1:3)

Y2 = Y;

Y2.img = REF;

fname = strcat(WorkDir,'/P28/P28_mirrored.nii');

save_nii(Y2,fname);

%V.fname=test;
%V.private.dat.fname = V.fname

%V.fname = strcat(SaveDir,'/',i_ROI,'_right.nii');
%spm_write_vol(V2,REF);
%end
