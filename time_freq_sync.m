%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% time_freq_sync.m                                                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autor: Kevin Döring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% Determine the pilot pairs for frame synchronization
% Calculate the frequency pilot index for frequency sync after fft
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% extract the pilots of the first symbol
%first_symbol_pilots = ofdm.ref_cells_array(:,1);
i = 1;
for a = 1:length(ofdm.ref_cells_array(:,1))-1
    if (ofdm.ref_cells_array(a,1) ~= 0)&&(ofdm.ref_cells_array(a+1,1) ~= 0)
        sync.pilot_pairs(i) = a;
        i = i + 1;
    end
end

% calculate filter delay for upsample/downsample filters
sync.filter_delay = 2*if_mod.filter_order/(2*if_mod.upsample_factor);

% get the frequency reference cell indexes for integer freq. offset
switch mode
    case 'A'
        sync.freq_ref_index = ofdm.sFreq_ref(1).A;
    case 'B'
        sync.freq_ref_index = ofdm.sFreq_ref(1).B;
    case 'C'
        sync.freq_ref_index = ofdm.sFreq_ref(1).C;
    case 'D'
        sync.freq_ref_index = ofdm.sFreq_ref(1).D;
    case 'E'
        % mode E does not use frequency reference thus
        % no frequency sync is available at this time
    otherwise
        error('sync:mode','Mode does not exist');
end

% get the frequency reference cell position relative to carrier min

sync.freq_pos_rel = -sFFT.size-1;

clear('i','a');