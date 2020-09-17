%%
clear
%%
load('./ecYeast8_ALL.mat');
ecModelALL = model;
%%
load('./ecYeast8_MIN.mat');
ecModelMIN = model;
%%
load('./ecYeast8_YPD.mat');
ecModelYPD = model;
%%
load('./yeastGEM.mat');     % yeast8

c_source = 'r_1714';
%%
[FVA_chemostatALL,~,stats_c] = comparativeFVA(model,ecModelALL,c_source,true,0);
[FVA_chemostatMIN,~,stats_d] = comparativeFVA(model,ecModelMIN,c_source,true,0);
[FVA_chemostatYPD,~,stats_e] = comparativeFVA(model,ecModelYPD,c_source,true,0);

%%
FVA_chemostatALL = filterDistributions(FVA_chemostatALL,1E-10);
FVA_chemostatMIN = filterDistributions(FVA_chemostatMIN,1E-10);
FVA_chemostatYPD = filterDistributions(FVA_chemostatYPD,1E-10);

distributions = {FVA_chemostatALL{1}, FVA_chemostatALL{2}, FVA_chemostatMIN{1}, FVA_chemostatMIN{2}, FVA_chemostatYPD{1}, FVA_chemostatYPD{2}};
stats         = {stats_c, stats_d, stats_e}; 
legends       = {'model-chemostat', 'ecModelALL-chemostat','model-chemostat', 'ecModelMIN-chemostat','model-chemostat', 'ecModelYPD-chemostat'};
titleStr      = 'Flux variability cumulative distribution';
[~, ~]        = plotCumDist(distributions,legends,titleStr);