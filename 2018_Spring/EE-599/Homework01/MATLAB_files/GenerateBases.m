function [T_dct, T_haar] = GenerateBases(N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Block-based DCT  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Generates N DCT basis vectors (N-dimensional)

N_b = 64;  % block size
T_dct = [];

% create a block diagonal matrix w/ blocks of size N_b x N_b
for m = 1:N/N_b
    T_dct = blkdiag(T_dct, dctmtx(N_b));
end


%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Dyadic Haar  %%%%
%%%%%%%%%%%%%%%%%%%%%%%

% Generates N Haar basis vectors (N-dimensional)

[h_lo, h_hi] = wfilters('haar');

L = log2(N);
T_haar = zeros(N,N);
m = 1;

while m <= N
    ind = fliplr(dec2bin(m-1));
    
    clear temp1
    for kk = 1:length(ind)
        temp1(kk) = str2num( ind(kk) );
    end
    
    for kk = length(ind)+1:L
        temp1(kk) = 0;
    end
    temp1 = fliplr(temp1);
    
    kmax = 1;
    while temp1(kmax) == 0
        kmax = kmax+1;
        
        if kmax > L
            kmax = kmax-1;
            break;
        end
    end
    
    if kmax < L
        kmax = kmax-1;
    else
        kmax = kmax-1;
    end
    
    if temp1(1) == 0
        y = h_lo;
    else
        y = h_hi;
    end
    
    for kk = 2:kmax+1
        if temp1(kk) == 0
            y = conv(y, upsample(h_lo,2^(kk-1)));
        else
            y = conv(y, upsample(h_hi,2^(kk-1)));
        end
    end
    
    y = y(find(y~=0));
    
    for kk = 1:N/length(y)
        T_haar(m,(kk-1)*length(y)+1:kk*length(y)) = y;
        m = m+1;
    end
end