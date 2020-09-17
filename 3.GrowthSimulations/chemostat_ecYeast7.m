%%
clear
%%
load('ecYeast7.mat');
ecModel = model;
%%
% adjust parameters for chemostat growth
ecModel = setParam(ecModel, 'eq', {'r_2111'}, 0.1);  % fix specific growth rate at the dilution rate value

uptake = find(strcmp(ecModel.rxnNames,'D-glucose exchange (reversible)')); % remove constraints on substrate uptake
%ecModel = setParam(ecModel, 'lb', uptake, -Inf);
ecModel = setParam(ecModel, 'ub', uptake, Inf);

% limit the total unmeasured enzyme mass
f = 0.4421;
sigma = 0.5;
Ptot = 0.448; 
prot_pool = Ptot * f * sigma;
ecModel = setParam(ecModel, 'ub', {'prot_pool_exchange'}, prot_pool);

ecModel = setParam(ecModel, 'ub', {'r_2033'}, 0.62); % pyruvate production
ecModel = setParam(ecModel, 'ub', {'r_1634'}, 0.05); % acetate production
ecModel = setParam(ecModel, 'ub', {'r_1549'}, 1e-5); % (R,R)-2,3-butanediol production
ecModel = setParam(ecModel, 'ub', {'r_1631'}, 1e-5); % acetaldehyde production
ecModel = setParam(ecModel, 'ub', {'r_1810'}, 1e-5); % glycine production
ecModel = setParam(ecModel, 'lb', {'r_2045'}, 0);   % L-serine transport between cytoplasm and mitochondria
ecModel = setParam(ecModel, 'eq', {'r_0659No1'}, 0); % conversion of isocitrate to 2-oxoglutarate in the [c] via NADPH
%%
% minimize substrate uptake
ecModel = setParam(ecModel, 'obj',{'r_2111'}, 0);
ecModel = setParam(ecModel, 'obj', uptake, -1);
sol = solveLP(ecModel)
printFluxes(ecModel, sol.x, true);
%%
% fix substrate uptake to optimal value, allowing a 0.1% flexibility
optimal_ub = sol.x(uptake)*1.001;
optimal_lb = sol.x(uptake)*0.999;
ecModel = setParam(ecModel, 'ub', uptake, optimal_ub);
ecModel = setParam(ecModel, 'lb', uptake, optimal_lb);
%%
% minimize enzyme usage
ecModel = setParam(ecModel, 'obj', uptake, 0);
enzyme_usage = find(~cellfun('isempty',strfind(ecModel.rxnNames,'prot_pool_exchange')));
ecModel = setParam(ecModel, 'obj', enzyme_usage, -1);
sol = solveLP(ecModel)
%%
printFluxes(ecModel, sol.x, true);