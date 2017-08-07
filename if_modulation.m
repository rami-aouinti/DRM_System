%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if_modulation.m                                                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autor: Kevin Döring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% contains all parameters for the if-modulation like
% up-/downsample-factor, if-frequency and IQ-Generator initialize
% defines the filter order for the upsmplin/downsampling-filter
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% parameters for if modulation
if strcmp(mode,'E')
    if_mod.if_freq = 192000;
    if_mod.upsample_factor = 4;
else
    if (spec_occupancy < 4)
        if_mod.upsample_factor = 4;
        if_mod.if_freq = 12000;
    else
        if_mod.upsample_factor = 4;
        if_mod.if_freq = 12000;
    end
end

% parameters for rate conversion+filtering
if_mod.filter_order = 128;

if_mod.filter_Fs = if_mod.upsample_factor * sFFT.base_samplefreq;

% parameters for IQ-modulator
if_mod.sample_time = sFFT.symbol_time/(if_mod.upsample_factor...
                                                    *sFFT.symbol_length);
                                                
if_mod.frame_size = if_mod.upsample_factor*sFFT.symbol_length;
