%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tailbit_select.m                                                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autor: Kevin Döring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% select puncturing pattern of the tailbits
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input:
% rp         : calculated index of the pattern
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output:
% tail_pat   : puncturing pattern of the tailbits
% tail_index : index for depuncture the tailbits in the decoder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [tail_pat,tail_index] = tailbit_select( rp )

% Puncturing patterns of the tailbits according to table 63
% the structure contains patterns and tailbit index

% Indexing the Pattern: sPunc_tail(1).rpxx
% Indexing the index: sPunc_tail(2).rpxx 

sPunc_tail = struct(... 
'rp0' ,{[1 1 0 0 0 0 1 1 0 0 0 0 1 1 0 0 0 0 1 1 0 0 0 0 1 1 0 0 0 0 1 1 0 0 0 0]' 12},...
'rp1' ,{[1 1 1 0 0 0 1 1 0 0 0 0 1 1 0 0 0 0 1 1 0 0 0 0 1 1 0 0 0 0 1 1 0 0 0 0]' 13},...
'rp2' ,{[1 1 1 0 0 0 1 1 0 0 0 0 1 1 0 0 0 0 1 1 1 0 0 0 1 1 0 0 0 0 1 1 0 0 0 0]' 14},...
'rp3' ,{[1 1 1 0 0 0 1 1 1 0 0 0 1 1 0 0 0 0 1 1 1 0 0 0 1 1 0 0 0 0 1 1 0 0 0 0]' 15},...
'rp4' ,{[1 1 1 0 0 0 1 1 1 0 0 0 1 1 0 0 0 0 1 1 1 0 0 0 1 1 1 0 0 0 1 1 0 0 0 0]' 16},...
'rp5' ,{[1 1 1 0 0 0 1 1 1 0 0 0 1 1 1 0 0 0 1 1 1 0 0 0 1 1 1 0 0 0 1 1 0 0 0 0]' 17},...
'rp6' ,{[1 1 1 0 0 0 1 1 1 0 0 0 1 1 1 0 0 0 1 1 1 0 0 0 1 1 1 0 0 0 1 1 1 0 0 0]' 18},...
'rp7' ,{[1 1 1 1 0 0 1 1 1 0 0 0 1 1 1 0 0 0 1 1 1 0 0 0 1 1 1 0 0 0 1 1 1 0 0 0]' 19},...
'rp8' ,{[1 1 1 1 0 0 1 1 1 0 0 0 1 1 1 0 0 0 1 1 1 1 0 0 1 1 1 0 0 0 1 1 1 0 0 0]' 20},...
'rp9' ,{[1 1 1 1 0 0 1 1 1 1 0 0 1 1 1 0 0 0 1 1 1 1 0 0 1 1 1 0 0 0 1 1 1 0 0 0]' 21},...
'rp10',{[1 1 1 1 0 0 1 1 1 1 0 0 1 1 1 0 0 0 1 1 1 1 0 0 1 1 1 0 0 0 1 1 1 1 0 0]' 22},...
'rp11',{[1 1 1 1 0 0 1 1 1 1 0 0 1 1 1 1 0 0 1 1 1 1 0 0 1 1 1 0 0 0 1 1 1 1 0 0]' 23}...
);

% select pattern from tailbit structure
switch rp                                                                
    case 0 
        tail_pat = sPunc_tail(1).rp0;
        tail_index = sPunc_tail(2).rp0;
    case 1 
        tail_pat = sPunc_tail(1).rp1;
        tail_index = sPunc_tail(2).rp1;
    case 2 
        tail_pat = sPunc_tail(1).rp2;
        tail_index = sPunc_tail(2).rp2;
    case 3 
        tail_pat = sPunc_tail(1).rp3;
        tail_index = sPunc_tail(2).rp3;
    case 4 
        tail_pat = sPunc_tail(1).rp4;
        tail_index = sPunc_tail(2).rp4;
    case 5 
        tail_pat = sPunc_tail(1).rp5;
        tail_index = sPunc_tail(2).rp5;
    case 6 
        tail_pat = sPunc_tail(1).rp6;
        tail_index = sPunc_tail(2).rp6;
    case 7 
        tail_pat = sPunc_tail(1).rp7;
        tail_index = sPunc_tail(2).rp7;
    case 8 
        tail_pat = sPunc_tail(1).rp8;
        tail_index = sPunc_tail(2).rp8;
    case 9 
        tail_pat = sPunc_tail(1).rp9;
        tail_index = sPunc_tail(2).rp9;
    case 10 
        tail_pat = sPunc_tail(1).rp10;
        tail_index = sPunc_tail(2).rp10;
    case 11 
        tail_pat = sPunc_tail(1).rp11;
        tail_index = sPunc_tail(2).rp11;
    otherwise
        error('tailbit','tailbit pattern does not exist');
end

end % end function

