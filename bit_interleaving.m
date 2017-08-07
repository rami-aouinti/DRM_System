%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% bit_interleaving.m                                                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autor: Kevin Döring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% Calculate permutation vector for bit interleaving (General Block
% Interleaver in channel encoders)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input:
% N   : number of bits to be permuted
% qam : QAM type (4,16 or 64)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output:
% Pb  : permutation vectors (contain indexes for interleaving)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Pb] = bit_interleaving(N,qam)

% select parameters depending on QAM type
if qam == 4
    tp(1) = 21;
    p = 1;
end
if qam == 16
        tp(1) = 13;
        tp(2) = 21;
        p = 2;
end
if qam == 64
        tp(2) = 13;
        tp(3) = 21;
        p = 3;
end;
        
xin = 2*N;

Pb = zeros(1,xin); % allocate memory for permutation vector

s = 2^ceil(log2(xin));

q = s/4-1;

Pb(1,1) = 0;
Pb(2,1) = 0;
Pb(3,1) = 0;

% build permutation vectors for all coding branches
for j=1:p
    for i=2:xin
        Pb(j,i)=mod((tp(j)*Pb(j,i-1)+q),s);
        while Pb(j,i) >= xin
            Pb(j,i)=mod((tp(j)*Pb(j,i)+q),s);
        end
    end
end

end % end function

