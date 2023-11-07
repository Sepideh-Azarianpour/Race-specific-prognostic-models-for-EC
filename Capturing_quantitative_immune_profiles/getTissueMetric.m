 function tiss=getTissueMetric(I)
 bw=I(:,:,2)<210&I(:,:,2)>30;
 tiss=sum(bw(:))/ numel(bw);
 end