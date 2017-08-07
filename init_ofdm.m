%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% init_ofdm.m                                                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autor: Kevin Döring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% - set all cell positions for FAC, SDC and MSC in one OFDM-Superframe
% - set all pilots according to the DRMspec
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% first get the fixed ofdm parameters 

[ofdm.nmb_symbols ofdm.carrier_min ofdm.carrier_max] = ...
    ofdm_parameter(mode,spec_occupancy);

% calculate the number of carriers for indexing the ofdm mapping
% Some constellations use only the upper side band.
% Although the min carrier number is higher then zero in cause of 
% unused carriers all of them are needed for the correct indexing.

if (ofdm.carrier_min > 0)
    ofdm.carrier_min = 0;
    ofdm.nmb_carriers = ofdm.carrier_max + 1;
else
    ofdm.nmb_carriers = ofdm.carrier_max - ofdm.carrier_min + 1;
end

switch mode
    case {'A','B','C','D'}
        ofdm.superframe_size = 3;
    case 'E'
        ofdm.superframe_size = 4;
end

ofdm.Nmb_cells_per_frame = ofdm.nmb_carriers*ofdm.nmb_symbols;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pilot cells

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% frequency references (section 8.4.2)

Z = zeros(ofdm.nmb_carriers,1);

switch mode
    case 'A'
        Z(ofdm.sFreq_ref(1).A - ofdm.carrier_min + 1) =...
            sqrt(2) * exp(1i*2*pi*ofdm.sFreq_ref(2).A/1024);
    case 'B'
        Z(ofdm.sFreq_ref(1).B - ofdm.carrier_min + 1) =...
            sqrt(2) * exp(1i*2*pi*ofdm.sFreq_ref(2).B/1024);
    case 'C'
        Z(ofdm.sFreq_ref(1).C - ofdm.carrier_min + 1) =...
            sqrt(2) * exp(1i*2*pi*ofdm.sFreq_ref(2).C/1024);
    case 'D'
        Z(ofdm.sFreq_ref(1).D - ofdm.carrier_min + 1) =...
            sqrt(2) * exp(1i*2*pi*ofdm.sFreq_ref(2).D/1024);
    case 'E'
        % mode E does not use frequency reference thus the
        % frequency reference matrix keeps a zero matrix
    otherwise
        error('pilots:mode','Mode does not exist');
end

% build the freq._reference matrix (copy the carriers to all symbols)
for k=1:ofdm.nmb_symbols
    % multiply with -1 for all odd symbols in mode D (page 143/144)
    if (mode=='D' && mod(k,2))
        ofdm.freq_ref_array(:,k) = -1.*Z(:);
    else
        ofdm.freq_ref_array(:,k) = Z(:);
    end
end

clear('k','Z');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% time references (section 8.4.3)

% define time reference matrix
ofdm.time_ref_array = zeros(ofdm.nmb_carriers,ofdm.nmb_symbols);

% set positions (carriers) and values to the time ref. matrix 
switch mode
    case 'A'
        ofdm.time_ref_array(ofdm.sTime_ref.A(:,1) - ofdm.carrier_min...
            + 1) = sqrt(2) * exp(1i*2*pi*ofdm.sTime_ref.A(:,2)/1024);
    case 'B'
        ofdm.time_ref_array(ofdm.sTime_ref.B(:,1) - ofdm.carrier_min...
            + 1) = sqrt(2) * exp(1i*2*pi*ofdm.sTime_ref.B(:,2)/1024);
    case 'C'
        ofdm.time_ref_array(ofdm.sTime_ref.C(:,1) - ofdm.carrier_min...
            + 1) = sqrt(2) * exp(1i*2*pi*ofdm.sTime_ref.C(:,2)/1024);
    case 'D'
        ofdm.time_ref_array(ofdm.sTime_ref.D(:,1) - ofdm.carrier_min...
            + 1) = sqrt(2) * exp(1i*2*pi*ofdm.sTime_ref.D(:,2)/1024);
    case 'E'
        ofdm.time_ref_array(ofdm.sTime_ref.E(:,1) - ofdm.carrier_min...
            + 1) = sqrt(2) * exp(1i*2*pi*ofdm.sTime_ref.E(:,2)/1024);
    otherwise
        error('pilots:mode','Mode does not exist');
end


% compute reference cells array
% Ref_cells_array contains all pilot cells and is needed for assigning the
% the SDC and MSC cells as well as checking for doubly clogged pilot cells.

ofdm.ref_cells_array = ofdm.time_ref_array + ofdm.freq_ref_array;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gain references (section 8.4.4)

% define gain reference matrix
ofdm.gain_ref_array = zeros(ofdm.nmb_carriers,ofdm.nmb_symbols);

% calculate the gain reference cells
ofdm.aGain_ref = gain_ref_calc(mode, spec_occupancy, ofdm.nmb_symbols,...
                               ofdm.carrier_min, ofdm.carrier_max);

k = 1;l = 1;

for m = 1:ofdm.nmb_symbols
    for n = 1:size(ofdm.aGain_ref,1)
        if (ofdm.aGain_ref(n,m,1) ~= 0)
            % create gain_ref_matrix for transmitting
            ofdm.gain_ref_array(ofdm.aGain_ref(n,m,1) - ofdm.carrier_min...
            + 1, m) = ofdm.aGain_ref(n,m,3)...
            * exp(1i*2*pi*ofdm.aGain_ref(n,m,2)/1024);
            % create gain_ref_index for receiving
            %ofdm.gain_ref_index(k) = + ofdm.nmb_carriers*m -...
            %ofdm.nmb_carriers -ofdm.carrier_min+1 + ofdm.aGain_ref(n,m);
            %k = k+1;
        end
        %if (ofdm.aGain_ref(n,m,3) == 2)
            % select overboosted gain cells 
         %   ofdm.gain_boost_index(k) = + ofdm.nmb_carriers*m -...
          %  ofdm.nmb_carriers -ofdm.carrier_min+1 + ofdm.aGain_ref(n,m);
          %  k = k+1;
        if (ofdm.aGain_ref(n,m,3) > 0)
            % select non-overboosted gain cells
            ofdm.gain_norm_index(l) = ofdm.nmb_carriers*m -...
            ofdm.nmb_carriers -ofdm.carrier_min+1 + ofdm.aGain_ref(n,m);
            l = l+1;            
        end
    end
end

sync.gain_ref_array = ofdm.gain_ref_array;

% Check if any of the gain reference cells are set as 
% time or frequency reference cells before and set them to zero.

for m = 1:ofdm.nmb_symbols
    for n = 1:ofdm.nmb_carriers
        if (ofdm.gain_ref_array(n,m) ~= 0 && ofdm.ref_cells_array(n,m) ~=0)
            ofdm.gain_ref_array(n,m) = 0;
        end
    end
end

% compute reference cells array
ofdm.ref_cells_array = ofdm.ref_cells_array + ofdm.gain_ref_array;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AFS references (section 8.4.5)

% define AFS reference matrix for a super frame
ofdm.AFS_ref_array = ...
            zeros(ofdm.nmb_carriers,ofdm.nmb_symbols*ofdm.superframe_size);

if strcmp(mode,'E')
    % assign the AFS cells for the fifth OFDM symbol in the first frame 
    ofdm.AFS_ref_array(ofdm.AFS_ref(:,1) - ofdm.carrier_min...
            + 1,5) = exp(1i*2*pi*ofdm.AFS_ref(:,2)/1024);
    % assign the AFS cells for the fortieth OFDM symbol in the fourth frame   
    ofdm.AFS_ref_array(ofdm.AFS_ref(:,1) - ofdm.carrier_min...
            + 1,160) = exp(1i*2*pi*ofdm.AFS_ref(:,3)/1024); 
        
    % Check if any of the AFS reference cells are set as 
    % gain reference cells before and set them to zero.

    for n = 1:ofdm.nmb_carriers
        if (ofdm.AFS_ref_array(n,5)~= 0 && ofdm.ref_cells_array(n,5)~=0)
            ofdm.AFS_ref_array(n,5) = 0;
        end
        if (ofdm.AFS_ref_array(n,160)~= 0 && ofdm.ref_cells_array(n,40)~=0)
            ofdm.AFS_ref_array(n,160) = 0;
        end    
    end            
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FAC cells

% FAC cell position        
ofdm.FAC_cell_index = zeros(fac.NmbQAMcells,1);

switch mode
    case 'A'
        ofdm.FAC_cell_pos = ofdm.fac_cell_pos.A;
    case 'B'
        ofdm.FAC_cell_pos = ofdm.fac_cell_pos.B;
    case 'C'
        ofdm.FAC_cell_pos = ofdm.fac_cell_pos.C;
    case 'D'
        ofdm.FAC_cell_pos = ofdm.fac_cell_pos.D;
    case 'E'
        ofdm.FAC_cell_pos = ofdm.fac_cell_pos.E;
end

k = 1;

for m = 1:ofdm.nmb_symbols 
    for n = 1:size(ofdm.FAC_cell_pos,2)
        if (ofdm.FAC_cell_pos(m,n) ~= 0)
            ofdm.FAC_cell_index(k) = + ofdm.nmb_carriers*m -...
            ofdm.nmb_carriers -ofdm.carrier_min+1 + ofdm.FAC_cell_pos(m,n);
            k = k+1;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SDC cells

% ofdm.sdc_symbol_width contains the number of symbols (from symbol 0) 
% in the first OFDM frame which are used to transmit the SDC cells.

switch mode
    case 'A'
        ofdm.sdc_symbol_width = 2;
        ofdm.unused_carriers = [-1 0 1];
    case 'B'
        ofdm.sdc_symbol_width = 2;
        ofdm.unused_carriers = 0;
    case 'C'
        ofdm.sdc_symbol_width = 3;
        ofdm.unused_carriers = 0;
    case 'D'
        ofdm.sdc_symbol_width = 3;
        ofdm.unused_carriers = 0;
    case 'E'
        ofdm.sdc_symbol_width = 5;
end

switch mode
    case {'A','B','C','D'}
        unused = ofdm.unused_carriers - ofdm.carrier_min +1;
    case 'E'
        % mode 'E' does not have any unused carriers
        unused = 0;
end

k = 1;

for n = 1:ofdm.sdc_symbol_width
    index = find(ofdm.ref_cells_array(:,n) == 0);
    for m = 1:size(index)
        % check for unused carriers
        if all(unused ~= index(m))
            % check for AFS references
            if (ofdm.AFS_ref_array(n * ofdm.nmb_carriers...
                                     - ofdm.nmb_carriers + index(m)) == 0)
                ofdm.SDC_cell_index(k) = n * ofdm.nmb_carriers...
                                     - ofdm.nmb_carriers + index(m);
            k = k+1;
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MSC cells

% determine all free positions in one frame (exclude the SDC cells)
cell_vec = ofdm.ref_cells_array;

% occupy the FAC cell positions
cell_vec(ofdm.FAC_cell_index) = 1;

k = 1;

% calculate the MSC cell positions in a superframe
for l=1:ofdm.superframe_size
    if l == 1
        start = ofdm.sdc_symbol_width+1;
    else
        start = 1;
    end
    for m = start:ofdm.nmb_symbols
        index = find(cell_vec(:,m) == 0);
        for n = 1:size(index)
            % check for unused carriers
            if all(unused ~= index(n))
                % check for AFS reference cells               
                if (ofdm.AFS_ref_array(l * ofdm.Nmb_cells_per_frame...
                    - ofdm.Nmb_cells_per_frame + m * ofdm.nmb_carriers...
                    - ofdm.nmb_carriers + index(n)) == 0)
                    % 
                    ofdm.MSC_cell_index(k) = ...
                    l * ofdm.Nmb_cells_per_frame...
                    - ofdm.Nmb_cells_per_frame +...
                    m * ofdm.nmb_carriers - ofdm.nmb_carriers + index(n);
                    k = k+1;
                end
            end
        end
    end
end



% dummy cells

% select number of dummy cells
[ofdm.Nmb_dummy_cells ofdm.dummy_cells_values] = ...
                        dummy_cells(mode,spec_occupancy);










