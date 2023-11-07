function drawNucContoursByClass_E_OR_S( M,I,nucCentroids, classes,colors,  tickness, list)
% if nargin<6
%     tickness=3;
% end
list=list-1;
loc_finder=ismember(classes,list);
classes_new= classes(loc_finder);
centroids_new=nucCentroids(loc_finder,:);

numCent=length(centroids_new);

boundaries = bwboundaries(M);
numNucMask = size(boundaries,1);
imshow(I,'Border','tight');
hold on;
for i=1:numNucMask
    b = boundaries{i};
    w=min(b(:,1));
    x=max(b(:,1));
    y=min(b(:,2));
    z=max(b(:,2));
    for j=1:numCent
        if centroids_new(j,1)>y && centroids_new(j,1)<z && centroids_new(j,2)>w && centroids_new(j,2)<x
            plot(b(:,2),b(:,1),'color',colors{classes_new(j)+1},'LineWidth',tickness);
        end
    end
    
end
hold off;
end

