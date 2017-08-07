%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% reference_cells.m                                                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autor: Kevin Döring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Date:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:
% contains the carrier positions and phases for the frequency, time 
% and AFS reference cells
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Frequency references (section 8.4.2)

% structure sFreq_ref
% indexing the cell position, cell phases and cell gain
% cell position: sFreq_ref(1).mode (carrier index !zero based)
% cell phases  : sFreq_ref(2).mode

ofdm.sFreq_ref = struct (...
                    'A',{[18 54 72] [205 836 215]},...
                    'B',{[16 48 64] [331 651 555]},...
                    'C',{[11 33 44] [214 392 242]},...
                    'D',{[ 7 21 28] [788 1014 332]}...
                   );

% Time references (section 8.4.3)

% structure sTime_ref.mode
% indexing the cell position, cell phases and cell gain
% cell position: sTime_ref(1).mode (carrier index !zero based)
% cell phases  : sTime_ref(2).mode

% uncommented positions are already used for frequency references

% time reference cells for robustness mode A according to table 88 
ofdm.sTime_ref.A =  [   17 973;
                        %18 205;
                        19 717;
                        21 264;
                        28 357;
                        29 357;
                        32 952;
                        33 440;
                        39 856;
                        40  88;
                        41  88;
                        53  68;
                        %54 836;
                        55 836;
                        56 836;
                        60 1008;
                        61 1008;
                        63 752;
                        71 215;
                        %72 215;
                        73 727];

% time reference cells for robustness mode B according to table 89 
ofdm.sTime_ref.B =  [   14 304;
                        %16 331;
                        18 108;
                        20 620;
                        24 192;
                        26 704;
                        32  44;
                        36 432;
                        42 588;
                        44 844;
                        %48 651;
                        49 651;
                        50 651;
                        54 460;
                        56 460;
                        62 944;
                        %64 555;
                        66 940;
                        68 428];

% time reference cells for robustness mode C according to table 90                     
ofdm.sTime_ref.C =  [    8 722;
                        10 466;
                        %11 214;
                        12 214;
                        14 479;
                        16 516;
                        18 260;
                        22 577;
                        24 662;
                        28   3;
                        30 771;
                        32 392;
                        %33 392;
                        36  37;
                        38  37;
                        42 474;
                        %44 242;
                        45 242;
                        46 754];
               
% time reference cells for robustness mode D according to table 91                     
ofdm.sTime_ref.D =  [    5 636;
                         6 124;
                         %7 788;
                         8 788;
                         9 200;
                        11 688;
                        12 152;
                        14 920;
                        15 920;
                        17 644;
                        18 388;
                        20 652;
                        %21 1014;
                        23 176;
                        24 176;
                        26 752;
                        27 496;
                        %28 332;
                        29 432;
                        30 964;
                        32 452];

% time reference cells for robustness mode E according to table 92                     
ofdm.sTime_ref.E =  [  -80 219;
                       -79 475;
                       -77 987;
                       -53 652;
                       -52 652;
                       -51 140;
                       -32 819;
                       -31 819;
                        12 907;
                        13 907;
                        14 651;
                        21 903;
                        22 391;
                        23 903;
                        40 203;
                        41 203;
                        42 203;
                        67 797;
                        68  29;
                        79 508;
                        80 508];
                    
         
% AFS references for robustness mode E (section 8.4.5)
% ofdm.afs_ref_cells contains the afs reference cells according to table 96

ofdm.AFS_ref =       [-106 134 115;
                      -102 866 135;
                       -98 588 194;
                       -94 325 293;
                       -90 77  431;
                       -86 868 608;
                       -82 649 825;
                       -78 445  57;
                       -74 256 353;
                       -70  82 688;
                       -66 946  38;
                       -62 801 452;
                       -58 671 905;
                       -54 556 373;
                       -50 455 905;
                       -46 369 452;
                       -42 298  39;
                       -38 242 689;
                       -34 200 354;
                       -30 173  59;
                       -26 161 827;
                       -22 164 610;
                       -18 181 433;
                       -14 213 295;
                       -10 260 197;
                        -6 322 138;
                        -2 398 118;
                         2 489 138;
                         6 595 197;
                        10 716 295;
                        14 851 433;
                        18 1001 610;
                        22 142 827;
                        26 322  59;
                        30 516 354;
                        34 725 689;
                        38 949  39;
                        42 164 452;
                        46 417 905;
                        50 685 373;
                        54 968 905;
                        58 242 452;
                        62 554  38;
                        66 881 688;
                        70 199 353;
                        74 556  57;
                        78 927 825;
                        82 289 608;
                        86 690 431;
                        90  82 293;
                        94 512 194;
                        98 957 135;
                       102 393 115;
                       106 868 134];
               
               