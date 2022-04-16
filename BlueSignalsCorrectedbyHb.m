function [Blue_cor,Blue_uncor_perc]=BlueSignalsCorrectedbyHb(Blue_uncor,HbO,HbR)
% Blue_uncor should be the raw unmixing results
% Blue_uncor should be 10 time points longer than HbO and HbR
% Weiting Zhang, 04/07/2022

parameters = xlsread('~/parameters_blue4correction.xlsx');

OxyE488 = 24174.8;
Deoxy488 = 15898;
X488 = 0.0451; 

x=((OxyE488 * X488 + parameters(:,2)) .* parameters(:,4))';
y=((Deoxy488 * X488 + parameters(:,3)) .* parameters(:,4))';
%Corrected for GCaMP, HbO/HbR curves smoothed with Savitzky-Golay filtering
%seems better than the butter filtering
HbO = sgolayfilt(HbO,2,61)*1.2; %1.2 is the scaling factor which may vary
HbR = sgolayfilt(HbR,2,61)*1.2; %1.2 is the scaling factor which may vary
c = HbO * x + HbR * y ;

Blue_uncorrected = Blue_uncor(11:end)./mean(Blue_uncor(1:10));
Blue_uncorr_ln = log(Blue_uncorrected);

c_ave = mean(c(:,16:20)')'; 
Blue_cor = exp(Blue_uncorr_ln + c_ave);
Blue_cor = (Blue_cor - 1) * 100;
Blue_uncor_perc = (Blue_uncorrected - 1) * 100;

