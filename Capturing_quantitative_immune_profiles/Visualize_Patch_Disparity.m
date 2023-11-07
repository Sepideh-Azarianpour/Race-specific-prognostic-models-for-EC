clear, clc, close all
errImgs=[];
addpath(genpath(pwd))
folder = 'D:\Disparity_cellular_panels\input\';
save_folder = 'D:\Disparity_cellular_panels\output_20230713\';
mkdir(save_folder)
mkdir(save_folder,'ES/')
mkdir(save_folder,'E/')
mkdir(save_folder,'S/')

%% input folders
modelPath=[folder,'\models\'];
lympModel_WSI=load([modelPath 'lymp_svm_matlab_wsi.mat']);
PatchFolder=[folder,'\patches\'];
imgList=dir([PatchFolder, '*.png']);
numFiles=length(imgList);

for n=18%:numFiles
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
        
%                 I=  im2double(imread([PatchFolder , '\' ,patch_Name , '.png'],{[shoroo,payan],[shoroo,payan]}));  %%%%%H&E image patch

        
        fprintf('patch %s\n',patch_Name);
        n
        tile_sz=max([size(I,1),size(I,2)]);
        sz_ES=floor(tile_sz/4); %%% it is the ratio of WSI to its ES mask
        ratio=40/1.25; %%% the ratio of magnification WSI over thumbnail images
        kk=tile_sz/ratio;
        
        j=LOC_ID1/tile_sz;
        i=LOC_ID2/tile_sz;
        
        H_cropped=HQC(floor((i-1)*kk)+1:min(floor(i*kk),size(HQC,1)),floor((j-1)*kk)+1:min(floor(j*kk),size(HQC,2)));
        H =im2double(imresize(H_cropped,[size(I,1),size(I,2)])>200);
        
        E=ES.*H;
        S=(1-ES).*H;
        
        
        
        
        tic
        
        
        
        if calc_frac(E)+calc_frac(S)<0.8 || calc_frac(M)<=0
            Case='inappropriate'
        else
            %% epithelial patches
            if ( eps+calc_frac(E))/(eps+calc_frac(S))>3   %%% this patch contains mainly epithelial
                Case='Epithelial'
                visFile=[save_folder,'E/' patch_Name];
                [~]=Visualize_Patch_Disp_E(I,M,H,E,S,lympModel_WSI,1,visFile);
            end
            %% stromal patches
            if ( eps+calc_frac(S))/(eps+calc_frac(E))>3   %%% this patch contains mainly epithelial
                Case='Stromal'
                visFile=[save_folder,'S/' patch_Name];
                [~]=Visualize_Patch_Disp_S(I,M,H,E,S,lympModel_WSI,1,visFile);
                
            end
            %% epi-stromal patches
            if ( eps+calc_frac(S))/(eps+calc_frac(E))<3 && ( eps+calc_frac(E))/(eps+calc_frac(S))<3    %%% this patch contains mainly epithelial
                Case='Epithelial and Stromal'
                visFile=[save_folder,'ES/' patch_Name];
                [~]=Visualize_Patch_Disp_ES(I,M,H,E,S,lympModel_WSI,1,visFile);
                
                
                visFile=[save_folder,'ES/' patch_Name, 'E'];
                [~]=Visualize_Patch_Disp_ES2(I,M,E,E,zeros(size(S)),lympModel_WSI,1,visFile);
                
                
                visFile=[save_folder,'ES/' patch_Name, 'S'];
                [~]=Visualize_Patch_Disp_ES2(I,M,S,zeros(size(E)),S,lympModel_WSI,1,visFile);
                
                
            end
            
        end
        
        
       
        
        
        toc
    catch
        % Nothing to do
        
    end
    
end











