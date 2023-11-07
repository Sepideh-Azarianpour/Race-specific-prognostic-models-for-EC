function drawCentroids2(V41, coords,colors,r,alpha,visFile)
a=alpha;
numGroups=length(coords);


MM=cell(numGroups,1);
for i=1:2
    b=a(i);
    [~,~,~,~,groupMatrix] = construct_nodesCluster_new(struct('centroid_r',coords{i}(:,2)','centroid_c',coords{i}(:,1)'), b, r);
    MM{i}=groupMatrix;
end
figure
imshow(ones(size(V41)),'Border','tight');
hold on;
drawcentroid_standard(coords,MM,colors);
saveas(gcf,[visFile, '_All_cent.png'])


figure
imshow(V41,'Border','tight');
hold on;
drawcentroid_standard(coords,MM,colors);
saveas(gcf,[visFile, '_ALL_cent_back.png'])
