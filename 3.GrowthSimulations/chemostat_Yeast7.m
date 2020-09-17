%%
clear;clc
%%
modelxml = importModel('yeast7.xml');
%%
% adjust parameters for chemostat growth
model = setParam(model, 'eq', {'r_2111'}, 0.1);  % fix specific growth rate at the dilution rate value

uptake = find(strcmp(model.rxnNames,'D-glucose exchange')); % remove constraints on substrate uptake
%model = setParam(model, 'lb', uptake, -Inf);
model = setParam(model, 'ub', uptake, Inf);

model = setParam(model, 'ub', {'r_2033'}, 0.62); % pyruvate production
model = setParam(model, 'ub', {'r_1634'}, 0.05); % acetate production
model = setParam(model, 'ub', {'r_1549'}, 1e-5); % (R,R)-2,3-butanediol production
model = setParam(model, 'ub', {'r_1631'}, 1e-5); % acetaldehyde production
model = setParam(model, 'ub', {'r_1810'}, 1e-5); % glycine production
model = setParam(model, 'lb', {'r_2045'}, 0);   % L-serine transport between cytoplasm and mitochondria
model = setParam(model, 'eq', {'r_06591'}, 0); % conversion of isocitrate to 2-oxoglutarate in the [c] via NADPH
%%
% minimize substrate uptake
model = setParam(model, 'obj',{'r_2111'}, 0);
model = setParam(model, 'obj', uptake, 1);
sol = solveLP(model)
printFluxes(model, sol.x, true);