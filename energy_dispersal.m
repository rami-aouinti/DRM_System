%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% energy_dispersal.m                                                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autor: Kevin Döring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Date: May 2010
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% contains the polynomial and the initial word for the scrambler
% calculate the samplerate and the reset vector for the PN-Generator of
% all channels
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% section 7.2.2 Energy dispersal

% scrambler polynomial and initial conditions

scrambler.poly = [1 0 0 0 0 1 0 0 0 1];

scrambler.init = ones(1,9);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% energy dispersal init for the FAC

scrambler.fac.pn_samplerate = sFFT.input_samplerate*msc.Nmb_input_bits...
                              /fac.Nmb_input_bits;

scrambler.fac.res_samplerate = msc.Nmb_input_bits*sFFT.input_samplerate;

% reset vector for FAC scrambler/descrambler depents on FAC frame size
scrambler.fac.reset_vec = zeros(fac.Nmb_input_bits,1);
scrambler.fac.reset_vec(1) = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% energy dispersal init for the SDC

scrambler.sdc.pn_samplerate = ofdm.superframe_size*sFFT.input_samplerate...
                              *msc.Nmb_input_bits/sdc.Nmb_input_bits;

scrambler.sdc.res_samplerate = ofdm.superframe_size*...
                               sFFT.input_samplerate*msc.Nmb_input_bits;

% reset vector for SDC scrambler/descrambler depents on SDC frame size
scrambler.sdc.reset_vec = zeros(sdc.Nmb_input_bits,1);
scrambler.sdc.reset_vec(1) = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% energy dispersal init for the MSC

scrambler.msc.pn_samplerate = sFFT.input_samplerate;

scrambler.msc.res_samplerate = msc.Nmb_input_bits*sFFT.input_samplerate;

% reset vector for MSC scrambler/descrambler depents on MSC frame size
scrambler.msc.reset_vec = zeros(msc.Nmb_input_bits,1);
scrambler.msc.reset_vec(1) = 1;

