%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% channel_est.m                                                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autor: Kevin Döring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Date:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% Contains parameters for channel modelling and estimation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Select the interpolation length for the FIR-filter used as frequency
% domain interpolator. The length depends on the robustness mode and the
% space between the gain pilots hence.
switch mode
    case 'A'
       channel.inter = 20;
    case 'B'
       channel.inter = 6;
    case 'C'
       channel.inter = 4;
    case 'D'
       channel.inter = 3;
    case 'E'
       channel.inter = 3;
    otherwise
        error('pilots:mode','Mode does not exist');
end
