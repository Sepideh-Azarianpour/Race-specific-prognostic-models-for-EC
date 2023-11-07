function perc = getSaturationPercentage(I)
hsv = rgb2hsv(I);
s=hsv(:,:,2);
perc=sum(sum(s))/(size(s,1)*size(s,2));
end

