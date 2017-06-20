clear
close all
%% 导入数据
filename = 'q1_data.txt';
delimiterIn = '\t';
headerlinesIn = 1;
A = importdata(filename,delimiterIn,headerlinesIn);
locations = A.data(1:101,2:3);
demands = A.data(1:101,4);
nnodes = size(locations,1);
ncustomers = nnodes - 1;

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
% The custom creation function
type create_permutations.m
% 自定义交叉函数
type crossover_permutation.m
% The custom mutation function
type mutate_permutation.m
% The custom fitness function
type vrp_fitness.m
FitnessFcn = @(x) vrp_fitness(x,demands,distances);
% The custom plot function
type vrp_plot.m
my_plot = @(options,state,flag) vrp_plot(options,state,flag,locations);

%% Genetic Algorithm Options Setup
options = optimoptions(@ga, 'PopulationType', 'custom','InitialPopulationRange', ...
                            [1;ncustomers]);
options = optimoptions(options,'CreationFcn',@create_permutations, ...
                        'CrossoverFcn',@crossover_permutation, ...
                        'MutationFcn',@mutate_permutation, ...
                        'PlotFcn', my_plot, ...
                        'MaxGenerations',500,'PopulationSize',60, ...
                        'MaxStallGenerations',200,'UseVectorized',true);
numberOfVariables = ncustomers;
[x,fval,reason,output] = ...
    ga(FitnessFcn,numberOfVariables,[],[],[],[],[],[],[],options)

%%
% The plot shows the location of the ncustomers in blue circles as well as the
% path found by the genetic algorithm that the salesman will travel. The
% salesman can  start at either end of the route and at the end, return to
% the starting city to get back home.
