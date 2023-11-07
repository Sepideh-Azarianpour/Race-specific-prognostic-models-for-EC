function drawGraphsAndConvexHull_Disp(I,V30,V41, coords,colors,r,alpha,visFile,list)
a=alpha;
numGroups=length(coords);



% figure
% imshow((V41),'Border','tight');
% hold on;
% drawGraph_standard_thick(coords,MM,colors);
% drawGraph_boundary_standard(coords,colors,a,r,3,3);
% saveas(gcf,[visFile, '_4.png'])
MM=cell(numGroups,1);
for i=list(1)
    b=a(i);
    [~,~,~,~,groupMatrix] = construct_nodesCluster_new(struct('centroid_r',coords{i}(:,2)','centroid_c',coords{i}(:,1)'), b, r);
    MM{i}=groupMatrix;
end
figure
imshow(ones(size(V41)),'Border','tight');
hold on;
drawcentroid_standard(coords,MM,colors);
saveas(gcf,[visFile, '_G1_cent.png'])


figure
imshow(ones(size(V41)),'Border','tight');
hold on;
drawGraph_standard_thick(coords,MM,colors);
hold on
drawGraph_convexHull_standard(coords(list(1)),colors(list(1)),a(list(1)),r,3,3);
saveas(gcf,[visFile, '_G1.png'])

figure
imshow(ones(size(V41)),'Border','tight');
hold on;
drawGraph_standard_thick(coords,MM,colors);
hold on
saveas(gcf,[visFile, '_G1_a5_v2.png'])


figure
imshow(ones(size(V41)),'Border','tight');
hold on
drawGraph_convexHull_standard(coords(list(1)),colors(list(1)),a(list(1)),r,3,3);
saveas(gcf,[visFile, '_G1_a5.png'])



figure
imshow(V41,'Border','tight');
hold on;
drawGraph_convexHull_standard(coords(list(1)),colors(list(1)),a(list(1)),r,3,3);
saveas(gcf,[visFile, '_G1_a5_back.png'])


figure
imshow(V41,'Border','tight');
hold on;
drawGraph_standard_thick(coords,MM,colors);
hold on
drawGraph_convexHull_standard(coords(list(1)),colors(list(1)),a(list(1)),r,3,3);
saveas(gcf,[visFile, '_G1_back.png'])

%%%%%%%%%%%% Black and white G1
figure
imshow(ones(size(V41)),'Border','tight');
hold on
drawGraph_convexHull_standard_BW(coords(list(1)),colors(list(1)),a(list(1)),r,3,3);
saveas(gcf,[visFile, '_G1_BW.png'])




MM=cell(numGroups,1);
for i=list(2)
    b=a(i);
    [~,~,~,~,groupMatrix] = construct_nodesCluster_new(struct('centroid_r',coords{i}(:,2)','centroid_c',coords{i}(:,1)'), b, r);
    MM{i}=groupMatrix;
end
figure
imshow(ones(size(V41)),'Border','tight');
hold on;
drawGraph_standard_thick(coords,MM,colors);
hold on
drawGraph_convexHull_standard(coords(list(2)),colors(list(2)),a(list(2)),r,3,3);
saveas(gcf,[visFile, '_G2.png'])

figure
imshow(ones(size(V41)),'Border','tight');
hold on;
drawGraph_standard_thick(coords,MM,colors);
hold on
saveas(gcf,[visFile, '_G2_a5_v2.png'])


figure
imshow(ones(size(V41)),'Border','tight');
hold on;
drawGraph_convexHull_standard(coords(list(2)),colors(list(2)),a(list(2)),r,3,3);
saveas(gcf,[visFile, '_G2_a5.png'])

figure
imshow(V41,'Border','tight');
hold on;
drawGraph_standard_thick(coords,MM,colors);
hold on
drawGraph_convexHull_standard(coords(list(2)),colors(list(2)),a(list(2)),r,3,3);
saveas(gcf,[visFile, '_G2_back.png'])

figure
imshow(V41,'Border','tight');
hold on;
drawGraph_convexHull_standard(coords(list(2)),colors(list(2)),a(list(2)),r,3,3);
saveas(gcf,[visFile, '_G2_a5_back.png'])
%%%%%%%%%%% G2 Black_White

figure
imshow(ones(size(V41)),'Border','tight');
hold on;
drawGraph_convexHull_standard_BW(coords(list(2)),colors(list(2)),a(list(2)),r,3,3);
saveas(gcf,[visFile, '_G2_BW.png'])

%%% interactions between G1 and G2
MM=cell(numGroups,1);
for i=list
    b=a(i);
    [~,~,~,~,groupMatrix] = construct_nodesCluster_new(struct('centroid_r',coords{i}(:,2)','centroid_c',coords{i}(:,1)'), b, r);
    MM{i}=groupMatrix;
end
figure  %% traditional
imshow(ones(size(V41)),'Border','tight');
hold on;
drawGraph_standard_thick(coords,MM,colors);
hold on
drawGraph_convexHull_standard(coords(list),colors(list),a(list),r,3,3);
saveas(gcf,[visFile, '_G1_G2_a.png'])


figure  %% traditional
imshow(ones(size(V41)),'Border','tight');
hold on;
drawGraph_standard_thick(coords,MM,colors);
saveas(gcf,[visFile, '_G1_G2_a_v2.png'])

figure  %% traditional
imshow(V41,'Border','tight');
hold on;
drawGraph_standard_thick(coords,MM,colors);
hold on
drawGraph_convexHull_standard(coords(list),colors(list),a(list),r,3,3);
saveas(gcf,[visFile, '_G1_G2_a_back.png'])

figure   %%% without graphs without cells
imshow(ones(size(V41)),'Border','tight');
hold on
drawGraph_convexHull_standard(coords(list),colors(list),a(list),r,3,3);
saveas(gcf,[visFile, '_G1_G2_a1.png'])

figure   %%% without graphs 
imshow(V41,'Border','tight');
hold on
drawGraph_convexHull_standard(coords(list),colors(list),a(list),r,3,3);
saveas(gcf,[visFile, '_G1_G2_a1_back.png'])


figure   %%% graphs are removed and non imfill of convex hull
imshow(ones(size(V41)),'Border','tight');
hold on
drawGraph_convexHull_standard_nofill(coords(list),colors(list),a(list),r,3,3);
saveas(gcf,[visFile, '_G1_G2_a2.png'])


figure   %%% graphs are removed and non imfill of convex hull
imshow(V41,'Border','tight');
hold on
drawGraph_convexHull_standard_nofill(coords(list),colors(list),a(list),r,3,3);
saveas(gcf,[visFile, '_G1_G2_a2_back.png'])



%%%%% graphs are removed and non imfill of convex hull+shading overlap


IG1=imresize(rgb2gray(imread([visFile, '_G1_BW.png'])),[size(V41,1),size(V41,2)])>0;
IG2=imresize(rgb2gray(imread([visFile, '_G2_BW.png'])),[size(V41,1),size(V41,2)])>0;
Graphs_simple_back=imresize(imread([visFile, '_G1_G2_a2_back.png']),[size(V41,1),size(V41,2)]);
Graphs_simple=imresize(imread([visFile, '_G1_G2_a2.png']),[size(V41,1),size(V41,2)]);
C=1-or(IG1,IG2);
C=uint8(C);
figure
colors_Intersc=((colors{list(1)}+colors{list(2)})/2);
C_colored=ROImaker_intersected(Graphs_simple_back,C,colors_Intersc);
imshow(C_colored,'Border','tight')
hold on
drawGraph_convexHull_standard_nofill(coords(list),colors(list),a(list),r,3,3);
saveas(gcf,[visFile, '_G1_G2_a3_back.png'])

figure
colors_Intersc=((colors{list(1)}+colors{list(2)})/2);
C_colored=ROImaker_intersected(Graphs_simple,C,colors_Intersc);
imshow(C_colored,'Border','tight')
hold on
drawGraph_convexHull_standard_nofill(coords(list),colors(list),a(list),r,3,3);
saveas(gcf,[visFile, '_G1_G2_a3.png'])









figure
% visboundaries(C,'Color','k','LineWidth',10);
colors_Intersc=(1+(colors{list(1)}+colors{list(2)})/2)/20;
C_colored=ROImaker_intersected(Graphs_simple,C,colors_Intersc);
imshow(C_colored,'Border','tight')
hold on
drawGraph_convexHull_standard_nofill(coords(list),colors(list),a(list),r,3,3);
saveas(gcf,[visFile, '_G1_G2_a4.png'])


figure
% visboundaries(C,'Color','k','LineWidth',10);
colors_Intersc=(1+(colors{list(1)}+colors{list(2)})/2)/20;
C_colored=ROImaker_intersected(Graphs_simple_back,C,colors_Intersc);
imshow(C_colored,'Border','tight')
hold on
drawGraph_convexHull_standard_nofill(coords(list),colors(list),a(list),r,3,3);
saveas(gcf,[visFile, '_G1_G2_a4_back.png'])







 