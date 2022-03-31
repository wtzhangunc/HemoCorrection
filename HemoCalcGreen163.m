function [Output] = HemoCalcGreen163(M,SpecID)
%Input M is 1044xtime_points matrix
%Input could be GCaMP+Td or other similiar data

 
Rscript='/usr/local/bin/Rscript';
Rfile='~/R_scripts/hemo_correction_script163_github.R';

if SpecID == 'A'
 COL = 290:452;
 Ref = '~/Documents/Reference_files/A-Dual-GCaMP&tdTomato.csv';
 %Ref = '~/Documents/Reference_files/A-Dual-GCaMP&mCherry.csv';
 parameters50='~/Documents/MATLAB/HemoCorrectionData/parameters_Td1_harry.xlsx';
end
if SpecID == 'B'
 COL = 294:456; 
 Ref = '~/Documents/Reference_files/B-Dual-GCaMP&tdTomato.csv';
 parameters50='~/Documents/MATLAB/HemoCorrectionData/parameters_Td2_harry.xlsx';
end

%Unmixing G and Td
Ref_mat = csvread(Ref,1,1);
coef = unmixing2_mod(M',Ref_mat); % coef is 2 x timepoints matrix

%retrieve G coefficients and replace negative values with baseline mean
idx = coef(1,:) < 0;
g = coef(1,:)';
g(idx == 1) = mean(g(1:400)); 

%Prepare the data for Hb fitting
data_fixed=M';
tmp = g * Ref_mat(COL,1)';
data_4Hb = data_fixed(:,COL) - tmp;

t=array2table(data_4Hb);
writetable(t,'tmp.xlsx','WriteVariableNames' ,0);

eval(['!',Rscript,' ',Rfile,' ','tmp.xlsx ',parameters50,' ','tmp.txt ','.'])
% 
file = fopen('tmp.txt','r');
Hbs = textscan(file, ['%f' '%f' '%f' '%f'],'HeaderLines',1);
fclose(file);
Hbs=cell2mat(Hbs);
Output.HbO = Hbs(:,1);
Output.HbR = Hbs(:,2);
Output.HbT=Hbs(:,1)+Hbs(:,2);
Output.G = coef(1,:)';
Output.Td = coef(2,:)';

%plot(Output.HbO,'r');hold on;plot(Output.HbR,'b');
delete tmp.xlsx;
delete tmp.txt;
end

