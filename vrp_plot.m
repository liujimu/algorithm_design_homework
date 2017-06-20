function state = vrp_plot(options,state,flag,locations)
%   TRAVELING_SALESMAN_PLOT Custom plot function for traveling salesman.
%   STATE = TRAVELING_SALESMAN_PLOT(OPTIONS,STATE,FLAG,LOCATIONS) Plot city
%   LOCATIONS and connecting route between them. This function is specific
%   to the traveling salesman problem.

%   Copyright 2004-2006 The MathWorks, Inc.
[unused,i] = min(state.Score);
genotype = state.Population{i};

depot = locations(1,:);
customers = locations(2:end,:);
plot(depot(1),depot(2),'rs');
hold on
plot(customers(:,1),customers(:,2),'bo');
plot(locations(genotype,1),locations(genotype,2));
hold off
