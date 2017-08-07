%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dummy_cells.m                                                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autor: Kevin Döring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Date: May 2010
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% Calculate number and values of dummy cells to fill the complete 
% OFDM superframe
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input:
% mode       : mode
% spec_occ   : spectrum occupancy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output:
% nmb_dummy  : number of dummy cells
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [nmb dummy] = dummy_cells(mode, spec_occ)

% number of dummy cells according to tables 76-80
Nmb_dummy_cells = [ 1,2,1,0,2,0;
                    2,0,0,2,0,1;
                    0,0,0,0,0,2;
                    0,0,0,1,0,1;
                    2,0,0,0,0,0];

switch mode
    case 'A'
        nmb = Nmb_dummy_cells(1,spec_occ+1);
    case 'B'
        nmb = Nmb_dummy_cells(2,spec_occ+1);                
    case 'C'
        nmb = Nmb_dummy_cells(3,spec_occ+1); 
    case 'D'
        nmb = Nmb_dummy_cells(4,spec_occ+1); 
    case 'E'
        nmb = Nmb_dummy_cells(5,spec_occ+1);
end

% values of dummy cells according to table 81
if nmb == 1
    dummy = 1+1i;
elseif nmb == 2
    dummy = [1+1i, 1-1i];
else
    dummy = 0;
end

end % end function

