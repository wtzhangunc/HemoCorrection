function [Green_cor, Green_uncor_perc]=GreenSignalsCorrectionbyHb_matrix(Green_uncor,HbO,HbR)
%Green_uncor should be the raw unmixing results, usually from HemoCalc
%Green_uncor should be 10 time points longer than HbO and HbR

parameters = xlsread('~/Documents/MATLAB/HemoCorrectionData/parameters_red_29.xlsx');
%parameters = xlsread('~/Documents/MATLAB/HemoCorrectionData/parameters_red_hillman.xlsx');

OxyE488 = 24174.8;
Deoxy488 = 15898;
X488 = 0.0451; %Harry's X488 value from 29 trials
x=((OxyE488 * X488 + parameters(:,2)) .* parameters(:,4))';
y=((Deoxy488 * X488 + parameters(:,3)) .* parameters(:,4))';

%X561 = 0.0411;OxyE561 = 32617;Deoxy561 = 53032;% X value is from 29 trials
%x=((OxyE561 * X561 + parameters(:,2)) .* parameters(:,4))';
%y=((Deoxy561 * X561 + parameters(:,3)) .* parameters(:,4))';

HbO = sgolayfilt(HbO,2,61)*1.2;
HbR = sgolayfilt(HbR,2,61)*1.2;
c = HbO * x + HbR * y ;

Green_uncorrected = Green_uncor(11:end)./mean(Green_uncor(1:10));
Green_uncorr_ln = log(Green_uncorrected);

c_ave = mean(c(:,16:20)')'; 
Green_cor = exp(Green_uncorr_ln + c_ave);
Green_cor = (Green_cor - 1) * 100;
Green_uncor_perc = (Green_uncorrected - 1) * 100;


