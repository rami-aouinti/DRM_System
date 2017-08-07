%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% analysis.m                                                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autor: Kevin Döring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: Delay-Calculation for the BER-measurement
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fac.tx_rx_delay = ofdm.superframe_size*3*fac.Nmb_input_bits;

if (SDC_QAM == 4)
    sdc.tx_rx_delay =  2*sdc.Nmb_input_bits;
else
    sdc.tx_rx_delay =  (2 + 2) *sdc.Nmb_input_bits;
end
     
if (MSC_QAM == 4)
    msc.tx_rx_delay = (ofdm.superframe_size*3 ...
                        + msc.long_interleave_depth)*msc.Nmb_input_bits;                 
else
    msc.tx_rx_delay = (ofdm.superframe_size*3 + 2 ...
                        + msc.long_interleave_depth)*msc.Nmb_input_bits;                  
end
