function [Green_cor, Green_uncor_perc]=GreenSignalsCorrectionbyHb_matrix(Green_uncor,HbO,HbR)
% Green_uncor should be the raw unmixing results, usually from HemoCalc
% Green_uncor should be 10 time points longer than HbO and HbR
% Weiting Zhang, 04/07/2022

parameters = xlsread('./parameters_green4correction.xlsx');

OxyE488 = 24174.8;
Deoxy488 = 15898;
X488 = 0.0451; % excitation laser for tdTomato. use X561 if excited by 561 nm laser
x=((OxyE488 * X488 + parameters(:,2)) .* parameters(:,4))';
y=((Deoxy488 * X488 + parameters(:,3)) .* parameters(:,4))';

% use following three lines to replace lines 8-12 if the green signal is excited by 561 nm laser
%X561 = 0.0411;OxyE561 = 32617;Deoxy561 = 53032;% X value is from 29 trials
%x=((OxyE561 * X561 + parameters(:,2)) .* parameters(:,4))';
%y=((Deoxy561 * X561 + parameters(:,3)) .* parameters(:,4))';

HbO = sgolayfilt(HbO,2,61)*1.2; %1.2 is the scaling factor which may vary
HbR = sgolayfilt(HbR,2,61)*1.2; %1.2 is the scaling factor which may vary
c = HbO * x + HbR * y ;

Green_uncorrected = Green_uncor(11:end)./mean(Green_uncor(1:10));
Green_uncorr_ln = log(Green_uncorrected);

c_ave = mean(c(:,16:20)')'; 
Green_cor = exp(Green_uncorr_ln + c_ave);
Green_cor = (Green_cor - 1) * 100;
Green_uncor_perc = (Green_uncorrected - 1) * 100;


