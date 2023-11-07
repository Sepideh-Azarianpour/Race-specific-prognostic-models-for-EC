function [M,err]=getMask(maskFile,C_maskFile,curTile,circlePixels)
err=0;
M=0;
if exist(maskFile,'file')~=2
    try
        M=getWatershedMask(curTile,true,4,10);
        imwrite(M,maskFile);
        M = M.*circlePixels;
        imwrite(M,C_maskFile);
    catch ex
        fprintf('Error creating the segmentation mask: %s\n',ex.message);
        err=1;
    end
else
    M=imread(C_maskFile);
end
end

