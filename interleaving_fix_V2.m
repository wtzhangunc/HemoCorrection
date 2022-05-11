function [G488_fix,G405_fix] = interleaving_fix_V2(varargin)

% Weiting Zhang & Tzu-Hao Harry Chao, 05/04/2022
% Tested with data generated with OceanView V1.5
% e.g. [G488,G405] = interleaving_fix_V2('BK_SpecA.txt','datalength',1200,'Hz',20,'Interp','no');

% interperet user parameters
p = inputParser;
p.addRequired('file', @ischar);  % raw text from OceanView
p.addParameter('datalength',1200,@isnumeric); % expected length of data points
p.addParameter('hz', 10, @isnumeric); %Sampling rate/frequency
p.addParameter('interp', 'no', @ischar); % interpolation yes or no

p.parse(varargin{:});

In = p.Results;
TEXTFILE = In.file;
sampling_points = In.datalength;
freq = In.hz;
In.interp = validatestring(In.interp, {'no', 'yes'});

% import the data 

tmp = detectImportOptions(TEXTFILE);
NumOfHeaderLines = tmp.DataLines(1,1); 
opts = detectImportOptions(TEXTFILE,'NumHeaderLines',NumOfHeaderLines);

data = dlmread(TEXTFILE,'\t',NumOfHeaderLines,2)';

t = readtable(TEXTFILE,opts);
TimeStamps = t.Var1;
TimeStamps = seconds(TimeStamps - TimeStamps(1));

AUC=sum(data(80:170,:),1); % range: 409 - 479 nm
threshold=mean(AUC);

G488=data(:,find(AUC<threshold));
G488_timestamp=TimeStamps(find(AUC<threshold));
[G488_timestamp, index1] = unique(G488_timestamp);

G405=data(:,find(AUC>threshold));
G405_timestamp=TimeStamps(find(AUC>threshold));
[G405_timestamp, index2] = unique(G405_timestamp);

if strcmp(In.interp,'no')
    G488_fix = G488;
    G405_fix = G405;
end

if strcmp(In.interp,'yes')
 for i=1:size(G488,1)
   G488_fix(i,:)=interp1(G488_timestamp,G488(i,index1),0:1/freq:(sampling_points/freq-1/freq));
 end
 for i=1:size(G405,1)
   G405_fix(i,:)=interp1(G405_timestamp,G405(i,index2),0:1/freq:(sampling_points/freq-1/freq));
 end
end

