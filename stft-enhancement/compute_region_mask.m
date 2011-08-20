%------------------------------------------------------------------------
%compute_region_mask
%computes the region mask based on the energy image output by 
%fft_enhance_cubs.m
%Usage:
% msk = compute_region_mask(eimg,nHt,nWt)
% eimg - energy image output by fft_enhance_cubs
% nHt  - height of the Original image (used to resize the block mask)
% nWt  - width of the original image (used to resize the block mask)
%Contact:
%   ssc5@cubs.buffalo.edu
%   http://www.sharat.org
%Reference:
%Digital Image Processing, Gonzales and Woods,
%------------------------------------------------------------------------
function msk = compute_region_mask(eimg,nHt,nWt)
    eimg = sqrt(imscale(eimg));
    eimg = imfilter(eimg,fspecial('gaussian',3));
    msk  = im2bw(eimg,graythresh(eimg));
    msk  = imclose(msk,ones(2,2));
    %---------------------
    %remove small elements
    %---------------------
    [ht,wt] = size(msk);
    msk     = bwareaopen(msk,floor(0.2*ht*wt));
    msk     = imresize(msk,[nHt nWt]);
%end function compute_region_mask