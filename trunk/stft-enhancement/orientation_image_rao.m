%------------------------------------------------------------------------
%orientation_image_rao
%Computes the orientation image for a fingerprints. 
%Usage:
%[gimg,oimg] = orientation_image_rao(x)
%oimg - orientation image
%gmag - gradient magnitude
%x    - fingerprint image 
%NOTE: The image x dimension should be multiple of 8
%
%Contact:
%   ssc5@eng.buffalo.edu
%   www.eng.buffalo.edu/~ssc5
%Reference:
%A. Ravishankar Rao,"A taxonomy of texture description", Springer Verlag
%------------------------------------------------------------------------
function [gimg,oimg] = orientation_image_rao(x)
    %---------------------------
    %parameters
    %---------------------------
    alpha   =   0.3;
    N       =   16;
    %---------------------------
    %smoothen the image
    %---------------------------
    msk     =   fspecial('gaussian',7);
    x       =   imfilter(x,msk,'symmetric','same');
    x       =   pseudo_matched_filter(x,alpha);

    %---------------------------
    %obtain gradient image
    %---------------------------
    hy      =   -fspecial('sobel')
    hx      =   transpose(hy);
    
    gx      =   imfilter(x,hx,'symmetric','same');
    gy      =   imfilter(x,hy,'symmetric','same');
    
    gmag    =   sqrt(gx.^2+gy.^2);
    theta   =   atan(gy./(gx+1e-5));
    %---------------------------
    %perform averaging
    %---------------------------
    oimg    =   [];
    gimg    =   [];
    [h,w]   =   size(x);
    for ii=1:N:h-N+1
        oln = [];
        gln = [];
        for jj=1:N:w-N+1
            a   = theta(ii:ii+N-1,jj:jj+N-1);
            g   = gmag(ii:ii+N-1,jj:jj+N-1).^2;
            %----------------------------
            %vector averaging
            %----------------------------
            num = sum(sum(g.*sin(2*a)));
            den = sum(sum(g.*cos(2*a)));
            t   = atan2(num,(den+1e-5));
            t(t<0) = t(t<0)+2*pi;
            t   = 0.5*t; %convert to [0,pi]
            g   = sum(sum(g));
            oln = [oln,t];
            gln = [gln,g];
        end;
        gimg = [gimg;gln];
        oimg = [oimg;oln];
    end;
    
    %---------------------------
    %smoothen the orientation image
    %---------------------------
    for i = 1:3
        oimg = smoothen_orientation_image(oimg);
    end;
%end function orientation_image