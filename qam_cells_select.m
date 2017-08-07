%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% qam_cells_select.m                                                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autor: Kevin Döring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Date:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% Choose number of QAM cells for SDC and MSC (needed for bitstream
% partitioning and permutation)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input:
% mode          : robustness mode
% spec_occ      : spectrum occupancy
% channel       : multiplex channel (SDC or MSC)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output:
% nmb_qam_cells : number of QAM cells
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ nmb_qam_cells ] = qam_cells_select ( mode, spec_occ, channel )

% number of QAM cells for SDC according to table 60
sNsdc = struct(...
    'A',{167 190 359 405 754 846},...
    'B',{130 150 282 322 588 662},...
    'C',{  0   0   0 288   0 607},...
    'D',{  0   0   0 152   0 332},...
    'E',{936   0   0   0   0   0}...
);

% number of QAM cells for MSC according to table 76 - 80
sNmsc = struct(...
    'A',{1259 1422 2632 2959 5464 6118},...
    'B',{ 966 1110 2051 2337 4249 4774},...
    'C',{   0    0    0 1844    0 3867},...
    'D',{   0    0    0 1226    0 2606},...
    'E',{7460    0    0    0    0    0}...
);

if (spec_occ > 5)
    error('qam_cells:spec_occ','Spectrum occupancy does not exist');
end

if strcmp(channel,'SDC')
    switch mode
        case 'A'
            nmb_qam_cells = sNsdc(spec_occ+1).A;
        case 'B'
            nmb_qam_cells = sNsdc(spec_occ+1).B;
        case 'C'
            nmb_qam_cells = sNsdc(spec_occ+1).C;
        case 'D'
            nmb_qam_cells = sNsdc(spec_occ+1).D;
        case 'E'
            nmb_qam_cells = sNsdc(spec_occ+1).E;
        otherwise
            error('qam_cells:mode','Mode does not exist');
    end
elseif strcmp(channel,'MSC')
    switch mode
        case 'A'
            nmb_qam_cells = sNmsc(spec_occ+1).A;
        case 'B'
            nmb_qam_cells = sNmsc(spec_occ+1).B;
        case 'C'
            nmb_qam_cells = sNmsc(spec_occ+1).C;
        case 'D'
            nmb_qam_cells = sNmsc(spec_occ+1).D;
        case 'E'
            nmb_qam_cells = sNmsc(spec_occ+1).E;
        otherwise
            error('qam_cells:mode','Mode does not exist');
    end
elseif strcmp(channel,'FAC')
    switch mode
        case {'A','B','C','D'}
            nmb_qam_cells = 65; % number of FAC QAM cells (fixed to 65 in mode A-D)
        case 'E'
            nmb_qam_cells = 244; % number of FAC QAM cells (fixed to 65 in mode A-D)
    end
else 
    error('qam_cells:channel','Channel does not exist');
end

if (nmb_qam_cells == 0)
    error('qam_cells:constellation','The selected constellation of mode and spectrum occupancy is not supported');
end

end % end function

