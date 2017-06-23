clear
close all
%% ��������
filename = 'q1_data.txt';
delimiterIn = '\t';
headerlinesIn = 1;
A = importdata(filename,delimiterIn,headerlinesIn);
locations = A.data(:,2:3);
demands = A.data(2:end,4);
nnodes = size(locations,1);
ncustomers = nnodes - 1;

%% �������������ڵ㣨����depot��֮��ľ���
% ��nΪ�ͻ��ڵ��������ܽڵ���
% nnodes = n + 1;
% ��distances����ʱ��Ҫ���ͻ��ڵ��ż�1
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

%% ���VRP�����Զ����Ŵ��㷨����ĺ���
% �Զ�����Ⱥ��ʼ������
type create_permutations.m
% �Զ��彻�溯��
type crossover_permutation.m
% type my_crossover_permutation.m
% �Զ�����캯��
type mutate_permutation.m
% �Զ�����Ӧ�Ⱥ���
type vrp_fitness.m
FitnessFcn = @(x) vrp_fitness(x,demands,distances);

% �����Ż�ѡ��
options = optimoptions(@ga, 'PopulationType', 'custom','InitialPopulationRange', ...
                            [1;ncustomers]);
options = optimoptions(options,'CreationFcn',@create_permutations, ...
                        'CrossoverFcn',@crossover_permutation, ...
                        'MutationFcn',@mutate_permutation, ...
                        'PlotFcn', @gaplotbestf, ...
                        'MaxGenerations',3000,'PopulationSize',300, ...
                        'MaxStallGenerations',200,'UseVectorized',true);
numberOfVariables = ncustomers;
% �������
[x,fval,reason,output] = ...
    ga(FitnessFcn,numberOfVariables,[],[],[],[],[],[],[],options);

%% ���Ƴ���·��
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
