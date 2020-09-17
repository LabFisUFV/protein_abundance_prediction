%%
clear;clc
%%
load('ecYeast7_v1.0.mat');	% ecYeast7 v1.0
model = ecModel;
%%
%filename = 'LAHT_mmolgDW.csv';
%filename = 'LAHT_mmolgDW_recalc.csv';
delimiter = ',';
startRow = 2;
formatSpec = '%*s%s%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);
predictions = table(dataArray{1:end-1}, 'VariableNames', {'Protein','LAHT'});
clearvars filename delimiter startRow formatSpec fileID dataArray ans;
%%
Ptot = 0.448;
sigma = 0.5;
f = 0.4421;
GAM = 15;
gRate = 0.1;
c_UptakeExp = 1.1;
c_source = 'D-glucose exchange (reversible)';

pIDs = table2array(predictions(:,1));
data = table2array(predictions(:,2));
%%
model = constrainEnzymes(model, Ptot, sigma, pIDs, data);