%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% init_fft.m                                                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autor: Kevin Döring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Date:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% defines the basic samplerate
% calculate ofdm-parameters for the ifft/fft processing 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(mode,'E')
    sFFT.base_samplefreq = 192000;
elseif (spec_occupancy < 4)
    sFFT.base_samplefreq = 12000;
else
    sFFT.base_samplefreq = 48000;
end

% select the symbol timings for the different modes
% according to table 82 (page 140)
% to avoid imprecive rounding the timings are calculated exactly
% Duration of useful part Tu = 1 / carrier spacing
% Duration of guard interval Tg = relation Tg/Tu * Tu
switch mode
    case 'A' 
        sFFT.time_useful_part = (125/3)^-1;
        sFFT.time_guard = sFFT.time_useful_part/9;
    case 'B'
        sFFT.time_useful_part = (375/8)^-1;
        sFFT.time_guard = sFFT.time_useful_part/4;
    case 'C'
        sFFT.time_useful_part = (750/11)^-1;
        sFFT.time_guard = sFFT.time_useful_part*4/11;        
    case 'D'
        sFFT.time_useful_part = (750/7)^-1;
        sFFT.time_guard = sFFT.time_useful_part*11/14;
    case 'E'
        sFFT.time_useful_part = (4000/9)^-1;
        sFFT.time_guard = sFFT.time_useful_part/9;
end        

sFFT.carrier_spacing = sFFT.time_useful_part^-1;

sFFT.symbol_time = sFFT.time_useful_part + sFFT.time_guard;

sFFT.size = round(sFFT.time_useful_part * sFFT.base_samplefreq);

sFFT.guard_size = round(sFFT.time_guard * sFFT.base_samplefreq);

sFFT.symbol_length = sFFT.size + sFFT.guard_size;

sFFT.input_samplerate = ofdm.nmb_symbols*sFFT.symbol_time ...
                                             / msc.Nmb_input_bits;

if (ofdm.carrier_min == 0)
    sFFT.shift_vec = 1:sFFT.size;
    sFFT.backshift_vec = 1:sFFT.size; 
else
    sFFT.shift_vec = [1-ofdm.carrier_min:sFFT.size 1:-ofdm.carrier_min];
    sFFT.backshift_vec = [sFFT.size+ofdm.carrier_min+1:sFFT.size ...
                          1:sFFT.size+ofdm.carrier_min]; 
end

sFFT.guard_index = [sFFT.size-sFFT.guard_size+1:sFFT.size 1:sFFT.size];
