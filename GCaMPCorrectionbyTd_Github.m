function GCaMPCorrectionbyTd(EXCELFILE)
%in the same directory as the raw text files

close all;

[path,name,ext]=fileparts(EXCELFILE);
outfitname = strcat(name,'.txt');
unmixingname = strcat(name,'.csv');
%data = xlsread(EXCELFILE);
cd LinearUnmixingOutput/
coef = csvread(unmixingname,1,0);
cd ..
cd Outfit 
HbFit = dlmread(outfitname,' ',1,0);

cd ..



%%
parameters = xlsread('~/Documents/MATLAB/HemoCorrectionData/parameters_blue_29.xlsx');

OxyE488 = 24174.8;
Deoxy488 = 15898;
X488 = 0.0451; 



x=((OxyE488 * X488 + parameters(:,2)) .* parameters(:,4))';
y=((Deoxy488 * X488 + parameters(:,3)) .* parameters(:,4))';


HbO = HbFit(:,1);
HbR = HbFit(:,2);
HbO = sgolayfilt(HbFit(:,1),2,61);
HbR = sgolayfilt(HbFit(:,2),2,61);
c = HbO * x + HbR * y ;

GCaMP_uncorrected = coef(11:end,1) ./mean(coef(1:10,1));
GCaMP_uncorr_ln = log(GCaMP_uncorrected);

c_ave = mean(c(:,16:20)')'; 
GCaMPCorrected = exp(GCaMP_uncorr_ln + c_ave);
GCaMPCorrected = (GCaMPCorrected - 1) * 100;
GCaMP_uncorrected = (GCaMP_uncorrected - 1 ) * 100;
plot(GCaMPCorrected);
hold on;
plot(GCaMP_uncorrected);
tmp = [GCaMP_uncorrected,GCaMPCorrected,HbFit(:,1),HbFit(:,2),HbFit(:,1)+HbFit(:,2)];
cd CorrectedGCaMP/
csvwrite(unmixingname,tmp);
clear tmp; 
cd ..


