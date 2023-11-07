clear, clc, close all
addpath(genpath(pwd))
folder = 'C:\Users\sxa786\Desktop\New folder\input\';
save_folder = 'C:\Users\sxa786\Desktop\New folder\output\';


%% input folders
modelPath=[folder,'\SVM_TIL_Detection_Model\'];
lympModel_WSI=load([modelPath 'lymp_svm_matlab_wsi.mat']);
PatchFolder=[folder,'\patches\'];
imgList=dir([PatchFolder, '*.png']);
numFiles=length(imgList);
mkdir(save_folder)

%% Feature calculation and visualization
for n=1:numFiles
    try
        close all
        [~,patch_Name]=fileparts(imgList(n).name);
        expression=['\_'];
        [match,noMatch] = regexp(patch_Name,expression,'split');
        Patient_Name=char(string(match{1}));
        LOC_ID1=str2double(string(match{2}));
        LOC_ID2=str2double(string(match{3}));
        
        I=  im2double(imread([PatchFolder , '\' ,patch_Name , '.png']));  %%%%%H&E image patch
        ES=  im2double(imread([folder,'\epi_stroma\' , '\' ,patch_Name , '.png']));
        M=  im2double(imread([folder,'\nuc\' , '\' ,patch_Name , '.png']));  %%%%nuclei mask
        HQC=  imread([folder,'\HQC_WSI\' , '\' ,Patient_Name , '.tif_mask_use.png']);
        
        
        
        fprintf('patch %s\n',patch_Name);
        visFile=[save_folder, patch_Name];
        tile_sz=max([size(I,1),size(I,2)]);
        
        ratio_1=4; %%% it is the ratio of WSI (40X) to its ES mask (10X)
        sz_ES=floor(tile_sz/ratio_1); 
        ratio_2=32; %%% the ratio of magnification WSI (40X) over thumbnail HistoQC images (1.25X)
        kk=tile_sz/ratio_2;
        
        j=LOC_ID1/tile_sz;
        i=LOC_ID2/tile_sz;
        
        H_cropped=HQC(floor((i-1)*kk)+1:min(floor(i*kk),size(HQC,1)),floor((j-1)*kk)+1:min(floor(j*kk),size(HQC,2)));
        H =im2double(imresize(H_cropped,[size(I,1),size(I,2)])>200);
        
        E=ES.*H; %%% effective Epithelial mask (masked out inappropriate quality regions if any)
        S=(1-ES).*H;  %%% effective Stromal mask (non-epithelium regions masked out inappropriate quality regions if any)
        [Case, Features]=extract_Feat_patchBased_drawFeat_Disparity_v2(I,M,H,E,S,lympModel_WSI,0,visFile);
    catch
    end
end











