
clear all;
WorkDir = '/home/uqtedwar/g2c/data/gene_expression_data/sagittal_P14_data';

%Atlas_list=importdata(strcat(WorkDir,'/Atlas_list'));

files = dir(WorkDir);
directoryNames = {files([files.isdir]).name};
directoryNames = directoryNames(~ismember(directoryNames,{'.','..'}));

for file = directoryNames;
    fname = strcat(WorkDir,'/',file,'/','energy.mhd');
    mhd=read_mhd(fname{1});
    
    dimensions = [200 200 200];
    
    nii = make_nii(mhd.data, dimensions, 0 , 2);
    
    mkdir(WorkDir, '/niftis');
    
    savename = strcat(WorkDir,'/niftis/',file,'.nii');
    
    sname = char(savename)
    
    save_nii(nii,sname);
    
end
