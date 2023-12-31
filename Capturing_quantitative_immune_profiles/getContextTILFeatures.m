function [features,featureNames] = getContextTILFeatures(nucleiCentroids, nucleiArea, nucleiEcc, nucleiDiam, MeanI, EntropyR, RatioMRB, RatioMRG,Kparameter)
%GETCONTEXTTILFEATURES Summary of this function goes here
%   Detailed explanation goes here

if size(nucleiCentroids,1)>1
    % ---------------------------------------------- %
    % Function No. 1
    % [L][extractSumInvDistLymp] Suma del inverso de las distancias entre linfocitos, en un radio específico
    %       calculate the distance between atoms and invert them to see farest as low
    %       value and closest as high value
    dist = pdist(nucleiCentroids);
    dist = dist.^-1;
    %       calculate the matrix of the pdist, which compares each atom to all the
    %       others
    matrxK10 = squareform(dist);
    matrxK20 = squareform(dist);
    matrxK30 = squareform(dist);
    % Normalize by div the matrix to 1000, to avoid larger numbers
    % if want to use a more local measurement or per image matrx = matrx / 1000.0
    % matrx = matrx/1000.0;
    %       remove the values lower (farest from a atom) from the matrix based on a
    %       thhreshold = 8 is the diameter of a lympb (mean) and multiply by 5
    %       to give a radious of cluster
    
    threshK10 = 1/(Kparameter(1));
    threshK20 = 1/(Kparameter(2));
    threshK30 = 1/(Kparameter(3));
    
    matrxK10(matrxK10<threshK10) = 0;
    matrxK20(matrxK20<threshK20) = 0;
    matrxK30(matrxK30<threshK30) = 0;
    %       sum the resulting columns of the matrix
    matrxSumK10 = sum(matrxK10);
    matrxSumK20 = sum(matrxK20);
    matrxSumK30 = sum(matrxK30);
    
    %       Invert row to columns
    sumInvDistNuc = [matrxSumK10(:) matrxSumK20(:) matrxSumK30(:)];
    % ---------------------------------------------- %
    
    %concParam = [nucleiCentroids nucleiArea MeanIntensity nucleiPrediction]; % unite the parameters to be fitlered
    concParam = [nucleiCentroids nucleiArea nucleiEcc nucleiDiam MeanI EntropyR RatioMRB RatioMRG]; % unite the parameters to be fitlered
    
    % a matrix for each of the three
    for i=1:length(Kparameter)
        thresh = 1/(Kparameter(i));
        eval(['matrxK' num2str(Kparameter(i)) '= squareform(dist);']);
    end
    
    %       remove the values lower (farest from a atom) from the matrix based on a
    %       thhreshold = 8 is the diameter of a lympb (mean) and multiply by 5
    %       to give a radious of cluster
    
    for k=1:length(Kparameter)
        thresh = 1/(Kparameter(k));
        eval([ 'tempMatrx = matrxK' num2str(Kparameter(k)) ';' ]);
        tempMatrx(tempMatrx<thresh) = 0;
        eval([ 'matrxK' num2str(Kparameter(k)) '= tempMatrx;']);
    end
    
    % Filt each of the nuclei,area,pred on each centroid
    
    for k=1:length(Kparameter)
        for j=1:length(nucleiCentroids)
            filtcent = []; filtarea = []; filtecc = [];
            filtdiam = []; filtmeanI = []; filtentrop = [];
            filtratiomrb = []; filtratiomrg = [];
            eval([ 'tempMatrx = matrxK' num2str(Kparameter(k)) ';' ]);
            tempMatrx(j,j) = 1;
            pos = find(tempMatrx(:, j:j));
            for i=1:length(pos)
                % save in filt the filtered 'centroids' and 'area' from the cells
                filtcent = [filtcent; concParam(pos(i),1:2)];
                filtarea = [filtarea; concParam(pos(i),3:3)];
                filtecc = [filtecc; concParam(pos(i),4:4)];
                filtdiam = [filtdiam; concParam(pos(i),5:5)];
                filtmeanI = [filtmeanI; concParam(pos(i),6:6)];
                filtentrop = [filtentrop; concParam(pos(i),7:7)];
                filtratiomrb = [filtratiomrb; concParam(pos(i),8:8)];
                filtratiomrg = [filtratiomrg; concParam(pos(i),9:9)];
            end
            % filtcentroids, filtareas, filtpreds, etc are saved as cells of 1 x alpha where
            % alpha is the quantity of nuclei within a radious, each cell contains the centroids; to
            % extract use centroid_x = filtcentroids{ 1, x}
            % Change var for mean or any other similar measurement accordingly
            filtcentroids{k,j} = filtcent;
            % Quantity of Nuclei by each K
            % Areas of the Nuclei by each K
            filtareas{k,j} = filtarea;
            filtquantvar{k,j} = length(filtcent);
            % Median of the Nuclei Area by each K
            filtareasvar{k,j} = var(filtarea);
            filtareasmean{k,j} = mean(filtarea);
            filtareasmedian{k,j} = median(filtarea);
            filtareasstd{k,j} = std(filtarea);
            % Median of the Nuclei Eccentricity  by each K
            filteccentricityvar{k,j} = var(filtecc);
            filteccentricitymean{k,j} = mean(filtecc);
            filteccentricitymedian{k,j} = median(filtecc);
            filteccentricitystd{k,j} = std(filtecc);
            % Median of the Nuclei Diamter Area by each K
            filtdiametervar{k,j} = var(filtdiam);
            filtdiametermean{k,j} = mean(filtdiam);
            filtdiametermedian{k,j} = median(filtdiam);
            filtdiameterstd{k,j} = std(filtdiam);
            % Median of the Nuclei Mean intensity by each K
            filtmeanIntensityvar{k,j} = var(filtmeanI);
            filtmeanIntensitymean{k,j} = mean(filtmeanI);
            filtmeanIntensitymedian{k,j} = median(filtmeanI);
            filtmeanIntensitystd{k,j} = std(filtmeanI);
            % Median of the Nuclei Red Entropy by each K
            filtentropyRedvar{k,j} = var(filtentrop);
            filtentropyRedmean{k,j} = mean(filtentrop);
            filtentropyRedmedian{k,j} = median(filtentrop);
            filtentropyRedstd{k,j} = std(filtentrop);
            % Median of the Nuclei Red Blue ratio by each K
            filtratioRedBbluevar{k,j} = var(filtratiomrb);
            filtratioRedBbluemean{k,j} = mean(filtratiomrb);
            filtratioRedBbluemedian{k,j} = median(filtratiomrb);
            filtratioRedBbluestd{k,j} = std(filtratiomrb);
            % Median of the Nuclei Red Green Ratio by each K
            filtratioRedGreenvar{k,j} = var(filtratiomrg);
            filtratioRedGreenmean{k,j} = mean(filtratiomrg);
            filtratioRedGreenmedian{k,j} = median(filtratiomrg);
            filtratioRedGreenstd{k,j} = std(filtratiomrg);
        end
    end
    filtquantvarmat = cell2mat(filtquantvar)';
    
    filtareasvarmat = cell2mat(filtareasvar)';
    filtareasmeanmat = cell2mat(filtareasmean)';
    filtareasmedianmat = cell2mat(filtareasmedian)';
    filtareasstdmat = cell2mat(filtareasstd)';
    
    filteccentricityvarmat = cell2mat(filteccentricityvar)';
    filteccentricitymeanmat = cell2mat(filteccentricitymean)';
    filteccentricitymedianmat = cell2mat(filteccentricitymedian)';
    filteccentricitystdmat = cell2mat(filteccentricitystd)';
    
    filtdiametervarmat = cell2mat(filtdiametervar)';
    filtdiametermeanmat = cell2mat(filtdiametermean)';
    filtdiametermedianmat = cell2mat(filtdiametermedian)';
    filtdiameterstdmat = cell2mat(filtdiameterstd)';
    
    filtmeanIntensityvarmat = cell2mat(filtmeanIntensityvar)';
    filtmeanIntensitymeanmat = cell2mat(filtmeanIntensitymean)';
    filtmeanIntensitymedianmat = cell2mat(filtmeanIntensitymedian)';
    filtmeanIntensitystdmat = cell2mat(filtmeanIntensitystd)';
    
    filtentropyRedvarmat = cell2mat(filtentropyRedvar)';
    filtentropyRedmeanmat = cell2mat(filtentropyRedmean)';
    filtentropyRedmedianmat = cell2mat(filtentropyRedmedian)';
    filtentropyRedstdmat = cell2mat(filtentropyRedstd)';
    
    filtratioRedBbluevarmat = cell2mat(filtratioRedBbluevar)';
    filtratioRedBbluemeanmat = cell2mat(filtratioRedBbluemean)';
    filtratioRedBbluemedianmat = cell2mat(filtratioRedBbluemedian)';
    filtratioRedBbluestdmat = cell2mat(filtratioRedBbluestd)';
    
    filtratioRedGreenvarmat = cell2mat(filtratioRedGreenvar)';
    filtratioRedGreenmeanmat = cell2mat(filtratioRedGreenmean)';
    filtratioRedGreenmedianmat = cell2mat(filtratioRedGreenmedian)';
    filtratioRedGreenstdmat = cell2mat(filtratioRedGreenstd)';
    
    
    features = horzcat(filtquantvarmat, filtareasvarmat, filtareasmeanmat, filtareasmedianmat,...
        filtareasstdmat, filteccentricityvarmat, filteccentricitymeanmat, filteccentricitymedianmat, filteccentricitystdmat,...
        filtdiametervarmat, filtdiametermeanmat, filtdiametermedianmat, filtdiameterstdmat, filtmeanIntensityvarmat,...
        filtmeanIntensitymeanmat, filtmeanIntensitymedianmat, filtmeanIntensitystdmat, filtentropyRedvarmat,...
        filtentropyRedmeanmat, filtentropyRedmedianmat, filtentropyRedstdmat, filtratioRedBbluevarmat, filtratioRedBbluemeanmat,...
        filtratioRedBbluemedianmat, filtratioRedBbluestdmat, filtratioRedGreenvarmat,  filtratioRedGreenmeanmat,...
        filtratioRedGreenmedianmat,  filtratioRedGreenstdmat...
        );
else
    features=zeros(1,87);
end

featureNames={'filtquantvarmatK1','filtquantvarmatK2','filtquantvarmatK3','filtareasvarmatK1',...
    'filtareasvarmatK2','filtareasvarmatK3','filtareasmeanmatK1','filtareasmeanmatK2','filtareasmeanmatK3',...
    'filtareasmedianmatK1','filtareasmedianmatK2','filtareasmedianmatK3','filtareasstdmatK1','filtareasstdmatK2',...
    'filtareasstdmatK3','filteccentricityvarmatK1','filteccentricityvarmatK2','filteccentricityvarmatK3',...
    'filteccentricitymeanmatK1','filteccentricitymeanmatK2','filteccentricitymeanmatK3','filteccentricitymedianmatK1',...
    'filteccentricitymedianmatK2','filteccentricitymedianmatK3','filteccentricitystdmatK1','filteccentricitystdmatK2',...
    'filteccentricitystdmatK3','filtdiametervarmatK1','filtdiametervarmatK2','filtdiametervarmatK3',...
    'filtdiametermeanmatK1','filtdiametermeanmatK2','filtdiametermeanmatK3','filtdiametermedianmatK1',...
    'filtdiametermedianmatK2','filtdiametermedianmatK3','filtdiameterstdmatK1','filtdiameterstdmatK2',...
    'filtdiameterstdmatK3','filtmeanIntensityvarmatK1','filtmeanIntensityvarmatK2','filtmeanIntensityvarmatK3',...
    'filtmeanIntensitymeanmatK1','filtmeanIntensitymeanmatK2','filtmeanIntensitymeanmatK3',...
    'filtmeanIntensitymedianmatK1','filtmeanIntensitymedianmatK2','filtmeanIntensitymedianmatK3',...
    'filtmeanIntensitystdmatK1','filtmeanIntensitystdmatK2','filtmeanIntensitystdmatK3','filtentropyRedvarmatK1',...
    'filtentropyRedvarmatK2','filtentropyRedvarmatK3','filtentropyRedmeanmatK1','filtentropyRedmeanmatK2',...
    'filtentropyRedmeanmatK3','filtentropyRedmedianmatK1','filtentropyRedmedianmatK2','filtentropyRedmedianmatK3',...
    'filtentropyRedstdmatK1','filtentropyRedstdmatK2','filtentropyRedstdmatK3','filtratioRedBbluevarmatK1',...
    'filtratioRedBbluevarmatK2','filtratioRedBbluevarmatK3','filtratioRedBbluemeanmatK1','filtratioRedBbluemeanmatK2',...
    'filtratioRedBbluemeanmatK3','filtratioRedBbluemedianmatK1','filtratioRedBbluemedianmatK2',...
    'filtratioRedBbluemedianmatK3','filtratioRedBbluestdmatK1','filtratioRedBbluestdmatK2','filtratioRedBbluestdmatK3',...
    'filtratioRedGreenvarmatK1','filtratioRedGreenvarmatK2','filtratioRedGreenvarmatK3','filtratioRedGreenmeanmatK1',...
    'filtratioRedGreenmeanmatK2','filtratioRedGreenmeanmatK3','filtratioRedGreenmedianmatK1',...
    'filtratioRedGreenmedianmatK2','filtratioRedGreenmedianmatK3','filtratioRedGreenstdmat','filtratioRedGreenstdma2',...
    'filtratioRedGreenstdma3'};

end

