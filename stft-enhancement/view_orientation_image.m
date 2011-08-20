%------------------------------------------------------------------------
%view_orientation_image
%Displays the orientation image as a quiver plot
%usage:
%view_orientation(o,[eimg])
%o      - orientation image(obtained by fft_enhance_cubs.m or
%eimg   - energy image(optional argument)
%orientation_image_rao.m)
%
%Contact:
%   ssc5@cubs.buffalo.edu/sharat@mit.edu
%   http://www.sharat.org
%------------------------------------------------------------------------
function view_orientation_image(o,varargin)
    [h,w]   =   size(o);
    x       =   0:w-1;
    y       =   0:h-1;
    if(nargin == 1)
        quiver(x,y,cos(o),sin(o)); 
    else
        e = varargin{1};
        imagesc(e);
        quiver(x,y,e.*cos(o),e.*sin(o));
    end;
    axis([0 w 0 h]),axis image, axis ij;
%end function view_orieintation_image