%--------------------------------------------------------
%pad the image to make height and width multiples of N
%--------------------------------------------------------
function y = pad_image(x,N)
    [ht,wt] = size(x);
    padcol  = N-mod(wt,N);
    if(padcol ~= N) %need padding
        padleft = floor(padcol/2);
        padright= padcol-padleft;
        x       = [zeros(ht,padleft),x,zeros(ht,padright)];
    else
        padcol  = 0;
    end;
    padrow  = N-mod(ht,N);
    if(padrow~= N) 
        padtop = floor(padrow/2);
        padbot = padrow-padtop;
        x      = [zeros(padtop,padcol+wt);x;zeros(padbot,padcol+wt)];
    else        
        padrow = 0;
    end;
    %---------------
    %changet ht,wt
    %--------------
    ht = ht+padrow;
    wt = wt+padcol;
    y=x;
%end function pad_image
