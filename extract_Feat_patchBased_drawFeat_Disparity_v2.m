function [Case,Features]=extract_Feat_patchBased_drawFeat_Disparity_v2(I,M,H,E,S,lympModel_WSI,draw_option,visFile)
visFile_E=[visFile, '_EEEE'];
visFile_S=[visFile, '_SSSS'];


if calc_frac(E)+calc_frac(S)<0.2 || calc_frac(M)<=0 || ( eps+calc_frac(E))/(eps+calc_frac(S))>4 ||( eps+calc_frac(S))/(eps+calc_frac(E))>4
    Case='inappropriate';
else
    %% epithelial patches
    if ( eps+calc_frac(E))/(eps+calc_frac(S))>1   %%% this patch contains mainly epithelial
        Case='Epithelial';
        ROI=E+S;
    end
    %% stromal patches
    if ( eps+calc_frac(S))/(eps+calc_frac(E))>1   %%% this patch contains mainly epithelial
        Case='Stromal';
        ROI=E+S;
    end
end
if strcmp(Case,'inappropriate')
    fprintf('empty patch \n')
    Features=zeros(1172,1);
else
    %% classify the cells in ROI
    [nucCentroids,nucFeatures,~] = get7NucLocalFeatures(I,ROI.*M);
    isLymph = (predict(lympModel_WSI.model,nucFeatures(:,1:7)))==1;
    cent=round(nucCentroids);
    numCent=length(cent);
    epiNuc=false(numCent,1);
    
    if numCent<3
        fprintf('empty patch \n')
        Features=zeros(1172,1);
    else
        
        for c=1:numCent
            epiNuc(c)=E(cent(c,2),cent(c,1));
        end
        
        
        coords= {   nucCentroids(~isLymph & epiNuc,:),...
            nucCentroids(isLymph & ~epiNuc,:),...
            nucCentroids(isLymph & epiNuc,:),...
            nucCentroids(~isLymph & ~epiNuc,:),...
            };
        
        
        
        alpha=0.37*ones(1,4);
        r=.185;
        
        %% draw centroids, graphs, convex hull for all families
        if draw_option==1
            classes=zeros(1,numCent);
            classes(isLymph & ~epiNuc)=1;
            classes(isLymph & epiNuc)=2;
            classes(~isLymph & ~epiNuc)=3;
            colors = {...
                [1, 0.54, 0],...
                [0 .81 .91],...
                [0.45, 0.8, 0],...
                [.1 0 .7]};
            V30= (ESW_maker2(E,S,H)+1)/2;
            V40=(V30+I)/2;
            V41=ROImaker(V40,ROI);
            
            figure
            imshow(I,'Border','tight');
            hold on;
            saveas(gcf,[visFile, '_0.png'])
            
            
            figure
            imshow(V30,'Border','tight');
            hold on;
            saveas(gcf,[visFile, '_1.png'])
            
            figure
            imshow(V40,'Border','tight');
            hold on;
            saveas(gcf,[visFile, '_2.png'])
            
            drawCentroids(V41, coords,colors,r,alpha,visFile)
            drawNucContoursByClass_E_OR_S(M,V41,nucCentroids,classes,colors,3,[1,2,3,4]);
            saveas(gcf,[visFile, '_3.png'])
            
            
            list=[1,3];  %epithelial
            drawCentroids2(V41, coords(list),colors(list),r,alpha(list),visFile_E)
            drawNucContoursByClass_E_OR_S(M,V41,nucCentroids,classes,colors,3,list);
            saveas(gcf,[visFile_E, '_3.png'])
            drawNucContoursByClass_E_OR_S(M,ones(size(V41)),nucCentroids,classes,colors,3,list);
            saveas(gcf,[visFile_E, '_3_v2.png'])
            drawGraphsAndConvexHull_Disp(I,V30,V41, coords,colors,r,alpha,visFile_E,list)
             
            
            list=[2,4];  %stromal
            drawCentroids2(V41, coords(list),colors(list),r,alpha(list),visFile_S)
            drawNucContoursByClass_E_OR_S(M,V41,nucCentroids,classes,colors,3,list);
            saveas(gcf,[visFile_S, '_3.png'])
            drawNucContoursByClass_E_OR_S(M,ones(size(V41)),nucCentroids,classes,colors,3,list);
            saveas(gcf,[visFile_S, '_3_v2.png'])
            drawGraphsAndConvexHull_Disp(I,V30,V41, coords,colors,r,alpha,visFile_S,list)
            
            
        end
        
        % extracting computational features
        [Features,featNames]=getSpaTILFeatures_v3(coords,alpha,r);
        featNames = reshape(featNames,[size(featNames,2), size(featNames,1)]);
    end
    
end







