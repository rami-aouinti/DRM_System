%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% init_fac.m                                                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autor: Kevin Döring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% - initialize the FAC
% - calculate the Interleaving vectors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FAC_QAM = 4; % mapping size of FAC (fixed to 4)

fac.qam_map = qam_map.sm4;
fac.qam_norm = qam_norm.a4;

switch mode
    case {'A','B','C','D'}
        % size of input bitstream of FAC (fixed to 72 in mode A-D)
        fac.Nmb_input_bits = 72; 
        fac.punc_pat0 = sPunc_pat(1).Rp35;
    case 'E'
        % size of input bitstream of FAC (fixed to 72 in mode A-D)
        fac.Nmb_input_bits = 116; 
        fac.punc_pat0 = sPunc_pat(1).Rp14;
    otherwise
        error('fac:mode','Mode does not exist');
end
    
fac.NmbQAMcells = qam_cells_select(mode,spec_occupancy,'FAC');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate and select permutation (interleaving) vector for fac

P = bit_interleaving(fac.NmbQAMcells,FAC_QAM);

fac.interleave_P0 = (P(1,:)+1)';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% remove all temporary variables used for calculating

clear('P');
