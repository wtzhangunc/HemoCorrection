function [Output] = HemoCalcGreen163(M)
% Input M is 1044xtime_points matrix
% Input could be GCaMP+Td or other similiar data
% Weiting Zhang, 04/07/2022
 
Rscript='/usr/local/bin/Rscript';% Edit this line according to your R environment
Rfile='~/R_scripts/hemo_correction_script163_github.R';% Edit this line according to your R environment


COL = 294:456; % define the wavelength range (575 - 700 nm);
Ref = './Dual-GCaMP&tdTomato.csv';
parameters = '~/parameters_Td163.xlsx';

%Unmixing G and Td
Ref_mat = csvread(Ref,1,1);
coef=zeros(size(Ref_mat,2),size(M,2)); 
for i=1:size(M,2)
  coef(:,i)=lsqnonneg(Ref_mat(140:500,:),M(140:500,i)); 
end
% coef is 2 x timepoints matrix

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

eval(['!',Rscript,' ',Rfile,' ','tmp.xlsx ',parameters,' ','tmp.txt ','.'])
% 
file = fopen('tmp.txt','r');
Hbs = textscan(file, ['%f' '%f' '%f' '%f'],'HeaderLines',1);
fclose(file);
Hbs=cell2mat(Hbs);
Output.HbO = Hbs(:,1);
Output.HbR = Hbs(:,2);
Output.HbT=Hbs(:,1)+Hbs(:,2);
Output.goodness = Hbs(:,4)
Output.G = coef(1,:)';
Output.Td = coef(2,:)';

%plot(Output.HbO,'r');hold on;plot(Output.HbR,'b');
delete tmp.xlsx;
delete tmp.txt;
end

