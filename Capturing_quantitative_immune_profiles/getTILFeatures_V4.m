function [nucleiCentroids,isLymphocyte,nucFeatures,nucFeatNames,denFeat,denFeatNames,spaFeat,spaFeatNames,ctxFeat,ctxFeatNames,...
nucleiCentroids_stro,isLymphocyte_stro,nucFeatures_stro,denFeat_stro,spaFeat_stro,ctxFeat_stro,...
nucleiCentroids_epi,isLymphocyte_epi,nucFeatures_epi,denFeat_epi,spaFeat_epi,ctxFeat_epi,...
nucleiCentroids_bund,isLymphocyte_bund,nucFeatures_bund,denFeat_bund,spaFeat_bund,ctxFeat_bund] = getTILFeatures_V4(I,ES,M,lympModel,k,maskFile,ESmaskFile)
%GETTILFEATURES Summary of this function goes here
%   Detailed explanation goes here
% Clean image by watershed
M = imcomplement(M);
M = getWatershedMask(M,false,6,12);
M = logical(M);
M = bwareafilt(M,[30 300]);
M1 = getWatershedMask(I,true,6,12);
M1 = logical(M1);
%figure, imshow(M)
%M = bwareaopen(M, 30);
%M1 = bwareaopen(M1, 30);
M1 = bwareafilt(M1,[30 300]);
%figure, imshow(M1)
M = M+M1;
%figure, imshow(M2)
imwrite(M,maskFile);
[nucleiCentroids,nucFeatures,nucFeatNames] = getNucLocalFeatures(I,logical(M));
% Lymphocyte detection is based on: Area,Eccentricity,RatioAxes,MedianRed, EntropyRed,MinIntensity,MaxIntensity
isLymphocyte = (predict(lympModel,nucFeatures(:,1:7)))==1;
lympCentroids=nucleiCentroids(isLymphocyte==1,:);
nonLympCentroids=nucleiCentroids(isLymphocyte~=1,:);
nucAreas=nucFeatures(:,1);
lympAreas=nucAreas(isLymphocyte==1);
% Extract features based on all image
[spaFeat,spaFeatNames]=getSpaTILFeatures(lympCentroids,nonLympCentroids);
[denFeat,denFeatNames]=getDenTILFeatures(I,lympCentroids,nonLympCentroids,lympAreas);
[ctxFeat,ctxFeatNames]=getContextTILFeatures(nucleiCentroids,nucAreas,nucFeatures(:,2),nucFeatures(:,8),nucFeatures(:,11),nucFeatures(:,5),nucFeatures(:,13),nucFeatures(:,14),k);
%Adapt the ES mask to the nuclei
[q_r,q_m,~] = size(I);
ES = imresize(ES,[q_r q_m],'Antialiasing',false);
ES = uint8(255*mat2gray(ES)); 
ES = uint8(ES);
level = graythresh(ES);
ES = imbinarize(ES,level);
ES1 = imfill(ES,8,'holes');
se = strel('disk',5);
ES1 = ~imopen(~ES1,se);
ES1 = imfill(ES1,4,'holes');
ES1= ~imfill(~ES1,8,'holes');
imwrite(ES1,ESmaskFile);
M_stro = M.*ES1;
M_stro = bwareaopen(M_stro, 50);
M_epi = M.*~ES1;
M_epi = bwareaopen(M_epi, 50);
%% Extract features based on Epithelium
[nucleiCentroids_epi,nucFeatures_epi,~] = getNucLocalFeatures(I,M_epi);
if sum(sum(M_epi)) == 0
    isLymphocyte_epi = [];
    lympCentroids_epi = [];
    nonLympCentroids_epi = [];
    nucAreas_epi = [];
    lympAreas_epi = [];
    spaFeat_epi = [];
    denFeat_epi = [];
    ctxFeat_epi = [];
else
    isLymphocyte_epi = (predict(lympModel,nucFeatures_epi(:,1:7)))==1;
    lympCentroids_epi=nucleiCentroids_epi(isLymphocyte_epi==1,:);
    nonLympCentroids_epi=nucleiCentroids_epi(isLymphocyte_epi~=1,:);
    nucAreas_epi=nucFeatures_epi(:,1);
    lympAreas_epi=nucAreas_epi(isLymphocyte_epi==1);
    [spaFeat_epi,~]=getSpaTILFeatures(lympCentroids_epi,nonLympCentroids_epi);
    [denFeat_epi,~]=getDenTILFeatures(I,lympCentroids_epi,nonLympCentroids_epi,lympAreas_epi);
    [ctxFeat_epi,~]=getContextTILFeatures(nucleiCentroids_epi,nucAreas_epi,nucFeatures_epi(:,2),nucFeatures_epi(:,8),nucFeatures_epi(:,11),nucFeatures_epi(:,5),nucFeatures_epi(:,13),nucFeatures_epi(:,14),k);
end
    %% Extract features based on Stroma
[nucleiCentroids_stro,nucFeatures_stro,~] = getNucLocalFeatures(I,M_stro);
if sum(sum(M_stro)) == 0
    isLymphocyte_stro = [];
    lympCentroids_stro = [];
    nonLympCentroids_stro = [];
    nucAreas_stro = [];
    lympAreas_stro = [];
    spaFeat_stro = [];
    denFeat_stro = [];
    ctxFeat_stro = [];
else
    isLymphocyte_stro = (predict(lympModel,nucFeatures_stro(:,1:7)))==1;
    lympCentroids_stro=nucleiCentroids_stro(isLymphocyte_stro==1,:);
    nonLympCentroids_stro=nucleiCentroids_stro(isLymphocyte_stro~=1,:);
    nucAreas_stro=nucFeatures_stro(:,1);
    lympAreas_stro=nucAreas_stro(isLymphocyte_stro==1);
    [spaFeat_stro,~]=getSpaTILFeatures(lympCentroids_stro,nonLympCentroids_stro);
    [denFeat_stro,~]=getDenTILFeatures(I,lympCentroids_stro,nonLympCentroids_stro,lympAreas_stro);
    [ctxFeat_stro,~]=getContextTILFeatures(nucleiCentroids_stro,nucAreas_stro,nucFeatures_stro(:,2),nucFeatures_stro(:,8),nucFeatures_stro(:,11),nucFeatures_stro(:,5),nucFeatures_stro(:,13),nucFeatures_stro(:,14),k);
end
%% Extract features based on epiStroma boundary
ES_Bound = boundarymask(ES1);
ES_Bound1 = imdilate(ES_Bound, strel('disk',40));
M_bund = M.*ES_Bound1;
M_bund= bwareaopen(M_bund, 50);
[nucleiCentroids_bund,nucFeatures_bund,~] = getNucLocalFeatures(I,M_bund);
if sum(sum(M_bund)) == 0
    isLymphocyte_bund = [];
    lympCentroids_bund = [];
    nonLympCentroids_bund = [];
    nucAreas_bund = [];
    lympAreas_bund = [];
    spaFeat_bund = [];
    denFeat_bund = [];
    ctxFeat_bund = [];
else
    isLymphocyte_bund = (predict(lympModel,nucFeatures_bund(:,1:7)))==1;
    lympCentroids_bund=nucleiCentroids_bund(isLymphocyte_bund==1,:);
    nonLympCentroids_bund=nucleiCentroids_bund(isLymphocyte_bund~=1,:);
    nucAreas_bund=nucFeatures_bund(:,1);
    lympAreas_bund=nucAreas_bund(isLymphocyte_bund==1);
    [spaFeat_bund,~]=getSpaTILFeatures(lympCentroids_bund,nonLympCentroids_bund);
    [denFeat_bund,~]=getDenTILFeatures(I,lympCentroids_bund,nonLympCentroids_bund,lympAreas_bund);
    [ctxFeat_bund,~]=getContextTILFeatures(nucleiCentroids_bund,nucAreas_bund,nucFeatures_bund(:,2),nucFeatures_bund(:,8),nucFeatures_bund(:,11),nucFeatures_bund(:,5),nucFeatures_bund(:,13),nucFeatures_bund(:,14),k);
end
end