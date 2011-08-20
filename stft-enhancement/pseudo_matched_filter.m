%------------------------------------------------------------------------
%pseudo_matched_filter
%Implements root filtering technique to increase SNR of an image
%usage:
%y = pseudo_matched_filter(x,alpha)
%y -  [OUT] enhanced image
%x - [IN] input image
%alpha - [IN] exponent to which the FFT mag is raised. having larger alpha
%        will increase smoothness, but will also introduce artefacts. 
%        optimal - 0.5 to 1
%Contact:
%   ssc5@cubs.buffalo/sharat@mit.edu
%   http://www.sharat.org
%Reference,
% C. I. Watson and G. T. Candela and P. J. Grother,"Comparison of FFT 
% Fingerprint Filtering Methods for Neural Network Classification",
% NISTIR (5493),National Institute of Standards and Technology,1994
%------------------------------------------------------------------------
function out = pseudo_matched_filter(img,alpha)
    BLKSZ       =   16;      %size of the block
    OVRLP       =   8;      %size of overlap
    NFFT        =   64;
    
    [nHt,nWt]   =   size(img);  
    img         =   im2double(img);    %convert to DOUBLE
    
    nBlkHt      =   floor((nHt-2*OVRLP)/BLKSZ);
    nBlkWt      =   floor((nWt-2*OVRLP)/BLKSZ);
    fftSrc      =   zeros(nBlkHt*nBlkWt,NFFT*NFFT); %stores FFT
    nWndSz      =   BLKSZ+2*OVRLP; %size of analysis window. 
    %-------------------------
    %allocate outputs
    %-------------------------
    out         =   zeros(nHt,nWt);
   %-------------------------
    %Block wise enhancement
    %-------------------------
    for i = 0:nBlkHt-1
        nRow = i*BLKSZ+OVRLP+1;  
        for j = 0:nBlkWt-1
            nCol = j*BLKSZ+OVRLP+1;
            %extract local block
            blk     =   img(nRow-OVRLP:nRow+BLKSZ+OVRLP-1,nCol-OVRLP:nCol+BLKSZ+OVRLP-1);
            %remove dc
            dAvg    =   sum(sum(blk))/(nWndSz*nWndSz);
            blk     =   blk-dAvg;   %remove DC content
           %filter
            blk     =   do_pseudo_matched_filter(blk,alpha);
            %put it back
            out(nRow-OVRLP:nRow+BLKSZ+OVRLP-1,nCol-OVRLP:nCol+BLKSZ+OVRLP-1) = blk;
        end;%for j
    end;%for i
%end function

%------------------------------------------------------------------------
%do_pseudo_matched_filter
%driver function
%------------------------------------------------------------------------
function y = do_pseudo_matched_filter(x,alpha)
    [h,w]   =   size(x);
    x       =   double(x);
    f       =   fft2(x);
    f       =   (abs(f).^alpha).*f; %this is all root filtering is about
    y       =   real(ifft2(f));
%end function pseudo_matched_filter