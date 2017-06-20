clear
close all
%% 导入数据
filename = 'q1_data.txt';
delimiterIn = '\t';
headerlinesIn = 1;
A = importdata(filename,delimiterIn,headerlinesIn);
locations = A.data(:,2:3);
demands = A.data(:,4);
nnodes = size(locations,1);
ncustomers = nnodes - 1;

depot = A.data(1,:);
customers = A.data(2:end,:);
plot(depot(2),depot(3),'rs');
hold on
plot(customers(:,2),customers(:,3),'bo');

%% 计算任意两个节点（包括depot）之间的距离
% 设n为客户节点数，则
% nnodes = n + 1;
% 对distances检索时需要将客户节点编号加1
distances = zeros(nnodes);
for count1 = 1:nnodes
    for count2 = 1:count1
        x1 = locations(count1,1);
        y1 = locations(count1,2);
        x2 = locations(count2,1);
        y2 = locations(count2,2);
        distances(count1,count2) = sqrt((x1 - x2)^2 + (y1 - y2)^2);
        distances(count2,count1) = distances(count1,count2);
    end;
end;

%% Customizing the Genetic Algorithm for a Custom Data Type
% By default, the genetic algorithm solver solves optimization problems
% based on double and binary string data types. The functions for creation,
% crossover, and mutation assume the population is a matrix of type double,
% or logical in the case of binary strings. The genetic algorithm solver
% can also work on optimization problems involving arbitrary data types.
% You can use any data structure you like for your population. For example,
% a custom data type can be specified using a MATLAB(R) cell array. In order
% to use |ga| with a population of type cell array you must provide a
% creation function, a crossover function, and a mutation function that
% will work on your data type, e.g., a cell array.

%% Required Functions for the Traveling Salesman Problem
% This section shows how to create and register the three required
% functions. An individual in the population for the traveling salesman
% problem is an ordered set, and so the population can easily be
% represented using a cell array. The custom creation function for the
% traveling salesman problem will create a cell array, say |P|, where each
% element represents an ordered set of ncustomers as a permutation vector. That
% is, the salesman will travel in the order specified in |P{i}|. The creation
% function will return a cell array of size |PopulationSize|.
type create_permutations.m

%%
% The custom crossover function takes a cell array, the population, and
% returns a cell array, the children that result from the crossover.
type crossover_permutation.m

%%
% The custom mutation function takes an individual, which is an ordered set
% of ncustomers, and returns a mutated ordered set.
type mutate_permutation.m

%%
% We also need a fitness function for the traveling salesman problem. The
% fitness of an individual is the total distance traveled for an ordered
% set of ncustomers. The fitness function also needs the distance matrix to
% calculate the total distance.
type vrp_fitness.m

%%
% |ga| will call our fitness function with just one argument |x|, but our
% fitness function has two arguments: |x|, |distances|. We can use an
% anonymous function to capture the values of the additional argument, the
% distances matrix. We create a function handle |FitnessFcn| to an
% anonymous function that takes one input |x|, but calls
% |traveling_salesman_fitness| with |x|, and distances. The variable,
% distances has a value when the function handle |FitnessFcn| is created,
% so these values are captured by the anonymous function.
%distances defined earlier
FitnessFcn = @(x) traveling_salesman_fitness(x,distances);

%%
% We can add a custom plot function to plot the location of the ncustomers and
% the current best route. A red circle represents a city and the blue
% lines represent a valid path between two ncustomers.
type vrp_plot.m

%%
% Once again we will use an anonymous function to create a function handle
% to an anonymous function which calls |traveling_salesman_plot| with the
% additional argument |locations|.
%locations defined earlier
my_plot = @(options,state,flag) vrp_plot_plot(options,state,flag,locations);

%% Genetic Algorithm Options Setup
% First, we will create an options container to indicate a custom data type
% and the population range.
options = optimoptions(@ga, 'PopulationType', 'custom','InitialPopulationRange', ...
                            [1;ncustomers]);

%%
% We choose the custom creation, crossover, mutation, and plot functions
% that we have created, as well as setting some stopping conditions.
options = optimoptions(options,'CreationFcn',@create_permutations, ...
                        'CrossoverFcn',@crossover_permutation, ...
                        'MutationFcn',@mutate_permutation, ...
                        'PlotFcn', my_plot, ...
                        'MaxGenerations',500,'PopulationSize',60, ...
                        'MaxStallGenerations',200,'UseVectorized',true);
%%
% Finally, we call the genetic algorithm with our problem information.

numberOfVariables = ncustomers;
[x,fval,reason,output] = ...
    ga(FitnessFcn,numberOfVariables,[],[],[],[],[],[],[],options)

%%
% The plot shows the location of the ncustomers in blue circles as well as the
% path found by the genetic algorithm that the salesman will travel. The
% salesman can  start at either end of the route and at the end, return to
% the starting city to get back home.
