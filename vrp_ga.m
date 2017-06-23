clear
close all
%% 导入数据
filename = 'q1_data.txt';
delimiterIn = '\t';
headerlinesIn = 1;
A = importdata(filename,delimiterIn,headerlinesIn);
locations = A.data(:,2:3);
demands = A.data(2:end,4);
nnodes = size(locations,1);
ncustomers = nnodes - 1;

%% 计算任意两个节点（包括depot）之间的距离
% 设n为客户节点数，则总节点数
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

%% 针对VRP问题自定义遗传算法所需的函数
% 自定义种群初始化函数
type create_permutations.m
% 自定义交叉函数
type crossover_permutation.m
% type my_crossover_permutation.m
% 自定义变异函数
type mutate_permutation.m
% 自定义适应度函数
type vrp_fitness.m
FitnessFcn = @(x) vrp_fitness(x,demands,distances);

% 设置优化选项
options = optimoptions(@ga, 'PopulationType', 'custom','InitialPopulationRange', ...
                            [1;ncustomers]);
options = optimoptions(options,'CreationFcn',@create_permutations, ...
                        'CrossoverFcn',@crossover_permutation, ...
                        'MutationFcn',@mutate_permutation, ...
                        'PlotFcn', @gaplotbestf, ...
                        'MaxGenerations',3000,'PopulationSize',300, ...
                        'MaxStallGenerations',200,'UseVectorized',true);
numberOfVariables = ncustomers;
% 仿真求解
[x,fval,reason,output] = ...
    ga(FitnessFcn,numberOfVariables,[],[],[],[],[],[],[],options);

%% 绘制车辆路线
depot = locations(1,:);
customers = locations(2:end,:);
figure
plot(depot(1),depot(2),'rs');
hold on
plot(customers(:,1),customers(:,2),'bo');

[scores,P] = vrp_fitness(x,demands,distances);
delimiters = unique(P);
ntrips = length(delimiters);
trip = cell(ntrips,1);
load = zeros(ntrips,1);
for i = 1:ntrips
    bg = delimiters(i)+1;
    if i == ntrips
        ed = length(x{1});
    else
        ed = delimiters(i+1);
    end
    trip{i}=x{1}(bg:ed);
    load(i)=sum(demands(trip{i}));
    plot(locations([1,trip{i},1],1),locations([1,trip{i},1],2));
end
