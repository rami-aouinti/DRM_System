%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gain_ref_calc.m                                                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autor: Kevin Döring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% Compute position, phase and gain of gain reference cells
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input:
% mode       : robustness mode
% spec_occ   : spectrum occupancy
% symbols    : number of symbols in one OFDM frame
% min        : minimum carrier number
% max        : maximum carrier number
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output:
% gain_cells : Array containing all calculated gain
%              reference carrier indexes, phases and gains 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function gain_cells = gain_ref_calc( mode, spec_occ, symbols, min, max)

% get the definitions for gain cell calculating according to table 95
% the values are needed for the computation of the indexes and the phases
switch mode
    case 'A'
        x = 4; y = 5; k0 = 2;
    case 'B'
        x = 2; y = 3; k0 = 1;
    case 'C'
        x = 2; y = 2; k0 = 1;
    case 'D'
        x = 1; y = 3; k0 = 1;
    case 'E'
        x = 4; y = 4; k0 = 2;
end

% Cell positions (section 8.4.4.1)

% calculate the gain reference cell positions according to table 93
% k = k0 + x * mod(s,y) + x*y * p
% p = integer;
% if carrier_min <= k <= carrier_max -> k is a gain_cell index

for i=1:symbols
    p = -20;
    for j = 1:100
        k = k0 + x * mod(i-1,y) + x * y * p;
        if (k >= min && k <= max)
            gain_cells(j,i,1) = k;
        end
        p = p+1;
    end
end

% Cell phases (section 8.4.4.3)

switch mode
    case 'A'
        W1024 = [228, 341, 455;
                 455, 569, 683;
                 683, 796, 910;
                 910,   0, 114;
                 114, 228, 341];

        Z256 =  [  0,  81, 248;
                  18, 106, 106;
                 122, 116,  31;
                 129, 129,  39;
                  33,  32, 111];

        Q1024 = 36;
    case 'B'
        W1024 = [512, 0, 512, 0, 512;
                   0, 512, 0, 512, 0;
                 512, 0, 512, 0, 512];

        Z256 =  [  0,  57, 164,  64,  12;
                 168, 255, 161, 106, 118;
                  25, 232, 132, 233,  38];
                  
        Q1024 = 12;
    case 'C'
        W1024 = [465, 372, 279, 186,  93,   0, 931, 838, 745, 652;
                 931, 838, 745, 652, 559, 465, 372, 279, 186,  93];

        Z256 =  [  0,  76,  29,  76,   9, 190, 161, 248,  33, 108;
                 179, 178,  83, 253, 127, 105, 101, 198, 250, 145];

        Q1024 = 12;
    case 'D'
        W1024 = [366, 439, 512, 585, 658, 731, 805, 878;
                 731, 805, 878, 951,   0,  73, 146, 219;
                  73, 146, 219, 293, 366, 439, 512, 585];

        Z256 =  [  0, 240,  17,  60, 220,  38, 151, 101;
                 110,   7,  78,  82, 175, 150, 106,  25;
                 165,   7, 252, 124, 253, 177, 197, 142];

        Q1024 = 14;
    case 'E'
        R1024 = [ 39, 118, 197, 276, 354, 433,  39, 118, 197, 276;
                  37, 183, 402,  37, 183, 402,  37, 183, 402, 37;
                 110, 329, 475, 110, 329, 475, 110, 329, 475, 110;
                  79, 158, 236, 315, 394, 473,  79, 158, 236, 315];

        Z1024 = [473, 394, 315, 236, 158,  79,   0,   0,   0,   0;
                 183, 914, 402,  37, 475, 841, 768, 768, 987, 183;
                 549, 622, 475, 110,  37, 622, 256, 768, 329, 549;
                  79, 158, 236, 315, 394, 473, 158, 315, 473, 630];

        Q1024 = [329, 489, 894, 419, 607, 519, 1020, 942,  817, 939;
                 824,1023,  74, 319, 225, 207,  348, 422,  395,  92;
                 959, 379,   7, 738, 500, 920,  440, 727,  263, 733;
                 907, 946, 924,  91, 189, 133,  910, 804, 1022, 433];

end

% calculate the gain reference phases 

for i = 1:symbols
    n = mod((i-1),y);
    m = floor((i-1)/y);
    for j = 1:size(gain_cells,1)
        if (gain_cells(j,i,1) ~= 0)
            p = (gain_cells(j,i,1) - k0 - n * x) / (x * y);
            switch mode
                case {'A','B','C','D'}
                    gain_cells(j,i,2) = mod(4*Z256(n+1,m+1)...
                        + p*W1024(n+1,m+1) + p^2*((1+i)-1)*Q1024, 1024);
                case 'E'
                    gain_cells(j,i,2) = mod(p^2*R1024(n+1,m+1)+p*Z1024(n+1,m+1)+Q1024(n+1,m+1), 1024);
            end
        end
    end
end

% Cell gains (section 8.4.4.2)

% select the cells that are over-boosted according to table 94 
switch mode
    case 'A'
        power_boost = [   2,   6,  98, 102;
                          2,   6, 110, 114;
                       -102, -98,  98, 102;
                       -114,-110, 110, 114;
                        -98, -94, 310, 314;
                       -110,-106, 346, 350];
    case 'B'
        power_boost = [   1,   3,  89,  91;
                          1,   3, 101, 103;
                        -91, -89,  89,  91;
                       -103,-101, 101, 103;
                        -87, -85, 277, 279;
                        -99, -97, 309, 311];
    case 'C'
        power_boost = [   0,   0,   0,   0;
                          0,   0,   0,   0;
                          0,   0,   0,   0;
                        -69, -67,  67,  69;
                          0,   0,   0,   0;
                        -67, -65, 211, 213];  
    case 'D'
        power_boost = [   0,   0,   0,   0;
                          0,   0,   0,   0;
                          0,   0,   0,   0;
                        -44, -43,  43,  44;
                          0,   0,   0,   0;
                        -43, -42, 134, 135];
    case 'E'
        power_boost = [-106,-102, 102, 106;
                          0,   0,   0,   0;
                          0,   0,   0,   0;
                          0,   0,   0,   0;
                          0,   0,   0,   0];   
end

for i = 1:symbols
    for j = 1:size(gain_cells,1)
        if (gain_cells(j,i,1) ~= 0)
            if any(power_boost(spec_occ+1,:) == gain_cells(j,i,1))
                gain_cells(j,i,3) = 2;
            else
                gain_cells(j,i,3) = sqrt(2);
            end
        end
    end
end

end % end function
