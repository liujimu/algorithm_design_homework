function xoverKids  = my_crossover_permutation(parents,options,NVARS, ...
    FitnessFcn,thisScore,thisPopulation)
%   CROSSOVER_PERMUTATION Custom crossover function for traveling salesman.
%   XOVERKIDS = CROSSOVER_PERMUTATION(PARENTS,OPTIONS,NVARS, ...
%   FITNESSFCN,THISSCORE,THISPOPULATION) crossovers PARENTS to produce
%   the children XOVERKIDS.
%
%   The arguments to the function are 
%     PARENTS: Parents chosen by the selection function
%     OPTIONS: Options created from OPTIMOPTIONS
%     NVARS: Number of variables 
%     FITNESSFCN: Fitness function 
%     STATE: State structure used by the GA solver 
%     THISSCORE: Vector of scores of the current population 
%     THISPOPULATION: Matrix of individuals in the current population

%   Copyright 2004-2015 The MathWorks, Inc. 

nKids = length(parents)/2;
xoverKids = cell(nKids,1); % Normally zeros(nKids,NVARS);
index = 1;

for i=1:nKids
    % here is where the special knowledge that the population is a cell
    % array is used. Normally, this would be thisPopulation(parents(index),:);
    parent1 = thisPopulation{parents(index)};
    parent2 = thisPopulation{parents(index + 1)};
    index = index + 2;

    % Flip a section of parent1.
    p1 = ceil((length(parent1) -1) * rand);
    p2 = p1 + ceil((length(parent1) - p1- 1) * rand);
    copy = parent1(p1:p2); % ����Ƭ��
    [C,ia] = setdiff(parent2,copy);
    child = parent2(sort(ia)); % �޳�parent2����copy��ͬ��Ԫ��
    xoverKids{i} = [child(1:p1-1),copy,child(p1:end)]; % Normally, xoverKids(i,:);
end