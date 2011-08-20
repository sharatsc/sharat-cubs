%--------------------------------------------------------------------------
%  Version 1.0 March 2005
%  Copyright (c) 2005-2010 by Center for Unified Biometrics and Sensors
%  www.cubs.buffalo.edu
%
%segment_print
%segments the fingerprint region from the background based on morphological
%operations
%syntax:
% [msk]= segment_print(img,iters,verbose)
% img       - original image 
% verbose   - a value of 1 displays intermediate results
%Contact:
%   ssc5@cubs.buffalo.edu, sharat@mit.edu
%   http://www.sharat.org
%--------------------------------------------------------------------------
function msk    =   segment_print(img,verbose)
    [ht,wt]     =   size(img);
    y           =   im2double(img);
    img         =   im2double(img);
    ITERS       =   4;
    %-----------------
    %compute the mask
    %-----------------
    for i=1:ITERS
        y           =   imerode(y,ones(5,5));      %diffuse blob
        c           =   y.^2;                       %enhance contrast
        msk         =   ~im2bw(c,otsu_threshold(c)); %find mask
        %---------------------------------------------------
        %remove sections that might grow to join main blob
        %---------------------------------------------------
        if(i == 2)
            small       =   msk & ~bwareaopen(msk,floor(0.2*ht*wt),4);
            y(small==1) =   sum(sum(img))/(ht*wt);
        end;

        %---------------------------------------------------
        %display intermediate result
        %---------------------------------------------------
        if(verbose==1)
            subplot(1,4,1),imagesc(img),title('Original');
            subplot(1,4,2),imagesc(y),title('Eroded');
            subplot(1,4,3),imagesc(c);colormap('gray'),title('Enhanced');
            subplot(1,4,4),imagesc(msk),title('Segmented');
            pause;
            drawnow;
        end;
    end;
    %----------------------------------------
    %get the largest blob as the fingerprint
    %----------------------------------------
    msk = bwareaopen(msk,round(0.4*ht*wt));
    msk = imerode(msk,ones(7,7));           %erode boundary
    msk = imfill(msk,'holes');              %fill holes

    %---------------------------------------------------
    %display final result
    %---------------------------------------------------
    if(verbose==1)
        figure,imagesc(msk.*img),axis image,colormap('gray'),title('Final');
    end;
%end function isotropic_diffusion

