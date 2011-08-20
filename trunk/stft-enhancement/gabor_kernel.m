%------------------------------------------------------------------------
%gabor_kernel
%creates a 2D gabor convolution mask
%------------------------------------------------------------------------
function [gr,gi] = gabor_kernel(dx,dy,f,theta)
    dx    = round(dx);
    dy    = round(dy);
    [x,y] = meshgrid(-3*dx:3*dx,-3*dy:3*dy);
    xp    = x*cos(theta)+y*sin(theta);
    yp    = -x*sin(theta)+y*cos(theta);
    gr     = exp(-xp.^2/dx.^2-yp.^2/dy.^2).*cos(2*pi/f*xp);
    gi     = exp(-xp.^2/dx.^2-yp.^2/dy.^2).*sin(2*pi/f*xp);
%end function gabor_kernel