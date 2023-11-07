function [M,err]=getMask_square(curTile)
err=0;
M=0;
    try
        M=getWatershedMask(curTile,true,8,16);
    catch ex
        fprintf('Error creating the segmentation mask: %s\n',ex.message);
        err=1;
    end
end

