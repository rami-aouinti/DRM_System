%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% init_msc.m                                                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autor: Kevin Döring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Date:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% - initialize the MSC
% - defines the subsystems from the MSC-libraries depending on QAM-type
% - calculate the Interleaving vectors, puncturing patterns 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MSC simulink variants of channel coding

if (MSC_QAM == 64)
    set_param(strcat(model_type,'MSC channel encoder'),'BlockChoice','64QAM');
    set_param(strcat(model_type,'MSC channel decoder'),'BlockChoice','64QAM');
elseif (MSC_QAM == 16)
    set_param(strcat(model_type,'MSC channel encoder'),'BlockChoice','16QAM');
    set_param(strcat(model_type,'MSC channel decoder'),'BlockChoice','16QAM');      
elseif (MSC_QAM == 4)
    set_param(strcat(model_type,'MSC channel encoder'),'BlockChoice','4QAM');
    set_param(strcat(model_type,'MSC channel decoder'),'BlockChoice','4QAM');    
else
    error('msc:qam_type','MSC QAM type does not exist');
end

% select QAM mapping and normalization factor
if (MSC_QAM == 64)
    msc.qam_norm = qam_norm.a64;
    msc.qam_map = qam_map.sm64;
elseif (MSC_QAM == 16)  
    msc.qam_norm = qam_norm.a16;
    msc.qam_map = qam_map.sm16;    
elseif (MSC_QAM == 4)  
    msc.qam_norm = qam_norm.a4;
    msc.qam_map = qam_map.sm4;
else
    error('msc:qam_type','MSC QAM type does not exist');
end

% number of QAM cells for MSC( depents on robustness mode and spectrum
% occupancy)
msc.NmbQAMcells = qam_cells_select(mode,spec_occupancy,'MSC');  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% select puncturing pattern for the different coders and protection levels
switch mode
    case {'A','B','C','D'}
        if (MSC_QAM == 64)
            switch msc.protection_level
                case 0
                    [msc.punc_pat0 RX0 RY0] = sPunc_pat.Rp14;
                    [msc.punc_pat1 RX1 RY1] = sPunc_pat.Rp12;
                    [msc.punc_pat2 RX2 RY2] = sPunc_pat.Rp34;
                case 1
                    [msc.punc_pat0 RX0 RY0] = sPunc_pat.Rp13;
                    [msc.punc_pat1 RX1 RY1] = sPunc_pat.Rp23;
                    [msc.punc_pat2 RX2 RY2] = sPunc_pat.Rp45;
                case 2
                    [msc.punc_pat0 RX0 RY0] = sPunc_pat.Rp12;
                    [msc.punc_pat1 RX1 RY1] = sPunc_pat.Rp34;
                    [msc.punc_pat2 RX2 RY2] = sPunc_pat.Rp78;
                case 3
                    [msc.punc_pat0 RX0 RY0] = sPunc_pat.Rp23;
                    [msc.punc_pat1 RX1 RY1] = sPunc_pat.Rp45;
                    [msc.punc_pat2 RX2 RY2] = sPunc_pat.Rp89;
                otherwise
                    error('msc:protection_level',...
                    'Protection level is not defined for MSC with 64-QAM in mode A-D');
            end
        elseif (MSC_QAM == 16)
            switch msc.protection_level
                case 0
                    [msc.punc_pat0 RX0 RY0] = sPunc_pat.Rp13;
                    [msc.punc_pat1 RX1 RY1] = sPunc_pat.Rp23;
                case 1
                    [msc.punc_pat0 RX0 RY0] = sPunc_pat.Rp12;
                    [msc.punc_pat1 RX1 RY1] = sPunc_pat.Rp34;
                otherwise
                    error('msc:protection_level',...
                    'Protection level is not defined for MSC with 16-QAM in mode A-D');
            end
        else
                error('msc:qam','MSC QAM type does not exist for mode A-D');
        end
    case 'E'
        if (MSC_QAM == 4)
            switch msc.protection_level
                case 0
                    [msc.punc_pat0 RX0 RY0] = sPunc_pat.Rp14;
                case 1
                    [msc.punc_pat0 RX0 RY0] = sPunc_pat.Rp13;
                case 2
                    [msc.punc_pat0 RX0 RY0] = sPunc_pat.Rp25;
                case 3
                    [msc.punc_pat0 RX0 RY0] = sPunc_pat.Rp12;
                otherwise
                    error('msc:protection_level',...
                    'Protection level is not defined for MSC with 4-QAM in mode E');
            end
        elseif (MSC_QAM == 16)
            switch msc.protection_level
                case 0
                    [msc.punc_pat0 RX0 RY0] = sPunc_pat.Rp16;
                    [msc.punc_pat1 RX1 RY1] = sPunc_pat.Rp12;
                case 1
                    [msc.punc_pat0 RX0 RY0] = sPunc_pat.Rp14;
                    [msc.punc_pat1 RX1 RY1] = sPunc_pat.Rp47;
                case 2
                    [msc.punc_pat0 RX0 RY0] = sPunc_pat.Rp13;
                    [msc.punc_pat1 RX1 RY1] = sPunc_pat.Rp23;
                case 3
                    [msc.punc_pat0 RX0 RY0] = sPunc_pat.Rp12;
                    [msc.punc_pat1 RX1 RY1] = sPunc_pat.Rp34;
                otherwise
                    error('msc:protection_level',...
                    'Protection level is not defined for MSC with 16-QAM in mode E');
            end            
        else
                error('msc:qam','MSC QAM type does not exist for mode E');
        end            
    otherwise
        error('msc:mode','Mode does not exist');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate the index for bitstream partitioning section 7.3.1.1

if (MSC_QAM == 4)
    M0 = RX0 *floor((2*msc.NmbQAMcells-12)/RY0);    
    msc.Nmb_input_bits = M0;
    
elseif (MSC_QAM == 16)    
    M0 = RX0 *floor((2*msc.NmbQAMcells-12)/RY0);
    M1 = RX1 *floor((2*msc.NmbQAMcells-12)/RY1);
    
    msc.Nmb_input_bits = M1 + M0;  % number of input bits for SDC bitstream
    
    % calculate the indexes for partitioning of the bitstream
    msc.ind_M1 = M0+1;            % index for encoder bitstream C1
    msc.ind_M0 = M0;        % index for encoder bitstream C0  
    
elseif (MSC_QAM == 64)
    M0 = RX0 * floor(( 2 * msc.NmbQAMcells - 12) / RY0);
    M1 = RX1 * floor(( 2 * msc.NmbQAMcells - 12) / RY1);
    M2 = RX2 * floor(( 2 * msc.NmbQAMcells - 12) / RY2);

    % number of input bits for MSC bitstream (EEP)
    msc.Nmb_input_bits = M0 + M1 + M2;    

    % calculate the index for partitioning of the bitstream
    msc.ind_M2 = M2 - 1;                % index for encoder bitstream C2
    msc.ind_M1 = M0 + M1;           % index for encoder bitstream C1
    msc.ind_M0 = M0;                % index for encoder bitstream C0    
else
    error('msc:qam','QAM mapping type does not exist for MSC');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tailbit puncturing for MSC

if (MSC_QAM == 4)
    % calculate the puncturing pattern for the selected coderate
    rp0 = (2*msc.NmbQAMcells-12)-RY0 * floor((2*msc.NmbQAMcells-12)/RY0); 

    % select pattern and index for sdc tailbits
    [msc.punc_tail0 , msc.ind_tail0] = tailbit_select(rp0);
    
elseif (MSC_QAM == 16)
    % calculate the puncturing pattern for the selected coderate
    rp0 = (2*msc.NmbQAMcells-12)-RY0 * floor((2*msc.NmbQAMcells-12)/RY0); 
    rp1 = (2*msc.NmbQAMcells-12)-RY1 * floor((2*msc.NmbQAMcells-12)/RY1);
    % select pattern and index for sdc tailbits
    [msc.punc_tail0 , msc.ind_tail0] = tailbit_select(rp0);
    [msc.punc_tail1 , msc.ind_tail1] = tailbit_select(rp1);

elseif (MSC_QAM == 64)
    % calculate the puncturing pattern for coderate
    rp0 = (2*msc.NmbQAMcells-12)-RY0*floor((2*msc.NmbQAMcells-12)/RY0); 
    rp1 = (2*msc.NmbQAMcells-12)-RY1*floor((2*msc.NmbQAMcells-12)/RY1); 
    rp2 = (2*msc.NmbQAMcells-12)-RY2*floor((2*msc.NmbQAMcells-12)/RY2); 

    % select pattern and index for msc tailbits
    [msc.punc_tail0 , msc.ind_tail0] = tailbit_select(rp0);
    [msc.punc_tail1 , msc.ind_tail1] = tailbit_select(rp1);
    [msc.punc_tail2 , msc.ind_tail2] = tailbit_select(rp2);

else
    error('msc:qam','QAM mapping type does not exist for MSC');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate and select permutation (interleaving) vector for msc bit
% interleaving

if (MSC_QAM == 4)
    P = bit_interleaving(msc.NmbQAMcells,MSC_QAM);
    msc.interleave_P0 = (P(1,:)+1)';
    
elseif (MSC_QAM == 16)
    P = bit_interleaving(msc.NmbQAMcells,MSC_QAM);
    msc.interleave_P0 = (P(1,:)+1)';
    msc.interleave_P1 = (P(2,:)+1)';
    
elseif (MSC_QAM == 64)
    P = bit_interleaving(msc.NmbQAMcells,MSC_QAM);
    msc.interleave_P1 = (P(2,:)+1)';
    msc.interleave_P2 = (P(3,:)+1)';
    
else
    error('msc:qam','QAM mapping type does not exist for MSC');
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate and select permutation (interleaving) vector for msc cell-
% interleaving

P = cell_interleaving(msc.NmbQAMcells);
msc.cell_interleave_P = (P(:)+1);


% calculate values for long interleaving
msc.long_interleave_vec = 0:msc.NmbQAMcells-1;

if (msc.long_interleaving == 1)
    if strcmp(mode,'E')
        msc.long_interleave_vec = mod(msc.long_interleave_vec,6)';
        msc.long_interleave_depth = 5;
    else
        msc.long_interleave_vec = mod(msc.long_interleave_vec,5)';
        msc.long_interleave_depth = 4;
    end
else
        msc.long_interleave_vec = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% remove all temporary variables used for calculating

clear('RX0','RX1','RX2','RY0','RY1','RY2');
clear('rp0','rp1','rp2');
clear('M0','M1','M2');
clear('P');


