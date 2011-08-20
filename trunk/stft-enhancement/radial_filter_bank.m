%----------------------------------------------------------
%radial_filter_bank
%precomputes radial filter  and also generates a C
%header file with filter coefficients. The matlab variable
%radf is stored in file 'radial_filters.mat' and the C 
%variables are stored in 'radial_fiter.h'.
%Contact:
%   ssc5@cubs.buffalo.edu
%   http://www.sharat.org
%References:
%S. Chikkerur, C. Wu and V. Govindaraju, "A Systematic Approach for 
%Feature Extraction in Fingerprint Images", ICBA 2004, HK
%B.G.Sherlock and  D.M.Monro and  K.Millard,"Fingerprint Enhancement by
%directional Fourier Filtering",IEEE Visual Image Signal Processing,
%141(2), pp. 87--94, 1994
%----------------------------------------------------------
    global NFFT;
    NFFT        =   32;     %size of FFT
    RMIN        =   3;      %min allowable ridge spacing
    RMAX        =   18;     %maximum allowable ridge spacing
    ETHRESH     =   6;      %threshold for the energy
    %-------------------------
    %precomputations
    %-------------------------
    [x,y]       =   meshgrid(-NFFT/2:NFFT/2-1,-NFFT/2:NFFT/2-1);
    r           =   sqrt(x.^2+y.^2)+eps;
    %-------------------------
    %Bandpass filter
    %-------------------------
    FLOW        =   NFFT/RMAX;
    FHIGH       =   NFFT/RMIN;
    
    dRLow       =   1./(1+(r/FHIGH).^4);    %low pass butterworth filter
    dRHigh      =   1./(1+(FLOW./r).^4);    %high pass butterworth filter
    dBPass      =   dRLow.*dRHigh;          %bandpass
    filter      =   dBPass(:);
    %-----------------
    %save the filters
    %-----------------
    imagesc(dBPass),pause;
    radf = filter;
    save radial_filter radf;
%----------------------
%write to a C file
%----------------------
fp = fopen('radial_filter.h','w');
fprintf(fp,'{\n');
for i = 1:size(filter,2)
    i
    k = 1;
    fprintf(fp,'{');
    for j = 1:size(filter,1)
        fprintf(fp,'%f,',filter(j,i));
        if(k == 32) k=0; fprintf(fp,'\n'); end;
        k = k+1;
    end;
    fprintf(fp,'},\n');
end;
fprintf(fp,'};\n');
fclose(fp);
%end function radial_filter_bank
