%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cell_interleaving.m                                                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autor: Kevin Döring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% Calculate permutation vector for cell interleaving (General Block
% Interleaver in MSC cell interleaver)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input:
% Nmux : number of MSC QAM cells to be permuted
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output:
% Pc  : permutation vectors (contains indexes for interleaving)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Pc] = cell_interleaving(Nmux)

Pc = zeros(1,Nmux); % allocate memory for permutation vector

t0 = 5;
        
s = 2^ceil(log2(Nmux));

q = s/4-1;

Pc(1) = 0;

for i=2:Nmux
    Pc(i)=mod((t0*Pc(i-1)+q),s);
    while Pc(i) >= Nmux
    	Pc(i)=mod((t0*Pc(i)+q),s);
    end
end

end % end function

