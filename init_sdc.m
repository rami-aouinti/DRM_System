%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% init_sdc.m                                                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autor: Kevin Döring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Date:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% - initialize the MSC
% - defines the subsystems from the SDC-libraries depending on QAM-type
% - calculate the Interleaving vectors, puncturing patterns 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% number of QAM cells for SDC: 
% depents on robustness mode and spectrum occupancy
sdc.NmbQAMcells = qam_cells_select(mode,spec_occupancy,'SDC');    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% select puncturing pattern for the different coders and protection levels
switch mode
    case {'A','B','C','D'}
        if (sdc.protection_level == 0)
                SDC_QAM = 16;
                % TR 
                set_param(strcat(model_type,'SDC channel coder'),'BlockChoice','16QAM');
                set_param(strcat(model_type,'SDC channel decoder'),'BlockChoice','16QAM');
                [sdc.punc_pat0 RX0 RY0] = sPunc_pat.Rp13;
                [sdc.punc_pat1 RX1 RY1] = sPunc_pat.Rp23;     
        elseif (sdc.protection_level == 1)
                SDC_QAM = 4;
                % TR 
                set_param(strcat(model_type,'SDC channel coder'),'BlockChoice','4QAM');
                set_param(strcat(model_type,'SDC channel decoder'),'BlockChoice','4QAM');
                [sdc.punc_pat0 RX0 RY0] = sPunc_pat.Rp12;
        else
                error('sdc:protection_level',...
                'Protection level is not defined for SDC');
        end
    case 'E'
        SDC_QAM = 4;
        set_param(strcat(model_type,'SDC channel coder'),'BlockChoice','4QAM');
        set_param(strcat(model_type,'SDC channel decoder'),'BlockChoice','4QAM');
        if (sdc.protection_level == 0)
                [sdc.punc_pat0 RX0 RY0] = sPunc_pat.Rp12;
        
        elseif (sdc.protection_level == 1)
                [sdc.punc_pat0 RX0 RY0] = sPunc_pat.Rp14;
        else
                error('sdc:protection_level',...
                'Protection level is not defined for SDC');
        end
    otherwise
        error('sdc:mode','Mode does not exist');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate the index for bitstream partitioning section 7.3.1.1

if (SDC_QAM == 4)
    M0 = RX0 *floor((2*sdc.NmbQAMcells-12)/RY0);
    % number of input bits for SDC bitstream
    sdc.Nmb_input_bits = M0;
    
elseif (SDC_QAM == 16)
    M0 = RX0 *floor((2*sdc.NmbQAMcells-12)/RY0);
    M1 = RX1 *floor((2*sdc.NmbQAMcells-12)/RY1);
    % number of input bits for SDC bitstream
    sdc.Nmb_input_bits = M1 + M0;
    
    % calculate the indexes for partitioning of the bitstream
    sdc.ind_M1 = M0+1;            % index for encoder bitstream C1
    sdc.ind_M0 = M0;        % index for encoder bitstream C0  
    
else
    error('sdc:qam','QAM mapping type does not exist for SDC');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tailbit puncturing for SDC

if (SDC_QAM == 4)
    % calculate the puncturing pattern for the selected coderate
    rp0 = (2*sdc.NmbQAMcells-12)-RY0 * floor((2*sdc.NmbQAMcells-12)/RY0); 
    % select pattern and index for sdc tailbits
    [sdc.punc_tail0 , sdc.ind_tail0] = tailbit_select(rp0);
    
elseif (SDC_QAM == 16)
    % calculate the puncturing pattern for the selected coderate
    rp0 = (2*sdc.NmbQAMcells-12)-RY0 * floor((2*sdc.NmbQAMcells-12)/RY0); 
    rp1 = (2*sdc.NmbQAMcells-12)-RY1 * floor((2*sdc.NmbQAMcells-12)/RY1);
    % select pattern and index for sdc tailbits
    [sdc.punc_tail0 , sdc.ind_tail0] = tailbit_select(rp0);
    [sdc.punc_tail1 , sdc.ind_tail1] = tailbit_select(rp1);
    
else
    error('sdc:qam','QAM mapping type does not exist for SDC');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate and select permutation (interleaving) vector for sdc

if (SDC_QAM == 4)
    P = bit_interleaving(sdc.NmbQAMcells,SDC_QAM);
    sdc.interleave_P0 = (P(1,:)+1)';
    
elseif (SDC_QAM == 16)
    P = bit_interleaving(sdc.NmbQAMcells,SDC_QAM);
    sdc.interleave_P0 = (P(1,:)+1)';
    sdc.interleave_P1 = (P(2,:)+1)';
    
else
    error('sdc:qam','QAM mapping type does not exist for SDC');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% select mapping constellation and normalization

if (SDC_QAM == 4)
    sdc.qam_map = qam_map.sm4;
    sdc.qam_norm = qam_norm.a4;
elseif (SDC_QAM == 16)
    sdc.qam_map = qam_map.sm16;
    sdc.qam_norm = qam_norm.a16;
else
    error('sdc:qam','QAM mapping type does not exist for SDC');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% remove all temporary variables used for calculating

clear('RX0','RX1','RY0','RY1');
clear('rp0','rp1');
clear('M1','M0');
clear('P');
