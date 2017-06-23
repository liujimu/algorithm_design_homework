function xoverKids  = my_crossover_permutation(parents,options,NVARS, ...
    FitnessFcn,thisScore,thisPopulation)
%   MY_CROSSOVER_PERMUTATION Custom crossover function for VRP.

nKids = length(parents)/2;
xoverKids = cell(nKids,1); % Normally zeros(nKids,NVARS);
index = 1;

for i=1:nKids
    % here is where the special knowledge that the population is a cell
    % array is used. Normally, this would be thisPopulation(parents(index),:);
    parent = zeros(2,NVARS);
    parent(1,:) = thisPopulation{parents(index)};
    parent(2,:) = thisPopulation{parents(index + 1)};
    index = index + 2;

    p1 = ceil((NVARS - 1) * rand);
    p2 = p1 + ceil((NVARS - p1 - 1) * rand);
    
    child = zeros(size(parent));
    for j = 1:2
    copied = parent(j,p1:p2); % 复制片段
    tmp = [parent(3-j,p2+1:end),parent(3-j,1:p2)];
    
    [unused,ia] = setdiff(tmp,copied);
    rearranged = tmp(sort(ia)); % 剔除另一父代中与复制片段相同的元素
    q = NVARS - p2;
    child(j,:) = [rearranged(q+1:end),copied,rearranged(1:q)];
    end
    xoverKids{i} = child(randi(2),:); % Normally, xoverKids(i,:);
end
