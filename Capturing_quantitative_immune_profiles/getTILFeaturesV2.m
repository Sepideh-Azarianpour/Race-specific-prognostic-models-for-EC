function [spaFeat,spaFeatNames] = getTILFeaturesV2( I,M,Model,k,C_lymp_maskFile,C_nonLymp_maskFile )
%GETTILFEATURES Summary of this function goes here
%   Detailed explanation goes here

[nucleiCentroids,nucFeatures,nucFeatNames] = getNucLocalFeatures(I,M);

% % % Lymphocyte detection is based on: Area,Eccentricity,RatioAxes,MedianRed,
% % %  EntropyRed,MinIntensity,MaxIntensity

isLymphocyte = (predict(Model,nucFeatures(:,1:7)))==1;

lympCentroids=nucleiCentroids(isLymphocyte==1,:);
nonLympCentroids=nucleiCentroids(isLymphocyte~=1,:);
nucAreas=nucFeatures(:,1);
lympAreas=nucAreas(isLymphocyte==1);

[lympMask,nonLympMask]=lympVsNonLympMask(lympCentroids,I, M );
lympMask=im2uint8(lympMask);

imwrite(lympMask,C_lymp_maskFile)
imwrite(nonLympMask,C_nonLymp_maskFile)

%%%%%%%%% for visualizing lymph and nonlymph with dark yellow (non lymph) and
%%%%%%%%% dark cyan (lymph)
% % % % Icop=I;
% % % % Icop(:,:,1)=(1-lympMask).*double(I(:,:,1));
% % % % Icop(:,:,3)=(1-nonLympMask).*double(I(:,:,3));
% % % % imshow(Icop)
%%%%%%%% nu,ber of lymph and non-lymph and whole nuclei
% % % 
% % % CC = bwconncomp(M);
% % % S = regionprops(CC,'Centroid');
% % % CC.NumObjects
% % % 
% % % CC = bwconncomp(lympMask);
% % % S = regionprops(CC,'Centroid');
% % % CC.NumObjects
% % % 
% % % CC = bwconncomp(nonLympMask);
% % % S = regionprops(CC,'Centroid');
% % % CC.NumObjects

%[denFeat,denFeatNames]=getDenTILFeatures(I,lympCentroids,nonLympCentroids,lympAreas);

[spaFeat,spaFeatNames]=getSpaTILFeatures(lympCentroids,nonLympCentroids);


%[ctxFeat,ctxFeatNames]=getContextTILFeatures(nucleiCentroids,nucAreas,nucFeatures(:,2),...
%    nucFeatures(:,8),nucFeatures(:,11),nucFeatures(:,5),nucFeatures(:,13),nucFeatures(:,14),k);

end