function [ feat,featDescription] = getClusterAreaMeasures( lympMembers,lympNodes,nonLympMembers,nonLympNodes )
%GETCLUSTERAREAMEASURES Summary of this function goes here
%   Detailed explanation goes here

[lympTot,lymAvg,lymMedian,lymStd,lymMode]=getAreaMeasures(lympMembers,lympNodes);
[nonLympTot,nonLymAvg,nonLymMedian,nonLymStd,nonLymMode]=getAreaMeasures(nonLympMembers,nonLympNodes);

feat=[lympTot,lymAvg,lymMedian,lymStd,lymMode,nonLympTot,nonLymAvg,...
    nonLymMedian,nonLymStd,nonLymMode];
featDescription={'lympTotArea','lymAvgArea','lymMedianArea','lymStdArea',...
    'lymModeArea','nonLympTotArea','nonLymAvgArea','nonLymMedianArea',...
    'nonLymStdArea','nonLymModeArea'};

%calculate intersected areas?

end

function [totalArea,avgArea,medianArea,stdArea,modeArea]=getAreaMeasures(members,nodes)
numMembers=length(members);
areas=[];
for i = 1:numMembers
    member = members{i};
    col = nodes.centroid_c(member)';
    row = nodes.centroid_r(member)';
    
    if length(col) >  2
        [k,a] = convhull(col,row);
        areas=[areas;a];
    end
end
totalArea=sum(areas);
avgArea=mean(areas);
medianArea=median(areas);
stdArea=std(areas);
modeArea=mode(areas);

end
