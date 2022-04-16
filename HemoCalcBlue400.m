function [Output] = HemoCalcBlue400(M)
% Input M is 1044xtime_points matrix
% Input could be EYFP, GFP, or GCaMP400 data
% Weiting Zhang, 04/07/2022

Rscript='/usr/local/bin/Rscript'; %Edit this line according to your R environment
Rfile='~/R_scripts/hemo_correction_script400nm.R'; %Edit this line according to your R environment
parameters55='./parameters_blue55.xlsx';%Edit this line accordingly

COL = 199:253; % set the data range in 502-544 nm

data_fixed=M';
data_4Hb=data_fixed(:,COL);
t=array2table(data_4Hb);
writetable(t,'tmp.xlsx','WriteVariableNames' ,0);

eval(['!',Rscript,' ',Rfile,' ','tmp.xlsx ',parameters55,' ','tmp.txt ','.'])
% 
file = fopen('tmp.txt','r');
Hbs = textscan(file, ['%f' '%f' '%f' '%f'],'HeaderLines',1);
fclose(file);
Hbs=cell2mat(Hbs);
Output.HbO = Hbs(:,1);
Output.HbR = Hbs(:,2);
Output.HbT=Hbs(:,1)+Hbs(:,2);
plot(Output.HbO,'r');hold on;plot(Output.HbR,'b');
delete tmp.xlsx;
delete tmp.txt;
end

