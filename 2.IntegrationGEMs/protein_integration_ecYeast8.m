%%
clear;clc
%%
load('ecYeastGEM.mat');	% ecYeast8
model = ecModel;
%%
filename = 'predictions_ecyeast8_mmolgDW.csv';
delimiter = '\t';
startRow = 2;
formatSpec = '%*s%s%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);
predictions = table(dataArray{1:end-1}, 'VariableNames', {'Protein','ALL','MIN','YPD'});
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
%data = table2array(predictions(:,2)); %ALL
%data = table2array(predictions(:,3)); %MIN
%data = table2array(predictions(:,4)); %YPD
%%
[model,enzUsages,modifications] = constrainEnzymes(model, Ptot, sigma, f, GAM, pIDs, data, gRate, c_UptakeExp, c_source);