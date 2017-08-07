%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% conv_and_puncturing.m                                                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autor: Kevin Döring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Date:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% Contains the polynomial for the convolutional coder
% and all puncturing patterns for the used part (not tailbits)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Section 7.3.2 Component code

% Convolutional encoder mother codeword 

conv_poly = poly2trellis(7, [133 171 145 133 171 145]);

% Puncturing patterns for different code rates Rp according to table 62
% the structure contains patterns, Numerator and Denominator for calculating tailbit patterns  

% Indexing the Pattern: sPunc_pat(1).Rpxx
% Indexing the Numerator RXp: sPunc_pat(2).Rpxx 
% Indexing the Denominator RYp: sPunc_pat(3).Rpxx 

sPunc_pat = struct(...                                                                                                  % Code rate
'Rp16' ,{[1 1 1 1 1 1]' 1 6},...                                                                                        % Rp = 1/6 
'Rp14' ,{[1 1 1 1 0 0]' 1 4},...                                                                                        % Rp = 1/4
'Rp310',{[1 1 1 1 0 0 1 1 1 0 0 0 1 1 1 0 0 0]' 3 10},...                                                               % Rp = 3/10
'Rp13' ,{[1 1 1 0 0 0]' 1 3},...                                                                                        % Rp = 1/3
'Rp411',{[1 1 1 0 0 0 1 1 1 0 0 0 1 1 1 0 0 0 1 1 0 0 0 0]' 4 11},...                                                   % Rp = 4/11
'Rp25',{[1 1 1 0 0 0 1 1 0 0 0]' 2 5},...                                                                               % Rp = 2/5
'Rp12',{[1 1 0 0 0 0]' 1 2},...                                                                                         % Rp = 1/2
'Rp47' ,{[1 1 0 0 0 0 1 0 1 0 0 0 1 1 0 0 0 0 1 0 0 0 0 0]' 4 7},...                                                    % Rp = 4/7
'Rp35' ,{[1 1 0 0 0 0 1 0 0 0 0 0 1 1 0 0 0 0]' 3 5},...                                                                % Rp = 3/5
'Rp23' ,{[1 1 0 0 0 0 1 0 0 0 0 0]' 2 3},...                                                                            % Rp = 2/3
'Rp811',{[1 1 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 1 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 1 0 0 0 0 1 0 0 0 0 0]' 8 11},...   % Rp = 8/11
'Rp34' ,{[1 1 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0]' 3 4},...                                                                % Rp = 3/4
'Rp45' ,{[1 1 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0]' 4 5},...                                                    % Rp = 4/5
'Rp78' ,{[1 1 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0]' 7 8},...                % Rp = 7/8
'Rp89' ,{[1 1 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0]' 8 9}...     % Rp = 8/9
);



