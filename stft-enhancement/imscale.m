%-----------------------------------------------------
%imscale
%normalizes the image to range [0-1]
%-----------------------------------------------------
function y = imscale(x)
    mn = min(min(x));
    mx = max(max(x));
    y  = (x-mn)/(mx-mn);
%end function imscale