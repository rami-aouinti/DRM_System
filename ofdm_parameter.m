%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ofdm_parameters.m                                                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autor: Kevin Döring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Date:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% select number of symbols per frame and the min. and max. carrier number
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input:
% mode        : robustness mode
% spec_occ    : spectrum occupancy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output:
% nmb_symbols : number of symbols in one OFDM frame
% min_car     : minimal carrier number
% max_car     : maximal carrier number
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [nmb_symbols min_car max_car] = ofdm_parameter(mode,spec_occ)

% number of symbols for each robustness mode according to table 82
sCarriers = struct(...
    'A',{[   2 102] [2 114] [-102 102] [-114 114] [-98 314] [-110 350]},...
    'B',{[   1  91] [1 103] [ -91  91] [-103 103] [-87 279] [ -99 311]},...
    'C',{[   0   0] [0   0] [   0   0] [ -69  69] [  0   0] [ -67 213]},...
    'D',{[   0   0] [0   0] [   0   0] [ -44  44] [  0   0] [ -43 135]},...
    'E',{[-106 106] [0   0] [   0   0] [   0   0] [  0   0] [   0   0]}...
    );

% select number of symbols and the min and max carrier number
switch mode
    case 'A'
        nmb_symbols = 15;
        [min_car] = sCarriers(spec_occ+1).A(1);
        [max_car] = sCarriers(spec_occ+1).A(2);
    case 'B'
        nmb_symbols = 15;
        [min_car] = sCarriers(spec_occ+1).B(1);
        [max_car] = sCarriers(spec_occ+1).B(2);        
    case 'C'
        nmb_symbols = 20;
        [min_car] = sCarriers(spec_occ+1).C(1);
        [max_car] = sCarriers(spec_occ+1).C(2);       
    case 'D'
        nmb_symbols = 24;
        [min_car] = sCarriers(spec_occ+1).D(1);
        [max_car] = sCarriers(spec_occ+1).D(2);        
    case 'E'
        nmb_symbols = 40;
        [min_car] = sCarriers(spec_occ+1).E(1);
        [max_car] = sCarriers(spec_occ+1).E(2);        
    otherwise
        error('ofdm:mode','Mode does not exist');
end

end % end function

